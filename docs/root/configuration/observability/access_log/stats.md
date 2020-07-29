Statistics {#config_access_log_stats}
==========

Currently only the gRPC and file based access logs have statistics.

gRPC access log statistics
--------------------------

The gRPC access log has statistics rooted at
*access\_logs.grpc\_access\_log.* with the following statistics:

  -----------------------------------------------------------------------
  Name              Type              Description
  ----------------- ----------------- -----------------------------------
  logs\_written     Counter           Total log entries sent to the
                                      logger which were not dropped. This
                                      does not imply the logs have been
                                      flushed to the gRPC endpoint yet.

  logs\_dropped     Counter           Total log entries dropped due to
                                      network or HTTP/2 back up.
  -----------------------------------------------------------------------

File access log statistics
--------------------------

The file access log has statistics rooted at the *filesystem.*
namespace.

  ------------------------------------------------------------------------------
  Name                     Type              Description
  ------------------------ ----------------- -----------------------------------
  write\_buffered          Counter           Total number of times file data is
                                             moved to Envoy\'s internal flush
                                             buffer

  write\_completed         Counter           Total number of times a file was
                                             successfully written

  write\_failed            Counter           Total number of times an error
                                             occurred during a file write
                                             operation

  flushed\_by\_timer       Counter           Total number of times internal
                                             flush buffers are written to a file
                                             due to flush timeout

  reopen\_failed           Counter           Total number of times a file was
                                             failed to be opened

  write\_total\_buffered   Gauge             Current total size of internal
                                             flush buffer in bytes
  ------------------------------------------------------------------------------
