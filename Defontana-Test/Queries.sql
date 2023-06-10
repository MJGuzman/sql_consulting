
-- El total de ventas de los últimos 30 días
SELECT SUM(total) AS MontoTotal, COUNT(*) AS CantidadVentas
FROM venta
WHERE fecha >= DATEADD(day, -30, GETDATE())


-- El día y hora en que se realizó la venta con el monto más alto
SELECT TOP 1 fecha, total AS Monto
FROM venta
Where Fecha >= DATEADD(DAY, -30, CAST(GETDATE() As Date))
ORDER BY total DESC

-- Producto con mayor monto total de ventas
SELECT TOP 1 p.nombre AS Producto, SUM(d.precio_unitario * d.cantidad) AS MontoTotalVentas
FROM ventaDetalle AS d
Inner Join Venta v On d.ID_Venta = v.ID_Venta
INNER JOIN producto AS p ON d.id_producto = p.ID_Producto
Where v.Fecha >= DATEADD(DAY, -30, CAST(GETDATE() As Date))
GROUP BY d.id_producto, p.nombre
ORDER BY MontoTotalVentas DESC


-- Local con mayor monto de ventas
SELECT top 1 l.nombre, SUM(v.total) AS monto_total_ventas
FROM local l
JOIN venta v ON l.id_local = v.id_local
WHERE v.fecha >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY l.nombre
ORDER BY monto_total_ventas DESC


-- Marca con mayor margen de ganancias
SELECT TOP 1 m.nombre, SUM((vd.precio_unitario - p.Costo_Unitario) * vd.cantidad) AS margen_ganancias
FROM marca m
JOIN Producto p ON m.id_marca = p.id_marca
JOIN ventaDetalle vd ON p.id_producto = vd.id_producto
WHERE vd.id_venta IN (
    SELECT id_venta
    FROM venta
    WHERE fecha >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
)
GROUP BY m.nombre
ORDER BY margen_ganancias DESC


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






