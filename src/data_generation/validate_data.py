# src/data_generation/validate_data.py

import pandas as pd
from pathlib import Path

RAW_DIR = Path("data/raw")
VAL_DIR = Path("data/validation")
VAL_DIR.mkdir(parents=True, exist_ok=True)

files = {
    "accounts": "accounts.csv",
    "users": "users.csv",
    "events": "events.csv",
    "experiments": "experiments.csv",
    "subscriptions": "subscriptions.csv"
}

summary_rows = []
schema_rows = []

for name, file in files.items():
    df = pd.read_csv(RAW_DIR / file)

    summary_rows.append({
        "table": name,
        "row_count": len(df),
        "column_count": len(df.columns),
        "null_pct": df.isnull().mean().mean()
    })

    for col in df.columns:
        schema_rows.append({
            "table": name,
            "column": col,
            "dtype": str(df[col].dtype),
            "nullable": df[col].isnull().any()
        })

pd.DataFrame(summary_rows).to_csv(
    VAL_DIR / "validation_summary.csv", index=False
)
pd.DataFrame(schema_rows).to_csv(
    VAL_DIR / "schema_metadata.csv", index=False
)

print("Validation complete. Summary and schema written.")
