using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


//use microsoft visual studio
//then create new project
//    then search for console app template
//    then name it as OrderProcessingApp
//    use .net 8

namespace OrderProcessingApp
{
    public class Order
    {
        public int OrderId { get; set; }
        public string CustomerName { get; set; }
        public decimal TotalAmount { get; set; }
        public bool IsProcessed { get; set; } = false;
    }

    class Program
    {
        public static async Task ProcessOrdersAsync(List<Order> orders)
        {
            foreach (var order in orders)
            {
                Console.WriteLine($"Processing Order {order.OrderId} for {order.CustomerName}...");
                await Task.Delay(2000);
                order.IsProcessed = true;
                Console.WriteLine($"Order {order.OrderId} processed");
            }
        }

        static async Task Main(string[] args)
        {
            List<Order> orders = new List<Order>
            {
                new Order { OrderId = 1, CustomerName = "Alice", TotalAmount = 150.75m },
                new Order { OrderId = 2, CustomerName = "Bob", TotalAmount = 299.99m },
                new Order { OrderId = 3, CustomerName = "Charlie", TotalAmount = 89.50m }
            };

            Console.WriteLine("Unprocessed Orders:");
            foreach (var order in orders.Where(o => !o.IsProcessed))
            {
                Console.WriteLine($"OrderId: {order.OrderId}, Customer: {order.CustomerName}, Amount: {order.TotalAmount}");
            }

            Console.WriteLine("\n--- Starting Order Processing ---\n");

            await ProcessOrdersAsync(orders);

            Console.WriteLine("\n--- All Orders Processed ---\n");

            Console.WriteLine("Processed Orders:");
            foreach (var order in orders.Where(o => o.IsProcessed))
            {
                Console.WriteLine($"OrderId: {order.OrderId}, Customer: {order.CustomerName}, Amount: {order.TotalAmount}, Status: Processed");
            }
        }
    }
}
