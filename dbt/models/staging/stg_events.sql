WITH filtered_events AS (
    SELECT
        event_id,
        account_id,
        user_id,
        event_type,
        event_timestamp
    FROM {{ source('flowgrid', 'events_raw') }}
    WHERE event_type IN (
        'workspace_created',
        'workflow_created',
        'workflow_executed',
        'integration_connected',
        'collaborator_invited',
        'collaborator_added'
    )
),

deduped AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                account_id,
                user_id,
                event_type,
                event_timestamp
            ORDER BY event_id ASC
        ) AS rn
    FROM filtered_events
)

SELECT
    event_id,
    account_id,
    user_id,
    event_type,
    event_timestamp
FROM deduped
WHERE rn = 1