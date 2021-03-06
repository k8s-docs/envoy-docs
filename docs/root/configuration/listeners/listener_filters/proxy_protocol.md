Proxy Protocol {#config_listener_filters_proxy_protocol}
==============

This listener filter adds support for [HAProxy Proxy
Protocol](https://www.haproxy.org/download/1.9/doc/proxy-protocol.txt).

In this mode, the downstream connection is assumed to come from a proxy
which places the original coordinates (IP, PORT) into a
connection-string. Envoy then extracts these and uses them as the remote
address.

In Proxy Protocol v2 there exists the concept of extensions (TLV) tags
that are optional. If the type of the TLV is added to the filter\'s
configuration, the TLV will be emitted as dynamic metadata with
user-specified key.

This implementation supports both version 1 and version 2, it
automatically determines on a per-connection basis which of the two
versions is present. Note: if the filter is enabled, the Proxy Protocol
must be present on the connection (either version 1 or version 2), the
standard does not allow parsing to determine if it is present or not.

If there is a protocol error or an unsupported address family (e.g.
AF\_UNIX) the connection will be closed and an error thrown.

-   `v3 API reference <envoy_v3_api_field_config.listener.v3.Filter.name>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.listener.proxy\_protocol*.

Statistics
----------

This filter emits the following statistics:

  -------------------------------------------------------------------------------------------
  Name                                  Type              Description
  ------------------------------------- ----------------- -----------------------------------
  downstream\_cx\_proxy\_proto\_error   Counter           Total proxy protocol errors

  -------------------------------------------------------------------------------------------
