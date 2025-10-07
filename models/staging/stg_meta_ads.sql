-- Staging model for Meta Ads data
-- Adds calculated metrics

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
        WHEN clicks > 0 THEN ROUND((spend / clicks)::numeric, 2)
        ELSE 0 
    END as cost_per_click,
    
    CASE 
        WHEN impressions > 0 THEN ROUND((clicks::numeric / impressions * 100)::numeric, 2)
        ELSE 0 
    END as click_through_rate,
    
    CASE 
        WHEN conversions > 0 THEN ROUND((spend / conversions)::numeric, 2)
        ELSE 0 
    END as cost_per_conversion
    
FROM {{ source('public', 'meta_ads_raw') }}