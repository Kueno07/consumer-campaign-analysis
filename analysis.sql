-- PostgreSQL reference query.
-- Grain: one campaign_assignment row per experiment/customer.
-- assignment_group is 'control' or 'treatment'. Outcome windows are half-open.
-- Assumption: campaigns do not overlap for the same customer during an outcome window.

WITH customer_outcomes AS (
    SELECT
        a.experiment_id,
        a.customer_id,
        a.assignment_group,
        a.segment_id,
        COALESCE(SUM(s.net_sales), 0)::numeric AS net_sales
    FROM campaign_assignment AS a
    LEFT JOIN customer_sales AS s
        ON s.customer_id = a.customer_id
       AND s.sale_at >= a.outcome_start
       AND s.sale_at < a.outcome_end
    GROUP BY
        a.experiment_id,
        a.customer_id,
        a.assignment_group,
        a.segment_id
),
segment_results AS (
    SELECT
        experiment_id,
        segment_id,
        COUNT(*) FILTER (WHERE assignment_group = 'control') AS control_customers,
        COUNT(*) FILTER (WHERE assignment_group = 'treatment') AS treatment_customers,
        AVG(net_sales) FILTER (WHERE assignment_group = 'control') AS control_avg_sales,
        AVG(net_sales) FILTER (WHERE assignment_group = 'treatment') AS treatment_avg_sales
    FROM customer_outcomes
    GROUP BY experiment_id, segment_id
)
SELECT
    experiment_id,
    segment_id,
    control_customers,
    treatment_customers,
    control_avg_sales,
    treatment_avg_sales,
    treatment_avg_sales - control_avg_sales AS absolute_lift,
    CASE
        WHEN control_avg_sales > 0
        THEN (treatment_avg_sales / control_avg_sales) - 1
    END AS relative_lift
FROM segment_results
ORDER BY experiment_id, segment_id;

-- Reference schema: department_year(department_id, department_name, year,
--                                   net_sales, customers)
-- Grain: one row per department/calendar year; customers is annual unique customers.
WITH changes AS (
    SELECT
        d.*,
        LAG(year) OVER department_years AS prior_year,
        LAG(net_sales) OVER department_years AS prior_year_sales
    FROM department_year AS d
    WINDOW department_years AS (PARTITION BY department_id ORDER BY year)
)
SELECT
    department_id,
    department_name,
    year,
    net_sales,
    customers,
    CASE WHEN customers > 0 THEN net_sales / customers END AS sales_per_customer,
    CASE WHEN prior_year = year - 1 THEN net_sales - prior_year_sales END AS yoy_sales_change,
    CASE
        WHEN prior_year = year - 1 AND prior_year_sales > 0
        THEN (net_sales / prior_year_sales) - 1
    END AS yoy_sales_change_rate
FROM changes
ORDER BY department_name, year;
