# src/data_generation/user_factory.py

import uuid
import random
from .config import ROLE_DRIFT_RATE

ROLES = ["ADMIN", "EDITOR", "VIEWER"]
ROLE_WEIGHTS = [0.10, 0.40, 0.50]

def generate_users_for_account(account):
    users = []
    seat_count = account["seat_count"]
    adoption_factor = random.uniform(0.6, 0.85)
    user_count = max(1, int(seat_count * adoption_factor))

    for i in range(user_count):
        role = random.choices(ROLES, weights=ROLE_WEIGHTS)[0]

        user = {
            "user_id": str(uuid.uuid4()),
            "account_id": account["account_id"],
            "initial_role": role,
            "current_role": role,
            "role_drifted": False
        }

        if random.random() < ROLE_DRIFT_RATE:
            user["current_role"] = random.choice(
                [r for r in ROLES if r != role]
            )
            user["role_drifted"] = True

        users.append(user)

    return users
