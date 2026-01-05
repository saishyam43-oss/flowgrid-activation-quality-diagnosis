WITH naive_activation AS (
    SELECT
        account_id,
        TRUE AS naive_is_activated,
        MIN(event_timestamp) AS naive_activation_ts
    FROM {{ ref('stg_events') }}
    WHERE event_type = 'workflow_executed'
    GROUP BY 1
)

SELECT
    a.account_id,

    COALESCE(n.naive_is_activated, FALSE) AS naive_is_activated,
    h.is_activated AS hardened_is_activated,

    n.naive_activation_ts,
    h.first_user_aha_ts AS hardened_activation_ts,

    COALESCE(n.naive_is_activated, FALSE)
    AND h.is_activated = FALSE AS false_positive_naive_activation

FROM {{ source('flowgrid', 'accounts_raw') }} a
LEFT JOIN naive_activation n
  ON a.account_id = n.account_id
LEFT JOIN {{ ref('fct_account_activation_state') }} h
  ON a.account_id = h.account_id
