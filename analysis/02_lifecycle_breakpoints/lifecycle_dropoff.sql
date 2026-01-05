WITH base AS (
  SELECT
    account_id,
    first_user_aha_ts,
    second_user_aha_ts,
    is_habitual
  FROM fct_account_lifecycle_state
),

states AS (
  SELECT
    account_id,
    'provisioned' AS state
  FROM base

  UNION ALL

  SELECT
    account_id,
    'aha' AS state
  FROM base
  WHERE first_user_aha_ts IS NOT NULL

  UNION ALL

  SELECT
    account_id,
    'multi_user' AS state
  FROM base
  WHERE second_user_aha_ts IS NOT NULL

  UNION ALL

  SELECT
    account_id,
    'habitual' AS state
  FROM base
  WHERE is_habitual = true
),

state_counts AS (
  SELECT
    state,
    COUNT(DISTINCT account_id) AS accounts_reached
  FROM states
  GROUP BY state
)

SELECT
  s1.state AS from_state,
  s2.state AS to_state,
  s1.accounts_reached AS accounts_entered,
  s2.accounts_reached AS accounts_progressed,
  ROUND(
    1 - SAFE_DIVIDE(s2.accounts_progressed, s1.accounts_entered),
    3
  ) AS drop_off_pct
FROM state_counts s1
JOIN state_counts s2
  ON (
    (s1.state = 'provisioned' AND s2.state = 'aha') OR
    (s1.state = 'aha' AND s2.state = 'multi_user') OR
    (s1.state = 'multi_user' AND s2.state = 'habitual')
  )
ORDER BY
  CASE s1.state
    WHEN 'provisioned' THEN 1
    WHEN 'aha' THEN 2
    WHEN 'multi_user' THEN 3
  END;
