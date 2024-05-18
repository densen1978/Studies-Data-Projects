# Customer Segmentation & RFM

## Task requirements
For your graded task, you have to do RFM analysis with a given data set. The data set table is called "rfm" and can be found under "turing_data_analytics" database, placed in the Turing College BigQuery project. Your tasks are:                                                                                
- Use only one year of data, 2010-12-01 to 2011-12-01.                                                                                
- Use SQL for calculation and data selection.                                                                                
- Calculate recency, frequency and money value and convert those values into R, F and M scores by using Quartiles, 1 to 4 values. In BigQuery, a function APPROX_QUANTILES is used to set the quartiles. You can check your results with rfm_value table and rfm_quantiles. Those tables contain intermediate calculations and are used in next steps(1 step: calculate RFM values, possible answer - rfm_value table, 2 step: calculate RFM quantiles from RFM values, possible answer - rfm_quantiles). Important note: the answers in the tables are one of the possible answers. The results might vary due to data filtering options.                    - Calculate recency from date 2011-12-01.                                                                                
- Calculate common RFM score. An example of a possible answer is given in the table rfm_score.                                                                      - Segment customers into Best Customers, Loyal Customers, Big Spenders, Lost Customers and other categories.                                                        - Present your analyses with a dashboard in Looker Studio or a similar visualisation tool. You can export data from BigQuery directly to Looker Studio.

## Customer Segmentatiomn

In a constantly growing business, understanding your customers behavior is one of the most important parts for success. This is where customer segmentation and RFM steps in. Segmentation means sorting your customers into groups who are similar, so we can treat them uniquely by the groups they are assigned. RFM is like looking at a customer's shopping habits - how recently they bought (R), how often (F), and how much they spend (M). By doing this, we can find out who your best customers are, how to engage those customers who haven't shopped in a while, and make your marketing campaigns even better. These tools help businesses understand customers like never before, making relationships stronger and businesses more successful.

In this project I received the RFM dataset with information about the customer invoices, when they bought, what they bought, how much of the products they bought and for what amount, from where I will bring insights about customers segments, their buying habits and I will give some recommendation where what we could do with each of the segmented group.

### The main question I wanted to answer 

1. How our segmented groups perform and where we need to pay more attention.
2. What suggestions would be for each of the segmented groups in order to increase their engagement.

## Results and insights
![RFM segments chart](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Customer%20Segmentation%20%26%20RFM/RFM-chart.png)
![RFM segments table](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Customer%20Segmentation%20%26%20RFM/RFM-table.png)

Best Customers:
There are 959 best customers who are highly valuable to your business. They have made, on average, 13.5 purchases and have a significantly high average monetary value of $5,868.3 per user. These customers have recently interacted with your business, with an average recency of just 15.6 days ago. They are engaged and should be a top priority for targeted marketing and retention efforts.

Cant Lose Them:
Although there are only 36 customers in this segment, they are extremely valuable. They have an impressive average monetary value of $2,943.9 per user.
These customers, despite a longer average recency of 214.3 days ago, have an exceptionally high frequency of 8.1 purchases. It's essential to focus on retaining these high-value customers. 

At Risk:
The 351 customers in this segment have a relatively high monetary value of $1,850.2 per user, but their recency is a bit concerning at an average of 135.0 days ago.
While they have a decent frequency of 5.5 purchases, they are on the verge of becoming inactive. Targeted re-engagement strategies are crucial to prevent them from slipping into the "Hibernating" or "Lost Customers" segments.

Loyal Customers:
The 743 loyal customers have an average recency of 16.7 days ago, indicating recent activity. Their frequency of 3.2 purchases and an average monetary value of $870.6 per user make them a valuable segment to nurture and retain.

Customers Needing Attention:
This segment includes 985 customers who have made an average of 2.3 purchases with an average monetary value of $643.0 per user.
While they are not the highest spenders, they may have potential for growth. Given their recent interaction (average recency of 70.8 days ago), targeted marketing efforts can help increase their frequency and monetary contributions.

Hibernating:
The 482 customers in the "Hibernating" segment have a concerning average recency of 240.9 days ago, indicating a lack of recent activity.
With an average monetary value of $384.5 per user and a low frequency of 1.7 purchases, it's important to consider reactivation strategies to bring them back into active engagement.

Lost Customers:
The 404 customers in this segment have an even longer average recency of 266.5 days ago, making them highly disengaged.
Their average monetary value is low at $135.8 per user, and they have made only one purchase on average. Efforts to re-engage these customers may be challenging but could yield significant benefits.

About to Sleep and Promising:
These segments represent customers who are at risk of becoming less engaged. "About to Sleep" customers have an average recency of 88.0 days ago, while "Promising" customers have an average recency of 32.3 days ago.
Both segments have low frequencies and moderate monetary values, indicating that they require attention to prevent them from slipping into the "Hibernating" or "Lost Customers" segments.

Recent Customers:
The 76 customers in this segment have an average recency of only 9.0 days ago, indicating very recent activity. However, they have a low frequency and moderate monetary value.
This segment presents an opportunity to encourage more frequent purchases and increase their monetary contributions through targeted marketing.

In summary, the RFM analysis provides valuable insights into customer behavior and segmentation, enabling businesses to tailor their marketing and retention strategies effectively. Prioritizing efforts towards the "Best Customers" and "Cant Lose Them" segments while implementing re-engagement strategies for the "At Risk," "Hibernating," and "Lost Customers" segments can help optimize customer relationships and revenue generation.

## Reports

#### Looker Studio Report

To answer these questions an interactive Looker Studio report was prepared, which can be found [here](https://)
