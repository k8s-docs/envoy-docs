Management Server
=================

Management Server Unreachability {#config_overview_mgmt_con_issues}
--------------------------------

When an Envoy instance loses connectivity with the management server,
Envoy will latch on to the previous configuration while actively
retrying in the background to reestablish the connection with the
management server.

Envoy debug logs the fact that it is not able to establish a connection
with the management server every time it attempts a connection.

`connected_state <management_server_stats>`{.interpreted-text
role="ref"} statistic provides a signal for monitoring this behavior.

Statistics {#management_server_stats}
----------

Management Server has a statistics tree rooted at *control\_plane.* with
the following statistics:

  -----------------------------------------------------------------------------
  Name                    Type              Description
  ----------------------- ----------------- -----------------------------------
  connected\_state        Gauge             A boolean (1 for connected and 0
                                            for disconnected) that indicates
                                            the current connection state with
                                            management server

  rate\_limit\_enforced   Counter           Total number of times rate limit
                                            was enforced for management server
                                            requests

  pending\_requests       Gauge             Total number of pending requests
                                            when the rate limit was enforced

  identifier              TextReadout       The identifier of the control plane
                                            instance that sent the last
                                            discovery response
  -----------------------------------------------------------------------------

xDS subscription statistics {#subscription_statistics}
---------------------------

Envoy discovers its various dynamic resources via discovery services
referred to as *xDS*. Resources are requested via
`subscriptions <xds_protocol>`{.interpreted-text role="ref"}, by
specifying a filesystem path to watch, initiating gRPC streams or
polling a REST-JSON URL.

The following statistics are generated for all subscriptions.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Name                              Type              Description
  --------------------------------- ----------------- -------------------------------------------------------------------------------------------------------------------
  config\_reload                    Counter           Total API fetches that resulted in a config reload due to a different config

  init\_fetch\_timeout              Counter           Total
                                                      `initial fetch timeouts <envoy_v3_api_field_config.core.v3.ConfigSource.initial_fetch_timeout>`{.interpreted-text
                                                      role="ref"}

  update\_attempt                   Counter           Total API fetches attempted

  update\_success                   Counter           Total API fetches completed successfully

  update\_failure                   Counter           Total API fetches that failed because of network errors

  update\_rejected                  Counter           Total API fetches that failed because of schema/validation errors

  update\_time                      Gauge             Timestamp of the last successful API fetch attempt as milliseconds since the epoch. Refreshed even after a trivial
                                                      configuration reload that contained no configuration changes.

  version                           Gauge             Hash of the contents from the last successful API fetch

  version\_text                     TextReadout       The version text from the last successful API fetch

  control\_plane.connected\_state   Gauge             A boolean (1 for connected and 0 for disconnected) that indicates the current connection state with management
                                                      server
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
