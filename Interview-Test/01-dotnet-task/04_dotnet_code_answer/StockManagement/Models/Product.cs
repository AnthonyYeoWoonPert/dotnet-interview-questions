using System.ComponentModel.DataAnnotations;

namespace StockManagement.Models
{
    public class Product
    {
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }
        
        public string Quantity { get; set; }
    }
}
