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

account_first_aha AS (
    SELECT
        account_id,
        MIN(user_aha_ts) AS first_user_aha_ts
    FROM user_aha
    WHERE user_aha_ts IS NOT NULL
    GROUP BY 1
),

account_second_aha AS (
    SELECT
        u.account_id,
        MIN(u.user_aha_ts) AS second_user_aha_ts
    FROM user_aha u
    JOIN account_first_aha f
      ON u.account_id = f.account_id
    WHERE u.user_aha_ts > f.first_user_aha_ts
    GROUP BY 1
),

account_aha AS (
    SELECT
        a.account_id,

        COUNTIF(u.user_aha_ts IS NOT NULL) AS aha_user_count,
        f.first_user_aha_ts,
        s.second_user_aha_ts

    FROM user_aha u
    LEFT JOIN account_first_aha f
      ON u.account_id = f.account_id
    LEFT JOIN account_second_aha s
      ON u.account_id = s.account_id
    RIGHT JOIN (
        SELECT DISTINCT account_id
        FROM {{ ref('int_account_event_sequence') }}
    ) a
      ON u.account_id = a.account_id
    GROUP BY 1, f.first_user_aha_ts, s.second_user_aha_ts
)

SELECT
    account_id,
    aha_user_count,
    first_user_aha_ts,
    second_user_aha_ts,

    first_user_aha_ts IS NOT NULL AS is_activated,

    CASE
        WHEN first_user_aha_ts IS NOT NULL
         AND second_user_aha_ts IS NOT NULL
        THEN TIMESTAMP_DIFF(second_user_aha_ts, first_user_aha_ts, DAY)
        ELSE NULL
    END AS tt2u_days

FROM account_aha