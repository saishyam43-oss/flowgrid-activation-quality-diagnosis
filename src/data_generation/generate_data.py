# src/data_generation/generate_data.py

import random
import pandas as pd
from pathlib import Path

from .config import RANDOM_SEED, NUM_ACCOUNTS
from .account_factory import generate_accounts
from .user_factory import generate_users_for_account
from .event_factory import generate_events
from .experiment_factory import assign_experiments
from .subscription_factory import generate_subscriptions

random.seed(RANDOM_SEED)

RAW_DIR = Path("data/raw")
RAW_DIR.mkdir(parents=True, exist_ok=True)

accounts = generate_accounts(NUM_ACCOUNTS)

users = []
events = []

for account in accounts:
    acc_users = generate_users_for_account(account)
    users.extend(acc_users)
    events.extend(generate_events(account, acc_users))

experiments = assign_experiments(accounts)
subscriptions = generate_subscriptions(accounts)

pd.DataFrame(accounts).to_csv(RAW_DIR / "accounts.csv", index=False)
pd.DataFrame(users).to_csv(RAW_DIR / "users.csv", index=False)
pd.DataFrame(events).to_csv(RAW_DIR / "events.csv", index=False)
pd.DataFrame(experiments).to_csv(RAW_DIR / "experiments.csv", index=False)
pd.DataFrame(subscriptions).to_csv(RAW_DIR / "subscriptions.csv", index=False)

print("All raw synthetic data generated successfully.")
