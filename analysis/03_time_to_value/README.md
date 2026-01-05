# Step 3 – Time to Value and Collaboration Collapse

## Question
How quickly do accounts reach initial value, and at what point does delayed collaboration eliminate the probability of Habit formation?

## Method
Two time-based analyses were performed:

1. **Time to Aha**
   - Measured as the number of days between account creation and first_user_aha_ts
   - Computed for all provisioned accounts

2. **Time to Second User (TT2U)**
   - Measured using tt2u_days
   - Evaluated only for accounts that reached Aha
   - Habit formation rate compared across TT2U buckets

## Results

### Time to Aha

| Time to Aha | Accounts |
|------------|----------|
| Day 0–1 | 309 |
| No Aha | 2,191 |

All accounts that reached Aha did so within the first day.  
The majority of accounts (87.6%) never reached Aha at all.

### Time to Second User (TT2U)

| TT2U Bucket | Accounts | Habit Rate |
|------------|----------|------------|
| Day 0–1 | 10 | 60% |
| No Second User | 299 | 0% |

## Insight
Activation failure is not driven by slow onboarding or delayed initial value. Accounts that reach value do so immediately.

However, Habit formation is highly sensitive to collaboration speed. If a second user does not join almost immediately after first value, the probability of Habit formation collapses to zero.

## Decision Implication
Improving onboarding speed or single-user Aha rates alone will not materially improve retention. The highest leverage intervention is accelerating second-user adoption immediately after first value is experienced.
