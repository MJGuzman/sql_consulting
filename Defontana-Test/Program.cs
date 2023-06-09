using Defontana_Test.Models;
using Microsoft.EntityFrameworkCore;

using (var dbContext = new PruebaContext())
{
    var ventas = dbContext.Venta
               .Where(v => v.Fecha >= DateTime.Now.AddDays(-30))
               .Include(v => v.VentaDetalles)
               .ThenInclude(d => d.IdProductoNavigation)
               .ToList();

    Console.WriteLine("--------------------------------------------------------");

    // El total de ventas de los últimos 30 días
    var totalVentas = ventas.Sum(v => v.Total);
    var cantidadVentas = ventas.Count();

    Console.WriteLine("Total de ventas de los últimos 30 días:");
    Console.WriteLine($"Monto total: {totalVentas}");
    Console.WriteLine($"Cantidad de ventas: {cantidadVentas}");
    Console.WriteLine();

    Console.WriteLine("--------------------------------------------------------");

    // El día y hora en que se realizó la venta con el monto más alto
    var ventaMasAlta = ventas.OrderByDescending(v => v.Total).FirstOrDefault();
    Console.WriteLine("Venta con el monto más alto:");
    Console.WriteLine($"Fecha: {ventaMasAlta?.Fecha}");
    Console.WriteLine($"Monto: {ventaMasAlta?.Total}");
    Console.WriteLine();

    Console.WriteLine("--------------------------------------------------------");

    // Producto con mayor monto total de ventas
    var productoMasVendido = ventas
        .SelectMany(v => v.VentaDetalles)
        .GroupBy(d => d.IdProducto)
        .OrderByDescending(g => g.Sum(d => d.PrecioUnitario * d.Cantidad))
        .FirstOrDefault()?.Key;
    var producto = dbContext.Productos.Find(productoMasVendido);
    Console.WriteLine("Producto con mayor monto total de ventas:");
    Console.WriteLine($"Nombre: {producto.Nombre}");
    Console.WriteLine($"Monto total de ventas: {productoMasVendido}");
    Console.WriteLine();

    Console.WriteLine("--------------------------------------------------------");

    // Local con mayor monto de ventas
    var localMasVendido = ventas
        .GroupBy(v => v.IdLocal)
        .OrderByDescending(g => g.Sum(v => v.Total))
        .FirstOrDefault()?.Key;
    var local = dbContext.Locals.Find(localMasVendido);
    Console.WriteLine("Local con mayor monto de ventas:");
    Console.WriteLine($"Nombre: {local.Nombre}");
    Console.WriteLine($"Monto total de ventas: {localMasVendido}");
    Console.WriteLine();

    Console.WriteLine("--------------------------------------------------------");

    // Marca con mayor margen de ganancias
    var marcaConMayorMargen = dbContext.Marcas
        .OrderByDescending(m => m.Productos
            .SelectMany(p => p.VentaDetalles)
            .Sum(d => (d.PrecioUnitario - producto.CostoUnitario) * d.Cantidad))
        .FirstOrDefault();
    Console.WriteLine("Marca con mayor margen de ganancias:");
    Console.WriteLine($"Nombre: {marcaConMayorMargen.Nombre}");
    Console.WriteLine();

    Console.WriteLine("--------------------------------------------------------");


    // Producto más vendido en cada local
    var productosMasVendidosPorLocal = ventas
        .GroupBy(v => v.IdLocal)
        .Select(g => new
        {
            LocalId = g.Key,
            ProductoId = g.SelectMany(v => v.VentaDetalles)
                .GroupBy(d => d.IdProducto)
                .OrderByDescending(g => g.Sum(d => d.Cantidad))
                .FirstOrDefault()?.Key
        })
        .ToList();

    
    Console.WriteLine("Producto más vendido en cada local:");
    foreach (var productoPorLocal in productosMasVendidosPorLocal)
    {
        var localNombre = dbContext.Locals.Find(productoPorLocal.LocalId)?.Nombre;
        var productoNombre = dbContext.Productos.Find(productoPorLocal.ProductoId)?.Nombre;
        Console.WriteLine($"Local: {localNombre}");
        Console.WriteLine($"Producto: {productoNombre}");
        Console.WriteLine();
    }

    Console.ReadKey();
}


