DynamoDB {#config_http_filters_dynamo}
========

-   DynamoDB
    `architecture overview <arch_overview_dynamo>`{.interpreted-text
    role="ref"}
-   `v3 API reference <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpFilter.name>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.http.dynamo*.

Statistics
----------

The DynamoDB filter outputs statistics in the
*http.\<stat\_prefix\>.dynamodb.* namespace. The `stat prefix
<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.stat_prefix>`{.interpreted-text
role="ref"} comes from the owning HTTP connection manager.

Per operation stats can be found in the
*http.\<stat\_prefix\>.dynamodb.operation.\<operation\_name\>.*
namespace.

>   --------------------------------------------------------------------------------
>   Name                       Type              Description
>   -------------------------- ----------------- -----------------------------------
>   upstream\_rq\_total        Counter           Total number of requests with
>                                                \<operation\_name\>
>
>   upstream\_rq\_time         Histogram         Time spent on \<operation\_name\>
>
>   upstream\_rq\_total\_xxx   Counter           Total number of requests with
>                                                \<operation\_name\> per response
>                                                code (503/2xx/etc)
>
>   upstream\_rq\_time\_xxx    Histogram         Time spent on \<operation\_name\>
>                                                per response code (400/3xx/etc)
>   --------------------------------------------------------------------------------
>
Per table stats can be found in the
*http.\<stat\_prefix\>.dynamodb.table.\<table\_name\>.* namespace. Most
of the operations to DynamoDB involve a single table, but BatchGetItem
and BatchWriteItem can include several tables, Envoy tracks per table
stats in this case only if it is the same table used in all operations
from the batch.

>   --------------------------------------------------------------------------------
>   Name                       Type              Description
>   -------------------------- ----------------- -----------------------------------
>   upstream\_rq\_total        Counter           Total number of requests on
>                                                \<table\_name\> table
>
>   upstream\_rq\_time         Histogram         Time spent on \<table\_name\> table
>
>   upstream\_rq\_total\_xxx   Counter           Total number of requests on
>                                                \<table\_name\> table per response
>                                                code (503/2xx/etc)
>
>   upstream\_rq\_time\_xxx    Histogram         Time spent on \<table\_name\> table
>                                                per response code (400/3xx/etc)
>   --------------------------------------------------------------------------------
>
*Disclaimer: Please note that this is a pre-release Amazon DynamoDB
feature that is not yet widely available.* Per partition and operation
stats can be found in the
*http.\<stat\_prefix\>.dynamodb.table.\<table\_name\>.* namespace. For
batch operations, Envoy tracks per partition and operation stats only if
it is the same table used in all operations.

>   -------------------------------------------------------------------------------------------------------------------------------------------------------
>   Name                                                                                              Type              Description
>   ------------------------------------------------------------------------------------------------- ----------------- -----------------------------------
>   capacity.\<operation\_name\>.\_\_partition\_id=\<last\_seven\_characters\_from\_partition\_id\>   Counter           Total number of capacity for
>                                                                                                                       \<operation\_name\> on
>                                                                                                                       \<table\_name\> table for a given
>                                                                                                                       \<partition\_id\>
>
>   -------------------------------------------------------------------------------------------------------------------------------------------------------
>
Additional detailed stats:

-   For 4xx responses and partial batch operation failures, the total
    number of failures for a given table and failure are tracked in the
    *http.\<stat\_prefix\>.dynamodb.error.\<table\_name\>.* namespace.

      -----------------------------------------------------------------------------------
      Name                          Type              Description
      ----------------------------- ----------------- -----------------------------------
      \<error\_type\>               Counter           Total number of specific
                                                      \<error\_type\> for a given
                                                      \<table\_name\>

      BatchFailureUnprocessedKeys   Counter           Total number of partial batch
                                                      failures for a given
                                                      \<table\_name\>
      -----------------------------------------------------------------------------------

Runtime
-------

The DynamoDB filter supports the following runtime settings:

dynamodb.filter\_enabled

:   The % of requests for which the filter is enabled. Default is 100%.
