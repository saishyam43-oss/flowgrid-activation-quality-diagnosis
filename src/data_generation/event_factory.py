# src/data_generation/event_factory.py

import uuid
import random
from datetime import timedelta
from .config import (
    SETUP_COMPLETION_PROB,
    AHA_PROB_SINGLE_USER,
    SECOND_USER_INVITE_PROB,
    SECOND_USER_AHA_PROB,
    DUPLICATE_EVENT_RATE,
    OVER_INSTRUMENTATION_RATE,
    HABIT_PROB_SINGLE,
    HABIT_PROB_MULTI
)
from .utils import random_minutes_after

def generate_events(account, users):
    events = []
    base_time = account["created_at"]

    segment = account["segment"]
    setup_completed = random.random() < SETUP_COMPLETION_PROB[segment]

    for user in users[:1]:
        # Setup events
        events.append(_event(account, user, "workspace_created", base_time))

        if random.random() < OVER_INSTRUMENTATION_RATE:
            events.append(_event(account, user, "integration_connected", base_time))

        if setup_completed:
            events.append(_event(account, user, "integration_connected", random_minutes_after(base_time)))

    # Aha logic
    aha_users = []
    if setup_completed and random.random() < AHA_PROB_SINGLE_USER[segment]:
        primary_user = users[0]
        aha_users.append(primary_user)

        events += _aha_sequence(account, primary_user, base_time)

        # Habit events for primary user
        if primary_user in aha_users:
            if random.random() < HABIT_PROB_SINGLE:
                events += _habit_events(account, primary_user, base_time + timedelta(days=7))

    # Light background usage for non-habit users
    for user in users:
        if user not in aha_users and random.random() < 0.15:
            events.append(
                _event(
                    account,
                    user,
                    "workflow_executed",
                    random_minutes_after(base_time + timedelta(days=10))
                )
            )

    # Collaboration
    if len(users) > 1 and random.random() < SECOND_USER_INVITE_PROB[segment]:
        second_user = users[1]
        events.append(_event(account, users[0], "collaborator_invited", random_minutes_after(base_time)))

        if random.random() < SECOND_USER_AHA_PROB:
            aha_users.append(second_user)
            events += _aha_sequence(account, second_user, base_time + timedelta(days=1))

    # Habit events for multi-user accounts
    for user in aha_users:
        if random.random() < HABIT_PROB_MULTI:
            events += _habit_events(account, user, base_time + timedelta(days=7))

    # Account-level background activity (realistic noise)
    for user in users:
        if random.random() < 0.35:  # background usage rate
            for _ in range(random.randint(2, 6)):
                events.append(
                    _event(
                        account,
                        user,
                        "workflow_executed",
                        random_minutes_after(base_time + timedelta(days=random.randint(5, 60)))
                    )
                )

    # Duplicate events
    dup_low, dup_high = DUPLICATE_EVENT_RATE
    for e in list(events):
        if random.random() < random.uniform(dup_low, dup_high):
            events.append(e.copy())

    return events

def _aha_sequence(account, user, start_time):
    return [
        _event(account, user, "workflow_created", random_minutes_after(start_time)),
        _event(account, user, "collaborator_added", random_minutes_after(start_time)),
        _event(account, user, "workflow_executed", random_minutes_after(start_time))
    ]

def _habit_events(account, user, start_time):
    """
    Generate repeat workflow executions across multiple weeks
    to simulate habit formation.
    """
    events = []
    num_events = random.randint(8, 20)
    num_weeks = random.randint(2, 4)

    base_time = start_time

    for week in range(num_weeks):
        weekly_events = random.randint(1, max(1, num_events // num_weeks))
        for _ in range(weekly_events):
            events.append(
                _event(
                    account,
                    user,
                    "workflow_executed",
                    base_time + timedelta(days=7 * week + random.randint(1, 3))
                )
            )

    return events

def _event(account, user, event_type, timestamp):
    return {
        "event_id": str(uuid.uuid4()),
        "account_id": account["account_id"],
        "user_id": user["user_id"],
        "event_type": event_type,
        "event_timestamp": timestamp
    }
