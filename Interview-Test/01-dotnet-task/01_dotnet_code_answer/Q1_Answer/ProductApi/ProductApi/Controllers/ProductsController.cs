using Microsoft.AspNetCore.Mvc;
using ProductApi.Models;
using System.Collections.Generic;
using System.Linq;

namespace ProductApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        // In-memory data store
        private static List<Product> _products = new List<Product>();
        private static int _nextId = 1;

        // GET: api/products
        [HttpGet]
        public ActionResult<IEnumerable<Product>> GetAll()
        {
            return Ok(_products);
        }

        // GET: api/products/{id}
        [HttpGet("{id}")]
        public ActionResult<Product> GetById(int id)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);
            if (product == null)
                return NotFound();

            return Ok(product);
        }

        // POST: api/products
        [HttpPost]
        public ActionResult<Product> Create(Product product)
        {
            product.Id = _nextId++;
            _products.Add(product);

            
            return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
        }

        // PUT: api/products/{id}
        [HttpPut("{id}")]
        public IActionResult Update(int id, Product updatedProduct)
        {
            var existing = _products.FirstOrDefault(p => p.Id == id);
            if (existing == null)
                return NotFound();

            existing.Name = updatedProduct.Name;
            existing.Price = updatedProduct.Price;
            existing.Stock = updatedProduct.Stock;

            return Ok(existing);
        }

        // DELETE: api/products/{id}
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);
            if (product == null)
                return NotFound();

            _products.Remove(product);
            return NoContent();
        }
    }
}
