Spatial & Statistical Analysis of Seattle Airbnb Prices📌

**Project Overview**
This project explores the short-term rental market in Seattle by analyzing Airbnb listings from 2023 and 2025. The primary goal is to examine the distributional heterogeneity and temporal stability of price determinants in the post-pandemic market. By comparing traditional linear spatial models with advanced geo-additive models, this study identifies the most robust predictors of Airbnb pricing.  

📊 Visualizations & Results
   
  **Spatial Distribution of Prices**
The analysis reveals clear spatial clustering, with high-price listings heavily concentrated in central, desirable neighborhoods (e.g., Downtown, Capitol Hill).  

2023
![image alt](https://github.com/inodeefernando/AirBnb_Seattle/blob/6c0890acfe41e9dd77675dde4dd425aec01aa8f5/Outputs/Spatial_Distribution_2023.jpg)

2025
![image alt](https://github.com/inodeefernando/AirBnb_Seattle/blob/78bf3085721eeb1bd8a35f45b06d7c9886fcd4d0/Outputs/Spatial_Distribution_2025.jpg) 

**Findings**

Model A - Predicting 2025 values with actual 2025 values, using Linear Spatial Quantile Regression 

![image alt](https://github.com/inodeefernando/AirBnb_Seattle/blob/f3530a00a4efbcd1ac1fc8ca0da955c14967cbee/Outputs/Quantile%20Regression.JPG) 

Moderl B - Predicting 2025 values with actual 2025 values, using Generalised Geo-Additive Model

![image alt](https://github.com/inodeefernando/AirBnb_Seattle/blob/4958ccdccee75600e03aaf2c9170d83d147a1f28/Outputs/Quantile%20Regression_ModelA.JPG) 

Actual vs. Predicted PricesThe Generalised Geo-Additive Model successfully captures non-linear geographic price variations that simple neighborhood boundaries miss.  

![image alt](https://github.com/inodeefernando/AirBnb_Seattle/blob/2ff3fcfe4afccaa7714b1777c13b5a174bb2e275/Predicted_Actual.jpg)

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
