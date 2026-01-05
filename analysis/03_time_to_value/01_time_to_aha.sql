SELECT
  CASE
    WHEN f.first_user_aha_ts IS NULL THEN 'no_aha'
    WHEN TIMESTAMP_DIFF(f.first_user_aha_ts, a.created_at, DAY) <= 1 THEN 'day_0_1'
    WHEN TIMESTAMP_DIFF(f.first_user_aha_ts, a.created_at, DAY) <= 3 THEN 'day_2_3'
    WHEN TIMESTAMP_DIFF(f.first_user_aha_ts, a.created_at, DAY) <= 7 THEN 'day_4_7'
    WHEN TIMESTAMP_DIFF(f.first_user_aha_ts, a.created_at, DAY) <= 14 THEN 'day_8_14'
    ELSE 'day_15_plus'
  END AS time_to_aha_bucket,
  COUNT(*) AS accounts
FROM fct_account_lifecycle_state f
JOIN accounts_raw a
  ON f.account_id = a.account_id
GROUP BY 1
ORDER BY
  CASE time_to_aha_bucket
    WHEN 'day_0_1' THEN 1
    WHEN 'day_2_3' THEN 2
    WHEN 'day_4_7' THEN 3
    WHEN 'day_8_14' THEN 4
    WHEN 'day_15_plus' THEN 5
    WHEN 'no_aha' THEN 6
  END;
