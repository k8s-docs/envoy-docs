Why are the Envoy xDS APIs versioned? What is the benefit?
==========================================================

Envoy is a platform and needs to allow its APIs to grow and evolve to
encompass new features, improve ergonomics and address new use cases. At
the same time, we need a disciplined approach to turning down stale
functionality and removing APIs and their supporting code that are no
longer maintained. If we don\'t do this, we lose the ability in the long
term to provide a reliable, maintainable, scalable code base and set of
APIs for our users.

We had previously put in place policies around `breaking changes
<CONTRIBUTING.md#breaking-change-policy>`{.interpreted-text role="repo"}
across releases, the `API versioning policy
<api/API_VERSIONING.md>`{.interpreted-text role="repo"} takes this a
step further, articulating a guaranteed multi-year support window for
APIs that provides control plane authors a predictable clock when
considering support for a range of Envoy versions.

For the v3 xDS APIs, a brief list of the key improvements that were made
with a clean break from v2:

-   Packages organization was improved to reflect a more logical
    grouping of related APIs:
    -   The legacy [envoy.api.v2]{.title-ref} tree was eliminated, with
        protos moved to their logical groupings, e.g.
        [envoy.config.core.v3]{.title-ref},
        [envoy.server.listener.v3]{.title-ref}.
    -   All packages are now versioned with a [vN]{.title-ref} at the
        end. This allows for type-level identification of major version.
    -   xDS service endpoints/transport and configuration are split
        between [envoy.service]{.title-ref} and
        [envoy.config]{.title-ref}.
    -   Extensions now reflect the Envoy source tree layout under
        [envoy.extensions]{.title-ref}.
-   [std::regex]{.title-ref} regular expressions were dropped from the
    API, in favor of RE2. The former have dangerous security
    implications.
-   [google.protobug.Struct]{.title-ref} configuration of extensions was
    dropped from the API, in favor of typed configuration. This provides
    for better support for multiple instances of extensions, e.g. in
    filter chains, and more flexible naming of extension instances.
-   Over 60 deprecated fields were removed from the API.
-   Tooling and processes were established for API versioning support.
    This has now been reflected in the bootstrap [Node]{.title-ref},
    providing a long term notion of API support that control planes can
    depend upon for client negotiation.
