WITH user_event_pivots AS (
    SELECT
        account_id,
        user_id,

        MIN(CASE WHEN event_type = 'workflow_created' THEN event_timestamp END) AS workflow_created_ts,
        MIN(CASE WHEN event_type = 'collaborator_added' THEN event_timestamp END) AS collaborator_added_ts,
        MIN(CASE WHEN event_type = 'workflow_executed' THEN event_timestamp END) AS workflow_executed_ts

    FROM {{ ref('int_account_event_sequence') }}
    GROUP BY 1,2
),

user_aha AS (
    SELECT
        account_id,
        user_id,

        CASE
            WHEN workflow_created_ts IS NOT NULL
             AND collaborator_added_ts IS NOT NULL
             AND workflow_executed_ts IS NOT NULL
             AND workflow_created_ts < collaborator_added_ts
             AND collaborator_added_ts < workflow_executed_ts
            THEN workflow_executed_ts
            ELSE NULL
        END AS user_aha_ts
    FROM user_event_pivots
),

post_aha_exec AS (
    SELECT
        e.account_id,
        e.user_id,
        e.event_timestamp
    FROM {{ ref('int_account_event_sequence') }} e
    JOIN user_aha u
      ON e.account_id = u.account_id
     AND e.user_id = u.user_id
    WHERE e.event_type = 'workflow_executed'
      AND u.user_aha_ts IS NOT NULL
      AND e.event_timestamp > u.user_aha_ts
),

habit_agg AS (
    SELECT
        account_id,
        COUNT(*) AS exec_count,
        COUNT(DISTINCT user_id) AS exec_user_count,
        DATE_DIFF(
            DATE(MAX(event_timestamp)),
            DATE(MIN(event_timestamp)),
            DAY
        ) AS exec_span_days
    FROM post_aha_exec
    GROUP BY 1
)

SELECT
    a.account_id,

    COALESCE(h.exec_count, 0) AS post_aha_exec_count,
    COALESCE(h.exec_user_count, 0) AS post_aha_exec_user_count,
    h.exec_span_days,

    h.exec_count >= 3
    AND h.exec_user_count >= 2
    AND h.exec_span_days >= 7 AS is_habitual

FROM {{ ref('fct_account_activation_state') }} a
LEFT JOIN habit_agg h
  ON a.account_id = h.account_id
