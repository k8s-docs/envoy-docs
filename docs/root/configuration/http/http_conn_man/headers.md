HTTP header manipulation {#config_http_conn_man_headers}
========================

The HTTP connection manager manipulates several HTTP headers both during
decoding (when the request is being received) as well as during encoding
(when the response is being sent).

::: {.contents local=""}
:::

user-agent {#config_http_conn_man_headers_user-agent}
----------

The *user-agent* header may be set by the connection manager during
decoding if the `add_user_agent
<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.add_user_agent>`{.interpreted-text
role="ref"} option is enabled. The header is only modified if it is not
already set. If the connection manager does set the header, the value is
determined by the `--service-cluster`{.interpreted-text role="option"}
command line option.

server {#config_http_conn_man_headers_server}
------

The *server* header will be set during encoding to the value in the
`server_name
<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.server_name>`{.interpreted-text
role="ref"} option.

x-client-trace-id {#config_http_conn_man_headers_x-client-trace-id}
-----------------

If an external client sets this header, Envoy will join the provided
trace ID with the internally generated
`config_http_conn_man_headers_x-request-id`{.interpreted-text
role="ref"}. x-client-trace-id needs to be globally unique and
generating a uuid4 is recommended. If this header is set, it has similar
effect to
`config_http_conn_man_headers_x-envoy-force-trace`{.interpreted-text
role="ref"}. See the `tracing.client_enabled
<config_http_conn_man_runtime_client_enabled>`{.interpreted-text
role="ref"} runtime configuration setting.

x-envoy-downstream-service-cluster {#config_http_conn_man_headers_downstream-service-cluster}
----------------------------------

Internal services often want to know which service is calling them. This
header is cleaned from external requests, but for internal requests will
contain the service cluster of the caller. Note that in the current
implementation, this should be considered a hint as it is set by the
caller and could be easily spoofed by any internal entity. In the future
Envoy will support a mutual authentication TLS mesh which will make this
header fully secure. Like *user-agent*, the value is determined by the
`--service-cluster`{.interpreted-text role="option"} command line
option. In order to enable this feature you need to set the
`user_agent <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.add_user_agent>`{.interpreted-text
role="ref"} option to true.

x-envoy-downstream-service-node {#config_http_conn_man_headers_downstream-service-node}
-------------------------------

Internal services may want to know the downstream node request comes
from. This header is quite similar to
`config_http_conn_man_headers_downstream-service-cluster`{.interpreted-text
role="ref"}, except the value is taken from the
`--service-node`{.interpreted-text role="option"} option.

x-envoy-external-address {#config_http_conn_man_headers_x-envoy-external-address}
------------------------

It is a common case where a service wants to perform analytics based on
the origin client\'s IP address. Per the lengthy discussion on
`XFF <config_http_conn_man_headers_x-forwarded-for>`{.interpreted-text
role="ref"}, this can get quite complicated, so Envoy simplifies this by
setting *x-envoy-external-address* to the
`trusted client address <config_http_conn_man_headers_x-forwarded-for_trusted_client_address>`{.interpreted-text
role="ref"} if the request is from an external client.
*x-envoy-external-address* is not set or overwritten for internal
requests. This header can be safely forwarded between internal services
for analytics purposes without having to deal with the complexities of
XFF.

x-envoy-force-trace {#config_http_conn_man_headers_x-envoy-force-trace}
-------------------

If an internal request sets this header, Envoy will modify the generated
`config_http_conn_man_headers_x-request-id`{.interpreted-text
role="ref"} such that it forces traces to be collected. This also forces
`config_http_conn_man_headers_x-request-id`{.interpreted-text
role="ref"} to be returned in the response headers. If this request ID
is then propagated to other hosts, traces will also be collected on
those hosts which will provide a consistent trace for an entire request
flow. See the
`tracing.global_enabled <config_http_conn_man_runtime_global_enabled>`{.interpreted-text
role="ref"} and
`tracing.random_sampling <config_http_conn_man_runtime_random_sampling>`{.interpreted-text
role="ref"} runtime configuration settings.

x-envoy-internal {#config_http_conn_man_headers_x-envoy-internal}
----------------

It is a common case where a service wants to know whether a request is
internal origin or not. Envoy uses
`XFF <config_http_conn_man_headers_x-forwarded-for>`{.interpreted-text
role="ref"} to determine this and then will set the header value to
*true*.

This is a convenience to avoid having to parse and understand XFF.

x-envoy-original-dst-host {#config_http_conn_man_headers_x-envoy-original-dst-host}
-------------------------

The header used to override destination address when using the
`Original Destination <arch_overview_load_balancing_types_original_destination>`{.interpreted-text
role="ref"} load balancing policy.

It is ignored, unless the use of it is enabled via
`use_http_header <envoy_v3_api_field_config.cluster.v3.Cluster.OriginalDstLbConfig.use_http_header>`{.interpreted-text
role="ref"}.

x-forwarded-client-cert {#config_http_conn_man_headers_x-forwarded-client-cert}
-----------------------

*x-forwarded-client-cert* (XFCC) is a proxy header which indicates
certificate information of part or all of the clients or proxies that a
request has flowed through, on its way from the client to the server. A
proxy may choose to sanitize/append/forward the XFCC header before
proxying the request.

The XFCC header value is a comma (\",\") separated string. Each
substring is an XFCC element, which holds information added by a single
proxy. A proxy can append the current client certificate information as
an XFCC element, to the end of the request\'s XFCC header after a comma.

Each XFCC element is a semicolon \";\" separated string. Each substring
is a key-value pair, grouped together by an equals (\"=\") sign. The
keys are case-insensitive, the values are case-sensitive. If \",\",
\";\" or \"=\" appear in a value, the value should be double-quoted.
Double-quotes in the value should be replaced by backslash-double-quote
(\").

The following keys are supported:

1.  `By` The Subject Alternative Name (URI type) of the current proxy\'s
    certificate.
2.  `Hash` The SHA 256 digest of the current client certificate.
3.  `Cert` The entire client certificate in URL encoded PEM format.
4.  `Chain` The entire client certificate chain (including the leaf
    certificate) in URL encoded PEM format.
5.  `Subject` The Subject field of the current client certificate. The
    value is always double-quoted.
6.  `URI` The URI type Subject Alternative Name field of the current
    client certificate.
7.  `DNS` The DNS type Subject Alternative Name field of the current
    client certificate. A client certificate may contain multiple DNS
    type Subject Alternative Names, each will be a separate key-value
    pair.

A client certificate may contain multiple Subject Alternative Name
types. For details on different Subject Alternative Name types, please
refer [RFC 2459](https://tools.ietf.org/html/rfc2459#section-4.2.1.7).

Some examples of the XFCC header are:

1.  For one client certificate with only URI type Subject Alternative
    Name:
    `x-forwarded-client-cert: By=http://frontend.lyft.com;Hash=468ed33be74eee6556d90c0149c1309e9ba61d6425303443c0748a02dd8de688;Subject="/C=US/ST=CA/L=San Francisco/OU=Lyft/CN=Test Client";URI=http://testclient.lyft.com`
2.  For two client certificates with only URI type Subject Alternative
    Name:
    `x-forwarded-client-cert: By=http://frontend.lyft.com;Hash=468ed33be74eee6556d90c0149c1309e9ba61d6425303443c0748a02dd8de688;URI=http://testclient.lyft.com,By=http://backend.lyft.com;Hash=9ba61d6425303443c0748a02dd8de688468ed33be74eee6556d90c0149c1309e;URI=http://frontend.lyft.com`
3.  For one client certificate with both URI type and DNS type Subject
    Alternative Name:
    `x-forwarded-client-cert: By=http://frontend.lyft.com;Hash=468ed33be74eee6556d90c0149c1309e9ba61d6425303443c0748a02dd8de688;Subject="/C=US/ST=CA/L=San Francisco/OU=Lyft/CN=Test Client";URI=http://testclient.lyft.com;DNS=lyft.com;DNS=www.lyft.com`

How Envoy processes XFCC is specified by the
`forward_client_cert_details<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.forward_client_cert_details>`{.interpreted-text
role="ref"} and the
`set_current_client_cert_details<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.set_current_client_cert_details>`{.interpreted-text
role="ref"} HTTP connection manager options. If
*forward\_client\_cert\_details* is unset, the XFCC header will be
sanitized by default.

x-forwarded-for {#config_http_conn_man_headers_x-forwarded-for}
---------------

*x-forwarded-for* (XFF) is a standard proxy header which indicates the
IP addresses that a request has flowed through on its way from the
client to the server. A compliant proxy will *append* the IP address of
the nearest client to the XFF list before proxying the request. Some
examples of XFF are:

1.  `x-forwarded-for: 50.0.0.1` (single client)
2.  `x-forwarded-for: 50.0.0.1, 40.0.0.1` (external proxy hop)
3.  `x-forwarded-for: 50.0.0.1, 10.0.0.1` (internal proxy hop)

Envoy will only append to XFF if the `use_remote_address
<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.use_remote_address>`{.interpreted-text
role="ref"} HTTP connection manager option is set to true and the
`skip_xff_append
<envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.skip_xff_append>`{.interpreted-text
role="ref"} is set false. This means that if *use\_remote\_address* is
false (which is the default) or *skip\_xff\_append* is true, the
connection manager operates in a transparent mode where it does not
modify XFF.

::: {.attention}
::: {.admonition-title}
Attention
:::

In general, *use\_remote\_address* should be set to true when Envoy is
deployed as an edge node (aka a front proxy), whereas it may need to be
set to false when Envoy is used as an internal service node in a mesh
deployment.
:::

::: {#config_http_conn_man_headers_x-forwarded-for_trusted_client_address}
The value of *use\_remote\_address* controls how Envoy determines the
*trusted client address*. Given an HTTP request that has traveled
through a series of zero or more proxies to reach Envoy, the trusted
client address is the earliest source IP address that is known to be
accurate. The source IP address of the immediate downstream node\'s
connection to Envoy is trusted. XFF *sometimes* can be trusted.
Malicious clients can forge XFF, but the last address in XFF can be
trusted if it was put there by a trusted proxy.
:::

Envoy\'s default rules for determining the trusted client address
(*before* appending anything to XFF) are:

-   If *use\_remote\_address* is false and an XFF containing at least
    one IP address is present in the request, the trusted client address
    is the *last* (rightmost) IP address in XFF.
-   Otherwise, the trusted client address is the source IP address of
    the immediate downstream node\'s connection to Envoy.

In an environment where there are one or more trusted proxies in front
of an edge Envoy instance, the *xff\_num\_trusted\_hops* configuration
option can be used to trust additional addresses from XFF:

-   If *use\_remote\_address* is false and *xff\_num\_trusted\_hops* is
    set to a value *N* that is greater than zero, the trusted client
    address is the (N+1)th address from the right end of XFF. (If the
    XFF contains fewer than N+1 addresses, Envoy falls back to using the
    immediate downstream connection\'s source address as trusted client
    address.)
-   If *use\_remote\_address* is true and *xff\_num\_trusted\_hops* is
    set to a value *N* that is greater than zero, the trusted client
    address is the Nth address from the right end of XFF. (If the XFF
    contains fewer than N addresses, Envoy falls back to using the
    immediate downstream connection\'s source address as trusted client
    address.)

Envoy uses the trusted client address contents to determine whether a
request originated externally or internally. This influences whether the
`config_http_conn_man_headers_x-envoy-internal`{.interpreted-text
role="ref"} header is set.

Example 1: Envoy as edge proxy, without a trusted proxy in front of it

:   

    Settings:

    :   | use\_remote\_address = true
        | xff\_num\_trusted\_hops = 0

    Request details:

    :   | Downstream IP address = 192.0.2.5
        | XFF = \"203.0.113.128, 203.0.113.10, 203.0.113.1\"

    Result:

    :   | Trusted client address = 192.0.2.5 (XFF is ignored)
        | X-Envoy-External-Address is set to 192.0.2.5
        | XFF is changed to \"203.0.113.128, 203.0.113.10, 203.0.113.1,
          192.0.2.5\"
        | X-Envoy-Internal is removed (if it was present in the incoming
          request)

Example 2: Envoy as internal proxy, with the Envoy edge proxy from Example 1 in front of it

:   

    Settings:

    :   | use\_remote\_address = false
        | xff\_num\_trusted\_hops = 0

    Request details:

    :   | Downstream IP address = 10.11.12.13 (address of the Envoy edge
          proxy)
        | XFF = \"203.0.113.128, 203.0.113.10, 203.0.113.1, 192.0.2.5\"

    Result:

    :   | Trusted client address = 192.0.2.5 (last address in XFF is
          trusted)
        | X-Envoy-External-Address is not modified
        | X-Envoy-Internal is removed (if it was present in the incoming
          request)

Example 3: Envoy as edge proxy, with two trusted external proxies in front of it

:   

    Settings:

    :   | use\_remote\_address = true
        | xff\_num\_trusted\_hops = 2

    Request details:

    :   | Downstream IP address = 192.0.2.5
        | XFF = \"203.0.113.128, 203.0.113.10, 203.0.113.1\"

    Result:

    :   | Trusted client address = 203.0.113.10 (2nd to last address in
          XFF is trusted)
        | X-Envoy-External-Address is set to 203.0.113.10
        | XFF is changed to \"203.0.113.128, 203.0.113.10, 203.0.113.1,
          192.0.2.5\"
        | X-Envoy-Internal is removed (if it was present in the incoming
          request)

Example 4: Envoy as internal proxy, with the edge proxy from Example 3 in front of it

:   

    Settings:

    :   | use\_remote\_address = false
        | xff\_num\_trusted\_hops = 2

    Request details:

    :   | Downstream IP address = 10.11.12.13 (address of the Envoy edge
          proxy)
        | XFF = \"203.0.113.128, 203.0.113.10, 203.0.113.1, 192.0.2.5\"

    Result:

    :   | Trusted client address = 203.0.113.10
        | X-Envoy-External-Address is not modified
        | X-Envoy-Internal is removed (if it was present in the incoming
          request)

Example 5: Envoy as an internal proxy, receiving a request from an internal client

:   

    Settings:

    :   | use\_remote\_address = false
        | xff\_num\_trusted\_hops = 0

    Request details:

    :   | Downstream IP address = 10.20.30.40 (address of the internal
          client)
        | XFF is not present

    Result:

    :   | Trusted client address = 10.20.30.40
        | X-Envoy-External-Address remains unset
        | X-Envoy-Internal is set to \"false\"

Example 6: The internal Envoy from Example 5, receiving a request proxied by another Envoy

:   

    Settings:

    :   | use\_remote\_address = false
        | xff\_num\_trusted\_hops = 0

    Request details:

    :   | Downstream IP address = 10.20.30.50 (address of the Envoy
          instance proxying to this one)
        | XFF = \"10.20.30.40\"

    Result:

    :   | Trusted client address = 10.20.30.40
        | X-Envoy-External-Address remains unset
        | X-Envoy-Internal is set to \"true\"

A few very important notes about XFF:

1.  If *use\_remote\_address* is set to true, Envoy sets the
    `config_http_conn_man_headers_x-envoy-external-address`{.interpreted-text
    role="ref"} header to the trusted client address.

::: {#config_http_conn_man_headers_x-forwarded-for_internal_origin}
2.  XFF is what Envoy uses to determine whether a request is internal
    origin or external origin. If *use\_remote\_address* is set to true,
    the request is internal if and only if the request contains no XFF
    and the immediate downstream node\'s connection to Envoy has an
    internal (RFC1918 or RFC4193) source address. If
    *use\_remote\_address* is false, the request is internal if and only
    if XFF contains a single RFC1918 or RFC4193 address.
    -   **NOTE**: If an internal service proxies an external request to
        another internal service, and includes the original XFF header,
        Envoy will append to it on egress if
        `use_remote_address <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.use_remote_address>`{.interpreted-text
        role="ref"} is set. This will cause the other side to think the
        request is external. Generally, this is what is intended if XFF
        is being forwarded. If it is not intended, do not forward XFF,
        and forward
        `config_http_conn_man_headers_x-envoy-internal`{.interpreted-text
        role="ref"} instead.
    -   **NOTE**: If an internal service call is forwarded to another
        internal service (preserving XFF), Envoy will not consider it
        internal. This is a known \"bug\" due to the simplification of
        how XFF is parsed to determine if a request is internal. In this
        scenario, do not forward XFF and allow Envoy to generate a new
        one with a single internal origin IP.
:::

x-forwarded-proto {#config_http_conn_man_headers_x-forwarded-proto}
-----------------

It is a common case where a service wants to know what the originating
protocol (HTTP or HTTPS) was of the connection terminated by front/edge
Envoy. *x-forwarded-proto* contains this information. It will be set to
either *http* or *https*.

x-request-id {#config_http_conn_man_headers_x-request-id}
------------

The *x-request-id* header is used by Envoy to uniquely identify a
request as well as perform stable access logging and tracing. Envoy will
generate an *x-request-id* header for all external origin requests (the
header is sanitized). It will also generate an *x-request-id* header for
internal requests that do not already have one. This means that
*x-request-id* can and should be propagated between client applications
in order to have stable IDs across the entire mesh. Due to the out of
process architecture of Envoy, the header can not be automatically
forwarded by Envoy itself. This is one of the few areas where a thin
client library is needed to perform this duty. How that is done is out
of scope for this documentation. If *x-request-id* is propagated across
all hosts, the following features are available:

-   Stable `access logging <config_access_log>`{.interpreted-text
    role="ref"} via the
    `v3 API runtime filter<envoy_v3_api_field_config.accesslog.v3.AccessLogFilter.runtime_filter>`{.interpreted-text
    role="ref"}.
-   Stable tracing when performing random sampling via the
    `tracing.random_sampling
    <config_http_conn_man_runtime_random_sampling>`{.interpreted-text
    role="ref"} runtime setting or via forced tracing using the
    `config_http_conn_man_headers_x-envoy-force-trace`{.interpreted-text
    role="ref"} and
    `config_http_conn_man_headers_x-client-trace-id`{.interpreted-text
    role="ref"} headers.

x-ot-span-context {#config_http_conn_man_headers_x-ot-span-context}
-----------------

The *x-ot-span-context* HTTP header is used by Envoy to establish proper
parent-child relationships between tracing spans when used with the
LightStep tracer. For example, an egress span is a child of an ingress
span (if the ingress span was present). Envoy injects the
*x-ot-span-context* header on ingress requests and forwards it to the
local service. Envoy relies on the application to propagate
*x-ot-span-context* on the egress call to an upstream. See more on
tracing `here <arch_overview_tracing>`{.interpreted-text role="ref"}.

x-b3-traceid {#config_http_conn_man_headers_x-b3-traceid}
------------

The *x-b3-traceid* HTTP header is used by the Zipkin tracer in Envoy.
The TraceId is 64-bit in length and indicates the overall ID of the
trace. Every span in a trace shares this ID. See more on zipkin tracing
[here](https://github.com/openzipkin/b3-propagation).

x-b3-spanid {#config_http_conn_man_headers_x-b3-spanid}
-----------

The *x-b3-spanid* HTTP header is used by the Zipkin tracer in Envoy. The
SpanId is 64-bit in length and indicates the position of the current
operation in the trace tree. The value should not be interpreted: it may
or may not be derived from the value of the TraceId. See more on zipkin
tracing [here](https://github.com/openzipkin/b3-propagation).

x-b3-parentspanid {#config_http_conn_man_headers_x-b3-parentspanid}
-----------------

The *x-b3-parentspanid* HTTP header is used by the Zipkin tracer in
Envoy. The ParentSpanId is 64-bit in length and indicates the position
of the parent operation in the trace tree. When the span is the root of
the trace tree, the ParentSpanId is absent. See more on zipkin tracing
[here](https://github.com/openzipkin/b3-propagation).

x-b3-sampled {#config_http_conn_man_headers_x-b3-sampled}
------------

The *x-b3-sampled* HTTP header is used by the Zipkin tracer in Envoy.
When the Sampled flag is either not specified or set to 1, the span will
be reported to the tracing system. Once Sampled is set to 0 or 1, the
same value should be consistently sent downstream. See more on zipkin
tracing [here](https://github.com/openzipkin/b3-propagation).

x-b3-flags {#config_http_conn_man_headers_x-b3-flags}
----------

The *x-b3-flags* HTTP header is used by the Zipkin tracer in Envoy. The
encode one or more options. For example, Debug is encoded as
`X-B3-Flags: 1`. See more on zipkin tracing
[here](https://github.com/openzipkin/b3-propagation).

b3 {#config_http_conn_man_headers_b3}
--

The *b3* HTTP header is used by the Zipkin tracer in Envoy. Is a more
compressed header format. See more on zipkin tracing
[here](https://github.com/openzipkin/b3-propagation#single-header).

x-datadog-trace-id {#config_http_conn_man_headers_x-datadog-trace-id}
------------------

The *x-datadog-trace-id* HTTP header is used by the Datadog tracer in
Envoy. The 64-bit value represents the ID of the overall trace, and is
used to correlate the spans.

x-datadog-parent-id {#config_http_conn_man_headers_x-datadog-parent-id}
-------------------

The *x-datadog-parent-id* HTTP header is used by the Datadog tracer in
Envoy. The 64-bit value uniquely identifies the span within the trace,
and is used to create parent-child relationships between spans.

x-datadog-sampling-priority {#config_http_conn_man_headers_x-datadog-sampling-priority}
---------------------------

The *x-datadog-sampling-priority* HTTP header is used by the Datadog
tracer in Envoy. The integer value indicates the sampling decision that
has been made for this trace. A value of 0 indicates that the trace
should not be collected, and a value of 1 requests that spans are
sampled and reported.

Custom request/response headers {#config_http_conn_man_headers_custom_request_headers}
-------------------------------

Custom request/response headers can be added to a request/response at
the weighted cluster, route, virtual host, and/or global route
configuration level. See the
`v3 <envoy_v3_api_msg_config.route.v3.RouteConfiguration>`{.interpreted-text
role="ref"} API documentation.

No *:-prefixed* pseudo-header may be modified via this mechanism. The
*:path* and *:authority* headers may instead be modified via mechanisms
such as
`prefix_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.prefix_rewrite>`{.interpreted-text
role="ref"},
`regex_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.regex_rewrite>`{.interpreted-text
role="ref"}, and
`host_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.host_rewrite_literal>`{.interpreted-text
role="ref"}.

Headers are appended to requests/responses in the following order:
weighted cluster level headers, route level headers, virtual host level
headers and finally global level headers.

Envoy supports adding dynamic values to request and response headers.
The percent symbol (%) is used to delimit variable names.

::: {.attention}
::: {.admonition-title}
Attention
:::

If a literal percent symbol (%) is desired in a request/response header,
it must be escaped by doubling it. For example, to emit a header with
the value `100%`, the custom header value in the Envoy configuration
must be `100%%`.
:::

Supported variable names are:

%DOWNSTREAM\_REMOTE\_ADDRESS%

:   Remote address of the downstream connection. If the address is an IP
    address it includes both address and port.

    ::: {.note}
    ::: {.admonition-title}
    Note
    :::

    This may not be the physical remote address of the peer if the
    address has been inferred from
    `proxy proto <envoy_v3_api_field_config.listener.v3.FilterChain.use_proxy_proto>`{.interpreted-text
    role="ref"} or `x-forwarded-for
    <config_http_conn_man_headers_x-forwarded-for>`{.interpreted-text
    role="ref"}.
    :::

%DOWNSTREAM\_REMOTE\_ADDRESS\_WITHOUT\_PORT%

:   Same as **%DOWNSTREAM\_REMOTE\_ADDRESS%** excluding port if the
    address is an IP address.

%DOWNSTREAM\_LOCAL\_ADDRESS%

:   Local address of the downstream connection. If the address is an IP
    address it includes both address and port. If the original
    connection was redirected by iptables REDIRECT, this represents the
    original destination address restored by the
    `Original Destination Filter <config_listener_filters_original_dst>`{.interpreted-text
    role="ref"} using SO\_ORIGINAL\_DST socket option. If the original
    connection was redirected by iptables TPROXY, and the listener\'s
    transparent option was set to true, this represents the original
    destination address and port.

%DOWNSTREAM\_LOCAL\_ADDRESS\_WITHOUT\_PORT%

:   Same as **%DOWNSTREAM\_LOCAL\_ADDRESS%** excluding port if the
    address is an IP address.

%DOWNSTREAM\_LOCAL\_PORT%

:   Similar to **%DOWNSTREAM\_LOCAL\_ADDRESS\_WITHOUT\_PORT%**, but only
    extracts the port portion of the **%DOWNSTREAM\_LOCAL\_ADDRESS%**

%DOWNSTREAM\_LOCAL\_URI\_SAN%

:   

    HTTP

    :   The URIs present in the SAN of the local certificate used to
        establish the downstream TLS connection.

    TCP

    :   The URIs present in the SAN of the local certificate used to
        establish the downstream TLS connection.

%DOWNSTREAM\_PEER\_URI\_SAN%

:   

    HTTP

    :   The URIs present in the SAN of the peer certificate used to
        establish the downstream TLS connection.

    TCP

    :   The URIs present in the SAN of the peer certificate used to
        establish the downstream TLS connection.

%DOWNSTREAM\_LOCAL\_SUBJECT%

:   

    HTTP

    :   The subject present in the local certificate used to establish
        the downstream TLS connection.

    TCP

    :   The subject present in the local certificate used to establish
        the downstream TLS connection.

%DOWNSTREAM\_PEER\_SUBJECT%

:   

    HTTP

    :   The subject present in the peer certificate used to establish
        the downstream TLS connection.

    TCP

    :   The subject present in the peer certificate used to establish
        the downstream TLS connection.

%DOWNSTREAM\_PEER\_ISSUER%

:   

    HTTP

    :   The issuer present in the peer certificate used to establish the
        downstream TLS connection.

    TCP

    :   The issuer present in the peer certificate used to establish the
        downstream TLS connection.

%DOWNSTREAM\_TLS\_SESSION\_ID%

:   

    HTTP

    :   The session ID for the established downstream TLS connection.

    TCP

    :   The session ID for the established downstream TLS connection.

%DOWNSTREAM\_TLS\_CIPHER%

:   

    HTTP

    :   The OpenSSL name for the set of ciphers used to establish the
        downstream TLS connection.

    TCP

    :   The OpenSSL name for the set of ciphers used to establish the
        downstream TLS connection.

%DOWNSTREAM\_TLS\_VERSION%

:   

    HTTP

    :   The TLS version (e.g., `TLSv1.2`, `TLSv1.3`) used to establish
        the downstream TLS connection.

    TCP

    :   The TLS version (e.g., `TLSv1.2`, `TLSv1.3`) used to establish
        the downstream TLS connection.

%DOWNSTREAM\_PEER\_FINGERPRINT\_256%

:   

    HTTP

    :   The hex-encoded SHA256 fingerprint of the client certificate
        used to establish the downstream TLS connection.

    TCP

    :   The hex-encoded SHA256 fingerprint of the client certificate
        used to establish the downstream TLS connection.

%DOWNSTREAM\_PEER\_SERIAL%

:   

    HTTP

    :   The serial number of the client certificate used to establish
        the downstream TLS connection.

    TCP

    :   The serial number of the client certificate used to establish
        the downstream TLS connection.

%DOWNSTREAM\_PEER\_CERT%

:   

    HTTP

    :   The client certificate in the URL-encoded PEM format used to
        establish the downstream TLS connection.

    TCP

    :   The client certificate in the URL-encoded PEM format used to
        establish the downstream TLS connection.

%DOWNSTREAM\_PEER\_CERT\_V\_START%

:   

    HTTP

    :   The validity start date of the client certificate used to
        establish the downstream TLS connection.

    TCP

    :   The validity start date of the client certificate used to
        establish the downstream TLS connection.

%DOWNSTREAM\_PEER\_CERT\_V\_END%

:   

    HTTP

    :   The validity end date of the client certificate used to
        establish the downstream TLS connection.

    TCP

    :   The validity end date of the client certificate used to
        establish the downstream TLS connection.

%HOSTNAME%

:   The system hostname.

%PROTOCOL%

:   The original protocol which is already added by Envoy as a
    `x-forwarded-proto <config_http_conn_man_headers_x-forwarded-proto>`{.interpreted-text
    role="ref"} request header.

%UPSTREAM\_METADATA(\[\"namespace\", \"key\", \...\])%

:   Populates the header with
    `EDS endpoint metadata <envoy_v3_api_field_config.endpoint.v3.LbEndpoint.metadata>`{.interpreted-text
    role="ref"} from the upstream host selected by the router. Metadata
    may be selected from any namespace. In general, metadata values may
    be strings, numbers, booleans, lists, nested structures, or null.
    Upstream metadata values may be selected from nested structs by
    specifying multiple keys. Otherwise, only string, boolean, and
    numeric values are supported. If the namespace or key(s) are not
    found, or if the selected value is not a supported type, then no
    header is emitted. The namespace and key(s) are specified as a JSON
    array of strings. Finally, percent symbols in the parameters **do
    not** need to be escaped by doubling them.

    Upstream metadata cannot be added to request headers as the upstream
    host has not been selected when custom request headers are
    generated.

%UPSTREAM\_REMOTE\_ADDRESS%

:   Remote address of the upstream host. If the address is an IP address
    it includes both address and port. The upstream remote address
    cannot be added to request headers as the upstream host has not been
    selected when custom request headers are generated.

%PER\_REQUEST\_STATE(reverse.dns.data.name)%

:   Populates the header with values set on the stream info
    filterState() object. To be usable in custom request/response
    headers, these values must be of type Envoy::Router::StringAccessor.
    These values should be named in standard reverse DNS style,
    identifying the organization that created the value and ending in a
    unique name for the data.

%REQ(header-name)%

:   Populates the header with a value of the request header.

%START\_TIME%

:   Request start time. START\_TIME can be customized with specifiers as
    specified in
    `access log format rules<config_access_log_format_start_time>`{.interpreted-text
    role="ref"}.

    An example of setting a custom header with current time in seconds
    with the milliseconds resolution:

    ``` {.none}
    route:
      cluster: www
    request_headers_to_add:
      - header:
          key: "x-request-start"
          value: "%START_TIME(%s.%3f)%"
        append: true
    ```

%RESPONSE\_FLAGS%

:   Additional details about the response or connection, if any.
    Possible values and their meanings are listed in the access log
    formatter
    `documentation<config_access_log_format_response_flags>`{.interpreted-text
    role="ref"}.

%RESPONSE\_CODE\_DETAILS%

:   Response code details provides additional information about the HTTP
    response code, such as who set it (the upstream or envoy) and why.
