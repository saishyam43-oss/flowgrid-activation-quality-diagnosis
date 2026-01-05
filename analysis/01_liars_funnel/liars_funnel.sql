WITH naive AS (
  SELECT
    'naive' AS funnel_type,
    'account_created' AS stage,
    COUNT(DISTINCT account_id) AS account_count
  FROM accounts

  UNION ALL

  SELECT
    'naive' AS funnel_type,
    'any_workflow_event' AS stage,
    COUNT(DISTINCT account_id) AS account_count
  FROM events
  WHERE event_type LIKE '%workflow%'
),

hardened AS (
  SELECT
    'hardened' AS funnel_type,
    lifecycle_state AS stage,
    COUNT(DISTINCT account_id) AS account_count
  FROM fct_account_lifecycle_state
  WHERE lifecycle_state IN (
    'provisioned',
    'configured',
    'aha',
    'multi_user',
    'habitual'
  )
  GROUP BY lifecycle_state
)

SELECT *
FROM naive

UNION ALL

SELECT *
FROM hardened
ORDER BY funnel_type, stage;
