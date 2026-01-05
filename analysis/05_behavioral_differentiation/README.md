# Step 5 – Behavioral Differentiation After Aha

## Question
Among accounts that reach Aha, what behaviors distinguish those that form a Habit from those that stall?

## Method
We analyzed post-Aha behavior in the first 7 days after initial value was reached.  
Only accounts with a valid Aha timestamp were included.

Behavioral metrics analyzed:
- Total events executed
- Number of active users
- Number of distinct event types (usage breadth)

Accounts were grouped by Habit outcome.

## Results

| Outcome | Accounts | Avg Events | Avg Active Users | Avg Event Types |
|-------|---------|------------|------------------|-----------------|
| Habitual | 6 | 5.2 | 2.8 | 3.3 |
| Non-habitual | 244 | 3.8 | 2.7 | 1.5 |
| Unclassified | 59 | 3.2 | 2.7 | 1.3 |

## Insight
Habit formation is driven by **Breadth-First Onboarding**, not repeated execution of a single workflow.

While Habitual and non-Habitual accounts show similar user counts and only modest differences in raw activity, Habitual accounts engage with more than twice as many feature types immediately after reaching Aha.

This indicates that sustained value emerges when users explore multiple workflows early, rather than repeatedly performing the same action.

## Decision Implication
Driving second-user adoption is necessary but not sufficient. Onboarding and activation flows should explicitly encourage multi-feature exploration immediately after first value is reached, as usage breadth is the clearest signal of long-term Habit formation.

### Statistical Validation
A two-sample Welch’s t-test confirms that the difference in post-Aha usage breadth between Habitual and Non-Habitual accounts is statistically significant (p = 0.0025), indicating that the observed separation is unlikely to be due to random variation.