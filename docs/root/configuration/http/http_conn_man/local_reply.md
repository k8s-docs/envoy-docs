Local reply modification {#config_http_conn_man_local_reply}
========================

The
`HTTP connection manager <arch_overview_http_conn_man>`{.interpreted-text
role="ref"} supports modification of local reply which is response
returned by Envoy itself.

Features:

-   `Local reply content modification<config_http_conn_man_local_reply_modification>`{.interpreted-text
    role="ref"}.
-   `Local reply format modification<config_http_conn_man_local_reply_format>`{.interpreted-text
    role="ref"}.

Local reply content modification {#config_http_conn_man_local_reply_modification}
--------------------------------

The local response content returned by Envoy can be customized. A list
of
`mappers <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.LocalReplyConfig.mappers>`{.interpreted-text
role="ref"} can be specified. Each mapper must have a
`filter <envoy_v3_api_field_config.accesslog.v3.AccessLog.filter>`{.interpreted-text
role="ref"}. It may have following rewrite rules; a
`status_code <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.ResponseMapper.status_code>`{.interpreted-text
role="ref"} rule to rewrite response code, a
`body <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.ResponseMapper.body>`{.interpreted-text
role="ref"} rule to rewrite the local reply body and a
`body_format_override <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.ResponseMapper.body_format_override>`{.interpreted-text
role="ref"} to specify the response body format. Envoy checks each
[mapper]{.title-ref} according to the specified order until the first
one is matched. If a [mapper]{.title-ref} is matched, all its rewrite
rules will apply.

Example of a LocalReplyConfig

``` {.}
mappers:
- filter:
    status_code_filter:
      comparison:
        op: EQ
        value:
          default_value: 400
          runtime_key: key_b
  status_code: 401
  body:
    inline_string: "not allowed"
```

In above example, if the status\_code is 400, it will be rewritten to
401, the response body will be rewritten to as \"not allowed\".

Local reply format modification {#config_http_conn_man_local_reply_format}
-------------------------------

The response body content type can be customized. If not specified, the
content type is plain/text. There are two [body\_format]{.title-ref}
fields; one is the
`body_format <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.LocalReplyConfig.body_format>`{.interpreted-text
role="ref"} field in the
`LocalReplyConfig <envoy_v3_api_msg_extensions.filters.network.http_connection_manager.v3.LocalReplyConfig>`{.interpreted-text
role="ref"} message and the other
`body_format_override <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.ResponseMapper.body_format_override>`{.interpreted-text
role="ref"} field in the [mapper]{.title-ref}. The latter is only used
when its mapper is matched. The former is used if there is no any
matched mappers, or the matched mapper doesn\'t have the
[body\_format]{.title-ref} specified.

Local reply format can be specified as
`SubstitutionFormatString <envoy_v3_api_msg_config.core.v3.SubstitutionFormatString>`{.interpreted-text
role="ref"}. It supports
`text_format <envoy_v3_api_field_config.core.v3.SubstitutionFormatString.text_format>`{.interpreted-text
role="ref"} and
`json_format <envoy_v3_api_field_config.core.v3.SubstitutionFormatString.json_format>`{.interpreted-text
role="ref"}.

Example of a LocalReplyConfig with [body\_format]{.title-ref} field.

``` {.}
mappers:
- filter:
    status_code_filter:
      comparison:
        op: EQ
        value:
          default_value: 400
          runtime_key: key_b
  status_code: 401
  body_format_override:
    text_format: "%LOCAL_REPLY_BODY% %REQ(:path)%"
- filter:
    status_code_filter:
      comparison:
        op: EQ
        value:
          default_value: 500
          runtime_key: key_b
  status_code: 501
body_format:
  text_format: "%LOCAL_REPLY_BODY% %RESPONSE_CODE%"
```

In above example, there is a [body\_format\_override]{.title-ref} inside
the first [mapper]{.title-ref} with a filter matching [status\_code ==
400]{.title-ref}. It generates the response body in plain text format by
concatenating %LOCAL\_REPLY\_BODY% with the [:path]{.title-ref} request
header. It is only used when the first mapper is matched. There is a
[body\_format]{.title-ref} at the bottom of the config and at the same
level as field [mappers]{.title-ref}. It is used when non of the mappers
is matched or the matched mapper doesn\'t have its own
[body\_format\_override]{.title-ref} specified.
