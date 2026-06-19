#-------------------------------------------------------------------------------
# INSTALLING PACKAGES 
#-------------------------------------------------------------------------------

install.packages("tidyverse")
install.packages("sf")
install.packages("mgcv")
install.packages("qgam")
install.packages("quantreg")
install.packages("ggmap")
install.packages("raster")
install.packages("fixest")
install.packages("broom")
install.packages("modelsummary")
install.packages("dreamerr")
install.packages("ggcorrplot")
install.packages("ggspatial")
install.packages("viridis")
install.packages("promises")
install.packages("qgam", dependencies = TRUE)
install.packages("shiny")
install.packages("promises", type = "source")
install.packages("readxl")
install.packages("stringr")
install.packages("dplyr")

#-------------------------------------------------------------------------------
# LOADING PACKAGES 
#-------------------------------------------------------------------------------

library(readxl)
library(stringr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggcorrplot)
library(ggspatial)
library(viridis)
library(rosm)
library(ggspatial)
library(prettymapr)
library(sf)
library(ggmap)
library(raster)
library(broom)
library(Hmisc) 

library(mgcv)       # For Generalized Geo-Additive Models
library(qgam)       # For Quantile Generalized Additive Models
library(quantreg)   # For standard quantile regression

#-------------------------------------------------------------------------------
# LOADING DATASETS
#-------------------------------------------------------------------------------

# Load the 2023 Dataset
seattle_2023 <- read_excel("2023_Seattle.xlsx")

# Load the 2025 Dataset
seattle_2025 <- read.csv("2025_Seattle.csv")

View(seattle_2023)
View(seattle_2025)

#-------------------------------------------------------------------------------
# DATA CLEARING - REMOVING COLUMNS 
#-------------------------------------------------------------------------------

cols_to_remove <- c(
  "listing_url", "id", "scrape_id", "last_scraped", "summary", "space", 
  "description", "experiences_offered", "neighborhood_overview", 
  "notes", "transit", "thumbnail_url", "medium_url", "picture_url", 
  "xl_picture_url", "host_url", "host_about", "host_thumbnail_url", 
  "host_picture_url", "host_listings_count", "neighbourhood", 
  "host_verifications", "country", "country_code", "weekly_price", 
  "monthly_price", "calendar_updated", "has_availability", 
  "availability_30", "availability_60", "availability_90", 
  "calendar_last_scraped", "number_of_reviews", "first_review", 
  "last_review", "jurisdiction_names", "require_guest_profile_picture", 
  "require_guest_phone_verification", "reviews_per_month","host_response_time", "host_acceptance_rate"
)

seattle_2023 <- seattle_2023[, !(names(seattle_2023) %in% cols_to_remove)]
seattle_2025 <- seattle_2025[, !(names(seattle_2025) %in% cols_to_remove)]

write.csv(seattle_2023, "seattle_2023.csv", row.names = FALSE)
write.csv(seattle_2025, "seattle_2025.csv", row.names = FALSE)

View(seattle_2023)
View(seattle_2025)

#-------------------------------------------------------------------------------
# DATA CLEARING - No.of Bathrooms chr column to split into two Columns as Numbers & Types 
#-------------------------------------------------------------------------------

seattle_2023 <- seattle_2023 %>%
  mutate(
    bathrooms = as.numeric(str_extract(bathrooms_text, "\\d+")),
    
    bath_type = case_when(
      is.na(bathrooms_text) ~ NA_character_,
      str_detect(bathrooms_text, "shared") ~ "bath shared",
      str_detect(bathrooms_text, "private") ~ "bath private",
      TRUE ~ "bath"
    )
  )

seattle_2025 <- seattle_2025 %>%
  mutate(
    bathrooms = as.numeric(str_extract(bathrooms_text, "\\d+")),
    bath_type = case_when(
      is.na(bathrooms_text) ~ NA_character_,
      str_detect(bathrooms_text, "shared") ~ "bath shared",
      str_detect(bathrooms_text, "private") ~ "bath private",
      TRUE ~ "bath"
    )
  )

#-------------------------------------------------------------------------------
# EXPLORING THE DATA SET - NUMBER OF PROPERTIES 
#-------------------------------------------------------------------------------

property_counts_2023 <- seattle_2023 %>%
  group_by(property_type) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(property_counts_2023, aes(x = reorder(property_type, -count), y = count)) +
  geom_bar(stat = "identity", fill = "firebrick") +
  # Add the numbers on top of the bars
  geom_text(aes(label = count), vjust = -0.5, size = 3.5) + 
  # Labels and Formatting
  labs(
    title = "Property Types listed on Airbnb in Seattle 2023",
    x = "Property Type",
    y = "Number of Listings"
  ) +
  theme_minimal() +
  # Use element_text instead of text
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

property_counts_2025 <- seattle_2025 %>%
  group_by(property_type) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(property_counts_2025, aes(x = reorder(property_type, -count), y = count)) +
  geom_bar(stat = "identity", fill = "firebrick") +
  # Add the numbers on top of the bars
  geom_text(aes(label = count), vjust = -0.5, size = 3.5) + 
  # Labels and Formatting
  labs(
    title = "Property Types listed on Airbnb in Seattle 2025",
    x = "Property Type",
    y = "Number of Listings"
  ) +
  theme_minimal() +
  # Use element_text instead of text
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
nrow(seattle_2025)

#-------------------------------------------------------------------------------
# EXPLORING THE DATA SET - Data Cleaning - Reducing the number of listed Property Types 
#-------------------------------------------------------------------------------

#----------------------------2023-----------------------------------------------

seattle_2023 <- seattle_2023 %>%
  filter(property_type %in% c("Entire rental unit", "Entire home",
                              "Private room in home","Entire townhouse","Entire guest suite",
                              "Entire condo","Private room in rental unit"))

property_counts <- seattle_2023 %>%
  group_by(property_type) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(property_counts, aes(x = reorder(property_type, -count), y = count)) +
  geom_bar(stat = "identity", fill = "firebrick") +
  # Add the numbers on top of the bars
  geom_text(aes(label = count), vjust = -0.5, size = 3.5) + 
  # Labels and Formatting
  labs(
    title = "Property Types listed on Airbnb in Seattle 2023",
    x = "Property Type",
    y = "Number of Listings"
  ) +
  theme_minimal() +
  # Use element_text instead of text
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

seattle_2023 <- seattle_2023 %>%
  filter(property_type %in% c("Entire rental unit", "Entire home",
                              "Private room in home","Entire townhouse","Entire guest suite",
                              "Entire condo","Private room in rental unit"))

#----------------------------2025-----------------------------------------------

seattle_2025 <- seattle_2025 %>%
  filter(property_type %in% c("Entire rental unit", "Entire home",
                              "Private room in home","Entire townhouse","Entire guest suite",
                              "Entire condo","Private room in rental unit"))


property_counts <- seattle_2025 %>%
  group_by(property_type) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(property_counts, aes(x = reorder(property_type, -count), y = count)) +
  geom_bar(stat = "identity", fill = "firebrick") +
  # Add the numbers on top of the bars
  geom_text(aes(label = count), vjust = -0.5, size = 3.5) + 
  # Labels and Formatting
  labs(
    title = "Property Types listed on Airbnb in Seattle 2025",
    x = "Property Type",
    y = "Number of Listings"
  ) +
  theme_minimal() +
  # Use element_text instead of text
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#-------------------------------------------------------------------------------
# EXPLORING THE DATA SET - Datasets after Data Cleaning 
#-------------------------------------------------------------------------------

nrow(seattle_2023)
nrow(seattle_2025)

#------------------------- END OF DATA CLEANING --------------------------------

#-------------------------------------------------------------------------------
# NORMALITY CHECK - PRICE DISTRIBUTION 
#-------------------------------------------------------------------------------

str(seattle_2023$price)
str(seattle_2025$price)

clean_data <- function(df) {
  df %>%
    mutate(
      price = as.numeric(gsub("[$,]", "", price)),
      # Log-transform target variable for hedonic modeling 
      log_price = log(price)
    ) %>%
    # Remove rows where price is 0 or NA
    filter(price > 0, !is.na(price))
}

seattle_2023 <- clean_data(seattle_2023)
seattle_2025 <- clean_data(seattle_2025)

# Normality Check 2023----------------------------------------------------------

ggplot(seattle_2023, aes(x = price)) +
  # Using binwidth = 25 means each bar represents a $25 range
  geom_histogram(fill = "firebrick", color = "white", binwidth = 25) +
  # Focus on the 0 to 1000 range to keep the "long tail" from squishing the main data
  coord_cartesian(xlim = c(0, 1200)) +
  labs(
    title = "Distribution of Price per Night",
    subtitle = "Listed Properties on Airbnb 2023",
    x = "Price ($)",
    y = "Number of Listings (Count)"
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 1200, 100))

# Normality Check 2025----------------------------------------------------------

ggplot(seattle_2025, aes(x = price)) +
  # Using binwidth = 25 means each bar represents a $25 range
  geom_histogram(fill = "firebrick", color = "white", binwidth = 25) +
  # Focus on the 0 to 1000 range to keep the "long tail" from squishing the main data
  coord_cartesian(xlim = c(0, 1200)) +
  labs(
    title = "Distribution of Price per Night",
    subtitle = "Listed Properties on Airbnb 2025",
    x = "Price ($)",
    y = "Number of Listings (Count)"
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 1200, 100))

#-------------------------------------------------------------------------------
# MEAN PRICE 2023 VS. 2025 
#-------------------------------------------------------------------------------

seattle_2023$price <- as.numeric(seattle_2023$price)
seattle_2025$price <- as.numeric(seattle_2025$price)

seattle_2023$year <- "2023"
seattle_2025$year <- "2025"

combined <- rbind(
  seattle_2023[, c("price", "year")],
  seattle_2025[, c("price", "year")]
)

aggregate(price ~ year, data = combined, mean, na.rm = TRUE)

boxplot(price ~ year,
        data = combined,
        col = c("firebrick", "indianred"),
        main = "Mean Price Comparison: 2023 vs 2025",
        ylab = "Price ($)",
        xlab = "Year")

#---------------Removing the outliers-------------------------------------------

seattle_2023 <- seattle_2023 %>%
  filter(price <= 2000 | is.na(price))

seattle_2025 <- seattle_2025 %>%
  filter(price <= 2000 | is.na(price))

#-------------Re-plotting-------------------------------------------------------

seattle_2023$price <- as.numeric(seattle_2023$price)
seattle_2025$price <- as.numeric(seattle_2025$price)

seattle_2023$year <- "2023"
seattle_2025$year <- "2025"

combined <- rbind(
  seattle_2023[, c("price", "year")],
  seattle_2025[, c("price", "year")]
)

aggregate(price ~ year, data = combined, mean, na.rm = TRUE)

boxplot(price ~ year,
        data = combined,
        col = c("firebrick", "indianred"),
        main = "Mean Price Comparison: 2023 vs 2025",
        ylab = "Price ($)",
        xlab = "Year")

# -----------------Variation of Mean Explanation--------------------------------

names(seattle_2023)
names(seattle_2025)

dplyr::select(seattle_2023, price, year, property_type)

combined <- rbind(
  dplyr::select(seattle_2023, price, year, property_type),
  dplyr::select(seattle_2025, price, year, property_type)
)

combined %>%
  group_by(year, property_type) %>%
  summarise(mean_price = mean(price, na.rm = TRUE), .groups = "drop")

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# SUB RESEARCH QUESTION 1 ------------------------------------------------------

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ADJUSTING THE PRICE 
#-------------------------------------------------------------------------------

clean_data <- function(df) {
  df %>%
    mutate(
      price = as.numeric(gsub("[$,]", "", price)),
      # Log-transform target variable for hedonic modeling 
      log_price = log(price)
    ) %>%
    # Remove rows where price is 0 or NA
    filter(price > 0, !is.na(price))
}

seattle_2023 <- clean_data(seattle_2023)
seattle_2025 <- clean_data(seattle_2025)

#-------------------------------------------------------------------------------
# AMENITIES TO AMENITIES COUNT 
#-------------------------------------------------------------------------------

# Count amenities by splitting the string
seattle_2023 <- seattle_2023 %>%
  mutate(amenities_count = str_count(amenities, ",") + 1)

seattle_2025 <- seattle_2025 %>%
  mutate(amenities_count = str_count(amenities, ",") + 1)

#-------------------------------------------------------------------------------
# CONVERTING CATEGORICAL VALUES 
#-------------------------------------------------------------------------------

# Convert categorical variables to factors
categorical_cols <- c("room_type", "neighbourhood_group_cleansed")

seattle_2023[categorical_cols] <- lapply(seattle_2023[categorical_cols], as.factor)
seattle_2025[categorical_cols] <- lapply(seattle_2025[categorical_cols], as.factor)

#-------------------------------------------------------------------------------
# REMOVING NAs
#-------------------------------------------------------------------------------

# Filter to keep only the variables for your model
final_vars <- c("log_price", "accommodates", "room_type", "beds", 
                "bedrooms", "bathrooms", "neighbourhood_group_cleansed", 
                "amenities_count", "latitude", "longitude")

seattle_2023 <- seattle_2023 %>% 
  dplyr::select(all_of(final_vars)) %>%
  drop_na()

seattle_2025 <- seattle_2025 %>% 
  dplyr::select(all_of(final_vars)) %>%
  drop_na()

#-------------------------------------------------------------------------------
# Correlation Analysis and Exploratory Spatial Visualization
#-------------------------------------------------------------------------------

#Numerical Correlation Analysis

# Numerical Correlation Analysis
numerical_vars <- seattle_2023 %>%
  dplyr::select(log_price, accommodates, beds, bedrooms, bathrooms, amenities_count)

# Compute correlation matrix
cor_matrix <- cor(numerical_vars, use = "complete.obs")

# Visualize the correlation matrix
library(corrplot)
corrplot(cor_matrix, method = "color", addCoef.col = "black", type = "upper")

#-----------------------Multi-collinearity Check (VIF)- 2023---------------------------

# Fit a simple OLS model to check Variance Inflation Factor (VIF)
library(car)
vif_model <- lm(log_price ~ accommodates + room_type + beds + bedrooms + 
                  bathrooms + amenities_count + neighbourhood_group_cleansed, 
                data = seattle_2023)

# Check VIF (Values > 5 or 10 may indicate problematic collinearity)
vif(vif_model)

#--------------------Adjusting according to VIF Results-----------------------------

seattle_2023 <- seattle_2023 %>%
  dplyr::select(log_price, accommodates, room_type,bedrooms,
                bathrooms, neighbourhood_group_cleansed,
                amenities_count, latitude, longitude) %>%
  drop_na()

#-----------------Exploratory Spatial Visualization----------------------------------

# Convert the cleaned dataframe to a spatial (sf) object
seattle_sf <- st_as_sf(seattle_2023, coords = c("longitude", "latitude"), crs = 4326)

# Create a spatial plot of log_prices
ggplot(data = seattle_sf) +
  annotation_map_tile(type = "osm", zoom = 12) + 
  geom_sf(aes(color = log_price), alpha = 0.6, size = 1) +
  scale_color_viridis_c(option = "plasma") +
  theme_minimal() +
  labs(title = "Spatial Distribution of Airbnb Log-Prices in Seattle (2023)",
       color = "Log(Price)")

#-------------------------Correlation 2025----------------------------------------

#Numerical Correlation Analysis

# Numerical Correlation Analysis
numerical_vars <- seattle_2025 %>%
  dplyr::select(log_price, accommodates, bedrooms, bathrooms, amenities_count)

# Compute correlation matrix
cor_matrix <- cor(numerical_vars, use = "complete.obs")

# Visualize the correlation matrix
library(corrplot)
corrplot(cor_matrix, method = "color", addCoef.col = "black", type = "upper")

#---------------------Spatial Map 2025-------------------------------------------

# Convert the cleaned dataframe to a spatial (sf) object
seattle_sf <- st_as_sf(seattle_2025, coords = c("longitude", "latitude"), crs = 4326)

# Create a spatial plot of log_prices
ggplot(data = seattle_sf) +
  annotation_map_tile(type = "osm", zoom = 12) + 
  geom_sf(aes(color = log_price), alpha = 0.6, size = 1) +
  scale_color_viridis_c(option = "plasma") +
  theme_minimal() +
  labs(title = "Spatial Distribution of Airbnb Log-Prices in Seattle (2025)",
       color = "Log(Price)")

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# SUB RESEARCH QUESTION 2 ------------------------------------------------------

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

#-------------------------Constructing Model in R-------------------------------

# Define the quantiles of interest (10th, 50th, and 90th percentiles)
quants <- c(0.1, 0.5, 0.9)

# Model 1: Linear Spatial Quantile Regression ----------------------------------
model_linear <- mqgam(log_price ~ accommodates + room_type + 
                        bathrooms + amenities_count + 
                        neighbourhood_group_cleansed, 
                      qu = quants, data = seattle_2023)

# View coefficients for the median (0.50)
summary(model_linear[[2]])

summary(model_linear[[2]][["0.1"]])  # 10th percentile
summary(model_linear[[2]][["0.5"]])  # 50th percentile
summary(model_linear[[2]][["0.9"]])  # 90th percentile

# Model 2: Generalised Geo-Additive Quantile Model------------------------------

# Fitting the geo-additive model
# s(..., bs="ps") defines a P-spline for non-linear effects
# s(latitude, longitude) defines the spatial random effect
model_geo <- mqgam(log_price ~ accommodates + room_type +
                     bedrooms + bathrooms + s(amenities_count, bs="ps") + 
                     neighbourhood_group_cleansed + 
                     s(latitude, longitude, bs="tp"), # Thin-plate spline for spatial effect
                   qu = quants, data = seattle_2023)

# Summary of the geo-additive median model
summary(model_geo[[2]])

models_geo <- model_geo[[2]]

summary(models_geo[["0.1"]])
summary(models_geo[["0.5"]])
summary(models_geo[["0.9"]])

#-------------------------------------------------------------------------------
# ANOVA TESTING FOR MODELS 
#-------------------------------------------------------------------------------

# Compare the two models for the median quantile
# This tests if the non-linear terms (s()) and spatial smoothers are significant

models_linear <- model_linear[[2]]
models_geo    <- model_geo[[2]]

# Compare at each quantile
anova(models_linear[["0.5"]], models_geo[["0.5"]], test = "Chisq")

# Example: Inspecting if 'accommodates' impact changes
summary(model_geo[[1]]) # Results for tau = 0.1
summary(model_geo[[3]]) # Results for tau = 0.9

#-------------------------------------------------------------------------------
# Predictive Equation and Validation
#-------------------------------------------------------------------------------

# Extract linear coefficients for the median model (tau = 0.5)
coef_table <- data.frame(
  Q0.5 = coef(models_geo[["0.5"]])
)

print(coef_table)

# Validating on the 2025 Dataset------------------------------------------------

# Predict using median model (Q0.5) for both
preds_2025_geo <- predict(models_geo[["0.5"]], newdata = seattle_2025)
preds_2025_lin <- predict(models_linear[["0.5"]], newdata = seattle_2025)

# Add predictions back to the 2025 dataframe
seattle_2025 <- seattle_2025 %>%
  mutate(pred_log_price_geo = preds_2025_geo,
         pred_log_price_lin = preds_2025_lin)

# Calculate Mean Absolute Error (MAE) for both models
mae_geo <- mean(abs(seattle_2025$log_price - seattle_2025$pred_log_price_geo))
mae_lin <- mean(abs(seattle_2025$log_price - seattle_2025$pred_log_price_lin))

cat("Geo-Additive Model MAE:", mae_geo, "\n")
cat("Linear Model MAE:", mae_lin, "\n")

ggplot(seattle_2025, aes(x = log_price)) +
  geom_point(aes(y = pred_log_price_geo, color = "Geo-Additive"), alpha = 0.3) +
  geom_point(aes(y = pred_log_price_lin, color = "Linear"), alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(title = "Actual vs Predicted Log-Price (2025)",
       x = "Actual Log-Price", y = "Predicted Log-Price",
       color = "Model") +
  theme_minimal()

