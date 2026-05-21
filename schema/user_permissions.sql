-- Arcana Platform: User Permissions table
-- Synced nightly to BigQuery (arcana_platform.user_permissions)
CREATE TABLE user_permissions (
  user_id        TEXT NOT NULL,
  org_id         TEXT NOT NULL,
  role           TEXT NOT NULL,          -- 'admin' | 'member' | 'viewer'
  granted_at     TIMESTAMPTZ NOT NULL,
  granted_by     TEXT NOT NULL,
  expires_at     TIMESTAMPTZ,
  is_active      BOOLEAN NOT NULL DEFAULT TRUE
  risk_score     NUMERIC,                -- ML-generated access risk score
  mfa_enforced   BOOLEAN DEFAULT FALSE   -- whether MFA is required for this role
);
