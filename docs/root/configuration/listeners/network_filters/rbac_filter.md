Role Based Access Control (RBAC) Network Filter {#config_network_filters_rbac}
===============================================

The RBAC network filter is used to authorize actions (permissions) by
identified downstream clients (principals). This is useful to explicitly
manage callers to an application and protect it from unexpected or
forbidden agents. The filter supports configuration with either a
safe-list (ALLOW) or block-list (DENY) set of policies based on
properties of the connection (IPs, ports, SSL subject). This filter also
supports policy in both enforcement and shadow modes. Shadow mode won\'t
effect real users, it is used to test that a new set of policies work
before rolling out to production.

-   `v3 API reference <envoy_v3_api_msg_extensions.filters.network.rbac.v3.RBAC>`{.interpreted-text
    role="ref"}
-   This filter should be configured with the name
    *envoy.filters.network.rbac*.

Statistics
----------

The RBAC network filter outputs statistics in the
*\<stat\_prefix\>.rbac.* namespace.

  -----------------------------------------------------------------------
  Name              Type              Description
  ----------------- ----------------- -----------------------------------
  allowed           Counter           Total requests that were allowed
                                      access

  denied            Counter           Total requests that were denied
                                      access

  shadow\_allowed   Counter           Total requests that would be
                                      allowed access by the filter\'s
                                      shadow rules

  shadow\_denied    Counter           Total requests that would be denied
                                      access by the filter\'s shadow
                                      rules
  -----------------------------------------------------------------------

Dynamic Metadata {#config_network_filters_rbac_dynamic_metadata}
----------------

The RBAC filter emits the following dynamic metadata.

  -------------------------------------------------------------------------------------
  Name                            Type              Description
  ------------------------------- ----------------- -----------------------------------
  shadow\_effective\_policy\_id   string            The effective shadow policy ID
                                                    matching the action (if any).

  shadow\_engine\_result          string            The engine result for the shadow
                                                    rules (i.e. either
                                                    [allowed]{.title-ref} or
                                                    [denied]{.title-ref}).
  -------------------------------------------------------------------------------------
