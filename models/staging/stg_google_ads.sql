-- Staging model for Google Ads data
-- Adds calculated metrics like CPC and CTR

SELECT 
    id,
    campaign_name,
    ad_group,
    clicks,
    impressions,
    cost,
    conversions,
    date,
    
    -- Calculated metrics
    CASE 
        WHEN clicks > 0 THEN ROUND((cost / clicks)::numeric, 2)
        ELSE 0 
    END as cost_per_click,
    
    CASE 
        WHEN impressions > 0 THEN ROUND((clicks::numeric / impressions * 100)::numeric, 2)
        ELSE 0 
    END as click_through_rate,
    
    CASE 
        WHEN conversions > 0 THEN ROUND((cost / conversions)::numeric, 2)
        ELSE 0 
    END as cost_per_conversion,
    
    created_at
    
FROM {{ source('public', 'google_ads_raw') }}