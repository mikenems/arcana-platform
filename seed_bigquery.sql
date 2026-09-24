-- ============================================================
-- Arcana Platform: BigQuery Seed
-- Project: arcana-platform-496912  |  Location: EU
-- ============================================================
-- Paste into BigQuery Studio (with arcana-platform-496912 as
-- the active project) and click Run.
--
-- Creates:
--   arcana_platform  — 4 source tables, ~200 rows of data
--   arcana_analytics — 4 views (transform layer)
-- ============================================================


-- ─── 1. Datasets ──────────────────────────────────────────────

CREATE SCHEMA IF NOT EXISTS `arcana-platform-496912`.`arcana_platform`
OPTIONS (location = 'EU');

CREATE SCHEMA IF NOT EXISTS `arcana-platform-496912`.`arcana_analytics`
OPTIONS (location = 'EU');


-- ─── 2. Source tables ─────────────────────────────────────────

CREATE OR REPLACE TABLE `arcana-platform-496912.arcana_platform.subscriptions` (
  org_id        STRING    NOT NULL,
  plan_id       STRING    NOT NULL,
  plan_name     STRING    NOT NULL,
  mrr           INT64     NOT NULL,
  billing_cycle STRING    NOT NULL,
  status        STRING    NOT NULL,
  trial_ends_at TIMESTAMP,
  created_at    TIMESTAMP NOT NULL
);

CREATE OR REPLACE TABLE `arcana-platform-496912.arcana_platform.user_permissions` (
  user_id      STRING    NOT NULL,
  org_id       STRING    NOT NULL,
  role         STRING    NOT NULL,
  granted_at   TIMESTAMP NOT NULL,
  granted_by   STRING    NOT NULL,
  expires_at   TIMESTAMP,
  is_active    BOOL      NOT NULL,
  risk_score   FLOAT64,
  mfa_enforced BOOL
);

CREATE OR REPLACE TABLE `arcana-platform-496912.arcana_platform.feature_flags` (
  org_id      STRING    NOT NULL,
  feature_key STRING    NOT NULL,
  enabled     BOOL      NOT NULL,
  enabled_at  TIMESTAMP,
  rollout_pct FLOAT64,
  enabled_by  STRING
);

CREATE OR REPLACE TABLE `arcana-platform-496912.arcana_platform.audit_log` (
  event_id      STRING    NOT NULL,
  event_type    STRING    NOT NULL,
  actor_id      STRING    NOT NULL,
  org_id        STRING    NOT NULL,
  resource_type STRING,
  resource_id   STRING,
  payload       STRING,
  occurred_at   TIMESTAMP NOT NULL
);


-- ─── 3. Subscriptions (20 orgs) ───────────────────────────────

INSERT INTO `arcana-platform-496912.arcana_platform.subscriptions`
  (org_id, plan_id, plan_name, mrr, billing_cycle, status, trial_ends_at, created_at)
SELECT org_id, plan_id, plan_name, mrr, billing_cycle, status, trial_ends_at, created_at
FROM UNNEST([
  STRUCT('org_001' AS org_id, 'plan_001' AS plan_id, 'enterprise' AS plan_name, 250000 AS mrr, 'annual' AS billing_cycle, 'active' AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2023-03-15') AS created_at),
  STRUCT('org_002' AS org_id, 'plan_002' AS plan_id, 'growth'     AS plan_name,  45000 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-01-08') AS created_at),
  STRUCT('org_003' AS org_id, 'plan_003' AS plan_id, 'starter'    AS plan_name,      0 AS mrr, 'monthly' AS billing_cycle, 'trialing' AS status, TIMESTAMP('2026-06-20') AS trial_ends_at, TIMESTAMP('2026-05-21') AS created_at),
  STRUCT('org_004' AS org_id, 'plan_004' AS plan_id, 'enterprise' AS plan_name, 280000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2022-11-01') AS created_at),
  STRUCT('org_005' AS org_id, 'plan_005' AS plan_id, 'growth'     AS plan_name,  52000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-06-14') AS created_at),
  STRUCT('org_006' AS org_id, 'plan_006' AS plan_id, 'starter'    AS plan_name,      0 AS mrr, 'monthly' AS billing_cycle, 'trialing' AS status, TIMESTAMP('2026-06-18') AS trial_ends_at, TIMESTAMP('2026-05-19') AS created_at),
  STRUCT('org_007' AS org_id, 'plan_007' AS plan_id, 'enterprise' AS plan_name, 220000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2023-07-22') AS created_at),
  STRUCT('org_008' AS org_id, 'plan_008' AS plan_id, 'growth'     AS plan_name,  41000 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-08-30') AS created_at),
  STRUCT('org_009' AS org_id, 'plan_009' AS plan_id, 'starter'    AS plan_name,   8500 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2025-02-11') AS created_at),
  STRUCT('org_010' AS org_id, 'plan_010' AS plan_id, 'growth'     AS plan_name,  48000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-04-03') AS created_at),
  STRUCT('org_011' AS org_id, 'plan_011' AS plan_id, 'enterprise' AS plan_name, 310000 AS mrr, 'annual'  AS billing_cycle, 'past_due' AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2022-09-17') AS created_at),
  STRUCT('org_012' AS org_id, 'plan_012' AS plan_id, 'growth'     AS plan_name,  38000 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-11-25') AS created_at),
  STRUCT('org_013' AS org_id, 'plan_013' AS plan_id, 'starter'    AS plan_name,      0 AS mrr, 'monthly' AS billing_cycle, 'trialing' AS status, TIMESTAMP('2026-06-25') AS trial_ends_at, TIMESTAMP('2026-05-26') AS created_at),
  STRUCT('org_014' AS org_id, 'plan_014' AS plan_id, 'growth'     AS plan_name,  43000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-02-28') AS created_at),
  STRUCT('org_015' AS org_id, 'plan_015' AS plan_id, 'enterprise' AS plan_name, 260000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2023-05-09') AS created_at),
  STRUCT('org_016' AS org_id, 'plan_016' AS plan_id, 'starter'    AS plan_name,   9200 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2025-04-17') AS created_at),
  STRUCT('org_017' AS org_id, 'plan_017' AS plan_id, 'growth'     AS plan_name,  35000 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-09-12') AS created_at),
  STRUCT('org_018' AS org_id, 'plan_018' AS plan_id, 'starter'    AS plan_name,      0 AS mrr, 'monthly' AS billing_cycle, 'trialing' AS status, TIMESTAMP('2026-07-01') AS trial_ends_at, TIMESTAMP('2026-06-02') AS created_at),
  STRUCT('org_019' AS org_id, 'plan_019' AS plan_id, 'growth'     AS plan_name,  39000 AS mrr, 'annual'  AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2024-12-05') AS created_at),
  STRUCT('org_020' AS org_id, 'plan_020' AS plan_id, 'starter'    AS plan_name,   7800 AS mrr, 'monthly' AS billing_cycle, 'active'   AS status, CAST(NULL AS TIMESTAMP) AS trial_ends_at, TIMESTAMP('2025-01-20') AS created_at)
]);


-- ─── 4. User permissions (85 users) ───────────────────────────
-- Users marked HIGH RISK have risk_score > 0.7.

INSERT INTO `arcana-platform-496912.arcana_platform.user_permissions`
  (user_id, org_id, role, granted_at, granted_by, expires_at, is_active, risk_score, mfa_enforced)
SELECT user_id, org_id, role, granted_at, granted_by, expires_at, is_active, risk_score, mfa_enforced
FROM UNNEST([
  STRUCT('usr_001_01' AS user_id,'org_001' AS org_id,'admin'  AS role,TIMESTAMP('2023-03-15') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.12 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_001_02' AS user_id,'org_001' AS org_id,'admin'  AS role,TIMESTAMP('2023-03-15') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.85 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK no MFA
  STRUCT('usr_001_03' AS user_id,'org_001' AS org_id,'member' AS role,TIMESTAMP('2023-06-20') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.34 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_001_04' AS user_id,'org_001' AS org_id,'member' AS role,TIMESTAMP('2024-01-08') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.28 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_001_05' AS user_id,'org_001' AS org_id,'member' AS role,TIMESTAMP('2024-03-14') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.45 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_001_06' AS user_id,'org_001' AS org_id,'member' AS role,TIMESTAMP('2024-07-22') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.19 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_001_07' AS user_id,'org_001' AS org_id,'viewer' AS role,TIMESTAMP('2024-09-11') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.08 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_001_08' AS user_id,'org_001' AS org_id,'viewer' AS role,TIMESTAMP('2025-01-15') AS granted_at,'usr_001_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(NULL AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_002_01' AS user_id,'org_002' AS org_id,'admin'  AS role,TIMESTAMP('2024-01-08') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.22 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_002_02' AS user_id,'org_002' AS org_id,'member' AS role,TIMESTAMP('2024-04-15') AS granted_at,'usr_002_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.78 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_002_03' AS user_id,'org_002' AS org_id,'member' AS role,TIMESTAMP('2024-06-30') AS granted_at,'usr_002_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.31 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_002_04' AS user_id,'org_002' AS org_id,'viewer' AS role,TIMESTAMP('2024-11-02') AS granted_at,'usr_002_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.15 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_003_01' AS user_id,'org_003' AS org_id,'admin'  AS role,TIMESTAMP('2026-05-21') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.18 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_003_02' AS user_id,'org_003' AS org_id,'member' AS role,TIMESTAMP('2026-05-21') AS granted_at,'usr_003_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.42 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_004_01' AS user_id,'org_004' AS org_id,'admin'  AS role,TIMESTAMP('2022-11-01') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.09 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_004_02' AS user_id,'org_004' AS org_id,'admin'  AS role,TIMESTAMP('2022-11-01') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.14 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_004_03' AS user_id,'org_004' AS org_id,'member' AS role,TIMESTAMP('2023-02-14') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.91 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- CRITICAL RISK
  STRUCT('usr_004_04' AS user_id,'org_004' AS org_id,'member' AS role,TIMESTAMP('2023-05-08') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.23 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_004_05' AS user_id,'org_004' AS org_id,'member' AS role,TIMESTAMP('2023-09-19') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.56 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_004_06' AS user_id,'org_004' AS org_id,'member' AS role,TIMESTAMP('2024-01-30') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.38 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_004_07' AS user_id,'org_004' AS org_id,'viewer' AS role,TIMESTAMP('2024-04-12') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.11 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_004_08' AS user_id,'org_004' AS org_id,'viewer' AS role,TIMESTAMP('2024-08-25') AS granted_at,'usr_004_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.07 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_005_01' AS user_id,'org_005' AS org_id,'admin'  AS role,TIMESTAMP('2024-06-14') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.29 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_005_02' AS user_id,'org_005' AS org_id,'member' AS role,TIMESTAMP('2024-08-20') AS granted_at,'usr_005_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.73 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_005_03' AS user_id,'org_005' AS org_id,'member' AS role,TIMESTAMP('2024-10-05') AS granted_at,'usr_005_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.44 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_005_04' AS user_id,'org_005' AS org_id,'viewer' AS role,TIMESTAMP('2025-01-18') AS granted_at,'usr_005_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.16 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_006_01' AS user_id,'org_006' AS org_id,'admin'  AS role,TIMESTAMP('2026-05-19') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.21 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_006_02' AS user_id,'org_006' AS org_id,'member' AS role,TIMESTAMP('2026-05-19') AS granted_at,'usr_006_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.35 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_007_01' AS user_id,'org_007' AS org_id,'admin'  AS role,TIMESTAMP('2023-07-22') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.08 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_007_02' AS user_id,'org_007' AS org_id,'admin'  AS role,TIMESTAMP('2023-07-22') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.17 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_007_03' AS user_id,'org_007' AS org_id,'member' AS role,TIMESTAMP('2023-10-14') AS granted_at,'usr_007_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.88 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),-- HIGH RISK (has MFA)
  STRUCT('usr_007_04' AS user_id,'org_007' AS org_id,'member' AS role,TIMESTAMP('2024-02-28') AS granted_at,'usr_007_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.25 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_007_05' AS user_id,'org_007' AS org_id,'member' AS role,TIMESTAMP('2024-05-16') AS granted_at,'usr_007_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.41 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_007_06' AS user_id,'org_007' AS org_id,'member' AS role,TIMESTAMP('2024-09-03') AS granted_at,'usr_007_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.33 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_007_07' AS user_id,'org_007' AS org_id,'viewer' AS role,TIMESTAMP('2025-02-07') AS granted_at,'usr_007_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.12 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_008_01' AS user_id,'org_008' AS org_id,'admin'  AS role,TIMESTAMP('2024-08-30') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.19 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_008_02' AS user_id,'org_008' AS org_id,'member' AS role,TIMESTAMP('2024-10-14') AS granted_at,'usr_008_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.72 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_008_03' AS user_id,'org_008' AS org_id,'member' AS role,TIMESTAMP('2025-01-06') AS granted_at,'usr_008_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.28 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_008_04' AS user_id,'org_008' AS org_id,'viewer' AS role,TIMESTAMP('2025-03-19') AS granted_at,'usr_008_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.09 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_009_01' AS user_id,'org_009' AS org_id,'admin'  AS role,TIMESTAMP('2025-02-11') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.31 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_009_02' AS user_id,'org_009' AS org_id,'member' AS role,TIMESTAMP('2025-03-28') AS granted_at,'usr_009_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.47 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_010_01' AS user_id,'org_010' AS org_id,'admin'  AS role,TIMESTAMP('2024-04-03') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.14 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_010_02' AS user_id,'org_010' AS org_id,'member' AS role,TIMESTAMP('2024-07-15') AS granted_at,'usr_010_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.62 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_010_03' AS user_id,'org_010' AS org_id,'member' AS role,TIMESTAMP('2024-10-22') AS granted_at,'usr_010_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.38 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_010_04' AS user_id,'org_010' AS org_id,'viewer' AS role,TIMESTAMP('2025-01-09') AS granted_at,'usr_010_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.22 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_011_01' AS user_id,'org_011' AS org_id,'admin'  AS role,TIMESTAMP('2022-09-17') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.52 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- admin no MFA
  STRUCT('usr_011_02' AS user_id,'org_011' AS org_id,'admin'  AS role,TIMESTAMP('2022-09-17') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.61 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- admin no MFA
  STRUCT('usr_011_03' AS user_id,'org_011' AS org_id,'member' AS role,TIMESTAMP('2023-01-05') AS granted_at,'usr_011_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.95 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- CRITICAL RISK
  STRUCT('usr_011_04' AS user_id,'org_011' AS org_id,'member' AS role,TIMESTAMP('2023-03-22') AS granted_at,'usr_011_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.82 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_011_05' AS user_id,'org_011' AS org_id,'member' AS role,TIMESTAMP('2023-08-14') AS granted_at,'usr_011_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.41 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_011_06' AS user_id,'org_011' AS org_id,'viewer' AS role,TIMESTAMP('2024-02-01') AS granted_at,'usr_011_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.28 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_012_01' AS user_id,'org_012' AS org_id,'admin'  AS role,TIMESTAMP('2024-11-25') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.11 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_012_02' AS user_id,'org_012' AS org_id,'member' AS role,TIMESTAMP('2025-01-14') AS granted_at,'usr_012_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.74 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_012_03' AS user_id,'org_012' AS org_id,'member' AS role,TIMESTAMP('2025-03-08') AS granted_at,'usr_012_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.29 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_012_04' AS user_id,'org_012' AS org_id,'viewer' AS role,TIMESTAMP('2025-05-20') AS granted_at,'usr_012_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.18 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_013_01' AS user_id,'org_013' AS org_id,'admin'  AS role,TIMESTAMP('2026-05-26') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.25 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_013_02' AS user_id,'org_013' AS org_id,'member' AS role,TIMESTAMP('2026-05-26') AS granted_at,'usr_013_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.38 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_014_01' AS user_id,'org_014' AS org_id,'admin'  AS role,TIMESTAMP('2024-02-28') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.16 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_014_02' AS user_id,'org_014' AS org_id,'member' AS role,TIMESTAMP('2024-05-12') AS granted_at,'usr_014_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.43 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_014_03' AS user_id,'org_014' AS org_id,'member' AS role,TIMESTAMP('2024-08-07') AS granted_at,'usr_014_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.27 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_014_04' AS user_id,'org_014' AS org_id,'viewer' AS role,TIMESTAMP('2024-12-01') AS granted_at,'usr_014_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.14 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_015_01' AS user_id,'org_015' AS org_id,'admin'  AS role,TIMESTAMP('2023-05-09') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.07 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_015_02' AS user_id,'org_015' AS org_id,'admin'  AS role,TIMESTAMP('2023-05-09') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.12 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_015_03' AS user_id,'org_015' AS org_id,'member' AS role,TIMESTAMP('2023-08-21') AS granted_at,'usr_015_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.79 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_015_04' AS user_id,'org_015' AS org_id,'member' AS role,TIMESTAMP('2023-11-14') AS granted_at,'usr_015_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.34 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_015_05' AS user_id,'org_015' AS org_id,'member' AS role,TIMESTAMP('2024-03-05') AS granted_at,'usr_015_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.28 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_015_06' AS user_id,'org_015' AS org_id,'member' AS role,TIMESTAMP('2024-07-18') AS granted_at,'usr_015_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.19 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_015_07' AS user_id,'org_015' AS org_id,'viewer' AS role,TIMESTAMP('2024-10-30') AS granted_at,'usr_015_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.08 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_016_01' AS user_id,'org_016' AS org_id,'admin'  AS role,TIMESTAMP('2025-04-17') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.33 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_016_02' AS user_id,'org_016' AS org_id,'member' AS role,TIMESTAMP('2025-05-30') AS granted_at,'usr_016_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.51 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_017_01' AS user_id,'org_017' AS org_id,'admin'  AS role,TIMESTAMP('2024-09-12') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.22 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_017_02' AS user_id,'org_017' AS org_id,'member' AS role,TIMESTAMP('2024-11-08') AS granted_at,'usr_017_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.71 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_017_03' AS user_id,'org_017' AS org_id,'member' AS role,TIMESTAMP('2025-01-24') AS granted_at,'usr_017_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.44 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_017_04' AS user_id,'org_017' AS org_id,'viewer' AS role,TIMESTAMP('2025-04-16') AS granted_at,'usr_017_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.19 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_018_01' AS user_id,'org_018' AS org_id,'admin'  AS role,TIMESTAMP('2026-06-02') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.28 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_018_02' AS user_id,'org_018' AS org_id,'member' AS role,TIMESTAMP('2026-06-02') AS granted_at,'usr_018_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.36 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_019_01' AS user_id,'org_019' AS org_id,'admin'  AS role,TIMESTAMP('2024-12-05') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.18 AS FLOAT64) AS risk_score,TRUE  AS mfa_enforced),
  STRUCT('usr_019_02' AS user_id,'org_019' AS org_id,'member' AS role,TIMESTAMP('2025-02-17') AS granted_at,'usr_019_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.76 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),-- HIGH RISK
  STRUCT('usr_019_03' AS user_id,'org_019' AS org_id,'member' AS role,TIMESTAMP('2025-04-29') AS granted_at,'usr_019_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.33 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_019_04' AS user_id,'org_019' AS org_id,'viewer' AS role,TIMESTAMP('2025-07-11') AS granted_at,'usr_019_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.11 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_020_01' AS user_id,'org_020' AS org_id,'admin'  AS role,TIMESTAMP('2025-01-20') AS granted_at,'system'     AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.24 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced),
  STRUCT('usr_020_02' AS user_id,'org_020' AS org_id,'member' AS role,TIMESTAMP('2025-03-05') AS granted_at,'usr_020_01' AS granted_by,CAST(NULL AS TIMESTAMP) AS expires_at,TRUE AS is_active,CAST(0.41 AS FLOAT64) AS risk_score,FALSE AS mfa_enforced)
]);


-- ─── 5. Feature flags (~42 rows) ──────────────────────────────
-- Enterprise orgs: all 5 features. Growth: 1-3. Starter/trial: 0-1.

INSERT INTO `arcana-platform-496912.arcana_platform.feature_flags`
  (org_id, feature_key, enabled, enabled_at, rollout_pct, enabled_by)
SELECT org_id, feature_key, enabled, enabled_at, rollout_pct, enabled_by
FROM UNNEST([
  -- org_001 enterprise: all 5
  STRUCT('org_001' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2023-04-01') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_001_01' AS enabled_by),
  STRUCT('org_001' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2023-06-15') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_001_01' AS enabled_by),
  STRUCT('org_001' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2023-09-20') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_001_01' AS enabled_by),
  STRUCT('org_001' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2024-01-10') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_001_01' AS enabled_by),
  STRUCT('org_001' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-03-01') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_001_01' AS enabled_by),
  -- org_002 growth: 2
  STRUCT('org_002' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2024-03-15') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_002_01' AS enabled_by),
  STRUCT('org_002' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-08-20') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_002_01' AS enabled_by),
  -- org_003 trialing: 1 (in rollout)
  STRUCT('org_003' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2026-05-22') AS enabled_at,CAST(100.0 AS FLOAT64) AS rollout_pct,'usr_003_01' AS enabled_by),
  -- org_004 enterprise: all 5
  STRUCT('org_004' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2023-01-05') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_004_01' AS enabled_by),
  STRUCT('org_004' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2023-03-18') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_004_01' AS enabled_by),
  STRUCT('org_004' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2023-07-22') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_004_01' AS enabled_by),
  STRUCT('org_004' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2023-11-14') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_004_01' AS enabled_by),
  STRUCT('org_004' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-02-08') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_004_01' AS enabled_by),
  -- org_005 growth: 2
  STRUCT('org_005' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2024-08-10') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_005_01' AS enabled_by),
  STRUCT('org_005' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2025-01-05') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_005_01' AS enabled_by),
  -- org_006 trialing: 1
  STRUCT('org_006' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2026-05-20') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_006_01' AS enabled_by),
  -- org_007 enterprise: all 5
  STRUCT('org_007' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2023-09-01') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_007_01' AS enabled_by),
  STRUCT('org_007' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2024-01-15') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_007_01' AS enabled_by),
  STRUCT('org_007' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2024-04-10') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_007_01' AS enabled_by),
  STRUCT('org_007' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2024-07-22') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_007_01' AS enabled_by),
  STRUCT('org_007' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-10-14') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_007_01' AS enabled_by),
  -- org_008 growth: 2
  STRUCT('org_008' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2024-10-22') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_008_01' AS enabled_by),
  STRUCT('org_008' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2025-02-14') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_008_01' AS enabled_by),
  -- org_010 growth: 1
  STRUCT('org_010' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2024-07-08') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_010_01' AS enabled_by),
  -- org_011 enterprise (past_due): 3
  STRUCT('org_011' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2023-01-15') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_011_01' AS enabled_by),
  STRUCT('org_011' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2023-04-08') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_011_01' AS enabled_by),
  STRUCT('org_011' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2023-08-30') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_011_01' AS enabled_by),
  -- org_012 growth: 2
  STRUCT('org_012' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2025-02-01') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_012_01' AS enabled_by),
  STRUCT('org_012' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2025-04-15') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_012_01' AS enabled_by),
  -- org_013 trialing: 1
  STRUCT('org_013' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2026-05-27') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_013_01' AS enabled_by),
  -- org_014 growth: 1
  STRUCT('org_014' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-05-20') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_014_01' AS enabled_by),
  -- org_015 enterprise: all 5
  STRUCT('org_015' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2023-06-12') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_015_01' AS enabled_by),
  STRUCT('org_015' AS org_id,'sso_saml'           AS feature_key,TRUE AS enabled,TIMESTAMP('2023-09-25') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_015_01' AS enabled_by),
  STRUCT('org_015' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2024-01-18') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_015_01' AS enabled_by),
  STRUCT('org_015' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2024-05-07') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_015_01' AS enabled_by),
  STRUCT('org_015' AS org_id,'api_access'          AS feature_key,TRUE AS enabled,TIMESTAMP('2024-08-22') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_015_01' AS enabled_by),
  -- org_017 growth: 2
  STRUCT('org_017' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2024-11-03') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_017_01' AS enabled_by),
  STRUCT('org_017' AS org_id,'audit_export'        AS feature_key,TRUE AS enabled,TIMESTAMP('2025-03-08') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_017_01' AS enabled_by),
  -- org_019 growth: 2
  STRUCT('org_019' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2025-01-14') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_019_01' AS enabled_by),
  STRUCT('org_019' AS org_id,'custom_roles'        AS feature_key,TRUE AS enabled,TIMESTAMP('2025-05-01') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_019_01' AS enabled_by),
  -- org_020 starter: 1
  STRUCT('org_020' AS org_id,'advanced_analytics' AS feature_key,TRUE AS enabled,TIMESTAMP('2025-02-10') AS enabled_at,CAST(NULL AS FLOAT64) AS rollout_pct,'usr_020_01' AS enabled_by)
]);


-- ─── 6. Audit log — explicit high-risk events ─────────────────
-- Concentrated in last 7 days to make high_risk_events_7d meaningful.
-- org_011 (Helios Energy) is the worst actor.

INSERT INTO `arcana-platform-496912.arcana_platform.audit_log`
  (event_id, event_type, actor_id, org_id, resource_type, resource_id, payload, occurred_at)
SELECT event_id, event_type, actor_id, org_id, resource_type, resource_id, payload, occurred_at
FROM UNNEST([
  -- Last 7 days — high-risk cluster
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-30 08:14:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-30 08:15:23') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-30 08:16:45') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'mfa.bypassed'          AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-30 08:17:12') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_011_01' AS actor_id,'org_011' AS org_id,'role' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-31 14:22:33') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'user' AS resource_type,'usr_004_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-01 09:45:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'user' AS resource_type,'usr_004_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-01 09:46:11') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'role' AS resource_type,'usr_004_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-01 10:01:45') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'mfa.bypassed'          AS event_type,'usr_011_04' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_04' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-02 16:33:18') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_001_02' AS actor_id,'org_001' AS org_id,'user' AS resource_type,'usr_001_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-02 22:11:05') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_001_02' AS actor_id,'org_001' AS org_id,'user' AS resource_type,'usr_001_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-02 22:12:44') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_001_02' AS actor_id,'org_001' AS org_id,'role' AS resource_type,'usr_001_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-03 09:15:22') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'api_key.leaked'        AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'api_key' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-03 11:44:52') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_005_02' AS actor_id,'org_005' AS org_id,'user' AS resource_type,'usr_005_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-04 07:22:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_008_02' AS actor_id,'org_008' AS org_id,'user' AS resource_type,'usr_008_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-04 15:55:33') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_007_03' AS actor_id,'org_007' AS org_id,'role' AS resource_type,'usr_007_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-04 18:10:44') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_015_03' AS actor_id,'org_015' AS org_id,'user' AS resource_type,'usr_015_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-04 20:33:15') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'mfa.bypassed'          AS event_type,'usr_019_02' AS actor_id,'org_019' AS org_id,'user' AS resource_type,'usr_019_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-05 08:44:22') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_011_02' AS actor_id,'org_011' AS org_id,'role' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-05 10:15:33') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_011_04' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_04' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-06-05 11:22:44') AS occurred_at),
  -- Older high-risk (>7 days ago, still in 90-day window)
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'user' AS resource_type,'usr_004_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-04-15 14:30:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'user' AS resource_type,'usr_004_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-04-15 14:31:22') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_011_01' AS actor_id,'org_011' AS org_id,'role' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-04-20 09:00:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'mfa.bypassed'          AS event_type,'usr_004_03' AS actor_id,'org_004' AS org_id,'user' AS resource_type,'usr_004_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-01 15:22:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_001_02' AS actor_id,'org_001' AS org_id,'user' AS resource_type,'usr_001_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-10 21:45:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_012_02' AS actor_id,'org_012' AS org_id,'role' AS resource_type,'usr_012_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-15 09:30:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_017_02' AS actor_id,'org_017' AS org_id,'user' AS resource_type,'usr_017_02' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-05-08 18:22:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'api_key.leaked'        AS event_type,'usr_011_01' AS actor_id,'org_011' AS org_id,'api_key' AS resource_type,'usr_011_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-03-25 12:00:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'permission.escalated'  AS event_type,'usr_015_03' AS actor_id,'org_015' AS org_id,'role' AS resource_type,'usr_015_01' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-04-28 14:15:00') AS occurred_at),
  STRUCT(GENERATE_UUID() AS event_id,'login.failed'          AS event_type,'usr_011_03' AS actor_id,'org_011' AS org_id,'user' AS resource_type,'usr_011_03' AS resource_id,CAST(NULL AS STRING) AS payload,TIMESTAMP('2026-03-18 08:14:00') AS occurred_at)
]);


-- ─── 7. Audit log — bulk login events (generated) ─────────────
-- ~150 login.success events spread across all active users over
-- the last 90 days. Drives MAU and active_orgs view.

INSERT INTO `arcana-platform-496912.arcana_platform.audit_log`
  (event_id, event_type, actor_id, org_id, resource_type, resource_id, payload, occurred_at)
SELECT
  GENERATE_UUID(),
  'login.success',
  up.user_id,
  up.org_id,
  CAST(NULL AS STRING),
  CAST(NULL AS STRING),
  CAST(NULL AS STRING),
  TIMESTAMP_ADD(
    TIMESTAMP('2026-03-08 00:00:00 UTC'),
    INTERVAL CAST(MOD(ABS(FARM_FINGERPRINT(CONCAT(up.user_id, CAST(n AS STRING)))), 129600) AS INT64) MINUTE
  )
FROM `arcana-platform-496912.arcana_platform.user_permissions` up
CROSS JOIN UNNEST(GENERATE_ARRAY(1, 8)) AS n
WHERE up.is_active = TRUE
  AND MOD(ABS(FARM_FINGERPRINT(CONCAT(up.user_id, CAST(n AS STRING)))), 2) = 0;


-- ─── 8. Analytics views (transform layer) ─────────────────────

CREATE OR REPLACE VIEW `arcana-platform-496912.arcana_analytics.role_risk_scores` AS
SELECT
  up.org_id,
  up.user_id,
  up.role,
  up.risk_score,
  up.mfa_enforced,
  CASE WHEN up.risk_score > 0.7 THEN CURRENT_TIMESTAMP() ELSE NULL END AS flagged_at,
  CASE
    WHEN up.risk_score > 0.9 THEN 'Critical: score exceeds 0.9'
    WHEN up.risk_score > 0.7 THEN 'Elevated: score exceeds alert threshold'
    ELSE NULL
  END AS flag_reason
FROM `arcana-platform-496912.arcana_platform.user_permissions` AS up
WHERE up.is_active = TRUE;


CREATE OR REPLACE VIEW `arcana-platform-496912.arcana_analytics.permission_audit_summary` AS
SELECT
  al.org_id,
  al.actor_id                                                                                       AS user_id,
  up.role,
  COUNT(*)                                                                                          AS total_events,
  COUNTIF(al.event_type IN ('login.failed','permission.escalated','mfa.bypassed','api_key.leaked')) AS high_risk_events,
  MAX(al.occurred_at)                                                                               AS last_event_at
FROM `arcana-platform-496912.arcana_platform.audit_log` AS al
LEFT JOIN `arcana-platform-496912.arcana_platform.user_permissions` AS up
  ON al.actor_id = up.user_id AND al.org_id = up.org_id
WHERE al.occurred_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY al.org_id, al.actor_id, up.role;


CREATE OR REPLACE VIEW `arcana-platform-496912.arcana_analytics.active_orgs` AS
WITH last_logins AS (
  SELECT
    org_id,
    MAX(occurred_at)        AS last_login_at,
    COUNT(DISTINCT actor_id) AS user_count
  FROM `arcana-platform-496912.arcana_platform.audit_log`
  WHERE event_type = 'login.success'
    AND occurred_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY org_id
)
SELECT
  ll.org_id,
  ll.last_login_at,
  ll.user_count,
  s.plan_name,
  (s.status = 'trialing') AS is_trial
FROM last_logins AS ll
LEFT JOIN `arcana-platform-496912.arcana_platform.subscriptions` AS s
  ON ll.org_id = s.org_id;


CREATE OR REPLACE VIEW `arcana-platform-496912.arcana_analytics.feature_adoption` AS
SELECT
  ff.org_id,
  ff.feature_key,
  ff.enabled,
  ff.enabled_at,
  s.plan_name,
  CASE
    WHEN ff.enabled AND ff.enabled_at IS NOT NULL
    THEN DATE_DIFF(CURRENT_DATE(), DATE(ff.enabled_at), DAY)
    ELSE NULL
  END AS days_since_enabled
FROM `arcana-platform-496912.arcana_platform.feature_flags` AS ff
LEFT JOIN `arcana-platform-496912.arcana_platform.subscriptions` AS s
  ON ff.org_id = s.org_id;
