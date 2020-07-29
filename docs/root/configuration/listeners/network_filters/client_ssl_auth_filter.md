Client TLS authentication {#config_network_filters_client_ssl_auth}
=========================

-   Client TLS authentication filter
    `architecture overview <arch_overview_ssl_auth_filter>`{.interpreted-text
    role="ref"}
-   `v3 API reference <envoy_v3_api_msg_extensions.filters.network.client_ssl_auth.v3.ClientSSLAuth>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.network.client\_ssl\_auth*.

Statistics {#config_network_filters_client_ssl_auth_stats}
----------

Every configured client TLS authentication filter has statistics rooted
at *auth.clientssl.\<stat\_prefix\>.* with the following statistics:

  -------------------------------------------------------------------------------
  Name                      Type              Description
  ------------------------- ----------------- -----------------------------------
  update\_success           Counter           Total principal update successes

  update\_failure           Counter           Total principal update failures

  auth\_no\_ssl             Counter           Total connections ignored due to no
                                              TLS

  auth\_ip\_allowlist       Counter           Total connections allowed due to
                                              the IP allowlist

  auth\_digest\_match       Counter           Total connections allowed due to
                                              certificate match

  auth\_digest\_no\_match   Counter           Total connections denied due to no
                                              certificate match

  total\_principals         Gauge             Total loaded principals
  -------------------------------------------------------------------------------

REST API {#config_network_filters_client_ssl_auth_rest_api}
--------
