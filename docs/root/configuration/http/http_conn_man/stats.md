Statistics {#config_http_conn_man_stats}
==========

Every connection manager has a statistics tree rooted at
*http.\<stat\_prefix\>.* with the following statistics:

  ----------------------------------------------------------------------------------------------------------
  Name                                                 Type              Description
  ---------------------------------------------------- ----------------- -----------------------------------
  downstream\_cx\_total                                Counter           Total connections

  downstream\_cx\_ssl\_total                           Counter           Total TLS connections

  downstream\_cx\_http1\_total                         Counter           Total HTTP/1.1 connections

  downstream\_cx\_upgrades\_total                      Counter           Total successfully upgraded
                                                                         connections. These are also counted
                                                                         as total http1/http2 connections.

  downstream\_cx\_http2\_total                         Counter           Total HTTP/2 connections

  downstream\_cx\_destroy                              Counter           Total connections destroyed

  downstream\_cx\_destroy\_remote                      Counter           Total connections destroyed due to
                                                                         remote close

  downstream\_cx\_destroy\_local                       Counter           Total connections destroyed due to
                                                                         local close

  downstream\_cx\_destroy\_active\_rq                  Counter           Total connections destroyed with 1+
                                                                         active request

  downstream\_cx\_destroy\_local\_active\_rq           Counter           Total connections destroyed locally
                                                                         with 1+ active request

  downstream\_cx\_destroy\_remote\_active\_rq          Counter           Total connections destroyed
                                                                         remotely with 1+ active request

  downstream\_cx\_active                               Gauge             Total active connections

  downstream\_cx\_ssl\_active                          Gauge             Total active TLS connections

  downstream\_cx\_http1\_active                        Gauge             Total active HTTP/1.1 connections

  downstream\_cx\_upgrades\_active                     Gauge             Total active upgraded connections.
                                                                         These are also counted as active
                                                                         http1/http2 connections.

  downstream\_cx\_http2\_active                        Gauge             Total active HTTP/2 connections

  downstream\_cx\_protocol\_error                      Counter           Total protocol errors

  downstream\_cx\_length\_ms                           Histogram         Connection length milliseconds

  downstream\_cx\_rx\_bytes\_total                     Counter           Total bytes received

  downstream\_cx\_rx\_bytes\_buffered                  Gauge             Total received bytes currently
                                                                         buffered

  downstream\_cx\_tx\_bytes\_total                     Counter           Total bytes sent

  downstream\_cx\_tx\_bytes\_buffered                  Gauge             Total sent bytes currently buffered

  downstream\_cx\_drain\_close                         Counter           Total connections closed due to
                                                                         draining

  downstream\_cx\_idle\_timeout                        Counter           Total connections closed due to
                                                                         idle timeout

  downstream\_cx\_max\_duration\_reached               Counter           Total connections closed due to max
                                                                         connection duration

  downstream\_cx\_overload\_disable\_keepalive         Counter           Total connections for which HTTP
                                                                         1.x keepalive has been disabled due
                                                                         to Envoy overload

  downstream\_flow\_control\_paused\_reading\_total    Counter           Total number of times reads were
                                                                         disabled due to flow control

  downstream\_flow\_control\_resumed\_reading\_total   Counter           Total number of times reads were
                                                                         enabled on the connection due to
                                                                         flow control

  downstream\_rq\_total                                Counter           Total requests

  downstream\_rq\_http1\_total                         Counter           Total HTTP/1.1 requests

  downstream\_rq\_http2\_total                         Counter           Total HTTP/2 requests

  downstream\_rq\_active                               Gauge             Total active requests

  downstream\_rq\_response\_before\_rq\_complete       Counter           Total responses sent before the
                                                                         request was complete

  downstream\_rq\_rx\_reset                            Counter           Total request resets received

  downstream\_rq\_tx\_reset                            Counter           Total request resets sent

  downstream\_rq\_non\_relative\_path                  Counter           Total requests with a non-relative
                                                                         HTTP path

  downstream\_rq\_too\_large                           Counter           Total requests resulting in a 413
                                                                         due to buffering an overly large
                                                                         body

  downstream\_rq\_completed                            Counter           Total requests that resulted in a
                                                                         response (e.g. does not include
                                                                         aborted requests)

  downstream\_rq\_1xx                                  Counter           Total 1xx responses

  downstream\_rq\_2xx                                  Counter           Total 2xx responses

  downstream\_rq\_3xx                                  Counter           Total 3xx responses

  downstream\_rq\_4xx                                  Counter           Total 4xx responses

  downstream\_rq\_5xx                                  Counter           Total 5xx responses

  downstream\_rq\_ws\_on\_non\_ws\_route               Counter           Total upgrade requests rejected by
                                                                         non upgrade routes. This now
                                                                         applies both to WebSocket and
                                                                         non-WebSocket upgrades

  downstream\_rq\_time                                 Histogram         Total time for request and response
                                                                         (milliseconds)

  downstream\_rq\_idle\_timeout                        Counter           Total requests closed due to idle
                                                                         timeout

  downstream\_rq\_max\_duration\_reached               Counter           Total requests closed due to max
                                                                         duration reached

  downstream\_rq\_timeout                              Counter           Total requests closed due to a
                                                                         timeout on the request path

  downstream\_rq\_overload\_close                      Counter           Total requests closed due to Envoy
                                                                         overload

  rs\_too\_large                                       Counter           Total response errors due to
                                                                         buffering an overly large body
  ----------------------------------------------------------------------------------------------------------

Per user agent statistics
-------------------------

Additional per user agent statistics are rooted at
*http.\<stat\_prefix\>.user\_agent.\<user\_agent\>.* Currently Envoy
matches user agent for both iOS (*ios*) and Android (*android*) and
produces the following statistics:

  ---------------------------------------------------------------------------------------------------
  Name                                          Type              Description
  --------------------------------------------- ----------------- -----------------------------------
  downstream\_cx\_total                         Counter           Total connections

  downstream\_cx\_destroy\_remote\_active\_rq   Counter           Total connections destroyed
                                                                  remotely with 1+ active requests

  downstream\_rq\_total                         Counter           Total requests
  ---------------------------------------------------------------------------------------------------

Per listener statistics {#config_http_conn_man_stats_per_listener}
-----------------------

Additional per listener statistics are rooted at
*listener.\<address\>.http.\<stat\_prefix\>.* with the following
statistics:

  ---------------------------------------------------------------------------------
  Name                        Type              Description
  --------------------------- ----------------- -----------------------------------
  downstream\_rq\_completed   Counter           Total responses

  downstream\_rq\_1xx         Counter           Total 1xx responses

  downstream\_rq\_2xx         Counter           Total 2xx responses

  downstream\_rq\_3xx         Counter           Total 3xx responses

  downstream\_rq\_4xx         Counter           Total 4xx responses

  downstream\_rq\_5xx         Counter           Total 5xx responses
  ---------------------------------------------------------------------------------

Per codec statistics {#config_http_conn_man_stats_per_codec}
--------------------

Each codec has the option of adding per-codec statistics. Both http1 and
http2 have codec stats.

### Http1 codec statistics

All http1 statistics are rooted at *http1.*

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Name                                                 Type              Description
  ---------------------------------------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------
  dropped\_headers\_with\_underscores                  Counter           Total number of dropped headers with names containing underscores. This action is configured by setting the
                                                                         `headers_with_underscores_action config setting <envoy_v3_api_field_config.core.v3.HttpProtocolOptions.headers_with_underscores_action>`{.interpreted-text
                                                                         role="ref"}.

  metadata\_not\_supported\_error                      Counter           Total number of metadata dropped during HTTP/1 encoding

  response\_flood                                      Counter           Total number of connections closed due to response flooding

  requests\_rejected\_with\_underscores\_in\_headers   Counter           Total numbers of rejected requests due to header names containing underscores. This action is configured by setting the
                                                                         `headers_with_underscores_action config setting <envoy_v3_api_field_config.core.v3.HttpProtocolOptions.headers_with_underscores_action>`{.interpreted-text
                                                                         role="ref"}.
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Http2 codec statistics

All http2 statistics are rooted at *http2.*

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Name                                                 Type              Description
  ---------------------------------------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  dropped\_headers\_with\_underscores                  Counter           Total number of dropped headers with names containing underscores. This action is configured by setting the
                                                                         `headers_with_underscores_action config setting <envoy_v3_api_field_config.core.v3.HttpProtocolOptions.headers_with_underscores_action>`{.interpreted-text role="ref"}.

  header\_overflow                                     Counter           Total number of connections reset due to the headers being larger than the
                                                                         `configured value <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.max_request_headers_kb>`{.interpreted-text role="ref"}.

  headers\_cb\_no\_stream                              Counter           Total number of errors where a header callback is called without an associated stream. This tracks an unexpected occurrence due to an as yet undiagnosed bug

  inbound\_empty\_frames\_flood                        Counter           Total number of connections terminated for exceeding the limit on consecutive inbound frames with an empty payload and no end stream flag. The limit is configured by setting the
                                                                         `max_consecutive_inbound_frames_with_empty_payload config setting <envoy_v3_api_field_config.core.v3.Http2ProtocolOptions.max_consecutive_inbound_frames_with_empty_payload>`{.interpreted-text
                                                                         role="ref"}.

  inbound\_priority\_frames\_flood                     Counter           Total number of connections terminated for exceeding the limit on inbound frames of type PRIORITY. The limit is configured by setting the
                                                                         `max_inbound_priority_frames_per_stream config setting <envoy_v3_api_field_config.core.v3.Http2ProtocolOptions.max_inbound_priority_frames_per_stream>`{.interpreted-text role="ref"}.

  inbound\_window\_update\_frames\_flood               Counter           Total number of connections terminated for exceeding the limit on inbound frames of type WINDOW\_UPDATE. The limit is configured by setting the
                                                                         `max_inbound_window_updateframes_per_data_frame_sent config setting <envoy_v3_api_field_config.core.v3.Http2ProtocolOptions.max_inbound_window_update_frames_per_data_frame_sent>`{.interpreted-text
                                                                         role="ref"}.

  outbound\_flood                                      Counter           Total number of connections terminated for exceeding the limit on outbound frames of all types. The limit is configured by setting the
                                                                         `max_outbound_frames config setting <envoy_v3_api_field_config.core.v3.Http2ProtocolOptions.max_outbound_frames>`{.interpreted-text role="ref"}.

  outbound\_control\_flood                             Counter           Total number of connections terminated for exceeding the limit on outbound frames of types PING, SETTINGS and RST\_STREAM. The limit is configured by setting the
                                                                         `max_outbound_control_frames config setting <envoy_v3_api_field_config.core.v3.Http2ProtocolOptions.max_outbound_control_frames>`{.interpreted-text role="ref"}.

  requests\_rejected\_with\_underscores\_in\_headers   Counter           Total numbers of rejected requests due to header names containing underscores. This action is configured by setting the
                                                                         `headers_with_underscores_action config setting <envoy_v3_api_field_config.core.v3.HttpProtocolOptions.headers_with_underscores_action>`{.interpreted-text role="ref"}.

  rx\_messaging\_error                                 Counter           Total number of invalid received frames that violated [section 8](https://tools.ietf.org/html/rfc7540#section-8) of the HTTP/2 spec. This will result in a *tx\_reset*

  rx\_reset                                            Counter           Total number of reset stream frames received by Envoy

  too\_many\_header\_frames                            Counter           Total number of times an HTTP2 connection is reset due to receiving too many headers frames. Envoy currently supports proxying at most one header frame for 100-Continue one non-100 response code
                                                                         header frame and one frame with trailers

  trailers                                             Counter           Total number of trailers seen on requests coming from downstream

  tx\_flush\_timeout                                   Counter           Total number of `stream idle timeouts <envoy_api_field_config.filter.network.http_connection_manager.v2.HttpConnectionManager.stream_idle_timeout>`{.interpreted-text role="ref"} waiting for open
                                                                         stream window to flush the remainder of a stream

  tx\_reset                                            Counter           Total number of reset stream frames transmitted by Envoy

  streams\_active                                      Gauge             Active streams as observed by the codec

  pending\_send\_bytes                                 Gauge             Currently buffered body data in bytes waiting to be written when stream/connection window is opened.
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

::: {.attention}
::: {.admonition-title}
Attention
:::

The HTTP/2 [streams\_active]{.title-ref} gauge may be greater than the
HTTP connection manager [downstream\_rq\_active]{.title-ref} gauge due
to differences in stream accounting between the codec and the HTTP
connection manager.
:::

Tracing statistics
------------------

Tracing statistics are emitted when tracing decisions are made. All
tracing statistics are rooted at *http.\<stat\_prefix\>.tracing.* with
the following statistics:

  ------------------------------------------------------------------------
  Name               Type              Description
  ------------------ ----------------- -----------------------------------
  random\_sampling   Counter           Total number of traceable decisions
                                       by random sampling

  service\_forced    Counter           Total number of traceable decisions
                                       by server runtime flag
                                       *tracing.global\_enabled*

  client\_enabled    Counter           Total number of traceable decisions
                                       by request header
                                       *x-envoy-force-trace*

  not\_traceable     Counter           Total number of non-traceable
                                       decisions by request id

  health\_check      Counter           Total number of non-traceable
                                       decisions by health check
  ------------------------------------------------------------------------
