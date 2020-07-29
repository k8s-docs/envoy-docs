---
title: "超载经理"
linkTitle: ""
weight: 1
---

The overload manager is an extensible component for protecting the Envoy
server from overload with respect to various system resources (such as
memory, cpu or file descriptors) due to too many client connections or
requests. This is distinct from
[circuit breaking](arch_overview_circuit_break){.interpreted-text
role="ref"} which is primarily aimed at protecting upstream services.

The overload manager is
[configured](config_overload_manager){.interpreted-text role="ref"} by
specifying a set of resources to monitor and a set of overload actions
that will be taken when some of those resources exceed certain pressure
thresholds.
