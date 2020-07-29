---
title: "什么是 Envoy?"
linkTitle: ""
weight: 21
---

`Envoy`是 L7 代理和通信总线设计的大型现代化面向服务的架构。 该项目是基于这样一种信念的出:

> _网络应该是透明的应用程序。当网络和应用问题确实发生了，应该很容易确定问题的根源。_

在实践中，实现前面提到的目标是非常困难的。
`Envoy`试图通过提供以下高级功能可以这样做：

**流程架构输出:** Envoy 是一个自包含处理, 被设计成每一起应用服务器运行.
所有 Envoy 形成透明通信网 其中 每个应用程序发送和接收消息 送出和来自本地主机和未知网络拓扑.
流程架构输出 有两个实实在在的好处 over the traditional library approach to service to service communication:

- `Envoy`适用于任何应用程序语言。 A single `Envoy` deployment
  can form a mesh between Java, C++, Go, PHP, Python, etc. It is
  becoming increasingly common for service oriented architectures to
  use multiple application frameworks and languages. `Envoy`
  transparently bridges the gap.
- 正如有人已经用了大量面向服务的架构工作的人都知道，在部署库升级可令人难以置信的痛苦。 `Envoy`
  can be deployed and upgraded quickly across an entire infrastructure
  transparently.

**现代 C ++ 11 代码库:** `Envoy` is written in C++11. Native code was
chosen because we believe that an architectural component such as `Envoy`
should get out of the way as much as possible. Modern application
developers already deal with tail latencies that are difficult to reason
about due to deployments in shared cloud environments and the use of
very productive but not particularly well performing languages such as
PHP, Python, Ruby, Scala, etc. Native code provides generally excellent
latency properties that don\'t add additional confusion to an already
confusing situation. Unlike other native code proxy solutions written in
C, C++11 provides both excellent developer productivity and performance.

**L3/L4 滤波器架构:** At its core, `Envoy` is an L3/L4 network
proxy. A pluggable
[filter](arch_overview_network_filters)
chain mechanism allows filters to be written to perform different TCP
proxy tasks and inserted into the main server. Filters have already been
written to support various tasks such as raw
[TCP proxy](arch_overview_tcp_proxy),
[HTTP proxy](arch_overview_http_conn_man), [TLS client certificate authentication](arch_overview_ssl_auth_filter), etc.

**HTTP L7 滤波器架构:** HTTP is such a critical component of
modern application architectures that `Envoy`
[supports](arch_overview_http_filters) an
additional HTTP L7 filter layer. HTTP filters can be plugged into the
HTTP connection management subsystem that perform different tasks such
as [buffering](config_http_filters_buffer), [rate limiting](arch_overview_global_rate_limit),
[routing/forwarding](arch_overview_http_routing), sniffing Amazon\'s
[DynamoDB](arch_overview_dynamo), etc.

**第一类 HTTP / 2 支持:** When operating in HTTP mode, `Envoy`
[supports](arch_overview_http_protocols) both
HTTP/1.1 and HTTP/2. `Envoy` can operate as a transparent HTTP/1.1 to
HTTP/2 proxy in both directions. This means that any combination of
HTTP/1.1 and HTTP/2 clients and target servers can be bridged. The
recommended service to service configuration uses HTTP/2 between all
`Envoy`s to create a mesh of persistent connections that requests and
responses can be multiplexed over. `Envoy` does not support SPDY as the
protocol is being phased out.

**HTTP L7 路由:** When operating in HTTP mode, `Envoy` supports a
[routing](arch_overview_http_routing)
subsystem that is capable of routing and redirecting requests based on
path, authority, content type,
[runtime](arch_overview_runtime) values,
etc. This functionality is most useful when using `Envoy` as a front/edge
proxy but is also leveraged when building a service to service mesh.

**gRPC 支持:** [gRPC](https://www.grpc.io/) is an RPC framework from
Google that uses HTTP/2 as the underlying multiplexed transport. `Envoy`
[supports](arch_overview_grpc) all of the
HTTP/2 features required to be used as the routing and load balancing
substrate for gRPC requests and responses. The two systems are very
complementary.

**MongoDB L7 支持:** [MongoDB](https://www.mongodb.com/) is a popular
database used in modern web applications. `Envoy`
[supports](arch_overview_mongo) L7
sniffing, statistics production, and logging for MongoDB connections.

**DynamoDB L7 支持**: [DynamoDB](https://aws.amazon.com/dynamodb/) is
Amazon's hosted key/value NOSQL datastore. `Envoy`
[supports](arch_overview_dynamo) L7
sniffing and statistics production for DynamoDB connections.

**服务发现和动态配置:** `Envoy` optionally
consumes a layered set of
[dynamic configuration APIs](arch_overview_dynamic_config) for centralized management. The layers provide an `Envoy` with
dynamic updates about: hosts within a backend cluster, the backend
clusters themselves, HTTP routing, listening sockets, and cryptographic
material. For a simpler deployment, backend host discovery can be
[done through DNS resolution](arch_overview_service_discovery_types_strict_dns) (or even
[skipped entirely](arch_overview_service_discovery_types_static)), with the further layers replaced by static config files.

**健康检查:** The
[recommended](arch_overview_service_discovery_eventually_consistent) way of building an `Envoy` mesh is to treat service discovery
as an eventually consistent process. `Envoy` includes a
[health checking](arch_overview_health_checking) subsystem which can optionally perform active health
checking of upstream service clusters. `Envoy` then uses the union of
service discovery and health checking information to determine healthy
load balancing targets. `Envoy` also supports passive health checking via
an [outlier detection](arch_overview_outlier_detection)
subsystem.

**高级负载平衡:**
[Load balancing](arch_overview_load_balancing) among different components in a distributed system is a
complex problem. Because `Envoy` is a self contained proxy instead of a
library, it is able to implement advanced load balancing techniques in a
single place and have them be accessible to any application. Currently
[Envoy`includes support for`automatic retries](arch_overview_http_routing_retry),
[circuit breaking](arch_overview_circuit_break),
[global rate limiting](arch_overview_global_rate_limit) via an external rate limiting service,
[request shadowing](`Envoy`_v3_api_msg_config.route.v3.RouteAction.RequestMirrorPolicy), and
[outlier detection](arch_overview_outlier_detection). Future support is planned for request racing.

**前端/边缘代理支持:** Although `Envoy` is primarily designed as a
service to service communication system, there is benefit in using the
same software at the edge (observability, management, identical service
discovery and load balancing algorithms, etc.). `Envoy` includes enough
features to make it usable as an edge proxy for most modern web
application use cases. This includes
[TLS](arch_overview_ssl) termination,
HTTP/1.1 and HTTP/2 [support](arch_overview_http_protocols), as well
as HTTP L7 [routing](arch_overview_http_routing).

**在类可观测里最好:** As stated above, the primary goal of
`Envoy` is to make the network transparent. However, problems occur both
at the network level and at the application level. `Envoy` includes robust
[statistics](arch_overview_statistics)
support for all subsystems. [statsd](https://github.com/etsy/statsd)
(and compatible providers) is the currently supported statistics sink,
though plugging in a different one would not be difficult. Statistics
are also viewable via the
[administration](operations_admin_interface) port. `Envoy` also supports distributed
[tracing](arch_overview_tracing) via
thirdparty providers.

## 设计目标

代码本身的设计目标的简短的笔记: Although `Envoy` is
by no means slow (we have spent considerable time optimizing certain
fast paths), the code has been written to be modular and easy to test
versus aiming for the greatest possible absolute performance. It\'s our
view that this is a more efficient use of time given that typical
deployments will be alongside languages and runtimes many times slower
and with many times greater memory usage.
