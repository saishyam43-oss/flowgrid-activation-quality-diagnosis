# src/data_generation/account_factory.py

import uuid
import random
from datetime import datetime
from .config import SEGMENT_DISTRIBUTION, SEAT_RANGES, REGION_DISTRIBUTION

def generate_accounts(n_accounts):
    accounts = []

    for _ in range(n_accounts):
        segment = random.choices(
            list(SEGMENT_DISTRIBUTION.keys()),
            weights=SEGMENT_DISTRIBUTION.values()
        )[0]

        seat_min, seat_max = SEAT_RANGES[segment]

        account = {
            "account_id": str(uuid.uuid4()),
            "segment": segment,
            "seat_count": random.randint(seat_min, seat_max),
            "region": random.choices(
                list(REGION_DISTRIBUTION.keys()),
                weights=REGION_DISTRIBUTION.values()
            )[0],
            "created_at": datetime.utcnow()
        }

        accounts.append(account)

    return accounts
