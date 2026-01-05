WITH configured_accounts AS (
    SELECT DISTINCT account_id
    FROM {{ ref('int_account_event_sequence') }}
    WHERE event_type = 'workflow_created'
),

churned_accounts AS (
    SELECT DISTINCT account_id
    FROM {{ source('flowgrid', 'subscriptions_raw') }}
    WHERE end_date IS NOT NULL
)

SELECT
    act.account_id,
    act.aha_user_count,
    act.first_user_aha_ts,
    act.second_user_aha_ts,
    act.tt2u_days,

    h.is_habitual,

    CASE
        WHEN c.account_id IS NOT NULL THEN 'churned'
        WHEN h.is_habitual THEN 'habitual'
        WHEN act.aha_user_count >= 2 THEN 'multi_user'
        WHEN act.aha_user_count = 1 THEN 'aha'
        WHEN cfg.account_id IS NOT NULL THEN 'configured'
        ELSE 'provisioned'
    END AS lifecycle_state

FROM {{ ref('fct_account_activation_state') }} act
LEFT JOIN {{ ref('fct_account_habit_state') }} h
  ON act.account_id = h.account_id
LEFT JOIN configured_accounts cfg
  ON act.account_id = cfg.account_id
LEFT JOIN churned_accounts c
  ON act.account_id = c.account_id
