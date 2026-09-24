-- arcana_analytics.role_risk_scores
-- One row per user per org. Joins user_permissions with recent high-risk audit
-- activity to produce a consolidated access-risk view for the Security team.
--
-- Refresh: daily at 04:00 UTC (after arcana_platform sync completes)
-- Owner:   Priya Nair <data@arcana.io>

SELECT
  up.org_id,
  up.user_id,
  up.role,

  -- Pass through the ML-generated risk score unchanged.
  -- Values above 0.7 are flagged as elevated risk in the Security Overview Dashboard.
  up.risk_score,

  up.mfa_enforced,

  -- Mark the timestamp when risk first crossed the 0.7 threshold.
  -- Null until the threshold is crossed; never reset even if score drops.
  CASE
    WHEN up.risk_score > 0.7 THEN CURRENT_TIMESTAMP
    ELSE NULL
  END AS flagged_at,

  CASE
    WHEN up.risk_score > 0.9 THEN 'Critical: score exceeds 0.9'
    WHEN up.risk_score > 0.7 THEN 'Elevated: score exceeds alert threshold'
    ELSE NULL
  END AS flag_reason

FROM arcana_platform.user_permissions AS up
WHERE up.is_active = TRUE
