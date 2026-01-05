SELECT
    event_id,
    account_id,
    user_id,
    event_type,
    event_timestamp,

    ROW_NUMBER() OVER (
        PARTITION BY account_id
        ORDER BY event_timestamp ASC, event_id ASC
    ) AS event_order,

    LAG(event_type) OVER (
        PARTITION BY account_id
        ORDER BY event_timestamp ASC, event_id ASC
    ) AS prev_event_type

FROM {{ ref('stg_events') }}