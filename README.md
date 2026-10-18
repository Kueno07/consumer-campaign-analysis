# Campaign Performance Analysis

Two PostgreSQL reference queries demonstrate experiment reporting and annual department performance. They show analytical patterns; they do not reproduce a company case or present findings from source data.

## Questions

- How do average net sales per assigned customer differ between treatment and control within an experiment segment?
- How did annual sales and sales per customer change from the immediately preceding calendar year?

## Data contract

The experiment query expects:

- `campaign_assignment`: one row per `experiment_id` and `customer_id`, with `assignment_group`, `segment_id`, `outcome_start`, and `outcome_end`.
- `customer_sales`: one row per sales event, with `customer_id`, `sale_at`, and `net_sales` in one consistent currency.
- Each outcome interval is `[outcome_start, outcome_end)`. Include all assigned customers, including customers with no sales. Avoid overlapping campaign intervals for the same customer, or define a separate attribution rule before using the query.

The annual query expects one row per department and calendar year in `department_year`. `customers` must count unique customers for the full year, not a sum of monthly counts. Missing calendar years produce a `NULL` year-over-year change rather than comparing nonconsecutive years.

## Metric definitions

- **Average net sales per assigned customer:** includes zero-sales customers from the assignment table.
- **Absolute lift:** treatment average minus control average, in the same currency as `net_sales`.
- **Relative lift:** absolute lift divided by control average. The query returns `NULL` when the control average is zero or negative.
- **Sales per customer:** annual net sales divided by annual unique customers. It is `NULL` when the denominator is not positive.

The experiment output is descriptive. A causal interpretation also depends on valid randomization, exposure and outcome definitions, no interference between groups, and uncertainty estimates. This query does not calculate confidence intervals or adjust for multiple segment comparisons.

## Use

Review and adapt the reference schemas in `analysis.sql` to an authorized dataset. Run each SQL statement in PostgreSQL after checking its grain, date boundaries, currency, and assignment rules. No case data or computed findings from the original process ship with this repository.

## Entrega original (resumo sanitizado)

A submissão da época reuniu um roteiro de consultas e uma apresentação. Este repositório é uma reconstrução técnica com dados sintéticos; não reproduz perguntas, dados ou resultados do processo seletivo.

## Exemplo sintético

`examples/setup.sql` cria tabelas temporárias e valores demonstrativos. Na mesma sessão PostgreSQL, execute o setup e as consultas de `analysis.sql`.

| Indicador demonstrativo | Resultado esperado |
|---|---:|
| Média por cliente controle | USD sintético 100 |
| Média por cliente tratamento | USD sintético 150 |
| Lift relativo | 50% |
| Variação 2024 vs. 2023 | USD sintético 200 (20%) |
| Variação 2026 vs. ano anterior | `NULL` (2025 ausente) |

Os valores são sintéticos e não representam o case original.
