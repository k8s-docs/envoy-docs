Dubbo proxy {#config_network_filters_dubbo_proxy}
===========

The dubbo proxy filter decodes the RPC protocol between dubbo clients
and servers. the decoded RPC information is converted to metadata. the
metadata includes the basic request ID, request type, serialization
type, and the required service name, method name, parameter name, and
parameter value for routing.

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.network.dubbo_proxy.v3.DubboProxy>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.network.dubbo\_proxy*.

Statistics {#config_network_filters_dubbo_proxy_stats}
----------

Every configured dubbo proxy filter has statistics rooted at
*dubbo.\<stat\_prefix\>.* with the following statistics:

  --------------------------------------------------------------------------------------------------
  Name                                         Type              Description
  -------------------------------------------- ----------------- -----------------------------------
  request                                      Counter           Total requests

  request\_twoway                              Counter           Total twoway requests

  request\_oneway                              Counter           Total oneway requests

  request\_event                               Counter           Total event requests

  request\_decoding\_error                     Counter           Total decoding error requests

  request\_decoding\_success                   Counter           Total decoding success requests

  request\_active                              Gauge             Total active requests

  response                                     Counter           Total responses

  response\_success                            Counter           Total success responses

  response\_error                              Counter           Total responses that protocol parse
                                                                 error

  response\_error\_caused\_connection\_close   Counter           Total responses that caused by the
                                                                 downstream connection close

  response\_business\_exception                Counter           Total responses that the protocol
                                                                 contains exception information
                                                                 returned by the business layer

  response\_decoding\_error                    Counter           Total decoding error responses

  response\_decoding\_success                  Counter           Total decoding success responses

  response\_error                              Counter           Total responses that protocol parse
                                                                 error

  local\_response\_success                     Counter           Total local responses

  local\_response\_error                       Counter           Total local responses that encoding
                                                                 error

  local\_response\_business\_exception         Counter           Total local responses that the
                                                                 protocol contains business
                                                                 exception

  cx\_destroy\_local\_with\_active\_rq         Counter           Connections destroyed locally with
                                                                 an active query

  cx\_destroy\_remote\_with\_active\_rq        Counter           Connections destroyed remotely with
                                                                 an active query
  --------------------------------------------------------------------------------------------------

Implement custom filter based on the dubbo proxy filter
-------------------------------------------------------

If you want to implement a custom filter based on the dubbo protocol,
the dubbo proxy filter like HTTP also provides a very convenient way to
expand, the first step is to implement the DecoderFilter interface, and
give the filter named, such as testFilter, the second step is to add
your configuration, configuration method refer to the following sample

``` {.yaml}
filter_chains:
- filters:
  - name: envoy.filters.network.dubbo_proxy
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.dubbo_proxy.v3.DubboProxy
      stat_prefix: dubbo_incomming_stats
      protocol_type: Dubbo
      serialization_type: Hessian2
      route_config:
        name: local_route
        interface: org.apache.dubbo.demo.DemoService
        routes:
        - match:
            method:
              name:
                exact: sayHello
          route:
            cluster: user_service_dubbo_server
      dubbo_filters:
      - name: envoy.filters.dubbo.testFilter
        typed_config:
          "@type": type.googleapis.com/google.protobuf.Struct
          value:
            name: test_service
      - name: envoy.filters.dubbo.router
```
