SELECT
  CASE
    WHEN tt2u_days IS NULL THEN 'no_second_user'
    WHEN tt2u_days <= 1 THEN 'day_0_1'
    WHEN tt2u_days <= 3 THEN 'day_2_3'
    WHEN tt2u_days <= 7 THEN 'day_4_7'
    WHEN tt2u_days <= 14 THEN 'day_8_14'
    ELSE 'day_15_plus'
  END AS tt2u_bucket,
  COUNT(*) AS accounts,
  COUNTIF(is_habitual = true) AS habitual_accounts,
  ROUND(
    SAFE_DIVIDE(COUNTIF(is_habitual = true), COUNT(*)),
    3
  ) AS habit_rate
FROM fct_account_lifecycle_state
WHERE first_user_aha_ts IS NOT NULL
GROUP BY 1
ORDER BY
  CASE tt2u_bucket
    WHEN 'day_0_1' THEN 1
    WHEN 'day_2_3' THEN 2
    WHEN 'day_4_7' THEN 3
    WHEN 'day_8_14' THEN 4
    WHEN 'day_15_plus' THEN 5
    WHEN 'no_second_user' THEN 6
  END;
