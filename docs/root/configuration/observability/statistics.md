Statistics
==========

Server {#server_statistics}
------

Server related statistics are rooted at *server.* with following
statistics:

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Name                                 Type              Description
  ------------------------------------ ----------------- ------------------------------------------------------------------------------------------------------------------------------------
  uptime                               Gauge             Current server uptime in seconds

  concurrency                          Gauge             Number of worker threads

  memory\_allocated                    Gauge             Current amount of allocated memory in bytes. Total of both new and old Envoy processes on hot restart.

  memory\_heap\_size                   Gauge             Current reserved heap size in bytes. New Envoy process heap size on hot restart.

  memory\_physical\_size               Gauge             Current estimate of total bytes of the physical memory. New Envoy process physical memory size on hot restart.

  live                                 Gauge             1 if the server is not currently draining, 0 otherwise

  state                                Gauge             Current `State <envoy_v3_api_field_admin.v3.ServerInfo.state>`{.interpreted-text role="ref"} of the Server.

  parent\_connections                  Gauge             Total connections of the old Envoy process on hot restart

  total\_connections                   Gauge             Total connections of both new and old Envoy processes

  version                              Gauge             Integer represented version number based on SCM revision or
                                                         `stats_server_version_override <envoy_v3_api_field_config.bootstrap.v3.Bootstrap.stats_server_version_override>`{.interpreted-text
                                                         role="ref"} if set.

  days\_until\_first\_cert\_expiring   Gauge             Number of days until the next certificate being managed will expire

  hot\_restart\_epoch                  Gauge             Current hot restart epoch \-- an integer passed via command line flag [\--restart-epoch]{.title-ref} usually indicating generation.

  hot\_restart\_generation             Gauge             Current hot restart generation \-- like hot\_restart\_epoch but computed automatically by incrementing from parent.

  initialization\_time\_ms             Histogram         Total time taken for Envoy initialization in milliseconds. This is the time from server start-up until the worker threads are ready
                                                         to accept new connections

  debug\_assertion\_failures           Counter           Number of debug assertion failures detected in a release build if compiled with [\--define
                                                         log\_debug\_assert\_in\_release=enabled]{.title-ref} or zero otherwise

  envoy\_bug\_failures                 Counter           Number of envoy bug failures detected in a release build. File or report the issue if this increments as this may be serious.

  static\_unknown\_fields              Counter           Number of messages in static configuration with unknown fields

  dynamic\_unknown\_fields             Counter           Number of messages in dynamic configuration with unknown fields
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
