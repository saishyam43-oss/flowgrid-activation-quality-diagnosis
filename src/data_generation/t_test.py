import pandas as pd
from scipy.stats import ttest_ind

df = pd.read_csv(r"D:\Sai\Learning\Projects\Project_6_Flowgrid_Activation_Metrics_Redesign\sql\analysis\05_behavioral_differentiation\post_aha_usage_breadth.csv")

habitual = df[df["is_habitual"] == True]["event_types"]
non_habitual = df[df["is_habitual"] == False]["event_types"]

t_stat, p_value = ttest_ind(habitual, non_habitual, equal_var=False)
print("t-statistic:", t_stat)
print("p-value:", p_value)
