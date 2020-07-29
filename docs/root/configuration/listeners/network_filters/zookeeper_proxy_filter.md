ZooKeeper proxy {#config_network_filters_zookeeper_proxy}
===============

The ZooKeeper proxy filter decodes the client protocol for [Apache
ZooKeeper](https://zookeeper.apache.org/). It decodes the requests,
responses and events in the payload. Most opcodes known in [ZooKeeper
3.5](https://github.com/apache/zookeeper/blob/master/zookeeper-server/src/main/java/org/apache/zookeeper/ZooDefs.java)
are supported. The unsupported ones are related to SASL authentication.

::: {.attention}
::: {.admonition-title}
Attention
:::

The zookeeper\_proxy filter is experimental and is currently under
active development. Capabilities will be expanded over time and the
configuration structures are likely to change.
:::

Configuration {#config_network_filters_zookeeper_proxy_config}
-------------

The ZooKeeper proxy filter should be chained with the TCP proxy filter
as shown in the configuration snippet below:

``` {.yaml}
filter_chains:
- filters:
  - name: envoy.filters.network.zookeeper_proxy
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.zookeeper_proxy.v3.ZooKeeperProxy
      stat_prefix: zookeeper
  - name: envoy.filters.network.tcp_proxy
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy
      stat_prefix: tcp
      cluster: ...
```

Statistics {#config_network_filters_zookeeper_proxy_stats}
----------

Every configured ZooKeeper proxy filter has statistics rooted at
*zookeeper.\<stat\_prefix\>.* with the following statistics:

  ----------------------------------------------------------------------------------
  Name                         Type              Description
  ---------------------------- ----------------- -----------------------------------
  decoder\_error               Counter           Number of times a message wasn\'t
                                                 decoded

  request\_bytes               Counter           Number of bytes in decoded request
                                                 messages

  connect\_rq                  Counter           Number of regular connect
                                                 (non-readonly) requests

  connect\_readonly\_rq        Counter           Number of connect requests with the
                                                 readonly flag set

  ping\_rq                     Counter           Number of ping requests

  auth.\<type\>\_rq            Counter           Number of auth requests for a given
                                                 type

  getdata\_rq                  Counter           Number of getdata requests

  create\_rq                   Counter           Number of create requests

  create2\_rq                  Counter           Number of create2 requests

  setdata\_rq                  Counter           Number of setdata requests

  getchildren\_rq              Counter           Number of getchildren requests

  getchildren2\_rq             Counter           Number of getchildren2 requests

  remove\_rq                   Counter           Number of delete requests

  exists\_rq                   Counter           Number of stat requests

  getacl\_rq                   Counter           Number of getacl requests

  setacl\_rq                   Counter           Number of setacl requests

  sync\_rq                     Counter           Number of sync requests

  multi\_rq                    Counter           Number of multi transaction
                                                 requests

  reconfig\_rq                 Counter           Number of reconfig requests

  close\_rq                    Counter           Number of close requests

  setwatches\_rq               Counter           Number of setwatches requests

  checkwatches\_rq             Counter           Number of checkwatches requests

  removewatches\_rq            Counter           Number of removewatches requests

  check\_rq                    Counter           Number of check requests

  response\_bytes              Counter           Number of bytes in decoded response
                                                 messages

  connect\_resp                Counter           Number of connect responses

  ping\_resp                   Counter           Number of ping responses

  auth\_resp                   Counter           Number of auth responses

  watch\_event                 Counter           Number of watch events fired by the
                                                 server

  getdata\_resp                Counter           Number of getdata responses

  create\_resp                 Counter           Number of create responses

  create2\_resp                Counter           Number of create2 responses

  createcontainer\_resp        Counter           Number of createcontainer responses

  createttl\_resp              Counter           Number of createttl responses

  setdata\_resp                Counter           Number of setdata responses

  getchildren\_resp            Counter           Number of getchildren responses

  getchildren2\_resp           Counter           Number of getchildren2 responses

  getephemerals\_resp          Counter           Number of getephemerals responses

  getallchildrennumber\_resp   Counter           Number of getallchildrennumber
                                                 responses

  remove\_resp                 Counter           Number of remove responses

  exists\_resp                 Counter           Number of exists responses

  getacl\_resp                 Counter           Number of getacl responses

  setacl\_resp                 Counter           Number of setacl responses

  sync\_resp                   Counter           Number of sync responses

  multi\_resp                  Counter           Number of multi responses

  reconfig\_resp               Counter           Number of reconfig responses

  close\_resp                  Counter           Number of close responses

  setauth\_resp                Counter           Number of setauth responses

  setwatches\_resp             Counter           Number of setwatches responses

  checkwatches\_resp           Counter           Number of checkwatches responses

  removewatches\_resp          Counter           Number of removewatches responses

  check\_resp                  Counter           Number of check responses
  ----------------------------------------------------------------------------------

Dynamic Metadata {#config_network_filters_zookeeper_proxy_dynamic_metadata}
----------------

The ZooKeeper filter emits the following dynamic metadata for each
message parsed:

  -----------------------------------------------------------------------------
  Name                    Type              Description
  ----------------------- ----------------- -----------------------------------
  \<path\>                string            The path associated with the
                                            request, response or event

  \<opname\>              string            The opname for the request,
                                            response or event

  \<create\_type\>        string            The string representation of the
                                            flags applied to the znode

  \<bytes\>               string            The size of the request message in
                                            bytes

  \<watch\>               string            True if a watch is being set, false
                                            otherwise

  \<version\>             string            The version parameter, if any,
                                            given with the request

  \<timeout\>             string            The timeout parameter in a connect
                                            response

  \<protocol\_version\>   string            The protocol version in a connect
                                            response

  \<readonly\>            string            The readonly flag in a connect
                                            response

  \<zxid\>                string            The zxid field in a response header

  \<error\>               string            The error field in a response
                                            header

  \<client\_state\>       string            The state field in a watch event

  \<event\_type\>         string            The event type in a a watch event
  -----------------------------------------------------------------------------
