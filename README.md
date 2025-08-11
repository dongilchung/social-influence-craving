# social-influence-craving
This project provides MATLAB scripts and functions for analyzing " Social norms modulate asymmetric effects of group opinions on cue-induced smoking craving", and details for variables measured in this study.  

**Running the scripts**
Scripts were run in Matlab, version 2019a.  
Figures can be reproduced by running the corresponding .m file named after the figure inside the figure_script folder. However, the figure_script, data, and functions folders must be located within the same parent directory.  

**Data structure**  
1. Each EXP#_data.mat file contains both EXP#_questionnaire_data and EXP#_rating_data.
2. EXP#_rating_data contains the response data from the craving rating task.
3. In EXP#_rating_data, the first column contains the subject index. The second column contains cells, each representing a subject’s responses to the stimuli.
4. Each subject's response data, i.e., EXP#_rating_data{X,2}, includes the following fields:
   - **stim**: stimulus index
   - **initial_rating**: the subject’s craving response on the first day (rated from 1 to 10; note that 0 represents 10).
   - **feedback**: score presented as group opinions
   - **conflict**: the difference between feedback and initial rating (feedback - initial_rating)
   - **second_rating**: craving rating for the same stimulus on the following day (day2)
   - **rating_diff**: change in craving rating from day1 to day2 for each stimulus (second_rating - initial_rating)  

**Measured variables**  
EXP#_questionnaire_data contains each participant’s questionnaire response data.  
- **Gender_M1_F2** represents gender: 1 = Male, 2 = female.
- **Age** represents participants’ age.
- **Smoking1_Past2** represents participants’ smoking status: 1 = smoker, 2 = past-smoker.
- **Education** represents participants’ level of education
- **Income_level** represents participants’ level of annual education converted to US dollars in an approximate term.
- **FTND** (The Fagerstrom Test for Nicotine Dependence) measures the level of nicotine dependence: Higher the number, the more participant is dependent on nicotine.
- **QSU_day#** measures participants’ urge to smoke in day 1 and day 2: Higher the number, the more participant experienced stronger urge to smoke.
- **Direct_smoking_cancer_risk** represents participants’ perception of getting cancer or smoking related diseases from smoking cigarettes (0-100%).
- **Indirect_smoking_cancer_risk** represents participants’ perception of getting cancer or smoking related diseases from indirect smoking (0-100%).
- **Self_assessed_cancer_risk** represents participants’ perception of him/herself getting a cancer or smoking related diseases (0-100%).
- **cessation_period** represents participants’ current smoking cessation length (In days).
- **cessation_attempt_Num** represents the number of participants’ total cessation attempts in their lives.
- **smoking_start_age** represents participants’ age that they first started smoking a cigarette.
- **smoking_period** represents the time length of participant’s smoking period (in Years).
- **num_cigarettes_last_24h** represents the amount of cigarettes participants smoked in the past 24 hours.
- **num_cigarettes_last_12h** represents the amount of cigarettes participants smoked in the past 12 hours.
- **days_smoked_last_7d** represents the number of days of participants smoked in the past week.
- **avg_daily_cigarettes_last_7d** represents the average amount of cigarettes participants smoked in a day over the past week.
- **CESD** (the Center for Epidemiologic Studies Depression) measures participants’ level of depression over the past week.: Higher the number, the stronger participants experienced depression.
- **General_risk** represents participants’ general tendency to take risks (0-100%).
- **MCQ** (Mehrabian Conformity Scale) measures participants’ dispositional tendency to conform.
- **ITS** (Interpersonal trust scale) measures participants’ dispositional level of trust.
- **RPI** (Resistance to peer influence scale) measures participants’ dispositional tendency to resist social influence (e.g., conformity).  
