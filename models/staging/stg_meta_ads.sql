-- Staging model for Meta Ads data
-- Adds calculated metrics like CPC and CTR
SELECT 
    id,
    campaign_name,
    ad_set_name,
    spend,
    impressions,
    clicks,
    conversions,
    date,
    
    -- Calculated metrics
    CASE 
        WHEN clicks > 0 THEN ROUND(spend / clicks, 2)
        ELSE 0 
    END as cost_per_click,
    
    CASE 
        WHEN impressions > 0 THEN ROUND(CAST(clicks AS FLOAT64) / impressions * 100, 2)
        ELSE 0 
    END as click_through_rate,
    
    CASE 
        WHEN conversions > 0 THEN ROUND(spend / conversions, 2)
        ELSE 0 
    END as cost_per_conversion
    
FROM {{ source('raw_data', 'meta_ads_raw') }}