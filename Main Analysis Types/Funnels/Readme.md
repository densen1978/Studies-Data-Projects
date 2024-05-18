# Funnels

## Task Description

1. Analyze the data in the `raw_events` table. Spend time querying the table to become familiar with the data. Identify events captured by users visiting the website.
2. Create a sales funnel chart from the events in your unique events table. Not all events are relevant or productive for this chart. Identify and collect data that could be used.

* Use between 4 to 6 types of events in this analysis.
* Create a funnel chart with a country split. The business is interested in the differences between the top 3 countries in the funnel chart.
* Top countries are decided by their overall number of events.
* Provide insights if any are found.
* Explore other ideas or slices for funnel analysis that could be worth investigating.

## Results & Conclusions

The `funnels.sql` code was utilized to extract data for further analysis. Funnels were generated for the top three countries based on customer count. The top three countries exhibit significant differences primarily in the number of engaged customers. However, the percentages of customer drop-off throughout the events remain relatively consistent despite the variations in countries.

![Funnels Charts](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Funnels/Funnels%20Charts.png)

## Conclusions

- The majority of customers are from the United States.
- Only a small fraction of users delve deeper and search for specific items on our website.
- A minority of users proceed to add items to the cart after viewing items, suggesting our product may not meet all customer requirements to progress further.
- A significant number of visitors leave our website after viewing the page without exploring further, implying users may struggle to find the items they are looking for. Further analysis is needed to enhance the first page to retain customers.
- Fewer users proceed to add products to the cart and complete the purchase after viewing items. This may indicate high prices or the product not meeting all requirements. Further analysis is necessary to understand what information users seek on the site to retain more customers interested in purchasing our products.

### Additional Insights

#### Data Preparation
For the funnel, five service/product purchasing steps were selected:
1. `view_search_results` - users actively searching for products.
2. `add_to_cart` - users showing interest in products by adding them to their cart.
3. `begin_checkout` - users initiating the checkout process.
4. `add_payment_info` - users providing payment information during checkout.
5. `purchase` - successful conversions where users complete a purchase.

#### Data Analysis and Visualization
Five event types were selected for funnel analysis to reflect the user journey from the top to the bottom of the funnel. The event counts generally follow a pattern from higher counts for `view_search_results` to lower counts for `purchase`, which is typical. Funnel charts were used to visualize event counts across countries and event types.

#### Trends and Patterns
- **View Search Results to Add to Cart:** The United States has the highest counts for all event types, suggesting it has the largest user base or the most active users among the three countries. This step in the funnel has the lowest drop-off rate for all three countries, indicating strong user intent after searching for products. The lowest drop-off rate is in Canada (8%) compared to the USA (13%) and India (12%).
- **Add to Cart to Begin Checkout:** The drop-off rate from adding to the cart to beginning checkout is relatively low, suggesting a high level of interest from users who added items to their cart.
- **Begin Checkout to Add Payment Info:** This step shows a significant drop-off, indicating users in all three countries may hesitate or abandon the process when asked for payment details.
- **Add Payment Info to Purchase:** The drop-off rate from entering payment information to completing a purchase is relatively moderate for all three countries.

#### Insights and Recommendations
In summary:
- All three countries show a common trend of higher drop-off rates at the payment information stage, suggesting this is a critical point where users often hesitate or abandon the process.
- Canada stands out for having a higher conversion rate from viewing search results to adding to the cart, indicating strong initial user engagement.

Further analysis is needed to understand user behavior at critical stages and to identify potential improvements in the purchasing process.
