---
title: "支持负载均衡"
linkTitle: ""
weight: 1
---

When a filter needs to acquire a connection to a host in an upstream
cluster, the cluster manager uses a load balancing policy to determine
which host is selected. The load balancing policies are pluggable and
are specified on a per upstream cluster basis in the `configuration <envoy_v3_api_msg_config.cluster.v3.Cluster>`{.interpreted-text
role="ref"}. Note that if no active health checking policy is
`configured <config_cluster_manager_cluster_hc>`{.interpreted-text role="ref"} for a
cluster, all upstream cluster members are considered healthy, unless
otherwise specified through
[health_status](envoy_v3_api_field_config.endpoint.v3.LbEndpoint.health_status){.interpreted-text
role="ref"}.

## Weighted round robin {#arch_overview_load_balancing_types_round_robin}

This is a simple policy in which each available upstream host is
selected in round robin order. If `weights <envoy_v3_api_field_config.endpoint.v3.LbEndpoint.load_balancing_weight>`{.interpreted-text
role="ref"} are assigned to endpoints in a locality, then a weighted
round robin schedule is used, where higher weighted endpoints will
appear more often in the rotation to achieve the effective weighting.

## Weighted least request {#arch_overview_load_balancing_types_least_request}

The least request load balancer uses different algorithms depending on
whether hosts have the same or different weights.

- _all weights equal_: An O(1) algorithm which selects N random
  available hosts as specified in the
  [configuration](envoy_v3_api_msg_config.cluster.v3.Cluster.LeastRequestLbConfig){.interpreted-text
  role="ref"} (2 by default) and picks the host which has the fewest
  active requests ([Mitzenmacher et
  al.](https://www.eecs.harvard.edu/~michaelm/postscripts/handbook2001.pdf)
  has shown that this approach is nearly as good as an O(N) full
  scan). This is also known as P2C (power of two choices). The P2C
  load balancer has the property that a host with the highest number
  of active requests in the cluster will never receive new requests.
  It will be allowed to drain until it is less than or equal to all of
  the other hosts.
- _all weights not equal_: If two or more hosts in the cluster have
  different load balancing weights, the load balancer shifts into a
  mode where it uses a weighted round robin schedule in which weights
  are dynamically adjusted based on the host\'s request load at the
  time of selection (weight is divided by the current active request
  count. For example, a host with weight 2 and an active request count
  of 4 will have a synthetic weight of 2 / 4 = 0.5). This algorithm
  provides good balance at steady state but may not adapt to load
  imbalance as quickly. Additionally, unlike P2C, a host will never
  truly drain, though it will receive fewer requests over time.

## Ring hash {#arch_overview_load_balancing_types_ring_hash}

The ring/modulo hash load balancer implements consistent hashing to
upstream hosts. Each host is mapped onto a circle (the \"ring\") by
hashing its address; each request is then routed to a host by hashing
some property of the request, and finding the nearest corresponding host
clockwise around the ring. This technique is also commonly known as
[\"Ketama\"](https://github.com/RJ/ketama) hashing, and like all
hash-based load balancers, it is only effective when protocol routing is
used that specifies a value to hash on.

Each host is hashed and placed on the ring some number of times
proportional to its weight. For example, if host A has a weight of 1 and
host B has a weight of 2, then there might be three entries on the ring:
one for host A and two for host B. This doesn\'t actually provide the
desired 2:1 partitioning of the circle, however, since the computed
hashes could be coincidentally very close to one another; so it is
necessary to multiply the number of hashes per host\-\--for example
inserting 100 entries on the ring for host A and 200 entries for host
B\-\--to better approximate the desired distribution. Best practice is
to explicitly set
`minimum_ring_size<envoy_v3_api_field_config.cluster.v3.Cluster.RingHashLbConfig.minimum_ring_size>`{.interpreted-text
role="ref"} and
`maximum_ring_size<envoy_v3_api_field_config.cluster.v3.Cluster.RingHashLbConfig.maximum_ring_size>`{.interpreted-text
role="ref"}, and monitor the
`min_hashes_per_host and max_hashes_per_host gauges<config_cluster_manager_cluster_stats_ring_hash_lb>`{.interpreted-text
role="ref"} to ensure good distribution. With the ring partitioned
appropriately, the addition or removal of one host from a set of N hosts
will affect only 1/N requests.

When priority based load balancing is in use, the priority level is also
chosen by hash, so the endpoint selected will still be consistent when
the set of backends is stable.

## Maglev {#arch_overview_load_balancing_types_maglev}

The Maglev load balancer implements consistent hashing to upstream
hosts. It uses the algorithm described in section 3.4 of [this
paper](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44824.pdf)
with a fixed table size of 65537 (see section 5.3 of the same paper).
Maglev can be used as a drop in replacement for the
[ring hash load balancer](arch_overview_load_balancing_types_ring_hash){.interpreted-text
role="ref"} any place in which consistent hashing is desired. Like the
ring hash load balancer, a consistent hashing load balancer is only
effective when protocol routing is used that specifies a value to hash
on.

The table construction algorithm places each host in the table some
number of times proportional to its weight, until the table is
completely filled. For example, if host A has a weight of 1 and host B
has a weight of 2, then host A will have 21,846 entries and host B will
have 43,691 entries (totaling 65,537 entries). The algorithm attempts to
place each host in the table at least once, regardless of the configured
host and locality weights, so in some extreme cases the actual
proportions may differ from the configured weights. For example, if the
total number of hosts is larger than the fixed table size, then some
hosts will get 1 entry each and the rest will get 0, regardless of
weight. Best practice is to monitor the `min_entries_per_host and max_entries_per_host gauges <config_cluster_manager_cluster_stats_maglev_lb>`{.interpreted-text
role="ref"} to ensure no hosts are underrepresented or missing.

In general, when compared to the ring hash (\"ketama\") algorithm,
Maglev has substantially faster table lookup build times as well as host
selection times (approximately 10x and 5x respectively when using a
large ring size of 256K entries). The downside of Maglev is that it is
not as stable as ring hash. More keys will move position when hosts are
removed (simulations show approximately double the keys will move). With
that said, for many applications including Redis, Maglev is very likely
a superior drop in replacement for ring hash. The advanced reader can
use
[this benchmark](/test/common/upstream/load_balancer_benchmark.cc){.interpreted-text
role="repo"} to compare ring hash versus Maglev with different
parameters.

## Random {#arch_overview_load_balancing_types_random}

The random load balancer selects a random available host. The random
load balancer generally performs better than round robin if no health
checking policy is configured. Random selection avoids bias towards the
host in the set that comes after a failed host.
