Redis proxy {#config_network_filters_redis_proxy}
===========

-   Redis
    `architecture overview <arch_overview_redis>`{.interpreted-text
    role="ref"}
-   `v3 API reference <envoy_v3_api_msg_extensions.filters.network.redis_proxy.v3.RedisProxy>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.network.redis\_proxy*.

Statistics {#config_network_filters_redis_proxy_stats}
----------

Every configured Redis proxy filter has statistics rooted at
*redis.\<stat\_prefix\>.* with the following statistics:

  -------------------------------------------------------------------------------------------
  Name                                  Type              Description
  ------------------------------------- ----------------- -----------------------------------
  downstream\_cx\_active                Gauge             Total active connections

  downstream\_cx\_protocol\_error       Counter           Total protocol errors

  downstream\_cx\_rx\_bytes\_buffered   Gauge             Total received bytes currently
                                                          buffered

  downstream\_cx\_rx\_bytes\_total      Counter           Total bytes received

  downstream\_cx\_total                 Counter           Total connections

  downstream\_cx\_tx\_bytes\_buffered   Gauge             Total sent bytes currently buffered

  downstream\_cx\_tx\_bytes\_total      Counter           Total bytes sent

  downstream\_cx\_drain\_close          Counter           Number of connections closed due to
                                                          draining

  downstream\_rq\_active                Gauge             Total active requests

  downstream\_rq\_total                 Counter           Total requests
  -------------------------------------------------------------------------------------------

Splitter statistics
-------------------

The Redis filter will gather statistics for the command splitter in the
*redis.\<stat\_prefix\>.splitter.* with the following statistics:

  ----------------------------------------------------------------------------
  Name                   Type              Description
  ---------------------- ----------------- -----------------------------------
  invalid\_request       Counter           Number of requests with an
                                           incorrect number of arguments

  unsupported\_command   Counter           Number of commands issued which are
                                           not recognized by the command
                                           splitter
  ----------------------------------------------------------------------------

Per command statistics
----------------------

The Redis filter will gather statistics for commands in the
*redis.\<stat\_prefix\>.command.\<command\>.* namespace. By default
latency stats are in milliseconds and can be changed to microseconds by
setting the configuration parameter
`latency_in_micros <envoy_v3_api_field_extensions.filters.network.redis_proxy.v3.RedisProxy.latency_in_micros>`{.interpreted-text
role="ref"} to true.

  -----------------------------------------------------------------------
  Name              Type              Description
  ----------------- ----------------- -----------------------------------
  total             Counter           Number of commands

  success           Counter           Number of commands that were
                                      successful

  error             Counter           Number of commands that returned a
                                      partial or complete error response

  latency           Histogram         Command execution time in
                                      milliseconds
  -----------------------------------------------------------------------

Runtime {#config_network_filters_redis_proxy_per_command_stats}
-------

The Redis proxy filter supports the following runtime settings:

redis.drain\_close\_enabled

:   \% of connections that will be drain closed if the server is
    draining and would otherwise attempt a drain close. Defaults to 100.
