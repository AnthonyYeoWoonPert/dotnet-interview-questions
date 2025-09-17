using System.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using HrMvc.Models;

namespace HrMvc.Controllers;

public class EmployeesController : Controller
{
    private readonly string _connStr;
    public EmployeesController(IConfiguration cfg) =>
        _connStr = cfg.GetConnectionString("DefaultConnection")!;

    // GET /Employees?minSalary=4000
    public async Task<IActionResult> Index([FromQuery] decimal minSalary = 4000m)
    {
        const string sql = @"
            SELECT e.Id,
                   e.[Name],
                   d.[Name] AS Department,
                   e.Salary
            FROM Employees e
            LEFT JOIN Departments d ON d.Id = e.DepartmentId
            WHERE e.Salary IS NOT NULL AND e.Salary >= @min
            ORDER BY e.Salary DESC;";

        var rows = new List<EmployeeList.Row>();

        await using var cn = new SqlConnection(_connStr);
        await cn.OpenAsync();

        await using var cmd = new SqlCommand(sql, cn);
        cmd.Parameters.Add(new SqlParameter("@min", SqlDbType.Decimal)
        {
            Precision = 12,
            Scale = 2,
            Value = minSalary
        });

        await using var rdr = await cmd.ExecuteReaderAsync();
        while (await rdr.ReadAsync())
        {
            int id = rdr.GetInt32(rdr.GetOrdinal("Id"));
            string name = rdr["Name"] as string ?? "";
            string dept = rdr["Department"] as string ?? "";
            decimal salary = rdr.GetDecimal(rdr.GetOrdinal("Salary"));

            rows.Add(new EmployeeList.Row(id, name, dept, salary));
        }

        return View(new EmployeeList { MinSalary = minSalary, Rows = rows });
    }

    [HttpPost]
    public IActionResult Filter([FromForm] decimal minSalary) =>
        RedirectToAction(nameof(Index), new { minSalary });
}
