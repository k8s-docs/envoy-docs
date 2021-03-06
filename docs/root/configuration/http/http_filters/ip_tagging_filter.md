IP Tagging {#config_http_filters_ip_tagging}
==========

The HTTP IP Tagging filter sets the header *x-envoy-ip-tags* with the
string tags for the trusted address from
`x-forwarded-for <config_http_conn_man_headers_x-forwarded-for>`{.interpreted-text
role="ref"}. If there are no tags for an address, the header is not set.

The implementation for IP Tagging provides a scalable way to compare an
IP address to a large list of CIDR ranges efficiently. The underlying
algorithm for storing tags and IP address subnets is a Level-Compressed
trie described in the paper [IP-address lookup using
LC-tries](https://www.nada.kth.se/~snilsson/publications/IP-address-lookup-using-LC-tries/)
by S. Nilsson and G. Karlsson.

Configuration
-------------

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.http.ip_tagging.v3.IPTagging>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.http.ip\_tagging*.

Statistics
----------

The IP Tagging filter outputs statistics in the
*http.\<stat\_prefix\>.ip\_tagging.* namespace. The stat prefix comes
from the owning HTTP connection manager.

  -------------------------------------------------------------------------
  Name                Type              Description
  ------------------- ----------------- -----------------------------------
  \<tag\_name\>.hit   Counter           Total number of requests that have
                                        the \<tag\_name\> applied to it

  no\_hit             Counter           Total number of requests with no
                                        applicable IP tags

  total               Counter           Total number of requests the IP
                                        Tagging Filter operated on
  -------------------------------------------------------------------------

Runtime
-------

The IP Tagging filter supports the following runtime settings:

ip\_tagging.http\_filter\_enabled

:   The % of requests for which the filter is enabled. Default is 100.
