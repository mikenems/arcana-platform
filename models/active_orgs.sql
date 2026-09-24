-- arcana_analytics.active_orgs
-- Organizations with at least one user login in the trailing 30 days.
-- Joined to subscriptions for plan and trial state.
--
-- Refresh: daily at 04:00 UTC
-- Owner:   Priya Nair <data@arcana.io>

WITH last_logins AS (
  SELECT
    org_id,
    MAX(occurred_at) AS last_login_at,
    COUNT(DISTINCT actor_id) AS user_count
  FROM arcana_platform.audit_log
  WHERE
    event_type = 'login.success'
    AND occurred_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY org_id
)

SELECT
  ll.org_id,
  ll.last_login_at,
  ll.user_count,

  -- plan_name and is_trial sourced from subscriptions.
  -- trial_conversion_rate in Product Analytics Dashboard uses is_trial.
  s.plan_name,
  (s.status = 'trialing') AS is_trial

FROM last_logins AS ll
LEFT JOIN arcana_platform.subscriptions AS s
  ON ll.org_id = s.org_id
