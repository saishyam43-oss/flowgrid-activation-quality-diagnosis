# Step 2 – Where Does Activation Break?

## Question
Where in the hardened lifecycle does activation irreversibly fail?

## Method
We reconstructed a monotonic activation funnel using event-backed signals:
- Provisioned: account exists
- Aha: first_user_aha_ts is present
- Multi-user: second_user_aha_ts is present
- Habitual: is_habitual = true

Lifecycle classifications were intentionally not used to avoid non-monotonic artifacts.

## Results

| Transition | Accounts Entered | Accounts Progressed | Drop-off |
|----------|-----------------|---------------------|----------|
| Provisioned → Aha | 2,500 | 309 | 87.6% |
| Aha → Multi-user | 309 | 10 | **96.8%** |
| Multi-user → Habitual | 10 | 6 | 40.0% |

## Insight
The largest and most damaging drop-off occurs **after users experience initial value**, when accounts attempt to move from individual usage to collaboration.

This indicates that activation failure is not driven by onboarding or feature discovery alone, but by an inability to convert early value into shared, multi-user adoption.

## Decision Implication
Improving the Aha experience alone will not materially increase Habit formation. The highest leverage intervention is reducing friction between first value and second-user adoption.
