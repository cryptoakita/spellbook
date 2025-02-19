{{ config(
	tags=['legacy'],
	
        alias = alias('trades', legacy_model=True),
        post_hook='{{ expose_spells(\'["polygon","arbitrum"]\',
                                "project",
                                "tigris",
                                \'["Henrystats"]\') }}'
        )
}}

{% set models = [
'tigris_polygon_trades'
,'tigris_arbitrum_trades'
] %}


SELECT *
FROM (
    {% for model in models %}
    SELECT
        blockchain,
        day,
        evt_block_time,
        evt_index,
        evt_tx_hash,
        position_id,
        price,
        new_margin,
        leverage,       
        volume_usd,
        margin_asset,
        pair,
        direction,
        referral,
        trader,
        margin_change,
        trade_type,
        version
    FROM {{ ref(model) }}
    {% if not loop.last %}
    UNION ALL
    {% endif %}
    {% endfor %}
)
;