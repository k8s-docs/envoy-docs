---
title: "加载报告服务 (LRS)"
linkTitle: ""
weight: 1
---

The Load Reporting Service provides a mechanism by which Envoy can emit
Load Reports to a management server at a regular cadence.

This will initiate a bi-directional stream with a management server.
Upon connecting, the management server can send a
[LoadStatsResponse](envoy_v3_api_msg_service.load_stats.v3.LoadStatsResponse){.interpreted-text
role="ref"} to a node it is interested in getting the load reports for.
Envoy in this node will start sending
[LoadStatsRequest](envoy_v3_api_msg_service.load_stats.v3.LoadStatsRequest){.interpreted-text
role="ref"}. This is done periodically based on the
[load reporting interval](envoy_v3_api_field_service.load_stats.v3.LoadStatsResponse.load_reporting_interval){.interpreted-text
role="ref"}

Envoy config with LRS can be found at
`/examples/load-reporting-service/service-envoy-w-lrs.yaml`{.interpreted-text
role="repo"}.
