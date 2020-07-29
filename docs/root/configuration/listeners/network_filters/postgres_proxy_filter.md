Postgres proxy {#config_network_filters_postgres_proxy}
==============

The Postgres proxy filter decodes the wire protocol between a Postgres
client (downstream) and a Postgres server (upstream). The decoded
information is currently used only to produce Postgres level statistics
like sessions, statements or transactions executed, among others. This
current version does not decode SQL queries. Future versions may add
more statistics and more advanced capabilities. When the Postgres filter
detects that a session is encrypted, the messages are ignored and no
decoding takes place. More information:

-   Postgres
    `architecture overview <arch_overview_postgres>`{.interpreted-text
    role="ref"}

::: {.attention}
::: {.admonition-title}
Attention
:::

The [postgres\_proxy]{.title-ref} filter is experimental and is
currently under active development. Capabilities will be expanded over
time and the configuration structures are likely to change.
:::

::: {.warning}
::: {.admonition-title}
Warning
:::

The [postgreql\_proxy]{.title-ref} filter was tested only with [Postgres
frontend/backend protocol version 3.0](), which was introduced in
Postgres 7.4. Earlier versions are thus not supported. Testing is
limited anyway to not EOL-ed versions.
:::

Configuration
-------------

The Postgres proxy filter should be chained with the TCP proxy as shown
in the configuration example below:

``` {.yaml}
filter_chains:
- filters:
  - name: envoy.filters.network.postgres_proxy
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.postgres_proxy.v3alpha.PostgresProxy
      stat_prefix: postgres
  - name: envoy.tcp_proxy
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy
      stat_prefix: tcp
      cluster: postgres_cluster
```

Statistics {#config_network_filters_postgres_proxy_stats}
----------

Every configured Postgres proxy filter has statistics rooted at
postgres.\<stat\_prefix\> with the following statistics:

  ------------------------------------------------------------------------
  Name                         Type           Description
  ---------------------------- -------------- ----------------------------
  errors                       Counter        Number of times the server
                                              replied with ERROR message

  errors\_error                Counter        Number of times the server
                                              replied with ERROR message
                                              with ERROR severity

  errors\_fatal                Counter        Number of times the server
                                              replied with ERROR message
                                              with FATAL severity

  errors\_panic                Counter        Number of times the server
                                              replied with ERROR message
                                              with PANIC severity

  errors\_unknown              Counter        Number of times the server
                                              replied with ERROR message
                                              but the decoder could not
                                              parse it

  messages                     Counter        Total number of messages
                                              processed by the filter

  messages\_backend            Counter        Total number of backend
                                              messages detected by the
                                              filter

  messages\_frontend           Counter        Number of frontend messages
                                              detected by the filter

  messages\_unknown            Counter        Number of times the filter
                                              successfully decoded a
                                              message but did not know
                                              what to do with it

  sessions                     Counter        Total number of successful
                                              logins

  sessions\_encrypted          Counter        Number of times the filter
                                              detected encrypted sessions

  sessions\_unencrypted        Counter        Number of messages
                                              indicating unencrypted
                                              successful login

  statements                   Counter        Total number of SQL
                                              statements

  statements\_delete           Counter        Number of DELETE statements

  statements\_insert           Counter        Number of INSERT statements

  statements\_select           Counter        Number of SELECT statements

  statements\_update           Counter        Number of UPDATE statements

  statements\_other            Counter        Number of statements other
                                              than DELETE, INSERT, SELECT
                                              or UPDATE

  transactions                 Counter        Total number of SQL
                                              transactions

  transactions\_commit         Counter        Number of COMMIT
                                              transactions

  transactions\_rollback       Counter        Number of ROLLBACK
                                              transactions

  notices                      Counter        Total number of NOTICE
                                              messages

  notices\_notice              Counter        Number of NOTICE messages
                                              with NOTICE subtype

  notices\_log                 Counter        Number of NOTICE messages
                                              with LOG subtype

  notices\_warning             Counter        Number ofr NOTICE messags
                                              with WARNING severity

  notices\_debug               Counter        Number of NOTICE messages
                                              with DEBUG severity

  notices\_info                Counter        Number of NOTICE messages
                                              with INFO severity

  notices\_unknown             Counter        Number of NOTICE messages
                                              which could not be
                                              recognized
  ------------------------------------------------------------------------
