
--consulta 1. Resumen ejecutivo mensual--

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO

-- Consulta 2. Top 5 de productos por facturación

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


--Consulta 3 Clientes que hicieron más de un pedido

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


--Consulta 4. Meses por encima o por debajo del promedio mensual

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'

        ELSE 'Por debajo'
    END AS comparacion_promedio

FROM facturacion_mensual
ORDER BY mes;
GO

-- HALLAZGOS
-- 1. El producto 1 lidera la facturación con $3.600, representando aproximadamente el 56% del total.
-- 2. El producto 2 presenta el mayor volumen de ventas con 13 unidades, pero genera solo $364, mostrando que mayor cantidad vendida no implica necesariamente mayor facturación.
-- 3. El cliente 1 (Maria Lopez) registra el mayor gasto acumulado, con $2.640 distribuidos en 2 pedidos.