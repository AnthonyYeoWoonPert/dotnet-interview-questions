using Microsoft.AspNetCore.Mvc;
using StockManagement.Models;
using System.Collections.Generic;
using System.Linq;


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


        //i add this
        public ActionResult Edit(int id)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);


            return View(product);
        }

        [HttpPost]
        public ActionResult Create(Product product)
        {
            if (ModelState.IsValid)
            {
                product.Id = _products.Count + 1;

                //i add this

                _products.Add(product);

                return RedirectToAction("Index");
            }
            return View(product);
        }

        [HttpPost]
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