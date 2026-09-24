-- arcana_analytics.feature_adoption
-- Feature flag state per org, enriched with subscription plan data.
-- Drives the feature_adoption_rate and avg_features_per_org metrics
-- in the Product Analytics Dashboard.
--
-- Refresh: daily at 04:00 UTC
-- Owner:   Priya Nair <data@arcana.io>
--
-- Note: feature_flags rows are only created when a flag is first evaluated
-- by the platform. A missing row means the feature was never evaluated,
-- not that it is disabled. This model only includes rows where the flag exists.

SELECT
  ff.org_id,
  ff.feature_key,
  ff.enabled,
  ff.enabled_at,

  -- plan_name joined from subscriptions for segmentation in the Product Dashboard.
  s.plan_name,

  -- Days since enabled; used for adoption velocity analysis.
  -- NULL when the feature has never been enabled.
  CASE
    WHEN ff.enabled AND ff.enabled_at IS NOT NULL
    THEN DATE_DIFF(CURRENT_DATE(), DATE(ff.enabled_at), DAY)
    ELSE NULL
  END AS days_since_enabled

FROM arcana_platform.feature_flags AS ff
LEFT JOIN arcana_platform.subscriptions AS s
  ON ff.org_id = s.org_id
