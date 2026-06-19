##Spatial & Statistical Analysis of Seattle Airbnb Prices📌

**Project Overview**
This project explores the short-term rental market in Seattle by analyzing Airbnb listings from 2023 and 2025. The primary goal is to examine the distributional heterogeneity and temporal stability of price determinants in the post-pandemic market. By comparing traditional linear spatial models with advanced geo-additive models, this study identifies the most robust predictors of Airbnb pricing.  

📊 Visualizations & Results
   
  **Spatial Distribution of Prices**
The analysis reveals clear spatial clustering, with high-price listings heavily concentrated in central, desirable neighborhoods (e.g., Downtown, Capitol Hill).  

Actual vs. Predicted PricesThe Generalised Geo-Additive Model successfully captures non-linear geographic price variations that simple neighborhood boundaries miss.  

📸 Upload your scatter plots here:Property Types BreakdownEntire homes and rental units make up the vast majority of listings across both cohorts.  

📸 Upload your bar charts here:

🗄️ Data SourcesThe analysis utilizes two distinct datasets to test the temporal stability of price determinants:  
* 2023 Cohort: 5,710 cleaned listings (Scraped June 25, 2023).
* 2025 Cohort: 5,828 cleaned listings (Scraped March 17, 2025).

🔬 MethodologyTo address spatial dependence and non-linear relationships, two distinct regression models were constructed using R:  

* Model A (Baseline): Linear Spatial Quantile Regression. This model handles location using fixed categorical boundaries (neighborhood dummy variables).  

* Model B (Primary): Generalised Geo-Additive Model (GAM). This approach employs a topographical tensor product smooth (latitude and longitude) and P-splines to capture continuous spatial dependence and non-linear covariate effects.  

💡 Key FindingsModel Superiority: 

The Geo-Additive Model (Model B) significantly outperformed the Linear Model across all price quantiles, proving that Airbnb prices follow a smooth, continuous geographical pattern rather than rigid neighborhood borders.  

Primary Price Drivers: Physical capacity (accommodates, bedrooms, bathrooms) remains the dominant structural determinant of price at all quantile levels.  

Temporal Stability vs. Seasonality: The structural drivers of price remained highly stable between 2023 and 2025. 

The overall drop in mean prices in 2025 was heavily attributed to the sharp seasonality of the Seattle market (comparing peak summer June 2023 data to off-peak March 2025 data).  

_💻 Technologies UsedLanguage: R   Key Packages: qgam (Model A baseline), mgcv (Model B) _  
