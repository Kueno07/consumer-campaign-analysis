# Campaign Performance Analysis

A generic SQL example for comparing campaign outcomes across randomized treatment and control groups. The sample calculates customer-level spend per assigned customer, then compares treatment and control within each campaign variant and segment.

## Data contract

Adapt the reference table and column names in `analysis.sql` to a dataset with one assignment per customer and sales records linked by customer ID. Include non-buyers in the assignment table so the analysis measures outcomes for everyone assigned.

## Interpretation

The query reports descriptive lift. A causal claim requires a valid random assignment, correct exposure tracking, a preselected outcome window, and uncertainty estimates. Segment comparisons also need enough observations to support the decision.

This sanitized example contains no source case prompt, company identifiers, or source data.
