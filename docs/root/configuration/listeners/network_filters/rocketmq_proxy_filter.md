RocketMQ proxy {#config_network_filters_rocketmq_proxy}
==============

Apache RocketMQ is a distributed messaging system, which is composed of
four types of roles: producer, consumer, name server and broker server.
The former two are embedded into user application in form of SDK; whilst
the latter are standalone servers.

A message in RocketMQ carries a topic as its destination and optionally
one or more tags as application specific labels.

Producers are used to send messages to brokers according to their
topics. Similar to many distributed systems, producers need to know how
to connect to these serving brokers. To achieve this goal, RocketMQ
provides name server clusters for producers to lookup. Namely, when
producers attempts to send messages with a new topic, it first tries to
lookup the addresses(called route info) of brokers that serve the topic
from name servers. Once producers get the route info of the topic, they
actively cache them in memory and renew them periodically thereafter.
This mechanism, though simple, effectively keeps service availability
high without demanding availability of name server service.

Brokers provides messaging service to end users. In addition to various
messaging services, they also periodically report health status and
route info of topics currently served to name servers.

Major role of the name server is to serve querying of route info for a
topic. Additionally, it also purges route info entries once the
belonging brokers fail to report their health info for a configured
period of time. This ensures clients almost always connect to brokers
that are online and ready to serve.

Consumers are used by application to pull message from brokers. They
perform similar heartbeats to maintain alive status. RocketMQ brokers
support two message-fetch approaches: long-pulling and pop.

Using the first approach, consumers have to implement load-balancing
algorithm. The pop approach, in the perspective of consumers, is
stateless.

Envoy RocketMQ filter proxies requests and responses between
producers/consumer and brokers. Various statistical items are collected
to enhance observability.

At present, pop-based message fetching is implemented. Long-pulling will
be implemented in the next pull request.

Statistics {#config_network_filters_rocketmq_proxy_stats}
----------

Every configured rocketmq proxy filter has statistics rooted at
*rocketmq.\<stat\_prefix\>.* with the following statistics:

  -----------------------------------------------------------------------------------
  Name                          Type              Description
  ----------------------------- ----------------- -----------------------------------
  request                       Counter           Total requests

  request\_decoding\_error      Counter           Total decoding error requests

  request\_decoding\_success    Counter           Total decoding success requests

  response                      Counter           Total responses

  response\_decoding\_error     Counter           Total decoding error responses

  response\_decoding\_success   Counter           Total decoding success responses

  response\_error               Counter           Total error responses

  response\_success             Counter           Total success responses

  heartbeat                     Counter           Total heartbeat requests

  unregister                    Counter           Total unregister requests

  get\_topic\_route             Counter           Total getting topic route requests

  send\_message\_v1             Counter           Total sending message v1 requests

  send\_message\_v2             Counter           Total sending message v2 requests

  pop\_message                  Counter           Total poping message requests

  ack\_message                  Counter           Total acking message requests

  get\_consumer\_list           Counter           Total getting consumer list
                                                  requests

  maintenance\_failure          Counter           Total maintenance failure

  request\_active               Gauge             Total active requests

  send\_message\_v1\_active     Gauge             Total active sending message v1
                                                  requests

  send\_message\_v2\_active     Gauge             Total active sending message v2
                                                  requests

  pop\_message\_active          Gauge             Total active poping message active
                                                  requests

  get\_topic\_route\_active     Gauge             Total active geting topic route
                                                  requests

  send\_message\_pending        Gauge             Total pending sending message
                                                  requests

  pop\_message\_pending         Gauge             Total pending poping message
                                                  requests

  get\_topic\_route\_pending    Gauge             Total pending geting topic route
                                                  requests

  total\_pending                Gauge             Total pending requests

  request\_time\_ms             Histogram         Request time in milliseconds
  -----------------------------------------------------------------------------------
