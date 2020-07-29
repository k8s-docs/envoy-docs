---
title: "当地速率限制"
linkTitle: ""
weight: 1
---

Envoy supports local (non-distributed) rate limiting of L4 connections
via the
[local rate limit filter](config_network_filters_local_rate_limit){.interpreted-text
role="ref"}.

Note that Envoy also supports
[global rate limiting](arch_overview_global_rate_limit){.interpreted-text
role="ref"}. Local rate limiting can be used in conjunction with global
rate limiting to reduce load on the global rate limit service.
