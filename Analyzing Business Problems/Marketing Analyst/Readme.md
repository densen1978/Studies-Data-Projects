# Marketing Analysis 

## Task requirements
- Create a presentation centered around the dynamic weekday duration, focusing on differences between marketing campaigns.
- See whether you can apply 1-2 techniques learned in this or other modules throughout the course material to enhance your presentation on this subject.
- Explore the data. See whether there are interesting data points that can give more insights to your presentation.
- Provide analytical insights, what are the drawbacks of this analysis, what further analysis could you recommend?
- You should use the turing_college.raw_events table to answer this question. 
- Write a SQL query that would extract data from BigQuery, make a visualisation using your preferred data visualisation tool (Google Sheets / Tableau / Looker Studio) and briefly comment your findings. 
- As we do not have session identifiers in the dataset, you will have to come up with your own logic for how you will model sessions. 
- Have in mind that a single user can come to your website on multiple days and if you were to calculate time on the website this may have an impact on this metric.

## Introduction

Marketing analysis is a crucial component of any successful business strategy. To effectively reach and engage your target audience, it's imperative to understand the performance of your marketing campaigns and user session times. This analysis involves evaluating the effectiveness of your marketing efforts during different time frames, including weekdays and various parts of the day, such as morning and afternoon.

By examining user session times and behavior patterns, you can gain valuable insights into when your audience is most active and responsive. This data allows you to optimize your marketing campaigns, ensuring that you reach your audience when they are most likely to be receptive to your messages. Additionally, it helps you allocate your resources efficiently and make data-driven decisions to enhance your overall marketing strategy. In a competitive business landscape, understanding these critical aspects of marketing analysis is key to staying ahead and maximizing your campaign's success.

In this analysis, we'll explain our methods and share insights on user session times per campaigns to enhance our website's performance and better understanding of users behavior.
## Main Questions 

For the business to understand users' behavior, session times per campaigns, and which campaigns are more successful, I raised a few questions to the business in order to bring more understanding of the business from a marketing point of view.

**How do users' session times differ in different periods?**
  - Understanding how user session times vary across different time periods allows marketers to pinpoint the most active and receptive times for their audience. This knowledge can be used to schedule marketing activities for maximum impact and engagement.

**How do users' session times differ on weekdays?**
  - Weekdays often have distinct user behavior patterns compared to weekends. Recognizing these differences is crucial for tailoring marketing strategies, as it enables businesses to target their audience effectively during the workweek and adapt their messaging for weekends.

**How does each marketing campaign perform?**
  - Assessing the performance of marketing campaigns is crucial for measuring their success and return on investment. Analyzing key metrics helps marketers refine their strategies, allocate resources efficiently, and make data-driven decisions for future campaigns.

## Analysis and Insights

**Average Duration Time Breakdown by Weekdays and Campaigns**
  - The average session duration was calculated and broken down by both weekdays and campaigns. This breakdown helps in understanding how different campaigns perform on different days of the week, providing insights into user engagement and behavior patterns.

**Engagement Funnels by Weekdays and Campaigns**
  - Engagement funnels were built to illustrate user engagement stages across different weekdays and campaigns. These funnels help in identifying drop-off points and understanding user progression through various stages of interaction with the campaigns.

## Reports 

**The Main Report**

  All the analysis steps can be found in the report, where all main questions and main insights are clearly introduced.

  The report can be found [here](https://)

**Looker Studio Report**

  To answer these questions, an interactive Looker Studio report was prepared, which can be found [here](https://)



