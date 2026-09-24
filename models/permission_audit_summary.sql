-- arcana_analytics.permission_audit_summary
-- Rolled-up audit event counts per user per org over the trailing 90 days.
-- Separates routine events from high-risk events for the Security Overview Dashboard.
--
-- Refresh: daily at 04:00 UTC
-- Owner:   Priya Nair <data@arcana.io>

-- High-risk event types sourced from audit_log.event_type.
-- The high_risk_events_7d metric in the Security Overview Dashboard aggregates
-- this column filtered to the trailing 7 days.
WITH high_risk_types AS (
  SELECT event_type
  FROM UNNEST([
    'login.failed',
    'permission.escalated',
    'mfa.bypassed',
    'api_key.leaked',
    'session.hijack_attempt'
  ]) AS event_type
)

SELECT
  al.org_id,
  al.actor_id                                          AS user_id,
  up.role,
  COUNT(*)                                             AS total_events,
  COUNTIF(al.event_type IN (SELECT event_type FROM high_risk_types))
                                                       AS high_risk_events,
  MAX(al.occurred_at)                                  AS last_event_at

FROM arcana_platform.audit_log AS al
LEFT JOIN arcana_platform.user_permissions AS up
  ON al.actor_id = up.user_id AND al.org_id = up.org_id

WHERE al.occurred_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)

GROUP BY
  al.org_id,
  al.actor_id,
  up.role
