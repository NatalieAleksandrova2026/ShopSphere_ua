Block 1. SQL: Datenvorbereitung

1.1. Berechnen Sie den gesamten Nettoumsatz (net_amount), die Anzahl der Bestellungen und den
durchschnittlichen Bestellwert für jede REGION und jedes JAHR. Erforderlich ist ein JOIN von orders
mit customers.

SELECT
    c.region                                   AS region,
    o.order_year                               AS order_year,
    SUM(o.net_amount)                          AS total_net_revenue,
    COUNT(o.order_id)                          AS order_count,
    ROUND(SUM(o.net_amount) * 1.0 / COUNT(o.order_id), 2) AS avg_order_value
FROM shopsphere_orders AS o
JOIN shopsphere_customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    c.region,
    o.order_year
ORDER BY
    c.region,
    o.order_year;

1.2. Finden Sie die Top-10-Kunden nach Gesamtausgaben. Geben Sie deren Region,
Akquisitionskanal und die Anzahl der getätigten Bestellungen an.

SELECT
    c.customer_id                      AS customer_id,
    c.region                           AS region,
    c.acquisition_chan              AS acquisition_channel,
    COUNT(o.order_id)                  AS order_count,
    SUM(o.net_amount)                  AS total_spent
FROM shopsphere_orders AS o
JOIN shopsphere_customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.region,
    c.acquisition_chan
ORDER BY
    total_spent DESC
LIMIT 10;

1.3. Berechnen Sie für jede Produktkategorie: den Gesamtumsatz, die durchschnittliche Marge
(margin_pct) und den Retourenanteil. Dafür müssen order_items, products und orders
zusammengeführt werden.

SELECT
    p.category                                                           AS category,
    SUM(oi.line_total)                                                   AS total_revenue,
    ROUND(AVG(p.margin_pct), 2)                                          AS avg_margin_pct,
    ROUND(
        COUNT(DISTINCT CASE WHEN o.is_returned = 1 THEN oi.order_id END) * 1.0
        / COUNT(DISTINCT oi.order_id), 4
    ) AS return_rate
FROM shopsphere_order_items AS oi
JOIN shopsphere_products AS p
    ON oi.product_id = p.product_id
JOIN shopsphere_orders AS o
    ON oi.order_id = o.order_id
GROUP BY
    p.category
ORDER BY
    total_revenue DESC;

1.4. Finden Sie mittels Unterabfrage die Kunden, deren Gesamtausgaben den durchschnittlichen
Ausgabenwert über die gesamte Datenbank hinweg übersteigen. Wie viele sind es? Welchen Anteil am
Gesamtumsatz haben sie?

SELECT
    COUNT(*)                                                  AS customers_above_avg,
    SUM(t.customer_total)                                     AS revenue_above_avg,
    ROUND(
        SUM(t.customer_total) * 1.0 /
        (SELECT SUM(net_amount) FROM shopsphere_orders), 4
    )                                                          AS share_of_total_revenue
FROM (
    SELECT
        customer_id,
        SUM(net_amount) AS customer_total
    FROM shopsphere_orders
   GROUP BY customer_id
) AS t
WHERE t.customer_total > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(net_amount) AS customer_total
        FROM shopsphere_orders
        GROUP BY customer_id
    )
);

1.5. Berechnen Sie für jeden Marketingkanal: das Gesamtbudget, den gesamten zugeschriebenen
Umsatz und den ROI (Umsatz / Budget). Verwenden Sie die Tabelle marketing.

SELECT
    channel                                                  AS channel,
    SUM(budget)                                              AS total_budget,
    SUM(attributed_reven)                                  AS total_attributed_revenue,
    ROUND(SUM(attributed_reven) * 1.0 / SUM(budget), 2)    AS roi
FROM shopsphere_marketing
GROUP BY
    channel
ORDER BY
    roi DESC;

2.1. Saisonalität. Liniendiagramm des Gesamtumsatzes nach Monaten über den gesamten Zeitraum.
Gibt es saisonale Spitzen? Wann verdient das Unternehmen am meisten?

SELECT
    order_year                                   AS order_year,
    order_month                                  AS order_month,
    SUM(net_amount)                              AS total_revenue
FROM shopsphere_orders
GROUP BY
    order_year, order_month
ORDER BY
    order_year, order_month;

2.2. Marketing: Budget vs. Effizienz. Vergleichen Sie die Kanäle nach Budget und ROI. Tipp: Eine
Dual-Axis- oder Scatter-Darstellung zeigt gut, ob das Budget sinnvoll verteilt ist.

SELECT
    channel                                                  AS channel,
    year                                                     AS year,
    SUM(budget)                                              AS total_budget,
    SUM(attributed_reven)                                  AS total_attributed_revenue,
    ROUND(SUM(attributed_reven) * 1.0 / SUM(budget), 2)    AS roi
FROM shopsphere_marketing
GROUP BY
    channel, year
ORDER BY
    channel, year;

2.3. Kategorien: Volumen vs. Profitabilität. Scatter- oder Bubble-Chart: Umsatz auf der X-Achse,
Marge auf der Y-Achse, Punktgröße = Retourenanteil. Welche Kategorien sind „versteckte
Diamanten“?

SELECT
    p.category                                                           AS category,
    o.order_year                                                         AS order_year,
    c.region                                                             AS region,
    SUM(oi.line_total)                                                   AS total_revenue,
    ROUND(AVG(p.margin_pct), 2)                                          AS avg_margin_pct,
    COUNT(DISTINCT CASE WHEN o.is_returned = 1 THEN oi.order_id END)     AS returned_orders,
    COUNT(DISTINCT oi.order_id)                                          AS total_orders
FROM shopsphere_order_items AS oi
JOIN shopsphere_products AS p
    ON oi.product_id = p.product_id
JOIN shopsphere_orders AS o
    ON oi.order_id = o.order_id
JOIN shopsphere_customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    p.category, o.order_year, c.region
ORDER BY
    p.category, o.order_year, c.region;
  


2.5. Kundenbeitrag (Pareto). Visualisieren Sie, welchen Umsatzanteil die Top-Kunden erwirtschaften.
Tipp: kumulatives Diagramm oder einfacher Vergleich „Top 5 % vs. Rest“.

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(net_amount) AS total_spent
    FROM shopsphere_orders
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spent,
        NTILE(20) OVER (ORDER BY total_spent DESC) AS percentile_bucket
    FROM customer_totals
)
SELECT
    percentile_bucket                          AS percentile_bucket,
    COUNT(*)                                    AS customers_in_bucket,
    SUM(total_spent)                            AS bucket_revenue
FROM ranked
GROUP BY percentile_bucket
ORDER BY percentile_bucket;

2.5.1.
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(net_amount) AS total_spent
    FROM shopsphere_orders
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spent,
        NTILE(20) OVER (ORDER BY total_spent DESC) AS percentile_bucket
    FROM customer_totals
)
SELECT
    CASE WHEN percentile_bucket = 1 THEN 'Top 5%' ELSE 'Rest 95%' END AS customer_group,
    COUNT(*)                                                          AS customer_count,
    SUM(total_spent)                                                  AS total_revenue,
    ROUND(
        SUM(total_spent) * 100.0 /
        (SELECT SUM(total_spent) FROM customer_totals), 2
    )                                                                  AS pct_of_total_revenue
FROM ranked
GROUP BY customer_group
ORDER BY customer_group;

2.5.2. Pareto mit Region


WITH customer_totals AS (
    SELECT
        o.customer_id                    AS customer_id,
        c.region                         AS region,
        SUM(o.net_amount)                AS total_spent
    FROM shopsphere_orders AS o
    JOIN shopsphere_customers AS c
        ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.region
),
ranked AS (
    SELECT
   customer_id,
        region,
        total_spent,
        NTILE(20) OVER (ORDER BY total_spent DESC) AS percentile_bucket
    FROM customer_totals
)
SELECT
    percentile_bucket                          AS percentile_bucket,
    region                                      AS region,
    COUNT(*)                                    AS customers_in_bucket,
    SUM(total_spent)                            AS bucket_revenue
FROM ranked
GROUP BY percentile_bucket, region
ORDER BY percentile_bucket, region;
 

2.6. (Kreativ). Wählen Sie einen noch nicht untersuchten Datenausschnitt und erstellen Sie eine
Visualisierung nach eigenem Ermessen. Überraschen Sie uns mit einem Insight.

SELECT
    c.acquisition_chan                                      AS acquisition_channel,
    COUNT(DISTINCT c.customer_id)                              AS customer_count,
    SUM(o.net_amount)                                          AS total_revenue,
    ROUND(SUM(o.net_amount) * 1.0 / COUNT(DISTINCT c.customer_id), 2) AS avg_ltv_per_customer,
    ROUND(COUNT(o.order_id) * 1.0 / COUNT(DISTINCT c.customer_id), 2)  AS avg_orders_per_customer
FROM shopsphere_customers AS c
JOIN shopsphere_orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.acquisition_chan
ORDER BY
    avg_ltv_per_customer DESC;
KPI:

SELECT
    o.order_id                                 AS order_id,
    o.order_year                               AS order_year,
    c.region                                    AS region,
    o.net_amount                                AS net_amount,
    o.is_returned                               AS is_returned
FROM shopsphere_orders AS o
JOIN shopsphere_customers AS c
    ON o.customer_id = c.customer_id;
 Block 4.8

WITH customer_discount AS (
    SELECT
        customer_id,
        AVG(discount_pct)                          AS avg_discount,
        COUNT(order_id)                             AS order_count,
        SUM(net_amount)                              AS total_spent
    FROM shopsphere_orders
    GROUP BY customer_id
)
SELECT
    CASE WHEN avg_discount > 20 THEN 'Discount-Kunden (>20%)' ELSE 'Übrige Kunden' END AS segment,
    COUNT(*)                                          AS customer_count,
    ROUND(AVG(order_count), 2)                        AS avg_orders_per_customer,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END)  AS one_time_buyers,
    ROUND(SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_one_time_buyers,
    ROUND(AVG(total_spent), 2)                        AS avg_total_spent
FROM customer_discount
GROUP BY segment;

Block 4.9

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(net_amount) AS total_spent
    FROM shopsphere_orders
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spent,
        NTILE(20) OVER (ORDER BY total_spent DESC) AS percentile_bucket
    FROM customer_totals
),
top5 AS (
    SELECT customer_id, total_spent
    FROM ranked
    WHERE percentile_bucket = 1
)
SELECT
    c.region                                   AS region,
    c.acquisition_chan                       AS acquisition_channel,
    COUNT(*)                                    AS top_customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_top5
FROM top5
JOIN shopsphere_customers AS c
    ON top5.customer_id = c.customer_id
GROUP BY c.region, c.acquisition_chan
ORDER BY top_customer_count DESC;
