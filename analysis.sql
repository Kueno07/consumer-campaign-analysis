-- Reference schema: campaign_assignment(customer_id, variant, assignment_group, segment_id)
--                 customer_sales(customer_id, net_sales)
-- PostgreSQL syntax. assignment_group is 'control' or 'treatment'.

WITH customer_outcomes AS (
    SELECT
        a.customer_id,
        a.variant,
        a.assignment_group,
        a.segment_id,
        COALESCE(SUM(s.net_sales), 0) AS net_sales
    FROM campaign_assignment AS a
    LEFT JOIN customer_sales AS s
        ON s.customer_id = a.customer_id
    GROUP BY a.customer_id, a.variant, a.assignment_group, a.segment_id
),
segment_results AS (
    SELECT
        variant,
        segment_id,
        COUNT(*) FILTER (WHERE assignment_group = 'control') AS control_customers,
        COUNT(*) FILTER (WHERE assignment_group = 'treatment') AS treatment_customers,
        AVG(net_sales) FILTER (WHERE assignment_group = 'control') AS control_avg_sales,
        AVG(net_sales) FILTER (WHERE assignment_group = 'treatment') AS treatment_avg_sales
    FROM customer_outcomes
    GROUP BY variant, segment_id
)
SELECT
    variant,
    segment_id,
    control_customers,
    treatment_customers,
    control_avg_sales,
    treatment_avg_sales,
    treatment_avg_sales - control_avg_sales AS absolute_lift,
    (treatment_avg_sales / NULLIF(control_avg_sales, 0)) - 1 AS relative_lift
FROM segment_results
ORDER BY variant, segment_id;

-- Reference schema: department_sales(department_id, department_name, year, sales, customers)
-- Compare complete years. NULLIF avoids dividing by a zero prior-year value.
WITH annual AS (
    SELECT
        department_id,
        department_name,
        year,
        SUM(sales) AS sales,
        SUM(customers) AS customers
    FROM department_sales
    GROUP BY department_id, department_name, year
), changes AS (
    SELECT
        *,
        LAG(sales) OVER (PARTITION BY department_id ORDER BY year) AS prior_year_sales
    FROM annual
)
SELECT
    department_id,
    department_name,
    year,
    sales,
    customers,
    sales / NULLIF(customers, 0) AS average_sales_per_customer,
    sales - prior_year_sales AS sales_change,
    (sales / NULLIF(prior_year_sales, 0)) - 1 AS sales_change_rate
FROM changes
ORDER BY department_name, year;
