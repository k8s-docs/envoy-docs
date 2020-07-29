JWT Authentication {#config_http_filters_jwt_authn}
==================

This HTTP filter can be used to verify JSON Web Token (JWT). It will
verify its signature, audiences and issuer. It will also check its time
restrictions, such as expiration and nbf (not before) time. If the JWT
verification fails, its request will be rejected. If the JWT
verification succeeds, its payload can be forwarded to the upstream for
further authorization if desired.

JWKS is needed to verify JWT signatures. They can be specified in the
filter config or can be fetched remotely from a JWKS server.

::: {.attention}
::: {.admonition-title}
Attention
:::

EdDSA, ES256, ES384, ES512, HS256, HS384, HS512, RS256, RS384 and RS512
are supported for the JWT alg.
:::

Configuration
-------------

This filter should be configured with the name
*envoy.filters.http.jwt\_authn*.

This HTTP
`filter config <envoy_v3_api_msg_extensions.filters.http.jwt_authn.v3.JwtAuthentication>`{.interpreted-text
role="ref"} has two fields:

-   Field *providers* specifies how a JWT should be verified, such as
    where to extract the token, where to fetch the public key (JWKS) and
    where to output its payload.
-   Field *rules* specifies matching rules and their requirements. If a
    request matches a rule, its requirement applies. The requirement
    specifies which JWT providers should be used.

### JwtProvider

`JwtProvider <envoy_v3_api_msg_extensions.filters.http.jwt_authn.v3.JwtProvider>`{.interpreted-text
role="ref"} specifies how a JWT should be verified. It has the following
fields:

-   *issuer*: the principal that issued the JWT, usually a URL or an
    email address.
-   *audiences*: a list of JWT audiences allowed to access. A JWT
    containing any of these audiences will be accepted. If not
    specified, the audiences in JWT will not be checked.
-   *local\_jwks*: fetch JWKS in local data source, either in a local
    file or embedded in the inline string.
-   *remote\_jwks*: fetch JWKS from a remote HTTP server, also specify
    cache duration.
-   *forward*: if true, JWT will be forwarded to the upstream.
-   *from\_headers*: extract JWT from HTTP headers.
-   *from\_params*: extract JWT from query parameters.
-   *forward\_payload\_header*: forward the JWT payload in the specified
    HTTP header.

### Default Extract Location

If *from\_headers* and *from\_params* is empty, the default location to
extract JWT is from HTTP header:

    Authorization: Bearer <token>

If fails to extract a JWT from above header, then check query parameter
key *access\_token* as in this example:

    /path?access_token=<JWT>

In the
`filter config <envoy_v3_api_msg_extensions.filters.http.jwt_authn.v3.JwtAuthentication>`{.interpreted-text
role="ref"}, *providers* is a map, to map *provider\_name* to a
`JwtProvider <envoy_v3_api_msg_extensions.filters.http.jwt_authn.v3.JwtProvider>`{.interpreted-text
role="ref"}. The *provider\_name* must be unique, it is referred in the
[JwtRequirement
\<envoy\_v3\_api\_msg\_extensions.filters.http.jwt\_authn.v3.JwtRequirement\>]{.title-ref}
in its *provider\_name* field.

::: {.important}
::: {.admonition-title}
Important
:::

For *remote\_jwks*, a **jwks\_cluster** cluster is required.
:::

Due to above requirement, [OpenID Connect
Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html)
is not supported since the URL to fetch JWKS is in the response of the
discovery. It is not easy to setup a cluster config for a dynamic URL.

### Remote JWKS config example

``` {.yaml}
providers:
  provider_name1:
    issuer: https://example.com
    audiences:
    - bookstore_android.apps.googleusercontent.com
    - bookstore_web.apps.googleusercontent.com
    remote_jwks:
      http_uri:
        uri: https://example.com/jwks.json
        cluster: example_jwks_cluster
      cache_duration:
        seconds: 300
```

Above example fetches JWSK from a remote server with URL
<https://example.com/jwks.json>. The token will be extracted from the
default extract locations. The token will not be forwarded to upstream.
JWT payload will not be added to the request header.

Following cluster **example\_jwks\_cluster** is needed to fetch JWKS.

``` {.yaml}
cluster:
  name: example_jwks_cluster
  type: STRICT_DNS
  load_assignment:
    cluster_name: example_jwks_cluster
    endpoints:
    - lb_endpoints:
      - endpoint:
          address:
            socket_address:
              address: example.com
              port_value: 80
```

### Inline JWKS config example

Another config example using inline JWKS:

``` {.yaml}
providers:
  provider_name2:
    issuer: https://example2.com
    local_jwks:
      inline_string: PUBLIC-KEY
    from_headers:
    - name: jwt-assertion
    forward: true
    forward_payload_header: x-jwt-payload
```

Above example uses config inline string to specify JWKS. The JWT token
will be extracted from HTTP headers as:

    jwt-assertion: <JWT>.

JWT payload will be added to the request header as following format:

    x-jwt-payload: base64url_encoded(jwt_payload_in_JSON)

### RequirementRule

`RequirementRule <envoy_v3_api_msg_extensions.filters.http.jwt_authn.v3.RequirementRule>`{.interpreted-text
role="ref"} has two fields:

-   Field *match* specifies how a request can be matched; e.g. by HTTP
    headers, or by query parameters, or by path prefixes.
-   Field *requires* specifies the JWT requirement, e.g. which provider
    is required.

::: {.important}
::: {.admonition-title}
Important
:::

\- **If a request matches multiple rules, the first matched rule will
apply**. - If the matched rule has empty *requires* field, **JWT
verification is not required**. - If a request doesn\'t match any rules,
**JWT verification is not required**.
:::

### Single requirement config example

``` {.yaml}
providers:
  jwt_provider1:
    issuer: https://example.com
    audiences:
      audience1
    local_jwks:
      inline_string: PUBLIC-KEY
rules:
- match:
    prefix: /health
- match:
    prefix: /api
  requires:
    provider_and_audiences:
      provider_name: jwt_provider1
      audiences:
        api_audience
- match:
    prefix: /
  requires:
    provider_name: jwt_provider1
```

Above config uses single requirement rule, each rule may have either an
empty requirement or a single requirement with one provider name.

### Group requirement config example

``` {.yaml}
providers:
  provider1:
    issuer: https://provider1.com
    local_jwks:
      inline_string: PUBLIC-KEY
  provider2:
    issuer: https://provider2.com
    local_jwks:
      inline_string: PUBLIC-KEY
rules:
- match:
    prefix: /any
  requires:
    requires_any:
      requirements:
      - provider_name: provider1
      - provider_name: provider2
- match:
    prefix: /all
  requires:
    requires_all:
      requirements:
      - provider_name: provider1
      - provider_name: provider2
```

Above config uses more complex *group* requirements:

-   The first *rule* specifies *requires\_any*; if any of **provider1**
    or **provider2** requirement is satisfied, the request is OK to
    proceed.
-   The second *rule* specifies *requires\_all*; only if both
    **provider1** and **provider2** requirements are satisfied, the
    request is OK to proceed.
