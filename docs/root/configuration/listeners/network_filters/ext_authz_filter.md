External Authorization {#config_network_filters_ext_authz}
======================

-   External authorization
    `architecture overview <arch_overview_ext_authz>`{.interpreted-text
    role="ref"}
-   `Network filter v3 API reference <envoy_v3_api_msg_extensions.filters.network.ext_authz.v3.ExtAuthz>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.network.ext\_authz*.

The external authorization network filter calls an external
authorization service to check if the incoming request is authorized or
not. If the request is deemed unauthorized by the network filter then
the connection will be closed.

::: {.tip}
::: {.admonition-title}
Tip
:::

It is recommended that this filter is configured first in the filter
chain so that requests are authorized prior to rest of the filters
processing the request.
:::

The content of the request that are passed to an authorization service
is specified by
`CheckRequest <envoy_v3_api_msg_service.auth.v3.CheckRequest>`{.interpreted-text
role="ref"}.

::: {#config_network_filters_ext_authz_network_configuration}
The network filter, gRPC service, can be configured as follows. You can
see all the configuration options at
`Network filter <envoy_v3_api_msg_extensions.filters.network.ext_authz.v3.ExtAuthz>`{.interpreted-text
role="ref"}.
:::

Example
-------

A sample filter configuration could be:

``` {.yaml}
filters:
  - name: envoy.filters.network.ext_authz
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.ext_authz.v3.ExtAuthz
      stat_prefix: ext_authz
      grpc_service:
        envoy_grpc:
          cluster_name: ext-authz
      include_peer_certificate: true

clusters:
  - name: ext-authz
    type: static
    http2_protocol_options: {}
    load_assignment:
      cluster_name: ext-authz
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: 127.0.0.1
                port_value: 10003
```

Statistics
----------

The network filter outputs statistics in the *config.ext\_authz.*
namespace.

  ------------------------------------------------------------------------------
  Name                     Type              Description
  ------------------------ ----------------- -----------------------------------
  total                    Counter           Total responses from the filter.

  error                    Counter           Total errors contacting the
                                             external service.

  denied                   Counter           Total responses from the
                                             authorizations service that were to
                                             deny the traffic.

  failure\_mode\_allowed   Counter           Total requests that were error(s)
                                             but were allowed through because of
                                             failure\_mode\_allow set to true.

  ok                       Counter           Total responses from the
                                             authorization service that were to
                                             allow the traffic.

  cx\_closed               Counter           Total connections that were closed.

  active                   Gauge             Total currently active requests in
                                             transit to the authorization
                                             service.
  ------------------------------------------------------------------------------
