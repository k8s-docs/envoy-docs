Runtime {#config_cluster_manager_cluster_runtime}
=======

Upstream clusters support the following runtime settings:

Active health checking
----------------------

health\_check.min\_interval

:   Min value for the health checking
    `interval <envoy_v3_api_field_config.core.v3.HealthCheck.interval>`{.interpreted-text
    role="ref"}. Default value is 1 ms. The effective health check
    interval will be no less than 1ms. The health checking interval will
    be between *min\_interval* and *max\_interval*.

health\_check.max\_interval

:   Max value for the health checking
    `interval <envoy_v3_api_field_config.core.v3.HealthCheck.interval>`{.interpreted-text
    role="ref"}. Default value is MAX\_INT. The effective health check
    interval will be no less than 1ms. The health checking interval will
    be between *min\_interval* and *max\_interval*.

health\_check.verify\_cluster

:   What % of health check requests will be verified against the
    `expected upstream service
    <envoy_v3_api_field_config.core.v3.HealthCheck.HttpHealthCheck.service_name_matcher>`{.interpreted-text
    role="ref"} as the `health check filter
    <arch_overview_health_checking_filter>`{.interpreted-text
    role="ref"} will write the remote service cluster into the response.

Outlier detection {#config_cluster_manager_cluster_runtime_outlier_detection}
-----------------

See the outlier detection
`architecture overview <arch_overview_outlier_detection>`{.interpreted-text
role="ref"} for more information on outlier detection. The runtime
parameters supported by outlier detection are the same as the
`static configuration parameters <envoy_v3_api_msg_config.cluster.v3.OutlierDetection>`{.interpreted-text
role="ref"}, namely:

outlier\_detection.consecutive\_5xx

:   `consecutive_5XX
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.consecutive_5xx>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.consecutive\_gateway\_failure

:   `consecutive_gateway_failure
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.consecutive_gateway_failure>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.consecutive\_local\_origin\_failure

:   `consecutive_local_origin_failure
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.consecutive_local_origin_failure>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.interval\_ms

:   `interval_ms
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.interval>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.base\_ejection\_time\_ms

:   `base_ejection_time_ms
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.base_ejection_time>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.max\_ejection\_percent

:   `max_ejection_percent
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.max_ejection_percent>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_consecutive\_5xx

:   `enforcing_consecutive_5xx
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_consecutive_5xx>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_consecutive\_gateway\_failure

:   `enforcing_consecutive_gateway_failure
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_consecutive_gateway_failure>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_consecutive\_local\_origin\_failure

:   `enforcing_consecutive_local_origin_failure
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_consecutive_local_origin_failure>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_success\_rate

:   `enforcing_success_rate
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_success_rate>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_local\_origin\_success\_rate

:   `enforcing_local_origin_success_rate
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_local_origin_success_rate>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.success\_rate\_minimum\_hosts

:   `success_rate_minimum_hosts
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.success_rate_minimum_hosts>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.success\_rate\_request\_volume

:   `success_rate_request_volume
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.success_rate_request_volume>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.success\_rate\_stdev\_factor

:   `success_rate_stdev_factor
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.success_rate_stdev_factor>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_failure\_percentage

:   `enforcing_failure_percentage
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_failure_percentage>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.enforcing\_failure\_percentage\_local\_origin

:   `enforcing_failure_percentage_local_origin
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.enforcing_failure_percentage_local_origin>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.failure\_percentage\_request\_volume

:   `failure_percentage_request_volume
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.failure_percentage_request_volume>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.failure\_percentage\_minimum\_hosts

:   `failure_percentage_minimum_hosts
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.failure_percentage_minimum_hosts>`{.interpreted-text
    role="ref"} setting in outlier detection

outlier\_detection.failure\_percentage\_threshold

:   `failure_percentage_threshold
    <envoy_v3_api_field_config.cluster.v3.OutlierDetection.failure_percentage_threshold>`{.interpreted-text
    role="ref"} setting in outlier detection

Core
----

upstream.healthy\_panic\_threshold

:   Sets the
    `panic threshold <arch_overview_load_balancing_panic_threshold>`{.interpreted-text
    role="ref"} percentage. Defaults to 50%.

upstream.use\_http2

:   Whether the cluster utilizes the *http2*
    `protocol options <envoy_v3_api_field_config.cluster.v3.Cluster.http2_protocol_options>`{.interpreted-text
    role="ref"} if configured. Set to 0 to disable HTTP/2 even if the
    feature is configured. Defaults to enabled.

Zone aware load balancing {#config_cluster_manager_cluster_runtime_zone_routing}
-------------------------

upstream.zone\_routing.enabled

:   \% of requests that will be routed to the same upstream zone.
    Defaults to 100% of requests.

upstream.zone\_routing.min\_cluster\_size

:   Minimal size of the upstream cluster for which zone aware routing
    can be attempted. Default value is 6. If the upstream cluster size
    is smaller than *min\_cluster\_size* zone aware routing will not be
    performed.

Circuit breaking
----------------

circuit\_breakers.\<cluster\_name\>.\<priority\>.max\_connections

:   `Max connections circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_connections>`{.interpreted-text
    role="ref"}

circuit\_breakers.\<cluster\_name\>.\<priority\>.max\_pending\_requests

:   `Max pending requests circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_pending_requests>`{.interpreted-text
    role="ref"}

circuit\_breakers.\<cluster\_name\>.\<priority\>.max\_requests

:   `Max requests circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_requests>`{.interpreted-text
    role="ref"}

circuit\_breakers.\<cluster\_name\>.\<priority\>.max\_retries

:   `Max retries circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.max_retries>`{.interpreted-text
    role="ref"}

circuit\_breakers.\<cluster\_name\>.\<priority\>.retry\_budget.budget\_percent

:   `Max retries circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.RetryBudget.budget_percent>`{.interpreted-text
    role="ref"}

circuit\_breakers.\<cluster\_name\>.\<priority\>.retry\_budget.min\_retry\_concurrency

:   `Max retries circuit breaker setting <envoy_v3_api_field_config.cluster.v3.CircuitBreakers.Thresholds.RetryBudget.min_retry_concurrency>`{.interpreted-text
    role="ref"}
