-- Consulta 1: Vista base del proyecto (INNER JOIN)

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta

FROM ventas AS v

INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente

INNER JOIN productos AS p
    ON v.id_producto = p.id_producto

INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categorias

ORDER BY v.fecha_venta;

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que todavía
-- no realizaron ninguna compra.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro

FROM clientes AS c

LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente

WHERE v.id_venta IS NULL;
-- Se encontraron 0 clientes sin ventas.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar productos del catálogo que no registraron ventas,

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio

FROM productos AS p

LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto

LEFT JOIN categorias AS cat
    ON p.id_categoria = cat.id_categorias

WHERE v.id_venta IS NULL;
-- Se encontraron 0 productos sin ventas.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: separar las ventas en dos períodos y comparar
-- la facturación total de cada grupo utilizando UNION ALL.

SELECT
    canal,
    SUM(total) AS total_canal

FROM (

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        '05 al 10 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        '11 al 15 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'

) AS consolidado

GROUP BY canal

ORDER BY total_canal DESC;

-- Hallazgo:
-- El período del 05 al 10 de marzo concentró la mayor facturación,
