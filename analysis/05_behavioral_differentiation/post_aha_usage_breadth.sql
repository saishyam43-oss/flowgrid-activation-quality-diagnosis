SELECT
  l.account_id,
  l.is_habitual,
  COUNT(DISTINCT e.event_type) AS event_types
FROM fct_account_lifecycle_state l
JOIN stg_events e
  ON l.account_id = e.account_id
 AND e.event_timestamp >= l.first_user_aha_ts
 AND e.event_timestamp < TIMESTAMP_ADD(l.first_user_aha_ts, INTERVAL 7 DAY)
WHERE l.first_user_aha_ts IS NOT NULL
GROUP BY l.account_id, l.is_habitual;
