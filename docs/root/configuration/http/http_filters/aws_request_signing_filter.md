AWS Request Signing {#config_http_filters_aws_request_signing}
===================

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.http.aws_request_signing.v3.AwsRequestSigning>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.http.aws\_request\_signing*.

::: {.attention}
::: {.admonition-title}
Attention
:::

The AWS request signing filter is experimental and is currently under
active development.
:::

The HTTP AWS request signing filter is used to access authenticated AWS
services. It uses the existing AWS Credential Provider to get the
secrets used for generating the required headers.

Example configuration
---------------------

Example filter configuration:

``` {.yaml}
name: envoy.filters.http.aws_request_signing
typed_config:
  "@type": type.googleapis.com/envoy.extensions.filters.http.aws_request_signing.v3.AwsRequestSigning
  service_name: s3
  region: us-west-2
```

Statistics
----------

The AWS request signing filter outputs statistics in the
*http.\<stat\_prefix\>.aws\_request\_signing.* namespace. The
`stat prefix <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.stat_prefix>`{.interpreted-text
role="ref"} comes from the owning HTTP connection manager.

  -----------------------------------------------------------------------
  Name              Type              Description
  ----------------- ----------------- -----------------------------------
  signing\_added    Counter           Total authentication headers added
                                      to requests

  signing\_failed   Counter           Total requests for which a
                                      signature was not added
  -----------------------------------------------------------------------
