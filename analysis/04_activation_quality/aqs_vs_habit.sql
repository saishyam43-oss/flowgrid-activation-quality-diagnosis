SELECT
  CASE
    WHEN aqs.activation_quality_score < 40 THEN 'low_aqs'
    WHEN aqs.activation_quality_score < 70 THEN 'mid_aqs'
    ELSE 'high_aqs'
  END AS aqs_bucket,
  COUNT(*) AS accounts,
  COUNTIF(l.is_habitual = true) AS habitual_accounts,
  ROUND(
    SAFE_DIVIDE(COUNTIF(l.is_habitual = true), COUNT(*)),
    3
  ) AS habit_rate
FROM fct_account_lifecycle_state l
JOIN fct_activation_quality_score aqs
  ON l.account_id = aqs.account_id
WHERE l.first_user_aha_ts IS NOT NULL
GROUP BY 1
ORDER BY
  CASE aqs_bucket
    WHEN 'low_aqs' THEN 1
    WHEN 'mid_aqs' THEN 2
    WHEN 'high_aqs' THEN 3
  END;
