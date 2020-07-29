---
title: "侦听器-Listeners"
linkTitle: "侦听器"
weight: 2220
---

`Envoy`配置在单个进程内里支持任何数量的监听器.
Generally we recommend running a single `Envoy` per machine regardless of the number of configured listeners.
This allows for easier operation and a single source of statistics.
`Envoy`同时支持 TCP 和 UDP 监听器。

## TCP

Each listener is independently configured with some number [filter chains](envoy_v3_api_msg_config.listener.v3.FilterChain), where an individual chain is selected based on its [match criteria](envoy_v3_api_msg_config.listener.v3.FilterChainMatch).
An individual filter chain is composed of one or more network level (L3/L4) [filters](arch_overview_network_filters).
When a new connection is received on a listener, the appropriate filter chain is selected, and the configured connection local filter stack is instantiated and begins processing subsequent events.
The generic listener architecture is used to perform the vast majority of different proxy tasks that Envoy is used for (e.g.,[rate limiting](arch_overview_global_rate_limit), [TLS client authentication](arch_overview_ssl_auth_filter), [HTTP connection management](arch_overview_http_conn_man), MongoDB [sniffing](arch_overview_mongo), raw [TCP proxy](arch_overview_tcp_proxy), etc.).

Listeners are optionally also configured with some number of [listener filters](arch_overview_listener_filters).
These filters are processed before the network level filters, and have the opportunity to manipulate the connection metadata, usually to influence how the connection is processed by later filters or clusters.

Listeners can also be fetched dynamically via the [listener discovery service (LDS)](config_listeners_lds).

Listener [configuration](config_listeners).

## UDP

Envoy also supports UDP listeners and specifically [UDP listener filters](config_udp_listener_filters).
UDP listener filters are instantiated once per worker and are global to that worker.
Each listener filter processes each UDP datagram that is received by the worker listening on the port. In practice, UDP listeners are configured with the SO_REUSEPORT kernel option which will cause the kernel to consistently hash each UDP 4-tuple to the same worker.
This allows a UDP listener filter to be \"session\" oriented if it so desires.
A built-in example of this functionality is the [UDP proxy](config_udp_listener_filters_udp_proxy) listener filter.
