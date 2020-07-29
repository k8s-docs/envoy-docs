---
title: "HTTP 动态正向代理"
linkTitle: ""
weight: 1
---

::: {.attention}
::: {.admonition-title}
Attention
:::

HTTP dynamic forward proxy support should be considered alpha and not
production ready.
:::

Through the combination of both an
[HTTP filter](config_http_filters_dynamic_forward_proxy){.interpreted-text
role="ref"} and
[custom cluster](envoy_v3_api_msg_extensions.clusters.dynamic_forward_proxy.v3.ClusterConfig){.interpreted-text
role="ref"}, Envoy supports HTTP dynamic forward proxy. This means that
Envoy can perform the role of an HTTP proxy without prior knowledge of
all configured DNS addresses, while still retaining the vast majority of
Envoy\'s benefits including asynchronous DNS resolution. The
implementation works as follows:

- The dynamic forward proxy HTTP filter is used to pause requests if
  the target DNS host is not already in cache.
- Envoy will begin asynchronously resolving the DNS address,
  unblocking any requests waiting on the response when the resolution
  completes.
- Any future requests will not be blocked as the DNS address is
  already in cache. The resolution process works similarly to the
  `logical DNS <arch_overview_service_discovery_types_logical_dns>`{.interpreted-text
  role="ref"} service discovery type with a single target address
  being remembered at any given time.
- All known hosts are stored in the dynamic forward proxy cluster such
  that they can be displayed in
  [admin output](operations_admin_interface){.interpreted-text
  role="ref"}.
- A special load balancer will select the right host to use based on
  the HTTP host/authority header during forwarding.
- Hosts that have not been used for a period of time are subject to a
  TTL that will purge them.
- When the upstream cluster has been configured with a TLS context,
  Envoy will automatically perform SAN verification for the resolved
  host name as well as specify the host name via SNI.

The above implementation details mean that at steady state Envoy can
forward a large volume of HTTP proxy traffic while all DNS resolution
happens asynchronously in the background. Additionally, all other Envoy
filters and extensions can be used in conjunction with dynamic forward
proxy support including authentication, RBAC, rate limiting, etc.

For further configuration information see the
`HTTP filter configuration documentation <config_http_filters_dynamic_forward_proxy>`{.interpreted-text
role="ref"}.

## Memory usage details

Memory usage detail\'s for Envoy\'s dynamic forward proxy support are as
follows:

- Each resolved host/port pair uses a fixed amount of memory global to
  the server and shared amongst all workers.
- Address changes are performed inline using read/write locks and
  require no host reallocations.
- Hosts removed via TTL are purged once all active connections stop
  referring to them and all used memory is regained.
- The `max_hosts <envoy_v3_api_field_extensions.common.dynamic_forward_proxy.v3.DnsCacheConfig.max_hosts>`{.interpreted-text
  role="ref"} field can be used to limit the number of hosts that the
  DNS cache will store at any given time.
- The cluster\'s `max_pending_requests <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_pending_requests>`{.interpreted-text
  role="ref"} circuit breaker can be used to limit the number of
  requests that are pending waiting for the DNS cache to load a host.
- Long lived upstream connections can have the underlying logical host
  expire via TTL while the connection is still open. Upstream requests
  and connections are still bound by other cluster circuit breakers
  such as `max_requests <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_requests>`{.interpreted-text
  role="ref"}. The current assumption is that host data shared between
  connections uses a marginal amount of memory compared to the
  connections and requests themselves, making it not worth controlling
  independently.