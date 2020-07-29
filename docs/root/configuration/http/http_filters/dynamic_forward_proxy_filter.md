Dynamic forward proxy {#config_http_filters_dynamic_forward_proxy}
=====================

::: {.attention}
::: {.admonition-title}
Attention
:::

HTTP dynamic forward proxy support should be considered alpha and not
production ready.
:::

-   HTTP dynamic forward proxy
    `architecture overview <arch_overview_http_dynamic_forward_proxy>`{.interpreted-text
    role="ref"}
-   `v3 API reference <envoy_v3_api_msg_extensions.filters.http.dynamic_forward_proxy.v3.FilterConfig>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.http.dynamic\_forward\_proxy*

The following is a complete configuration that configures both the
`dynamic forward proxy HTTP filter
<envoy_v3_api_msg_extensions.filters.http.dynamic_forward_proxy.v3.FilterConfig>`{.interpreted-text
role="ref"} as well as the `dynamic forward proxy cluster
<envoy_v3_api_msg_extensions.clusters.dynamic_forward_proxy.v3.ClusterConfig>`{.interpreted-text
role="ref"}. Both filter and cluster must be configured together and
point to the same DNS cache parameters for Envoy to operate as an HTTP
dynamic forward proxy.

This filter supports
`host rewrite <envoy_v3_api_msg_extensions.filters.http.dynamic_forward_proxy.v3.FilterConfig>`{.interpreted-text
role="ref"} via the
`virtual host's typed_per_filter_config <envoy_v3_api_field_config.route.v3.VirtualHost.typed_per_filter_config>`{.interpreted-text
role="ref"} or the
`route's typed_per_filter_config <envoy_v3_api_field_config.route.v3.Route.typed_per_filter_config>`{.interpreted-text
role="ref"}. This can be used to rewrite the host header with the
provided value before DNS lookup, thus allowing to route traffic to the
rewritten host when forwarding. See the example below within the
configured routes.

::: {.note}
::: {.admonition-title}
Note
:::

Configuring a
`transport_socket with name envoy.transport_sockets.tls <envoy_v3_api_field_config.cluster.v3.Cluster.transport_socket>`{.interpreted-text
role="ref"} on the cluster with *trusted\_ca* certificates instructs
Envoy to use TLS when connecting to upstream hosts and verify the
certificate chain. Additionally, Envoy will automatically perform SAN
verification for the resolved host name as well as specify the host name
via SNI.
:::

::: {#dns_cache_circuit_breakers}
> Dynamic forward proxy uses circuit breakers built in to the DNS cache
> with the configuration of
> `DNS cache circuit breakers <envoy_v3_api_field_extensions.common.dynamic_forward_proxy.v3.DnsCacheConfig.dns_cache_circuit_breaker>`{.interpreted-text
> role="ref"}. By default, this behavior is enabled by the runtime
> feature
> [envoy.reloadable\_features.enable\_dns\_cache\_circuit\_breakers]{.title-ref}.
> If this runtime feature is disabled, cluster circuit breakers will be
> used even when setting the configuration of
> `DNS cache circuit breakers <envoy_v3_api_field_extensions.common.dynamic_forward_proxy.v3.DnsCacheConfig.dns_cache_circuit_breaker>`{.interpreted-text
> role="ref"}.
:::

``` {.yaml}
admin:
  access_log_path: /tmp/admin_access.log
  address:
    socket_address:
      protocol: TCP
      address: 127.0.0.1
      port_value: 9901
static_resources:
  listeners:
  - name: listener_0
    address:
      socket_address:
        protocol: TCP
        address: 0.0.0.0
        port_value: 10000
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: ingress_http
          route_config:
            name: local_route
            virtual_hosts:
            - name: local_service
              domains: ["*"]
              routes:
              - match:
                  prefix: "/force-host-rewrite"
                route:
                  cluster: dynamic_forward_proxy_cluster
                typed_per_filter_config:
                  envoy.filters.http.dynamic_forward_proxy:
                    "@type": type.googleapis.com/envoy.extensions.filters.http.dynamic_forward_proxy.v3.PerRouteConfig
                    host_rewrite_literal: www.example.org
              - match:
                  prefix: "/"
                route:
                  cluster: dynamic_forward_proxy_cluster
          http_filters:
          - name: envoy.filters.http.dynamic_forward_proxy
            typed_config:
              "@type": type.googleapis.com/envoy.config.filter.http.dynamic_forward_proxy.v2alpha.FilterConfig
              dns_cache_config:
                name: dynamic_forward_proxy_cache_config
                dns_lookup_family: V4_ONLY
          - name: envoy.filters.http.router
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
  clusters:
  - name: dynamic_forward_proxy_cluster
    connect_timeout: 1s
    lb_policy: CLUSTER_PROVIDED
    cluster_type:
      name: envoy.clusters.dynamic_forward_proxy
      typed_config:
        "@type": type.googleapis.com/envoy.extensions.clusters.dynamic_forward_proxy.v3.ClusterConfig
        dns_cache_config:
          name: dynamic_forward_proxy_cache_config
          dns_lookup_family: V4_ONLY
    transport_socket:
      name: envoy.transport_sockets.tls
      typed_config:
        "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext
        common_tls_context:
          validation_context:
            trusted_ca: {filename: /etc/ssl/certs/ca-certificates.crt}
```

Statistics
----------

The dynamic forward proxy DNS cache outputs statistics in the
dns\_cache.\<dns\_cache\_name\>.\* namespace.

  ----------------------------------------------------------------------------------
  Name                         Type              Description
  ---------------------------- ----------------- -----------------------------------
  dns\_query\_attempt          Counter           Number of DNS query attempts.

  dns\_query\_success          Counter           Number of DNS query successes.

  dns\_query\_failure          Counter           Number of DNS query failures.

  host\_address\_changed       Counter           Number of DNS queries that resulted
                                                 in a host address change.

  host\_added                  Counter           Number of hosts that have been
                                                 added to the cache.

  host\_removed                Counter           Number of hosts that have been
                                                 removed from the cache.

  num\_hosts                   Gauge             Number of hosts that are currently
                                                 in the cache.

  dns\_rq\_pending\_overflow   Counter           Number of dns pending request
                                                 overflow.
  ----------------------------------------------------------------------------------

The dynamic forward proxy DNS cache circuit breakers outputs statistics
in the dns\_cache.\<dns\_cache\_name\>.circuit\_breakers\* namespace.

  ------------------------------------------------------------------------------
  Name                     Type              Description
  ------------------------ ----------------- -----------------------------------
  rq\_pending\_open        Gauge             Whether the requests circuit
                                             breaker is closed (0) or open (1)

  rq\_pending\_remaining   Gauge             Number of remaining requests until
                                             the circuit breaker opens
  ------------------------------------------------------------------------------
