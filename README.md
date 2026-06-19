# AirBnb_Seattle
Project Overview: Spatial & Statistical Analysis of Seattle Airbnb Prices

This repository contains an R-based statistical analysis of the Seattle Airbnb market, examining the structural and spatial determinants of short-term rental prices in a post-pandemic context. Using comprehensive listing data from 2023 and 2025, the project investigates the distributional heterogeneity and temporal stability of price drivers across different market quantiles.  

The analysis constructs and evaluates two primary predictive models:

Model A (Baseline): A Linear Spatial Quantile Regression that accounts for price heterogeneity using fixed categorical neighborhood boundaries.  

Model B (Primary): A Generalised Geo-Additive Model (GAM) that utilizes spatial smoothers (latitude/longitude) and P-splines to capture non-linear, continuous spatial dependencies.  

Key Findings:

Model Superiority: The Geo-Additive Model significantly outperforms the baseline linear approach, demonstrating that Airbnb pricing follows complex, continuous geographic gradients rather than rigid neighborhood borders.  

Price Determinants: Physical capacity metrics—such as the number of guests accommodated, bedrooms, and bathrooms—dominate as the primary price drivers across all market tiers.  

Temporal Stability: Predictive pricing equations from 2023 successfully generalize to the 2025 data, indicating stable structural market determinants. 

Overall price drops between the two years were heavily attributed to Seattle's sharp seasonal demand cycles rather than structural market shifts. 
