# src/data_generation/utils.py

from datetime import datetime, timedelta
import random

def random_days_after(base_date, min_days=0, max_days=3):
    return base_date + timedelta(days=random.randint(min_days, max_days))

def random_minutes_after(base_date, min_min=1, max_min=60):
    return base_date + timedelta(minutes=random.randint(min_min, max_min))
