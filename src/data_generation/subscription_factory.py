# src/data_generation/subscription_factory.py

import random
from datetime import timedelta
from .utils import random_days_after

PLANS = {
    "SMB": ("basic", 49),
    "MID_MARKET": ("pro", 199),
    "ENTERPRISE": ("enterprise", 999)
}

def generate_subscriptions(accounts):
    subs = []

    for account in accounts:
        plan, mrr = PLANS[account["segment"]]

        churned = random.random() < 0.25  # baseline churn risk
        start_date = account["created_at"]
        end_date = random_days_after(start_date, 30, 180) if churned else None

        subs.append({
            "account_id": account["account_id"],
            "plan": plan,
            "mrr": mrr,
            "start_date": start_date,
            "end_date": end_date,
            "status": "churned" if churned else "active"
        })

    return subs
