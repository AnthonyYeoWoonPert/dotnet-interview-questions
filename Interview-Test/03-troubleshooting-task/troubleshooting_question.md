# Section 4 Troubleshooting
This section assesses your ability to diagnose and resolve issues, as well as your practical experience in software development 

## Questions

1. Your ASP.NET Core Web API application, which connects to an MSSQL database, suddenly starts returning HTTP 500 Internal Server Error for all data retrieval endpoints. The application was working fine an hour ago, and no code changes were deployed. What steps would you take to diagnose and resolve this issue?

```
First I confirm scope and capture the real exception by hitting a non-DB route and checking health probes, then I pull the last hour of logs and reproduce a failing call in Postman so I can correlate its request ID to the exact stack trace. Next, from the same VM/pod I test DNS/TCP to SQL (1433) and try logging in with the app’s identity; if that fails, I know it’s credentials, firewall, routing, failover, or TLS. I then verify the secrets/Key Vault rotation, RBAC/managed identity, SQL login/permissions, database state (restore/single_user), schema drift (columns/procs altered), or AG/Azure SQL failover/DNS. If logs show timeouts, I'll start with checking the DMVs/Query Store (or sp_WhoIsActive) for blocking and plan regressions; to stabilize I keep transactions short, consider enabling RCSI to cut reader/writer blocking, refresh stats, fix non-SARGable predicates/implicit conversions. If errors show “login failed” or “pre-login handshake,” I'll fix the login/default DB/firewall or update drivers/cert trust/TLS settings. I'll also verify pooling behavior where every SqlConnection/SqlCommand/SqlDataReader is disposed, whilst ensuring the connection string is identical everywhere (to avoid tiny multiple pools), and also ensuring Max Pool Size is reasonable, and only genuine transient faults are retried. If EF mapping errors appear (“Invalid column name”), I align the model or roll back the schema change and, as a guard, project only the columns I need. For AlwaysOn/failover issues, I validate the listener and flush stale DNS. Once the root cause is fixed, I confirm latency is back to normal, then harden: add a lightweight DB readiness check (e.g., SELECT 1), ensure dependency telemetry for SQL calls is emitting duration/success/fail, and set alerts for spikes in 500s, SQL dependency failures, pool exhaustion, deadlocks, and blocking so this doesn’t blindside us again.
```

2. A user reports that a specific report in your .NET application is taking an unusually long time to load, sometimes timing out. This report involves complex queries to multiple tables in MSSQL. How would you approach identifying the bottlenecks and improving the report’s performance?

```
I'll start by reproducing the slow report and correlating a failing request’s ID with server/APM logs to capture the exact SQL/stored procedure text, SET options, and parameter values the app is sending. Then I run that same statement in SSMS with identical parameters and SET options to grab the actual execution plan and waits, comparing estimated vs actual row counts to spot parameter sniffing, stale stats, non-SARGable predicates, implicit conversions (often from AddWithValue widening to NVARCHAR(4000)), key lookup storms, hash/sort spills to tempdb, and oversized memory grants or parallelism thrash. In parallel, I check DMVs/Query Store/extended events during a slow run to confirm blocking (LCK_*), I/O waits (PAGEIOLATCH_*), or plan regressions, and whether long writes are blocking the report. Based on the findings, I will then split the query into staged temp tables to improve estimates; make predicates SARGable and align datatypes to remove implicit conversions; add/adjust covering/filtered/computed-column indexes to eliminate lookups and reduce join cost; refresh stats and address spills/memory grants.

example:-

-- Bad (function on column)
WHERE YEAR(OrderDate) = 2025
-- Good (range is sargable)
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01'

-- Bad (leading wildcard)
WHERE Name LIKE '%lee'
-- Better: add a computed, indexed column for reversed name or use FULLTEXT for contains

-- Bad (implicit conversion from NVARCHAR to INT)
WHERE NVarCharId = @Id   -- @Id is INT
-- Good
WHERE NVarCharId = CONVERT(varchar(10), @Id)  -- or store as numeric consistently

-- Bad (expression on column)
WHERE Price * 1.1 > @p
-- Good
WHERE Price > @p / 1.1

On the app side, I will ensure parameters are declared with the correct SQL types and sizes, set a sane CommandTimeout, stream large result sets, and reduce work via pagination, projecting only needed columns, pre-aggregation (summary tables/indexed views), columnstore on large fact tables, or directing reads to a reporting replica/cache when real-time isn’t required. Finally, I will validate against baseline (duration, logical reads, tempdb usage).
```

3. You are working on a .NET application that uses Entity Framework Core. After deploying anew feature, you notice that some database operations are causing deadlocks. How would you identify the cause of these deadlocks and what strategies would you employ to prevent them?

```
I’d first prove these are true SQL Server deadlocks caused by the new feature, then capture exactly which statements and rows are involved, and finally break the deadlock cycle with the smallest, safest change. To confirm and capture the issue, I will check the app logs for SqlException (1205) right after the deploy, turn on EF Core command/transaction logging, and make sure the logs include the exact SQL plus parameter types & sizes and a correlation ID per request. Then to capture a deadlock graph, I will use Extended Events in SSMS (system_health → Watch Live Data → filter by deadlock) and reproduce the issue; if I lack permissions, I’ll query recent system_health*.xel files or (temporarily) enable trace flag 1222 to write graphs to the error log.


I'll then correlate EF Core logs (SQL + parameters) with database events, reproduce under realistic concurrency, I then will load the new feature concurrently (including any background jobs touching the same tables) so I can observe the deadlock reliably and correlate app requests to DB sessions; to validate live blocking, I will sample DMVs and Query Store during the incident (dm_exec_requests, dm_tran_locks, dm_os_waiting_tasks) and check for spikes in LCK_* waits to confirm who is blocking whom, read the deadlock pattern (lock order, scans, cascades, escalation, long tx), and apply fixes which includes standardize access order, shorten/scope transactions, make queries seekable with the right indexes/types, and—if acceptable—move readers to snapshot isolation.

While rolling out the fix, I add safe retries for the deadlock to keep the app resilient, where I will enable safe retries for the deadlock victim (error 1205) via EnableRetryOnFailure and use optimistic concurrency such as  rowversion; on idempotent operations; where appropriate, surface a 409/Retry-After to clients.

```

4. A .NET application that processes messages from a queue occasionally crashes with an OutOfMemoryException. The application is designed to handle a high volume of messages. What are the potential causes for this exception, and how would you investigate and resolve it?

```
An intermittent OutOfMemoryException in a high-volume queue worker usually comes from (1) too many messages in memory at once because prefetch/parallelism is unbounded, (2) messages that are too big or handled with “copy-everything” patterns (e.g., ToArray(), converting bytes to huge strings, parsing into massive JSON graphs, or inflating compressed payloads entirely in RAM), or (3) leaks—managed (unbounded caches, static collections, never-unsubscribed event handlers) or native (undisposed Stream/HttpResponseMessage/SqlDataReader); sometimes it’s simply a 32-bit process or a tight container memory cap. I’d investigate by first confirming the kind of OOM (actual .NET OutOfMemoryException vs container OOMKilled), ensuring the process is x64 and noting any pod/service memory limits; then I’d watch memory live under load with dotnet-counters alongside queue metrics (prefetch and unacked/backlog) to spot unbounded buffering; at the high-water mark I’d grab a dump (dotnet-dump/dotnet-gcdump) and inspect with PerfView/VS/WinDbg for top types (byte[], string, JObject/JArray, giant ConcurrentQueue/Channel/cache) and use GC roots to see why they’re held; finally I’d read the hot path for anti-patterns like ToArray(), Encoding.UTF8.GetString(...), full-payload logging, in-memory decompression, JObject.Parse on large JSON, unlimited Parallel.ForEachAsync, TPL Dataflow without BoundedCapacity, and IMemoryCache with no size limit. To resolve, I bound in-flight work by lowering prefetch/batch size and MaxConcurrentCalls (start near Environment.ProcessorCount) and add back-pressure (SemaphoreSlim or TPL Dataflow with BoundedCapacity) so RAM can’t fill with queued items; I stream instead of buffer (avoid ToArray()/stringifying; parse JSON from the stream via System.Text.Json JsonDocument.ParseAsync(stream)/Utf8JsonReader; decompress stream→stream with GZipStream); I reduce churn by pooling big buffers (ArrayPool<byte>.Shared) and using a RecyclableMemoryStream; I dispose deterministically (using/await using for all streams/readers; HttpClientFactory to avoid socket/native leaks); I put hard limits on growing things (set IMemoryCache SizeLimit and TTLs, cap in-memory retry/backoff queues, stop logging full payloads);  and I right-size the runtime (x64, sensible container limits, and scale out workers rather than cranking concurrency once memory is stable). I then prove it and keep it that way by re-load-testing to find the safe prefetch/concurrency ceiling and adding dashboards/alerts for GC heap, LOH size, allocation rate, process RSS, and queue backlog so regressions are obvious.


```

5. During a .NET framework to .Net Migration, you encounter an issue where a third-party library, which was critical for a specific business logic, is not compatible with .NET 8. The vendor has no plans for a .NET 8 compatible version. What are your options, and how would you proceed?

```
I will make the app depend on a small, domain-focused interface (e.g., IMyFeature) rather than the vendor library. I register interchangeable implementations in DI—one that calls a legacy implementation and one that uses a modern replacement—so swapping is a configuration/startup change (“zero-touch” for call-sites) instead of a refactor.

Before I swap anything, I “freeze” current behavior with characterization tests so I can prove parity later. I map real usage (APIs, flags, edge cases), collect anonymized golden inputs from production with their current outputs, and build a test harness that exercises the interface and asserts outputs/errors match those results. This matters because any replacement (or a wrapper around a sidecar) must pass the same tests; if it doesn’t, I immediately see the differences and can decide to shim or reject.

My long-term plan is to replace the library entirely. I start by reviewing potential alternatives against criteria like supported target frameworks, maintenance activity, licensing, performance, and how well they handle my edge cases. Once I’ve chosen a candidate, I build an adapter that implements the existing interface but uses the new API under the hood. I then run the full characterization test suite, ironing out any small mismatches in the adapter, and follow that with soak testing to validate performance. Once the cutover is done behind a feature flag so I can monitor SLOs and logs, and quickly roll back by flipping the flag if something goes wrong. This way, I end up fully on .NET 8, free of Windows-only dependencies, while minimizing operational risk for the transition.

If no viable replacement exists or rewriting would be risky now, I isolate the old library as an out-of-process “sidecar.” Where I run it as a separate Windows service/container, keep it stateless if possible, and expose only the operations I use (e.g., /compute, /validate) over  HTTP/JSON, or Named Pipes (if co-located on Windows). To keep this reliable, I define versioned request/response contracts, enforce timeouts/retries with backoff and a circuit breaker, design calls to be idempotent (request IDs), restrict network scope and require mTLS or tokens, add structured logs with correlation IDs across both processes plus metrics and health endpoints, and set/alert on SLOs. In deployment, I pair a Windows sidecar with my .NET 8 app. In practice, my .NET 8 app binds the interface to a sidecar client today and, when ready, I flip the DI binding to a new in-process implementation—no call-site changes. Where I treat the sidecar as a bridge,  because it adds a hop and keeps a Windows dependency.

If the “.NET Framework” assembly is just a thin wrapper over a native DLL that still works on modern Windows, I can sometimes stay in-process by writing a new P/Invoke layer or a C++/CLI bridge targeting .NET 8. This lowers latency compared to a sidecar but is only appropriate if licensing and native support allow it. Alongside the technical choices, I run risk, licensing, and security checks to confirm I’m permitted to wrap or re-implement behavior, recognize that unmaintained libraries carry CVE risk, and, if sensitive data is involved, limit logs, encrypt in transit, and scrub PII in telemetry.

```

6. How do you ensure the quality and maintainability of the code your write? Discuss your approach to Unit testing, code reviews, and adherence to coding standards. 

```
I keep quality and maintainability high by making small, well-scoped changes that are covered by tests, reviewed by peers, enforced by automated tooling, and traceable in both code and database.

 On unit testing, I write at the right levels; where fast unit tests for pure logic (xUnit/NUnit with FluentAssertions), a thinner layer of integration tests that hit real infrastructure (EF Core against SQLite in-memory or SQL Server via Testcontainers), and a few end-to-end smoke tests; I use clear Arrange–Act–Assert naming (e.g., “Should_Calculate_Fee_When_PromoActive”), mock only outer boundaries (HTTP, queue, file, clock), and keep tests deterministic (builders/fixtures, injectable IClock).

For code reviews, I open small PRs (ideally ≤ 300 lines) with a crisp why/what/risk and evidence (tests, screenshots, query metrics) and ask reviewers to use a checklist: readability/naming, nullability/async/cancellation, error handling and logging, performance (allocations, DB round-trips), security (authz), and data-access impacts (SARGability, indexes, plan regression risk); PRs run automated gates—build, unit/integration tests, static analysis, and formatting—and we don’t merge if anything fails.

On coding standards & static analysis I enforce consistency with .editorconfig, Roslyn analyzers/StyleCop, nullable reference types enabled, “warnings as errors,” and `dotnet format` in CI; package versions are centralized (Directory.Packages.props) to avoid drift—this catches leaks, null bugs, and insecure patterns early and keeps code readable. Because I work heavily with SQL, I add a short header summary to every stored procedure (purpose + change log: who/what/when) to give instant context; before changes I prefer versioned migrations (sqlproj/Flyway/DbUp) with up/down scripts under source control and rely on backups/PITR for safety—though in dev I may clone an SP/table to experiment quickly.

I strongly avoid loops in SQL and favor set-based queries with SARGable predicates and correct datatypes to avoid implicit conversions; I design the right indexes (on join/filter columns, using INCLUDE to eliminate key lookups).

In the app I always parameterize with the correct types and sizes to avoid `AddWithValue` surprises. I add observability structured logging (Serilog) with correlation IDs, SQL dependency telemetry (duration/success/fail), health checks including a DB ping, and alerts for error spikes/slow queries—so we can see what broke and why, fast.

```

