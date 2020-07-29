On-demand VHDS Updates {#config_http_filters_on_demand}
======================

The on-demand VHDS filter is used to request a
`virtual host <envoy_v3_api_msg_config.route.v3.VirtualHost>`{.interpreted-text
role="ref"} data if it\'s not already present in the
`Route Configuration <envoy_v3_api_msg_config.route.v3.RouteConfiguration>`{.interpreted-text
role="ref"}. The contents of the *Host* or *:authority* header is used
to create the on-demand request. For an on-demand request to be created,
`VHDS <envoy_v3_api_field_config.route.v3.RouteConfiguration.vhds>`{.interpreted-text
role="ref"} must be enabled and either *Host* or *:authority* header be
present.

On-demand VHDS cannot be used with SRDS at this point.

Configuration
-------------

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.http.on_demand.v3.OnDemand>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.http.on\_demand*.
-   The filter should be placed before *envoy.filters.http.router*
    filter in the HttpConnectionManager\'s filter chain.
