using StockManagement.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace StockManagement.Controllers
{
    public class ProductsController : Controller
    {
        // In-memory list of products
        private static List<Product> _products = new List<Product>();

        public ActionResult Index()
        {
            return View(_products);
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Product product)
        {
            if (ModelState.IsValid)
            {
                product.Id = _products.Count + 1;

                return RedirectToAction("Index");
            }
            return View(product);
        }

        public ActionResult UpdateStock(int id, int newQty)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);
            if (product != null)
            {
                product.Quantity = newQty.ToString();
            }
            return RedirectToAction("Index");
        }
    }
}
