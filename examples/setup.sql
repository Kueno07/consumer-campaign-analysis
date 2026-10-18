CREATE TEMP TABLE campaign_assignment (
    experiment_id text NOT NULL,
    customer_id text NOT NULL,
    assignment_group text NOT NULL,
    segment_id text NOT NULL,
    outcome_start timestamptz NOT NULL,
    outcome_end timestamptz NOT NULL,
    PRIMARY KEY (experiment_id, customer_id)
);
CREATE TEMP TABLE customer_sales (
    customer_id text NOT NULL,
    sale_at timestamptz NOT NULL,
    net_sales numeric NOT NULL
);
INSERT INTO campaign_assignment VALUES
('EXP-SYN-01', 'C001', 'control', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'C002', 'control', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'C003', 'control', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'C004', 'control', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'T001', 'treatment', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'T002', 'treatment', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'T003', 'treatment', 'all', '2026-01-01', '2026-02-01'),
('EXP-SYN-01', 'T004', 'treatment', 'all', '2026-01-01', '2026-02-01');
INSERT INTO customer_sales VALUES
('C001', '2026-01-15 12:00:00+00', 100),
('C002', '2026-01-15 12:00:00+00', 100),
('C003', '2026-01-15 12:00:00+00', 200),
('T001', '2026-01-15 12:00:00+00', 300),
('T002', '2026-01-15 12:00:00+00', 200),
('T003', '2026-01-15 12:00:00+00', 100);
CREATE TEMP TABLE department_year (
    department_id text NOT NULL,
    department_name text NOT NULL,
    year integer NOT NULL,
    net_sales numeric NOT NULL,
    customers integer NOT NULL,
    PRIMARY KEY (department_id, year)
);
INSERT INTO department_year VALUES
('D-SYN-01', 'Synthetic department', 2023, 1000, 100),
('D-SYN-01', 'Synthetic department', 2024, 1200, 120),
('D-SYN-01', 'Synthetic department', 2026, 900, 90);
