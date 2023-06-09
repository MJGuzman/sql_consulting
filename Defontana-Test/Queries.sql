
-- El total de ventas de los últimos 30 días
SELECT SUM(total) AS MontoTotal, COUNT(*) AS CantidadVentas
FROM venta
WHERE fecha >= DATEADD(day, -30, GETDATE())

-- El día y hora en que se realizó la venta con el monto más alto
SELECT TOP 1 fecha, total AS Monto
FROM venta
ORDER BY total DESC

-- Producto con mayor monto total de ventas
SELECT TOP 1 p.nombre AS Producto, SUM(d.precio_unitario * d.cantidad) AS MontoTotalVentas
FROM ventaDetalle AS d
INNER JOIN producto AS p ON d.id_producto = p.ID_Producto
GROUP BY d.id_producto, p.nombre
ORDER BY MontoTotalVentas DESC

-- Local con mayor monto de ventas
SELECT TOP 1 l.nombre AS Local, SUM(v.Total) AS MontoTotalVentas
FROM venta AS v
INNER JOIN local AS l ON v.id_local = l.ID_Local
GROUP BY v.id_local, l.nombre
ORDER BY MontoTotalVentas DESC

-- Marca con mayor margen de ganancias
SELECT TOP 1 m.nombre AS Marca, SUM((vd.precio_unitario - p.Costo_Unitario) * vd.cantidad) AS MargenGanancias
FROM ventaDetalle AS vd
INNER JOIN producto AS p ON vd.id_producto = p.ID_Producto
INNER JOIN marca AS m ON p.id_marca = m.ID_Marca
GROUP BY p.id_marca, m.nombre
ORDER BY MargenGanancias DESC

-- Producto más vendido en cada local

SELECT l.Nombre AS local, p.Nombre AS Producto, d.TotalVendido
FROM
    local l
    CROSS APPLY (
        SELECT TOP 1 d.ID_Producto, SUM(d.Cantidad) AS TotalVendido
        FROM
            Venta v
            INNER JOIN VentaDetalle d ON v.ID_Venta = d.ID_Venta
        WHERE v.ID_Local = l.ID_Local AND v.Fecha BETWEEN DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)
        GROUP BY d.ID_Producto
        ORDER BY SUM(d.Cantidad) DESC
    ) d
INNER JOIN Producto p ON d.ID_Producto = p.ID_Producto;








