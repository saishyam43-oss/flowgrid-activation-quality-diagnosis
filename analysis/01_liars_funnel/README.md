# Step 1.5 – The Liar’s Funnel (Naive vs Hardened Activation)

## Question
How misleading are naive activation metrics when compared to decision-safe, hardened definitions?

## Method
Two activation funnels were constructed:

**Naive Funnel**
- Start: account_created
- Activation: any workflow-related event
- No sequencing, deduplication, or collaboration requirements

This mirrors how activation is often measured in raw product dashboards.

**Hardened Funnel**
- Uses pre-validated, decision-safe lifecycle metrics
- Enforces strict event sequencing
- Requires collaboration and sustained usage signals

## Results

| Funnel Type | Stage | Accounts |
|------------|------|----------|
| Naive | account_created | 2,500 |
| Naive | any_workflow_event | 2,438 |
| Hardened | Aha | 226 |
| Hardened | Multi-user | 3 |
| Hardened | Habitual | 5 |

## Insight
A naive funnel suggests nearly universal activation (~97%).  
When strict sequencing and collaboration are enforced, fewer than 1% of accounts reach sustained, multi-user value.

This gap demonstrates that binary activation metrics dramatically overstate product success and obscure the true source of user drop-off.

## Decision Implication
Activation should not be treated as a single event. Without hardened definitions, teams risk optimizing onboarding for vanity metrics while failing to address the real bottleneck: converting individual value into shared, habitual usage.
