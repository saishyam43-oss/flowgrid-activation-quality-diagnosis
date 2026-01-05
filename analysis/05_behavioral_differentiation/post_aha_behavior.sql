WITH aha_accounts AS (
  SELECT
    account_id,
    first_user_aha_ts,
    is_habitual
  FROM fct_account_lifecycle_state
  WHERE first_user_aha_ts IS NOT NULL
),

post_aha_events AS (
  SELECT
    e.account_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT e.user_id) AS active_users,
    COUNT(DISTINCT e.event_type) AS event_types
  FROM stg_events e
  JOIN aha_accounts a
    ON e.account_id = a.account_id
   AND e.event_timestamp >= a.first_user_aha_ts
   AND e.event_timestamp < TIMESTAMP_ADD(a.first_user_aha_ts, INTERVAL 7 DAY)
  GROUP BY e.account_id
)

SELECT
  a.is_habitual,
  COUNT(*) AS accounts,
  ROUND(AVG(p.total_events), 1) AS avg_events_post_aha,
  ROUND(AVG(p.active_users), 1) AS avg_active_users,
  ROUND(AVG(p.event_types), 1) AS avg_event_types
FROM aha_accounts a
LEFT JOIN post_aha_events p
  ON a.account_id = p.account_id
GROUP BY a.is_habitual
ORDER BY a.is_habitual DESC;
