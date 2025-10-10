-- Daily aggregated marketing performance across platforms
-- Combines Google Ads and Meta Ads data

WITH google_ads_daily AS (
    SELECT 
        date,
        'Google Ads' as platform,
        SUM(clicks) as total_clicks,
        SUM(impressions) as total_impressions,
        SUM(cost) as total_spend,
        SUM(conversions) as total_conversions,
        ROUND(AVG(click_through_rate), 2) as avg_ctr,
        ROUND(AVG(cost_per_click), 2) as avg_cpc
    FROM {{ ref('stg_google_ads') }}
    GROUP BY date
),

meta_ads_daily AS (
    SELECT 
        date,
        'Meta Ads' as platform,
        SUM(clicks) as total_clicks,
        SUM(impressions) as total_impressions,
        SUM(spend) as total_spend,
        SUM(conversions) as total_conversions,
        ROUND(AVG(click_through_rate), 2) as avg_ctr,
        ROUND(AVG(cost_per_click), 2) as avg_cpc
    FROM {{ ref('stg_meta_ads') }}
    GROUP BY date
),

combined AS (
    SELECT * FROM google_ads_daily
    UNION ALL
    SELECT * FROM meta_ads_daily
)

SELECT 
    date,
    platform,
    total_clicks,
    total_impressions,
    total_spend,
    total_conversions,
    avg_ctr,
    avg_cpc,
    CASE 
        WHEN total_conversions > 0 
        THEN ROUND(total_spend / total_conversions, 2)
        ELSE 0 
    END as cost_per_conversion,
    CASE 
        WHEN total_clicks > 0 
        THEN ROUND(CAST(total_conversions AS FLOAT64) / total_clicks * 100, 2)
        ELSE 0 
    END as conversion_rate
FROM combined
ORDER BY date DESC, platform