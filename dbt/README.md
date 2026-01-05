# dbt Models – Flowgrid Activation Analysis

This folder contains the dbt project used to model, validate, and harden activation metrics for the Flowgrid analysis.

The focus of these models is **metric correctness**, not transformation volume. All downstream analysis and dashboards rely exclusively on the fact tables produced here.

### Structure

- **staging/**  
  Event-level cleaning and normalization.

- **intermediate/**  
  Sequencing and lifecycle validation logic.

- **facts/**  
  Final, analytics-ready tables used for activation, collaboration, and habit analysis.

### Design Principles

- Explicit lifecycle sequencing
- Account-level grain enforcement
- Defensive metric definitions to avoid false activation signals

Implementation details are intentionally kept secondary to analytical intent.
