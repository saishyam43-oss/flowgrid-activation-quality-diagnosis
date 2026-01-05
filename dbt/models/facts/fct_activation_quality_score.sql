WITH setup_score AS (
    SELECT DISTINCT
        account_id,
        30 AS setup_score
    FROM {{ ref('int_account_event_sequence') }}
    WHERE event_type = 'workflow_created'
),

aha_score AS (
    SELECT
        account_id,
        CASE
            WHEN aha_user_count >= 2 THEN 30
            WHEN aha_user_count = 1 THEN 15
            ELSE 0
        END AS aha_depth_score
    FROM {{ ref('fct_account_activation_state') }}
),

tt2u_score AS (
    SELECT
        account_id,
        CASE
            WHEN aha_user_count >= 2 AND tt2u_days <= 7 THEN 15
            WHEN aha_user_count >= 2 AND tt2u_days BETWEEN 8 AND 14 THEN 10
            WHEN aha_user_count >= 2 AND tt2u_days BETWEEN 15 AND 30 THEN 5
            ELSE 0
        END AS collaboration_speed_score
    FROM {{ ref('fct_account_activation_state') }}
),

habit_score AS (
    SELECT
        account_id,
        CASE WHEN is_habitual THEN 25 ELSE 0 END AS habit_score
    FROM {{ ref('fct_account_habit_state') }}
)

SELECT
    a.account_id,

    COALESCE(s.setup_score, 0) AS setup_score,
    a2.aha_depth_score,
    t.collaboration_speed_score,
    h.habit_score,

    COALESCE(s.setup_score, 0)
    + a2.aha_depth_score
    + t.collaboration_speed_score
    + h.habit_score AS activation_quality_score

FROM {{ source('flowgrid', 'accounts_raw') }} a
LEFT JOIN setup_score s ON a.account_id = s.account_id
LEFT JOIN aha_score a2 ON a.account_id = a2.account_id
LEFT JOIN tt2u_score t ON a.account_id = t.account_id
LEFT JOIN habit_score h ON a.account_id = h.account_id
