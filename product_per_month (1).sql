-- Membuat temporary table
CREATE TEMP TABLE report_monthly_orders_product_agg AS
SELECT 
    p.name AS product_name,
    p.brand,
    p.category,
    FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS month,
    o.status,
    COUNT(o.product_id) AS total_sales,
    SUM(o.sale_price) AS total_revenue 
FROM 
    `bigquery-public-data.thelook_ecommerce.products` p
LEFT JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` o
ON 
    p.id = o.product_id
WHERE
    o.status = 'Complete'
GROUP BY 
    product_name, 
    month,
    o.status,
    p.brand,
    p.category        
HAVING
    month IS NOT NULL AND total_revenue IS NOT NULL AND p.brand IS NOT NULL;


-- Mencari produk dengan penjualan tertinggi setiap bulannya
SELECT 
    month, 
    product_name, 
    brand,
    category,
    total_sales,
    ROUND(total_revenue,2) AS total_revenue,
    status    
FROM 
    (
        SELECT 
            month, 
            product_name,
            brand,
            category, 
            total_sales,
            total_revenue,
            status,
            ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_sales DESC, total_revenue DESC) as row_num
        FROM 
           report_monthly_orders_product_agg
    ) 
WHERE 
    row_num = 1
ORDER BY month ASC;
