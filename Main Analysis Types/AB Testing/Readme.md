# A/B Testing

## Task Requirements

- Prepare an SQL query to pull all necessary data and estimate if different variants of marketing campaigns (V1 vs. V2) for both “NewYear” and “BlackFriday” had significantly better clickthrough rates (CTR), defined as the number of users who clicked on the campaign divided by the number of impressions.
- Ignore the timing of user tracking data for now; do not check if those sessions were recorded when the marketing campaign was running.
- Run the A/B testing on the results from your query.
- Use a Binomial A/B test Calculator.
- Add visualizations to help illustrate A/B testing results.

# Campaign Performance

| Campaign       | Impressions | Unique Users | CTR  |
| -------------- | ----------- | ------------ | ---- |
| BlackFriday_V1 | 8220        | 8            | 0.1  |
| BlackFriday_V2 | 24276       | 24           | 0.1  |
| NewYear_V1     | 4430        | 57           | 1.29 |
| NewYear_V2     | 13039       | 30           | 0.23 |

## Results & Conclusions 

### Black Friday Campaign

Here, I analyzed two Black Friday campaigns (V1 and V2) conducted in November 2020 to evaluate the following hypotheses:

- **H0 (Null Hypothesis)**: There is no statistically significant difference between Black Friday V1 and Black Friday V2 campaigns.
- **Ha (Alternative Hypothesis)**: There is a statistically significant difference between Black Friday V1 and Black Friday V2 campaigns.

![Black_Friday_Campaign](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/AB%20Testing/ab-tests-black-friday.png)

The analysis shows no statistically significant difference between Black Friday Campaign V1 and Black Friday V2 at either the 95% or 99% confidence levels. With a p-value of 0.5154 and a Z-score of 0.04, our p-value exceeds the chosen confidence level (alpha = 0.05 or alpha = 0.01). Consequently, we fail to reject the null hypothesis, indicating no significant difference between the two groups.

### New Year Campaign

Here, I examined two New Year campaigns (V1 and V2) conducted in January 2021 to assess the following hypotheses:

- **H0 (Null Hypothesis)**: There is no statistical significance between NewYear_V1 and NewYear_V2 campaigns.
- **Ha (Alternative Hypothesis)**: There is statistical significance between NewYear_V1 and NewYear_V2 campaigns.

![New_Year_Campaign](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/AB%20Testing/ab-tests-new-year.png)

The results show a notable difference between the two groups at a 95% confidence level (alpha = 0.05). With a P-value of 1 and an observed uplift of approximately -80 percent between the groups, we reject the null hypothesis, supporting the alternative hypothesis that there is a significant difference between the groups.

### Additional Information: Campaign Performance Data Overview

We have campaign data for two A/B test series: NewYear_V1 and NewYear_V2, BlackFriday_V1 and BlackFriday_V2. For each campaign, we have information about total impressions, unique users who interacted with the campaign (estimated based on distinct user pseudo-IDs), and the estimated clickthrough rate (CTR). The analysis focused on the NewYear campaigns because the COV% of the BlackFriday campaigns was very similar, indicating that the variant does not impact the conversion rate.

- **Null Hypothesis (H0)**: There is no significant variant impact on COV% (CTR).
- **Alternative Hypothesis (H1)**: There is a significant variant impact on COV% (CTR).

**Statistical Test Results:**
- **P-value**: Since the P-value is 0 (<0.05), it indicates very strong evidence against the null hypothesis.
- **Z-score**: A Z-score of 6.06 indicates that the data point is more than 6 standard deviations above the mean.

This result shows strong evidence against the null hypothesis, leading us to reject it in favor of the alternative hypothesis. The variant has more than a 99% probability of having a better COV (1.29%) compared to the control (0.23%).

### Recommendations

Consider further analyzing and understanding what made NewYear_V1 highly successful in terms of user engagement and apply those insights to other campaigns. For NewYear_V2, there might be room for improvement in user engagement strategies to match the success of NewYear_V1. These insights provide a comprehensive understanding of how different campaign variants performed in terms of user engagement, based on the unique users who interacted with the campaigns.
