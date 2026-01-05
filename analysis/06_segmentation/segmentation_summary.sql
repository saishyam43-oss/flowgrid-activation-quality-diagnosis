SELECT
  a.segment,
  COUNT(*) AS accounts,

  COUNTIF(l.first_user_aha_ts IS NOT NULL) AS aha_accounts,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(l.first_user_aha_ts IS NOT NULL),
      COUNT(*)
    ),
    3
  ) AS aha_rate,

  COUNTIF(l.second_user_aha_ts IS NOT NULL) AS multi_user_accounts,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(l.second_user_aha_ts IS NOT NULL),
      COUNTIF(l.first_user_aha_ts IS NOT NULL)
    ),
    3
  ) AS aha_to_multi_user_rate,

  COUNTIF(l.is_habitual = true) AS habitual_accounts,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(l.is_habitual = true),
      COUNT(*)
    ),
    3
  ) AS habit_rate

FROM fct_account_lifecycle_state l
JOIN accounts_raw a
  ON l.account_id = a.account_id
GROUP BY a.segment
ORDER BY accounts DESC;
