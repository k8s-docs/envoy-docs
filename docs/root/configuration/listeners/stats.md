Statistics {#config_listener_stats}
==========

Listener
--------

Every listener has a statistics tree rooted at *listener.\<address\>.*
with the following statistics:

  ------------------------------------------------------------------------------------
  Name                           Type              Description
  ------------------------------ ----------------- -----------------------------------
  downstream\_cx\_total          Counter           Total connections

  downstream\_cx\_destroy        Counter           Total destroyed connections

  downstream\_cx\_active         Gauge             Total active connections

  downstream\_cx\_length\_ms     Histogram         Connection length milliseconds

  downstream\_cx\_overflow       Counter           Total connections rejected due to
                                                   enforcement of listener connection
                                                   limit

  downstream\_pre\_cx\_timeout   Counter           Sockets that timed out during
                                                   listener filter processing

  downstream\_pre\_cx\_active    Gauge             Sockets currently undergoing
                                                   listener filter processing

  global\_cx\_overflow           Counter           Total connections rejected due to
                                                   enforecement of the global
                                                   connection limit

  no\_filter\_chain\_match       Counter           Total connections that didn\'t
                                                   match any filter chain

  ssl.connection\_error          Counter           Total TLS connection errors not
                                                   including failed certificate
                                                   verifications

  ssl.handshake                  Counter           Total successful TLS connection
                                                   handshakes

  ssl.session\_reused            Counter           Total successful TLS session
                                                   resumptions

  ssl.no\_certificate            Counter           Total successful TLS connections
                                                   with no client certificate

  ssl.fail\_verify\_no\_cert     Counter           Total TLS connections that failed
                                                   because of missing client
                                                   certificate

  ssl.fail\_verify\_error        Counter           Total TLS connections that failed
                                                   CA verification

  ssl.fail\_verify\_san          Counter           Total TLS connections that failed
                                                   SAN verification

  ssl.fail\_verify\_cert\_hash   Counter           Total TLS connections that failed
                                                   certificate pinning verification

  ssl.ciphers.\<cipher\>         Counter           Total successful TLS connections
                                                   that used cipher \<cipher\>

  ssl.curves.\<curve\>           Counter           Total successful TLS connections
                                                   that used ECDHE curve \<curve\>

  ssl.sigalgs.\<sigalg\>         Counter           Total successful TLS connections
                                                   that used signature algorithm
                                                   \<sigalg\>

  ssl.versions.\<version\>       Counter           Total successful TLS connections
                                                   that used protocol version
                                                   \<version\>
  ------------------------------------------------------------------------------------

Per-handler Listener Stats {#config_listener_stats_per_handler}
--------------------------

Every listener additionally has a statistics tree rooted at
*listener.\<address\>.\<handler\>.* which contains *per-handler*
statistics. As described in the
`threading model <arch_overview_threading>`{.interpreted-text
role="ref"} documentation, Envoy has a threading model which includes
the *main thread* as well as a number of *worker threads* which are
controlled by the `--concurrency`{.interpreted-text role="option"}
option. Along these lines, *\<handler\>* is equal to *main\_thread*,
*worker\_0*, *worker\_1*, etc. These statistics can be used to look for
per-handler/worker imbalance on either accepted or active connections.

  ------------------------------------------------------------------------------
  Name                     Type              Description
  ------------------------ ----------------- -----------------------------------
  downstream\_cx\_total    Counter           Total connections on this handler.

  downstream\_cx\_active   Gauge             Total active connections on this
                                             handler.
  ------------------------------------------------------------------------------

Listener manager {#config_listener_manager_stats}
----------------

The listener manager has a statistics tree rooted at
*listener\_manager.* with the following statistics. Any `:` character in
the stats name is replaced with `_`.

  ---------------------------------------------------------------------------------------
  Name                              Type              Description
  --------------------------------- ----------------- -----------------------------------
  listener\_added                   Counter           Total listeners added (either via
                                                      static config or LDS).

  listener\_modified                Counter           Total listeners modified (via LDS).

  listener\_removed                 Counter           Total listeners removed (via LDS).

  listener\_stopped                 Counter           Total listeners stopped.

  listener\_create\_success         Counter           Total listener objects successfully
                                                      added to workers.

  listener\_create\_failure         Counter           Total failed listener object
                                                      additions to workers.

  listener\_in\_place\_updated      Counter           Total listener objects created to
                                                      execute filter chain update path.

  total\_filter\_chains\_draining   Gauge             Number of currently draining filter
                                                      chains.

  total\_listeners\_warming         Gauge             Number of currently warming
                                                      listeners.

  total\_listeners\_active          Gauge             Number of currently active
                                                      listeners.

  total\_listeners\_draining        Gauge             Number of currently draining
                                                      listeners.

  workers\_started                  Gauge             A boolean (1 if started and 0
                                                      otherwise) that indicates whether
                                                      listeners have been initialized on
                                                      workers.
  ---------------------------------------------------------------------------------------
