
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

SELECT DISTINCT l.nombre AS local, p.nombre AS producto, vd.total_vendido as total
FROM local l
JOIN (
    SELECT v.id_local, vd.id_producto, SUM(vd.cantidad) AS total_vendido
    FROM ventaDetalle vd
    JOIN venta v ON vd.id_venta = v.id_venta
    GROUP BY v.id_local, vd.id_producto
    HAVING SUM(vd.cantidad) = (
        SELECT MAX(total_vendido)
        FROM (
            SELECT v.id_local, vd.id_producto, SUM(vd.cantidad) AS total_vendido
            FROM ventaDetalle vd
            JOIN venta v ON vd.id_venta = v.id_venta
            GROUP BY v.id_local, vd.id_producto
        ) AS subquery
        WHERE subquery.id_local = v.id_local
    )
) AS vd ON l.id_local = vd.id_local
JOIN producto p ON vd.id_producto = p.id_producto








