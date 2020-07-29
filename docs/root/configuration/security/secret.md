Secret discovery service (SDS) {#config_secret_discovery_service}
==============================

TLS certificates, the secrets, can be specified in the
bootstrap.static\_resource
`secrets <envoy_v3_api_field_config.bootstrap.v3.Bootstrap.StaticResources.secrets>`{.interpreted-text
role="ref"}. But they can also be fetched remotely by secret discovery
service (SDS).

The most important benefit of SDS is to simplify the certificate
management. Without this feature, in k8s deployment, certificates must
be created as secrets and mounted into the proxy containers. If
certificates are expired, the secrets need to be updated and the proxy
containers need to be re-deployed. With SDS, a central SDS server will
push certificates to all Envoy instances. If certificates are expired,
the server just pushes new certificates to Envoy instances, Envoy will
use the new ones right away without re-deployment.

If a listener server certificate needs to be fetched by SDS remotely, it
will NOT be marked as active, its port will not be opened before the
certificates are fetched. If Envoy fails to fetch the certificates due
to connection failures, or bad response data, the listener will be
marked as active, and the port will be open, but the connection to the
port will be reset.

Upstream clusters are handled in a similar way, if a cluster client
certificate needs to be fetched by SDS remotely, it will NOT be marked
as active and it will not be used before the certificates are fetched.
If Envoy fails to fetch the certificates due to connection failures, or
bad response data, the cluster will be marked as active, it can be used
to handle the requests, but the requests routed to that cluster will be
rejected.

If a static cluster is using SDS, and it needs to define a SDS cluster
(unless Google gRPC is used which doesn\'t need a cluster), the SDS
cluster has to be defined before the static clusters using it.

The connection between Envoy proxy and SDS server has to be secure. One
option is to run the SDS server on the same host and use Unix Domain
Socket for the connection. Otherwise the connection requires TLS with
authentication between the proxy and SDS server. Credential types in use
today for authentication are:

-   mTLS \-- In this case, the client certificates for the SDS
    connection must be statically configured.
-   AWS IAM SigV4

SDS server
----------

A SDS server needs to implement the gRPC service
`SecretDiscoveryService <api/envoy/service/secret/v3/sds.proto>`{.interpreted-text
role="repo"}. It follows the same protocol as other
`xDS <xds_protocol>`{.interpreted-text role="ref"}.

SDS Configuration
-----------------

`SdsSecretConfig <envoy_v3_api_msg_extensions.transport_sockets.tls.v3.SdsSecretConfig>`{.interpreted-text
role="ref"} is used to specify the secret. Its field *name* is a
required field. If its *sds\_config* field is empty, the *name* field
specifies the secret in the bootstrap static\_resource
`secrets <envoy_v3_api_field_config.bootstrap.v3.Bootstrap.StaticResources.secrets>`{.interpreted-text
role="ref"}. Otherwise, it specifies the SDS server as
`ConfigSource <envoy_v3_api_msg_config.core.v3.ConfigSource>`{.interpreted-text
role="ref"}. Only gRPC is supported for the SDS service so its
*api\_config\_source* must specify a **grpc\_service**.

*SdsSecretConfig* is used in two fields in
`CommonTlsContext <envoy_v3_api_msg_extensions.transport_sockets.tls.v3.CommonTlsContext>`{.interpreted-text
role="ref"}. The first field is *tls\_certificate\_sds\_secret\_configs*
to use SDS to get
`TlsCertificate <envoy_v3_api_msg_extensions.transport_sockets.tls.v3.TlsCertificate>`{.interpreted-text
role="ref"}. The second field is
*validation\_context\_sds\_secret\_config* to use SDS to get
`CertificateValidationContext <envoy_v3_api_msg_extensions.transport_sockets.tls.v3.CertificateValidationContext>`{.interpreted-text
role="ref"}.

Example one: static\_resource
-----------------------------

This example show how to configure secrets in the static\_resource:

``` {.yaml}
static_resources:
  secrets:
    - name: server_cert
      tls_certificate:
        certificate_chain:
          filename: certs/servercert.pem
        private_key:
          filename: certs/serverkey.pem
    - name: client_cert
      tls_certificate:
        certificate_chain:
          filename: certs/clientcert.pem
        private_key:
          filename: certs/clientkey.pem
    - name: validation_context
      validation_context:
        trusted_ca:
          filename: certs/cacert.pem
        verify_certificate_hash:
          E0:F3:C8:CE:5E:2E:A3:05:F0:70:1F:F5:12:E3:6E:2E:97:92:82:84:A2:28:BC:F7:73:32:D3:39:30:A1:B6:FD
  clusters:
    - connect_timeout: 0.25s
      load_assignment:
        cluster_name: local_service_tls
        ...
        transport_socket:
          name: envoy.transport_sockets.tls
          typed_config:
            "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext
            common_tls_context:
              tls_certificate_sds_secret_configs:
              - name: client_cert
  listeners:
    ....
    filter_chains:
      transport_socket:
        name: envoy.transport_sockets.tls
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext
          common_tls_context:
            tls_certificate_sds_secret_configs:
            - name: server_cert
            validation_context_sds_secret_config:
              name: validation_context
```

In this example, certificates are specified in the bootstrap
static\_resource, they are not fetched remotely. In the config,
*secrets* static resource has 3 secrets: **client\_cert**,
**server\_cert** and **validation\_context**. In the cluster config, one
of hosts uses **client\_cert** in its
*tls\_certificate\_sds\_secret\_configs*. In the listeners section, one
of them uses **server\_cert** in its
*tls\_certificate\_sds\_secret\_configs* and **validation\_context** for
its *validation\_context\_sds\_secret\_config*.

Example two: SDS server {#sds_server_example}
-----------------------

This example shows how to configure secrets fetched from remote SDS
servers:

``` {.yaml}
clusters:
  - name: sds_server_mtls
    http2_protocol_options: {}
    load_assignment:
      cluster_name: sds_server_mtls
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: 127.0.0.1
                port_value: 8234
    transport_socket:
      name: envoy.transport_sockets.tls
      typed_config:
        "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext
        common_tls_context:
        - tls_certificate:
          certificate_chain:
            filename: certs/sds_cert.pem
          private_key:
            filename: certs/sds_key.pem
  - name: sds_server_uds
    http2_protocol_options: {}
    load_assignment:
      cluster_name: sds_server_uds
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              pipe:
                path: /tmp/uds_path
  - name: example_cluster
    connect_timeout: 0.25s
    load_assignment:
      cluster_name: local_service_tls
      ...
      transport_socket:
      name: envoy.transport_sockets.tls
      typed_config:
        "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext
          common_tls_context:
            tls_certificate_sds_secret_configs:
            - name: client_cert
              sds_config:
                api_config_source:
                  api_type: GRPC
                  grpc_services:
                    google_grpc:
                      target_uri: unix:/tmp/uds_path
listeners:
  ....
  filter_chains:
  - transport_socket:
      name: envoy.transport_sockets.tls
      typed_config:
        "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext
        common_tls_context:
          tls_certificate_sds_secret_configs:
          - name: server_cert
            sds_config:
              api_config_source:
                api_type: GRPC
                grpc_services:
                  envoy_grpc:
                    cluster_name: sds_server_mtls
          validation_context_sds_secret_config:
            name: validation_context
            sds_config:
              api_config_source:
                api_type: GRPC
                grpc_services:
                  envoy_grpc:
                    cluster_name: sds_server_uds
```

For illustration, above example uses three methods to access the SDS
server. A gRPC SDS server can be reached by Unix Domain Socket path
**/tmp/uds\_path** and **127.0.0.1:8234** by mTLS. It provides three
secrets, **client\_cert**, **server\_cert** and **validation\_context**.
In the config, cluster **example\_cluster** certificate **client\_cert**
is configured to use Google gRPC with UDS to talk to the SDS server. The
Listener needs to fetch **server\_cert** and **validation\_context**
from the SDS server. The **server\_cert** is using Envoy gRPC with
cluster **sds\_server\_mtls** configured with client certificate to use
mTLS to talk to SDS server. The **validate\_context** is using Envoy
gRPC with cluster **sds\_server\_uds** configured with UDS path to talk
to the SDS server.

Example three: certificate rotation for xDS gRPC connection {#xds_certificate_rotation}
-----------------------------------------------------------

Managing certificates for xDS gRPC connection between Envoy and xDS
server introduces a bootstrapping problem: SDS server cannot manage
certificates that are required to connect to the server.

This example shows how to set up xDS connection by sourcing SDS
configuration from the filesystem. The certificate and key files are
watched with inotify and reloaded automatically without restart. In
contrast, `sds_server_example`{.interpreted-text role="ref"} requires a
restart to reload xDS certificates and key after update.

``` {.yaml}
clusters:
- name: control_plane
  type: LOGICAL_DNS
  connect_timeout: 1s
  load_assignment:
    cluster_name: control_plane
    endpoints:
    - lb_endpoints:
      - endpoint:
          address:
            socket_address:
              address: controlplane
              port_value: 8443
  http2_protocol_options: {}
  transport_socket:
    name: "envoy.transport_sockets.tls"
    typed_config:
      "@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext"
      common_tls_context:
        tls_certificate_sds_secret_configs:
          sds_config:
            path: /etc/envoy/tls_certificate_sds_secret.yaml
        validation_context_sds_secret_config:
          sds_config:
            path: /etc/envoy/validation_context_sds_secret.yaml
```

Paths to client certificate, including client\'s certificate chain and
private key are given in SDS config file
`/etc/envoy/tls_certificate_sds_secret.yaml`:

``` {.yaml}
resources:
  - "@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.Secret"
    tls_certificate:
      certificate_chain:
        filename: /certs/sds_cert.pem
      private_key:
        filename: /certs/sds_key.pem
```

Path to CA certificate bundle for validating the xDS server certificate
is given in SDS config file
`/etc/envoy/validation_context_sds_secret.yaml`:

``` {.yaml}
resources:
  - "@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.Secret"
    validation_context:
      trusted_ca:
        filename: /certs/cacert.pem
```

Statistics
----------

SSL socket factory outputs following SDS related statistics. They are
all counter type.

For downstream listeners, they are in the
*listener.\<LISTENER\_IP\>.server\_ssl\_socket\_factory.* namespace.

  ------------------------------------------------------------------------------------------
  Name                                       Description
  ------------------------------------------ -----------------------------------------------
  ssl\_context\_update\_by\_sds              Total number of ssl context has been updated.

  downstream\_context\_secrets\_not\_ready   Total number of downstream connections reset
                                             due to empty ssl certificate.
  ------------------------------------------------------------------------------------------

For upstream clusters, they are in the
*cluster.\<CLUSTER\_NAME\>.client\_ssl\_socket\_factory.* namespace.

  ----------------------------------------------------------------------------------------
  Name                                     Description
  ---------------------------------------- -----------------------------------------------
  ssl\_context\_update\_by\_sds            Total number of ssl context has been updated.

  upstream\_context\_secrets\_not\_ready   Total number of upstream connections reset due
                                           to empty ssl certificate.
  ----------------------------------------------------------------------------------------