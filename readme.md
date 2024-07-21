# Mencari Produk Dengan Penjualan Tertinggi Setiap Bulan (E-Commerce)

## Membuat Temporary Table

Pertama-tama kita membuat temporary table terlebih dahulu untuk menampung kolom yang telah dimodifikasi dan terdiri dari informasi setiap produk beserta waktu transaksinya 

### Langkah 1:

```bash
CREATE TEMP TABLE report_monthly_orders_product_agg AS
```

Membuat temporary tabel ‘report_monthly_orders_product_agg’ dengan perintah ‘CREATE TEMP TABLE’, dimana tabel tersebut terdiri dari beberapa kolom 

### Langkah 2:

```bash
SELECT 
    p.name AS product_name,
    p.brand,
    p.category,
    FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS month,
    o.status,
    COUNT(o.product_id) AS total_sales,
    SUM(o.sale_price) AS total_revenue 
```

Memunculkan kolom yang terdiri dari: product_name, month, status, total_sales, dan total_revenue

product_name didapatkan dari kolom name pada tabel `bigquery-public-data.thelook_ecommerce.products` yang dilambangkan dengan p

brand didapatkan dari kolom name pada tabel `bigquery-public-data.thelook_ecommerce.products` yang dilambangkan dengan p

category didapatkan dari kolom name pada tabel `bigquery-public-data.thelook_ecommerce.products` yang dilambangkan dengan p

month didapatkan dari kolom created_at pada tabel `bigquery-public-data.thelook_ecommerce.order_items` yang dilambangkan dengan o, kolom mothn di modifikasi agar hanya memunculkan tahun-bulan saja dengan perintah ‘FORMAT_TIMESTAMP’

status didapatkan dari kolom status pada tabel  `bigquery-public-data.thelook_ecommerce.order_items` yang dilambangkan dengan o

total_sales didapatkan dari perhitungan total munculnya product_id pada tabel `bigquery-public-data.thelook_ecommerce.order_items` yang dilambangkan dengan o

total_revenue didapatkan dari penjumlahan sale_price untuk setiap produk pada tabel 
`bigquery-public-data.thelook_ecommerce.order_items` yang dilambangkan dengan o

### Langkah 3:

```bash
FROM 
    `bigquery-public-data.thelook_ecommerce.products` p
LEFT JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` o
ON 
    p.id = o.product_id
```
Kolom diambil dari tabel `bigquery-public-data.thelook_ecommerce.products`yang dilambangkan dengan p dan melakukan irisan (LEFT JOIN) dengan tabel `bigquery-public-data.thelook_ecommerce.order_items`yang dilambangkan dengan o di product_id pada masing-masing tabel 

### Langkah 4:

```bash
WHERE
    o.status = 'Complete'
```
Kueri ini berfungsi agar informasi produk yang ditampilkan hanyalah produk yang memiliki status complete

### Langkah 5:

```bash
GROUP BY 
    product_name, 
    month,
    o.status,
    p.brand,
    p.category   
```
Tabel akan dikelompokkan menggunakan perintah 'GROUP BY' sesuai dengan product_name, month, status, brand dan category

### Langkah 6:

```bash
HAVING
    month IS NOT NULL AND total_revenue IS NOT NULL AND p.brand IS NOT NULL;
```
Tabel difilter menggunakan perintah ‘HAVING’, dimana tabel hanya memunculkan hasil kolom month yang tidak kosong, total_revenue yang tidak kosong dan brand yang tidak kosong 
