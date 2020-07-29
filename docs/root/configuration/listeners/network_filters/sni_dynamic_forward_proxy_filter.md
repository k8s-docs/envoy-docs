SNI dynamic forward proxy {#config_network_filters_sni_dynamic_forward_proxy}
=========================

::: {.attention}
::: {.admonition-title}
Attention
:::

SNI dynamic forward proxy support should be considered alpha and not
production ready.
:::

Through the combination of
`TLS inspector <config_listener_filters_tls_inspector>`{.interpreted-text
role="ref"} listener filter, this network filter and the
`dynamic forward proxy cluster <envoy_api_msg_config.cluster.dynamic_forward_proxy.v2alpha.ClusterConfig>`{.interpreted-text
role="ref"}, Envoy supports SNI based dynamic forward proxy. The
implementation works just like the
`HTTP dynamic forward proxy <arch_overview_http_dynamic_forward_proxy>`{.interpreted-text
role="ref"}, but using the value in SNI as target host instead.

The following is a complete configuration that configures both this
filter as well as the `dynamic forward proxy cluster
<envoy_api_msg_config.cluster.dynamic_forward_proxy.v2alpha.ClusterConfig>`{.interpreted-text
role="ref"}. Both filter and cluster must be configured together and
point to the same DNS cache parameters for Envoy to operate as an SNI
dynamic forward proxy.

::: {.note}
::: {.admonition-title}
Note
:::

The following config doesn\'t terminate TLS in listener, so there is no
need to configure TLS context in cluster. The TLS handshake is passed
through by Envoy.
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
    listener_filters:
      - name: envoy.filters.listener.tls_inspector
    filter_chains:
      - filters:
          - name: envoy.filters.network.sni_dynamic_forward_proxy
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.network.sni_dynamic_forward_proxy.v3alpha.FilterConfig
              port_value: 443
              dns_cache_config:
                name: dynamic_forward_proxy_cache_config
                dns_lookup_family: V4_ONLY
          - name: envoy.tcp_proxy
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy
              stat_prefix: tcp
              cluster: dynamic_forward_proxy_cluster
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
```
