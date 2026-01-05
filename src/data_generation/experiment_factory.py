# src/data_generation/experiment_factory.py

import uuid
import random
from datetime import timedelta
from .utils import random_days_after

EXPERIMENTS = [
    {
        "experiment_name": "guided_setup_flow",
        "variants": ["control", "guided"],
        "exposure_rate": 0.5
    },
    {
        "experiment_name": "gamified_activation",
        "variants": ["control", "gamified"],
        "exposure_rate": 0.5
    }
]

def assign_experiments(accounts):
    rows = []

    for account in accounts:
        for exp in EXPERIMENTS:
            if random.random() <= exp["exposure_rate"]:
                rows.append({
                    "experiment_id": str(uuid.uuid4()),
                    "account_id": account["account_id"],
                    "experiment_name": exp["experiment_name"],
                    "variant": random.choice(exp["variants"]),
                    "exposed_at": random_days_after(account["created_at"], 0, 7)
                })

    return rows
