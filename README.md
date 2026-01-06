<p align="center">
  <img src="images/flowgrid_logo.png" width="220"/>
</p>

<h1 align="center">Flowgrid Activation: Are We Building Real Habit or Fooling Ourselves?</h1>

<p align="center">
  <strong>Executive Activation Quality Review</strong><br/>
  Product Analytics • Activation Metrics • B2B SaaS
</p>

---

## ⚡ Executive TL;DR

Flowgrid’s activation metrics appear healthy on the surface, with ~98% of accounts triggering an activation event.  
However, when activation is measured as **sustained, collaborative usage**, the true habit rate collapses to **0.24%**.

This analysis shows that Flowgrid is not failing to deliver first value.  
It is failing to **reinforce that value through collaboration and breadth of usage**.

The result is a system that reports success while silently accumulating churn risk.

The gap is not incremental.  
It is structural.

---

## 📊 Executive Dashboard (Decision View)

The dashboard below is intentionally constrained to answer one question:

**Are we building real habit, or reporting activity as success?**

It contains no filters or exploratory views.  
Each visual exists to support a specific product decision.

![Flowgrid Executive Dashboard](dashboard/looker_overview.png)

---

## 🏢 Product & Business Context

Flowgrid is a fictional B2B SaaS platform that enables teams to design, execute, and monitor operational workflows collaboratively.

The product’s core job-to-be-done is not solo task completion, but **shared execution and repeatable value across teams**.  
As a result, collaboration and adoption spread are fundamental to long-term retention.

This project evaluates whether Flowgrid’s current activation metrics accurately reflect that reality.

---

## 🧠 Project Framing: Why Activation Metrics Are Broken

This is not a churn post-mortem.

The goal is to **detect failure before churn appears**, by challenging whether commonly reported activation metrics are decision-safe.

Rather than asking *“How many users activated?”*, the analysis asks:

- Does activation predict habit?
- Where does activation collapse?
- Which behaviors actually separate retained accounts from churned ones?

The output is a metric and decision redesign, not a reporting exercise.

---

## ⭐ Metric Philosophy: From Activation to Habit

Binary activation metrics optimize for **motion**, not **outcomes**.

In this analysis:

- **Setup** represents technical readiness  
- **Aha** represents validated first value  
- **Habit** represents repeat, collaborative value over time  

Activation is treated as **necessary but insufficient**.  
Only habit is considered a true success state.

To bridge this gap, an **Activation Quality Score (AQS)** is used as a leading indicator, combining depth of value, collaboration speed, and habit signals into a decision-safe measure.

---

## 🚨 Why Naive Activation Metrics Failed

Flowgrid’s naive activation rate is approximately **98%**, defined as any workflow-related event.

When activation is redefined as sustained, multi-user behavior, the true habit rate drops to **0.24%**.

This exposes a classic **liar’s funnel**.

Binary activation metrics collapse a complex behavioral journey into a single checkbox and dramatically overstate success.  
Completion is easy. Habit is rare.

---

## 🔍 Where Activation Breaks

Lifecycle analysis shows that Flowgrid reliably delivers first value:

- All Aha events occur within Day 0–1  
- Provisioning and configuration are not bottlenecks  

The failure occurs **after** first value.

There is a **96.8% drop-off** between the Aha moment and multi-user usage.

**Aha is necessary, but not sufficient.**  
Without fast reinforcement through collaboration, first value decays instead of compounding.

---

## 📈 What Predicts Real Success

Several signals clearly differentiate habitual accounts from churned ones.

### Collaboration Timing
- Accounts that invite a second user within one day have a meaningful chance of becoming habitual  
- If Time-to-Second-User exceeds one day, the habit rate is **0%**

Delay is fatal.

### Activation Quality
- Low and mid-quality activation behave identically, both fail  
- Only high AQS correlates with habit, at ~60%

Moderate activation is not a stepping stone.  
It is a dead end.

### Behavioral Breadth
- Habitual accounts explore roughly **2× more feature types** early  
- Raw activity volume does not differentiate outcomes  

This difference is statistically validated and reflects *how* users engage, not how much they click.

---

## 🧱 Metric Lineage & Hardening

Activation metrics are not computed directly from raw events.

All decision-grade metrics are derived through a layered modeling approach that enforces:

- Event deduplication  
- Strict sequencing  
- Lifecycle validity  

Naive activation is intentionally isolated to demonstrate inflation and is never reused downstream.

![dbt Metric Lineage](images/dbt_lineage.png)

---

## 🧭 Insights → Product Decisions

This analysis leads to three explicit product decisions.

### FORCE COLLABORATION
Solo accounts have **0% retention**.  
Gate new workflows until a second user is invited.

**Metric Owner:** Time to Second User ≤ 1 day

---

### GUIDE EXPLORATION
Repetition does not build habit.  
Replace linear checklists with guided, multi-feature discovery.

**Metric Owner:** % High Activation Quality Accounts

---

### MEASURE REALITY
Stop reporting “Setup Complete.”  
It hides **99% of churn risk** and creates false confidence.

**Metric Owner:** True Habit Rate

---

## ⚠️ Limitations & What This Does Not Cover

- Data is synthetic, though behavior-faithful and intentionally noisy  
- No pricing or revenue linkage is modeled  
- Habit is defined behaviorally, not financially  
- No predictive or ML models are used by design  

These constraints are intentional and do not invalidate the directional conclusions.

---

## 🧠 How This Demonstrates Senior Product Analytics

This project demonstrates senior-level analytical judgment by:

- Redefining success metrics instead of optimizing dashboards  
- Invalidating comforting KPIs rather than defending them  
- Treating activation as a system, not a step  
- Translating evidence directly into product decisions  
- Knowing when *not* to use ML or over-segmentation  

The value lies in **what is measured, what is rejected, and what decisions follow**.

---

## 📣 Call to Action

If you’re interested in discussing activation metrics, habit formation, or product analytics at a senior level, feel free to reach out or open an issue in the repository.

This project is intended to spark better questions, not just better charts.
