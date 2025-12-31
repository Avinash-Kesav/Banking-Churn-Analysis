Customer Churn Rate Across Average Relationship Duration

What % of customers are leaving the bank after stay with the bank for average period?
SELECT 
    Count(customerid) as Total_Customers, Sum(exited) as Customers_left, ROUND(SUM(exited) / COUNT(customerid) * 100, 2) as 'Customer_drop%', AVG(TENURE)
FROM
    banking_churn;
Answer - 20.37% 


1. Business Problem

The bank wants to understand what proportion of customers leave after maintaining an average relationship duration, in order to assess overall customer loyalty and long-term retention health.

2. Interpretation & Strategic Insights

The analysis shows that 20.37% of customers exit the bank after staying for the average tenure. This means roughly 1 in 5 customers churn despite having an established relationship, indicating that churn is not limited to early-stage customers. This insight highlights the need for mid-lifecycle retention strategies, not just onboarding improvements.

3. How I Solved It (Analyst Approach)

I calculated the total number of customers, identified how many exited, and derived the churn percentage by dividing exited customers by total customers. I also computed the average tenure to ensure the churn rate reflects behavior across a typical customer lifecycle.


------------------------------------------------------------------------------------------------------------------------------------
“Which Countries Are Losing the Most Customers?”
Which country is losing the most customers?
SELECT 
    COUNT(exited) AS T, Geography AS Customers_left
FROM
    banking_churn
WHERE
    exited = 1
GROUP BY Geography
Order by T DESC;
Answer
“Germany has a significantly higher churn rate compared to France and Spain.”

Use a “Decision-Driven Insight” approach — this sounds senior and strategic.

1. Business Problem (Decision-Oriented)

The bank needs to identify which regional market is driving customer churn so leadership can make data-backed decisions on retention investments.

2. Interpretation & Strategic Insight

Germany emerges as the primary churn driver, losing more customers than France and Spain. This concentration of churn suggests localized issues such as service quality, product mismatch, or competitive pressure. Addressing churn in Germany would likely deliver the highest ROI for retention efforts.

3. How I Solved It (Analyst Mindset)

I isolated churned customers using the exit flag, aggregated churn counts by geography, and ranked countries by customer loss. This approach directly links churn data to actionable regional insights.


--------------------------------------------------------------------------------------------------------------------------------------------------------

"Ensuring equal engagement and retention opportunities for all customer segments"

Business Problem (Government Angle)

The bank seeks to promote equitable financial access and retention across genders, identifying which group needs targeted engagement programs.

Insight Statement

The data shows which gender has higher churn, signaling where intervention programs or personalized financial campaigns may be needed.

Example: If women are leaving more, a “Women’s Financial Empowerment Program” could be designed; if men, maybe a “High-Value Engagement Program for Men.”

Churn by Gender
SELECT 
    COUNT(exited) AS T, Gender, sum(isactivemember) AS Customers_left
FROM
    banking_churn
GROUP BY Gender
Order by T DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
Churn Patterns Across Product Ownership
Business-level insight:
Multi-product inactive customers = highest churn risk
These are retention campaign targets


/*Products vs Churn
SELECT 
    COUNT(CUSTOMERID) AS T, NumofProducts, SUM(exited) AS Customers_left, ROUND(SUM(exited) / COUNT(customerid) * 100, 2) as 'Customer_drop%'
FROM
    banking_churn
    GROUP BY NumofProducts
Order by T DESC;

Interview Interpretation
1 product → medium churn
2 products → lowest churn (best customers)
3–4 products → very high churn
Interview-grade interpretation:
“Customers with 2 products are the most stable. Surprisingly, customers with 3 or more products show higher churn, possibly due to complexity, dissatisfaction, or forced bundling.”
*/
1. Business Problem

The bank needs to understand how product ownership affects customer churn, so it can identify which customer segments are most stable and which are at risk despite higher product adoption.

2. Interpretation & Strategic Insights

2-product customers have the lowest churn, making them the most loyal and stable segment.

1-product customers show moderate churn, likely due to weak engagement or low switching costs.

Customers with 3–4 products show unexpectedly high churn, suggesting that:

Product complexity may be overwhelming

Bundled offerings may not meet expectations

Service friction increases as product count grows

This challenges the assumption that “more products = higher loyalty” and highlights over-bundling risk.

3. How I Solved It (Analytical Approach)

I grouped customers by number of products, counted total customers per group, calculated churn volume and churn percentage, and compared churn behavior across segments to identify risk patterns tied to product ownership.

--------------------------------------------------------------------------------------------------------------------------------------------
CHURN DRIVERS - Multi-Product & Activity Status Churn
/*Select SUM(exited) as s, NumofProducts, isactivemember, SUM(balance) as p, Count(customerid), ROUND(SUM(exited) / COUNT(customerid) * 100, 2) as 'Customer_drop%' from Banking_churn
Group by NumofProducts, isactivemember;*/

🚀 Business-Level Interpretation (Recommended)
Business Problem

The bank wants to understand how product ownership and customer activity status together influence churn, so it can identify high-risk segments and prioritize retention efforts.

Insight Statement

Inactive customers with multiple products have the highest churn risk, even when they hold significant balances. While active members show lower churn across all product levels, inactivity dramatically increases churn—especially for customers with 2 or more products. This indicates that engagement is a stronger retention driver than product count alone.

How the Query Solves the Problem

Aggregates churn (SUM(exited)) and customer counts across number of products and activity status

Calculates churn percentage to compare risk levels across segments

Includes total balance, helping identify high-value but high-risk customers

Enables side-by-side comparison of active vs inactive customers within each product group

🎯 Interview-Grade Insight (Short & Sharp)

“Churn is driven more by inactivity than product count—multi-product inactive customers represent the highest-value retention targets.”
Analyzed churn by product ownership and activity status to identify inactive multi-product customers as the highest-risk, high-value churn segment.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
High Balance, Low Credit Score Customers
High Balance - low credit score customers for Marketing Campaigns.
SELECT 
    CustomerId, 
    NumOfProducts, 
    Balance,
    CReditscore, hascrcard,
    Geography,
    RANK() OVER (PARTITION BY NumOfProducts order by balance desc) AS BalanceRank
FROM banking_churn
WHERE Exited = 0 
	AND CREDITSCORE<500 
	AND BALANCE>100000
LIMIT 10;

Business interpretation
Insight statement
“Customers who have a high account balance but a low credit score are prime candidates for targeted credit card campaigns or personalized offers. By engaging these customers, the bank can potentially improve their credit score while increasing product uptake and loyalty.”


Business Problem

The bank wants to identify low-risk, high-opportunity customers who are currently retained but underutilized from a credit perspective, in order to run targeted marketing campaigns.

Insight Statement

Customers with high account balances but low credit scores represent strong cross-sell opportunities. Despite weaker credit profiles, their high balances signal financial capacity and trust in the bank. These customers are ideal candidates for personalized credit card offers, credit-building products, or tailored financial guidance, which can improve both customer loyalty and product penetration.

How the Query Supports This Insight

Filters for active customers (Exited = 0) to focus on retention and growth

Targets low credit score (<500) customers who may benefit from credit-building products

Focuses on high-balance accounts (>100,000), indicating strong financial engagement

Uses window ranking to prioritize the highest-value customers within each product group