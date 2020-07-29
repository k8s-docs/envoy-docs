UDP proxy {#config_udp_listener_filters_udp_proxy}
=========

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.udp.udp_proxy.v3.UdpProxyConfig>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.udp\_listener.udp\_proxy*

Overview
--------

The UDP proxy listener filter allows Envoy to operate as a
*non-transparent* proxy between a UDP client and server. The lack of
transparency means that the upstream server will see the source IP and
port of the Envoy instance versus the client. All datagrams flow from
the client, to Envoy, to the upstream server, back to Envoy, and back to
the client.

Because UDP is not a connection oriented protocol, Envoy must keep track
of a client\'s *session* such that the response datagrams from an
upstream server can be routed back to the correct client. Each session
is index by the 4-tuple consisting of source IP/port and local IP/port
that the datagram is received on. Sessions last until the `idle timeout
<envoy_v3_api_field_extensions.filters.udp.udp_proxy.v3.UdpProxyConfig.idle_timeout>`{.interpreted-text
role="ref"} is reached.

Load balancing and unhealthy host handling
------------------------------------------

Envoy will fully utilize the configured load balancer for the configured
upstream cluster when load balancing UDP datagrams. When a new session
is created, Envoy will associate the session with an upstream host
selected using the configured load balancer. All future datagrams that
belong to the session will be routed to the same upstream host.

When an upstream host becomes unhealthy (due to `active health checking
<arch_overview_health_checking>`{.interpreted-text role="ref"}), Envoy
will attempt to create a new session to a healthy host when the next
datagram is received.

Circuit breaking
----------------

The number of sessions that can be created per upstream cluster is
limited by the cluster\'s
`maximum connection circuit breaker <arch_overview_circuit_break_cluster_maximum_connections>`{.interpreted-text
role="ref"}. By default this is 1024.

Example configuration
---------------------

The following example configuration will cause Envoy to listen on UDP
port 1234 and proxy to a UDP server listening on port 1235.

> ``` {.yaml}
> admin:
>   access_log_path: /tmp/admin_access.log
>   address:
>     socket_address:
>       protocol: TCP
>       address: 127.0.0.1
>       port_value: 9901
> static_resources:
>   listeners:
>   - name: listener_0
>     address:
>       socket_address:
>         protocol: UDP
>         address: 127.0.0.1
>         port_value: 1234
>     listener_filters:
>       name: envoy.filters.udp_listener.udp_proxy
>       typed_config:
>         '@type': type.googleapis.com/envoy.extensions.filters.udp.udp_proxy.v3.UdpProxyConfig
>         stat_prefix: service
>         cluster: service_udp
>   clusters:
>   - name: service_udp
>     connect_timeout: 0.25s
>     type: STATIC
>     lb_policy: ROUND_ROBIN
>     load_assignment:
>       cluster_name: service_udp
>       endpoints:
>       - lb_endpoints:
>         - endpoint:
>             address:
>               socket_address:
>                 address: 127.0.0.1
>                 port_value: 1235
> ```

Statistics
----------

The UDP proxy filter emits both its own downstream statistics as well as
many of the `cluster
upstream statistics <config_cluster_manager_cluster_stats>`{.interpreted-text
role="ref"} where applicable. The downstream statistics are rooted at
*udp.\<stat\_prefix\>.* with the following statistics:

  ---------------------------------------------------------------------------------------
  Name                              Type              Description
  --------------------------------- ----------------- -----------------------------------
  downstream\_sess\_no\_route       Counter           Number of datagrams not routed due
                                                      to no cluster

  downstream\_sess\_rx\_bytes       Counter           Number of bytes received

  downstream\_sess\_rx\_datagrams   Counter           Number of datagrams received

  downstream\_sess\_rx\_errors      Counter           Number of datagram receive errors

  downstream\_sess\_total           Counter           Number sessions created in total

  downstream\_sess\_tx\_bytes       Counter           Number of bytes transmitted

  downstream\_sess\_tx\_datagrams   Counter           Number of datagrams transmitted

  downstream\_sess\_tx\_errors      counter           Number of datagram transmission
                                                      errors

  idle\_timeout                     Counter           Number of sessions destroyed due to
                                                      idle timeout

  downstream\_sess\_active          Gauge             Number of sessions currently active
  ---------------------------------------------------------------------------------------

The following standard
`upstream cluster stats <config_cluster_manager_cluster_stats>`{.interpreted-text
role="ref"} are used by the UDP proxy:

  --------------------------------------------------------------------------------------
  Name                             Type              Description
  -------------------------------- ----------------- -----------------------------------
  upstream\_cx\_none\_healthy      Counter           Number of datagrams dropped due to
                                                     no healthy hosts

  upstream\_cx\_overflow           Counter           Number of datagrams dropped due to
                                                     hitting the session circuit breaker

  upstream\_cx\_rx\_bytes\_total   Counter           Number of bytes received

  upstream\_cx\_tx\_bytes\_total   Counter           Number of bytes transmitted
  --------------------------------------------------------------------------------------

The UDP proxy filter also emits custom upstream cluster stats prefixed
with *cluster.\<cluster\_name\>.udp.*:

  ---------------------------------------------------------------------------
  Name                  Type              Description
  --------------------- ----------------- -----------------------------------
  sess\_rx\_datagrams   Counter           Number of datagrams received

  sess\_rx\_errors      Counter           Number of datagram receive errors

  sess\_tx\_datagrams   Counter           Number of datagrams transmitted

  sess\_tx\_errors      Counter           Number of datagrams tramsitted
  ---------------------------------------------------------------------------
