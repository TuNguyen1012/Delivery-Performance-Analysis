# Delivery Performance Analysis – Olist E-commerce 

This analysis is based on Kaggle dataset with around 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. The notebook will present 2 goals of analysis to help more understand about Olist performance as below:

**Goal 1. Business Overview**

**Goal 2. We will work through delivery performance and find ways to optimize delivery times**

-------------------------------------------------------------------------------------------

## **Goal 1. Business Overview**

![image](https://user-images.githubusercontent.com/126956224/231110768-491c24c9-23d2-4a95-83f8-8b679eb41988.png)

**As we can see from the dashboard:**

•	When this dataset was created, the highest number of orders came from delivered status. Only 3% of all orders came from another status.

•	E-commerce in Brazil is increasing over time. We can see some months of sudden spikes in both Numbers of orders and Order Value like the peak in 11/2017, due to the Black Friday event.

•	Working days (Mon to Fri) are probably the most popular shopping days, and weekends especially Saturdays have the lowest number of orders. And they tend to buy more in the afternoon.

•	Almost all orders came from 10 large states in Brazil, especially Sao Paulo (SP).

•	Credit card is the most common payment method, at 74%.

•	Customer satisfaction scores for orders are high at 4 and 5 points. However, the number of orders rated with 1, or 2 points is still relatively high.


## **Goal 2. We will work through delivery performance and find ways to optimize delivery times**

![image](https://user-images.githubusercontent.com/126956224/231111238-0b38e1c2-6cd8-4e48-88fa-4e95adf351da.png)

•	Olist has a **very effective delivery performance** with only **6.77% late delivery than estimated**. However, the **average number of days to complete an order is quite long, approximately 2 weeks**.

•	Over 65% of orders were delivered over 5 days behind schedule as opposed to what was estimated.

•	Majority (35.55%) are <5 days delayed: These can often be mitigated with slight process tweaks or expedited shipping options.

•	26.51% delayed 10–30 days: Focus on these as they likely impact customer satisfaction the most.

•	Critical Delays (>30 days): Rare (3.99%) but require investigation of root causes like inventory shortages, lost packages, or customs clearance.

•	In the review score, there is a big difference between timely delivery and late delivery. **Over-time delivery orders have an average score of just 2.3, while on-time delivery orders have an average score of 4.3**. Therefore, over-time delivery may affect customer satisfaction.

•	It can be seen that the Top 20 sellers delay more than 30 times when preparing orders, especially 1 seller has 189 overdue deliveries to the carrier. When sellers fail to prepare goods repeatedly, warnings or sanctions should be implemented.

•	Generally, states with a large volume of orders have faster delivery times, which is similar to the average delivery time from shipper to customer. **Sao Paulo has the fastest delivery times along with the largest volume of orders, which is a well-developed market for the company.**


## Optimization Recommendations:

**Addressing State-Specific Delays:**

•	Focus on improving logistics and carrier partnerships in states like RR, AM, and AP. This may involve using regional warehouses or faster shipping options.

**Improving Seller Performance:**

•	 Collaborate with underperforming sellers. Offer training or tools for better order preparation and dispatch processes.

•	 There should be warnings and penalties for sellers who repeatedly delay orders to the carrier. These sellers may be restricted from displaying on the website or fined for violations

**Optimizing Processes for Delayed Categories:**

•	 Prioritize orders that tend to fall into the 5–30 day delay range by reviewing internal workflows, carrier handovers, or resource allocation.

**Enhancing On-Time Rates:**

•	 Analyze reasons for the 6.77& of late deliveries and implement strategies like predictive analytics for demand and route optimization.
Customer Satisfaction:

•	 Leverage the 4.3 review score for on-time deliveries as a benchmark. Work on improving the 2.3 score for late deliveries by providing better communication or compensation.

**Tech Integration:**

•	 Introduce AI-powered logistics software to forecast demand, optimize inventory placement, and automate task scheduling.
