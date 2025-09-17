namespace HrMvc.Models
{
    public class EmployeeList
    {
        public decimal MinSalary { get; set; } = 4000m;
        public IEnumerable<Row> Rows { get; set; } = Enumerable.Empty<Row>();
        public record Row(int Id, string Name, string Department, decimal Salary);
    }
}
