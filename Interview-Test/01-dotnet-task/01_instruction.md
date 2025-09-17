# Section 1 .NET Theoretical and Coding Exercise 

## Theoretical Exercises
This section assesses your understanding of the challenges and best practices involived in migrating applications from the .NET framework to .NET. 

1. What are the most significant challenges you would expect to face when migrating a large, m,monolithic ASP.NET MVC application from .NET Framework 4.8 to .NET 8? Please describe at least three challenges and explain how you would mitigate them?

2. Explain the role of the .NET Upgrade Assistance. What are its limitations, and when would you choose to use it versus a manual migration approach?

3. Describe the key difference between the project file format (.csproj) in .NET Framework and .NET. What are the advantages of the new SDK-style project format?

4. Your team is migrating a .NET framework application that heavily relies on WCF for communication with other services. What are the recommended alternatives to WCF in the .NET ecosystem, and what factors would you consider when choosing a replacement?

5. How would you handle third-party dependencies that are not compatible with .NET during a migration? Describe a step-by-step process for identifying and resolving such dependencies.

---

### .NET Exercises

6. Explain the concept of async and await in C#. Provide a simple code
example demonstrating their use and explain the benefits of asynchronous
programming in a typical web application context.

'''''
In C#, async and await are keywords that make asynchronous programming easier to write and read. When you mark a method with async, it can contain one or more await expressions. The await keyword tells the program to run the awaited task asynchronously—meaning it can pause at that point, let other work continue , and then resume when the task is done. This avoids blocking a thread while waiting for I/O operations (like database calls, API requests, or file reads), which improves scalability and responsiveness in web applications.

example:-
public async Task<string> GetDataAsync()
{
    using (var httpClient = new HttpClient())
    {
        // "await" lets other work happen while waiting for this request to finish
        string result = await httpClient.GetStringAsync("https://api.example.com/data");
        return result;
    }
}

public async Task<IActionResult> Index()
{
    // Call the async method
    string data = await GetDataAsync();
    return Content(data);
}

''''''



7. Describe the Dependency Injection (DI) pattern and its benefits. How is DI typically implemented in ASP.NET core application? Provide a conceptual code example demonstrating it.
''''''''''
Dependency Injection (DI) means a class doesn’t create the things it depends on (its “dependencies”)—instead, those are provided (injected) from the outside. This keeps code loosely coupled, easier to test, and simpler to change.

The main benefit of Dependency Injection (DI) is that it helps keep code loosely coupled, meaning you can swap out implementations without changing the classes that use them—for example, replacing a real repository with a mock during testing. This makes applications much more testable because you can easily pass in fake objects without rewriting code. It also supports the Single Responsibility Principle, since classes focus only on their own logic rather than creating and managing their dependencies. On top of that, DI centralizes configuration so that all service registrations live in one place, typically in the Program.cs file in an ASP.NET Core application. ASP.NET Core provides a built-in DI container where you register services with lifetimes such as AddSingleton (one instance for the whole app), AddScoped (one instance per web request), or AddTransient (a new instance every time it’s requested). Once registered, services are injected into consumers, usually through constructor injection in controllers, minimal APIs, or background services. This approach makes applications cleaner, easier to maintain, and much more flexible.

example:-
controller :-
[ApiController]
[Route("api/notify")]
public class NotifyController : ControllerBase
{
    private readonly IEmailSender _email;
    private readonly IOptions<SmtpConfig> _smtp; // if you want config too

    public NotifyController(IEmailSender email, IOptions<SmtpConfig> smtp)
    {
        _email = email;
        _smtp = smtp;
    }

    [HttpPost("welcome")]
    public async Task<IActionResult> SendWelcome([FromQuery] string to)
    {
        await _email.SendAsync(to, "Welcome!", "Thanks for signing up.");
        return Ok(new { sent = true, host = _smtp.Value.Host });
    }
}

program.cs:-
var builder = WebApplication.CreateBuilder(args);

// Options/config pattern (optional but common)
builder.Services.Configure<SmtpConfig>(builder.Configuration.GetSection("Smtp"));
builder.Services.AddScoped<IEmailSender, SmtpEmailSender>(); // lifetime: per request
builder.Services.AddControllers();

var app = builder.Build();
app.MapControllers();
app.Run();

''''''''''''''''''''''''''''''''''

8. What is LINQ (Language Integrated Query)? Provide a C# code example that uses LINQ to perform a complex query on collection (e.g., filtering, sorting, and grouping)
''''''''''''''''''''''''''''''''''''''''
LINQ (Language Integrated Query) is a feature in C# that lets you query and manipulate data in a more readable, SQL-like way directly within the language. It works with different data sources such as collections (lists, arrays), databases (via Entity Framework), XML, and more. The main advantage of LINQ is that it provides a consistent, expressive, and strongly typed way to work with data—so you get IntelliSense and compile-time checking while writing queries.

In this example, we filter employees with salaries above 4500, sort them in descending order by salary, and then group them by department. LINQ makes these operations concise, readable, and strongly typed, which is especially useful in real-world scenarios like querying data from a database or working with in-memory collections.

example:-
using System;
using System.Collections.Generic;
using System.Linq;

public class Employee
{
    public string Department { get; set; }
    public string Name { get; set; }
    public int Salary { get; set; }
}

class Program
{
    static void Main()
    {
        var employees = new List<Employee>
        {
            new Employee { Department = "IT", Name = "Alice", Salary = 6000 },
            new Employee { Department = "IT", Name = "Bob", Salary = 4000 },
            new Employee { Department = "HR", Name = "Carol", Salary = 5000 },
            new Employee { Department = "HR", Name = "David", Salary = 7000 },
            new Employee { Department = "Finance", Name = "Eve", Salary = 6500 }
        };

        // LINQ query: filter high earners, sort by salary descending, then group by department
        var query = from emp in employees
                    where emp.Salary > 4500               // filtering
                    orderby emp.Salary descending          // sorting
                    group emp by emp.Department into dept  // grouping
                    select new
                    {
                        Department = dept.Key,
                        Employees = dept.ToList()
                    };

        // Display results
        foreach (var group in query)
        {
            Console.WriteLine($"Department: {group.Department}");
            foreach (var emp in group.Employees)
            {
                Console.WriteLine($"  {emp.Name} - {emp.Salary}");
            }
        }
    }
}

'''''''''''''''''''''''''''''''''''''''''


9. Discuss the differences between IEnumerable<T>, ICollection<T>, IList<T>, and List<T> in C#. When would you choose one over the others.
'''''''''''''''''''''''
IEnumerable<T>
This is the most basic interface for working with collections. It lets you iterate over a sequence of items using foreach, but it doesn’t provide ways to add, remove, or count items. It’s great when you just need to read data in order, especially for deferred execution with LINQ queries. Example: returning query results without exposing modification. IEnumerable<T> is used when you only need to read or iterate through a sequence of items, without adding, removing, or modifying them.

example:-

IEnumerable<int> numbers = new List<int> { 1, 2, 3, 4, 5 };

foreach (var n in numbers)
{
    Console.WriteLine(n); // can only read/iterate
}

ICollection<T>
This builds on IEnumerable<T> and adds basic collection operations such as Count, Add, Remove, and Contains. It represents a collection where you can query the size and modify it, but it doesn’t guarantee indexed access. You’d use this when you want general collection behavior but don’t care about order or indexing. ICollection<T> is used when you want basic collection features like Count, Add, or Remove, but don’t need indexing.

example:-

ICollection<string> fruits = new List<string> { "Apple", "Banana" };
fruits.Add("Orange");
fruits.Remove("Banana");

Console.WriteLine(fruits.Count); // 2


IList<T>
This inherits from ICollection<T> and adds index-based access through the this[int index] indexer. It allows inserting or removing items at specific positions. You’d use IList<T> when you want both collection behavior and the ability to treat the items like an array (accessing items directly by position). IList<T> is used when the order matters and you need to access items by index or insert/remove them at specific positions.

example:-

IList<string> cities = new List<string> { "London", "Paris" };
cities.Insert(1, "Tokyo"); // insert at position 1

Console.WriteLine(cities[1]); // Tokyo


List<T>
This is the concrete implementation of IList<T> provided by .NET. It’s the most commonly used class for everyday programming when you need a dynamic array that can grow or shrink and supports indexing, adding, removing, and searching. List<T> is used when you need a concrete, general-purpose, resizable collection that supports all common operations like adding, removing, and indexing.

example:-

List<int> scores = new List<int>();
scores.Add(90);
scores.Add(80);
scores.Add(70);

scores.Sort(); // has extra methods
Console.WriteLine(string.Join(", ", scores)); // 70, 80, 90

''''''''''''''''''''''''''''''''''


---

## Coding Exercises

1. You are tasked with building a simple RESTful API endpoint in ASP.NET Core that manages a collection of Product objects. Each Product has an Id (int), Name (string), Price (decimal) and Stock (int). Implement the following: 
    - A Product model class.  
    - A simple in-memory data store (e.g., List<Product>) 
    - An API endpoint (GET /api/products) that returns all products. 
    - An API endpoint (GET /api/products/{id}) that returns a single product by its ID. 
    - An API endpoint (POST /api/products) that adds a new product. Ensure that the Id is unique and generated by system (e.g., incrementing integer) 
    - An API endpoint (PUT /api/products/{id}) that updates an existing product. Return a 404 of the product is not found.
    - An API endpoint (DELETE /api/products/{id}) that deletes a product. Return 404 if the product is not found. 

2. Create a .NET console application that simulates a basic Order processing system 
    - Define a class Order with properties OrderId (int), CustomerName (string), TotalAmount(decimal), IsProcessed(bool, default false)
    - Store a list of orders in memory. 
    - Write a method ProcessOrderAsync() that simulates order processing with a 2-second delay per order (use Task.Delay). After processing, IsProcessed = true
    - In Main(), print all the unprocessed orders, call processOrderAsync, and print all processed orders once done. 

3. Build a feature in the HR web application to display a list of employees 
    - whose salary is RM4,000 and above. 
    - the salary threshold should be a parameter from the web app.
    - Ensure the SQL database connection is ready.
    - Use the tables provided in coding questions _Interview-Test/02-tsql-task/create_database_table.sql_

4. You are given a basic ASP.NET MVC Web Application for managing stock. The system should allow:
    - Listing all products
    - Adding a new product
    - Updating stock
However, the code has errors (compile-time + runtime). Find out and fix them.


## Submission 

You may create one directory for each coding question you complete and commit.
Please define which .NET version you are using
