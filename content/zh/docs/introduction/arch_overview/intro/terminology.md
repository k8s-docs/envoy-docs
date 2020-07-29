---
title: "术语"
linkTitle: ""
weight: 2211
---

一些定义之前，我们深入到主架构文档。
一些定义是行业内略有争议, 然而他们是 Envoy 通过整个文档和代码库如何使用它们 , so _c'est la vie_.

**主机(Host)**: An entity capable of network communication (application on a
mobile phone, server, etc.). In this documentation a host is a logical
network application. A physical piece of hardware could possibly have
multiple hosts running on it as long as each of them can be
independently addressed.

**下游(Downstream)**: A downstream host connects to Envoy, sends requests, and
receives responses.

**上游(Upstream)**: An upstream host receives connections and requests from
Envoy and returns responses.

**倾听者(Listener)**: A listener is a named network location (e.g., port, unix
domain socket, etc.) that can be connected to by downstream clients.
Envoy exposes one or more listeners that downstream hosts connect to.

**簇(Cluster)**: A cluster is a group of logically similar upstream hosts
that Envoy connects to. Envoy discovers the members of a cluster via
[service discovery](arch_overview_service_discovery). It optionally determines the health of cluster members via
[active health checking](arch_overview_health_checking). The
cluster member that Envoy routes a request to is determined by the
[load balancing policy](arch_overview_load_balancing).

**网格(Mesh)**: 一组协调，以提供一致的网络拓扑结构的主机。
In this documentation, an "Envoy mesh" is a group of
Envoy proxies that form a message passing substrate for a distributed
system comprised of many different services and application platforms.

**运行时配置(Runtime configuration)**: 带外实时配置系统的部署在一起`Envoy`。
Configuration settings can be altered that
will affect operation without needing to restart Envoy or change the
primary configuration.
