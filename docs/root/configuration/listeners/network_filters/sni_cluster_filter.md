Upstream Cluster from SNI {#config_network_filters_sni_cluster}
=========================

The [sni\_cluster]{.title-ref} is a network filter that uses the SNI
value in a TLS connection as the upstream cluster name. The filter will
not modify the upstream cluster for non-TLS connections. This filter
should be configured with the name *envoy.filters.network.sni\_cluster*.

This filter has no configuration. It must be installed before the
`tcp_proxy <config_network_filters_tcp_proxy>`{.interpreted-text
role="ref"} filter.

-   `v3 API reference <envoy_v3_api_field_config.listener.v3.Filter.name>`{.interpreted-text
    role="ref"}
