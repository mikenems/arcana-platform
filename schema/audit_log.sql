-- Arcana Platform: Audit Log table
-- Compliance trail for all platform events
CREATE TABLE audit_log (
  event_id       TEXT NOT NULL,
  event_type     TEXT NOT NULL,
  actor_id       TEXT NOT NULL,
  org_id         TEXT NOT NULL,
  resource_type  TEXT,
  resource_id    TEXT,
  payload        JSONB,
  occurred_at    TIMESTAMPTZ NOT NULL
);
