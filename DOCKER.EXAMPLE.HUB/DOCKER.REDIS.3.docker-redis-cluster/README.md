# Docker Redis Cluster
### original https://github.com/sinbadxiii/docker-redis-cluster


## Install
```shell
docker-compose up -d
```


```
root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# redis-cli -h 127.0.0.1 -p 6381
127.0.0.1:6381> CLUSTER NODES
e0abf3edec0f40f04467f7c9798cbf3c125d6ee5 173.18.0.14:6384@16384 master - 0 1717696462069 4 connected 9830-13106
c102bc21fa3345ab1da48b89c88fd50116416809 173.18.0.11:6381@16381 myself,master - 0 1717696461000 1 connected 0-3276
65974bc3855cb6a8779027a4845ef2154e51f535 173.18.0.19:6389@16389 slave acff3170e9af085d87e48388f97ac05d6604cb99 0 1717696462069 3 connected
aab104882ad86ea09dc7cbbb5e98a9efdc316793 173.18.0.18:6388@16388 slave 42622d180a4d31609714bbfbe9708df8bb38a18a 0 1717696462000 2 connected
0ecd7c4405547906cd6382012deae5e14fabc83d 173.18.0.17:6387@16387 slave c102bc21fa3345ab1da48b89c88fd50116416809 0 1717696462571 1 connected
88802b9a38075e8a9d75eabf1602070a23edfdfc 173.18.0.16:6386@16386 slave 94ec11cc656d6ca0ebad91505daaccf65785c3d8 0 1717696462571 5 connected
23452b9d54b5df1c3a9f541e167255fc852e2a56 173.18.0.20:6390@16390 slave e0abf3edec0f40f04467f7c9798cbf3c125d6ee5 0 1717696462000 4 connected
94ec11cc656d6ca0ebad91505daaccf65785c3d8 173.18.0.15:6385@16385 master - 0 1717696462571 5 connected 13107-16383
acff3170e9af085d87e48388f97ac05d6604cb99 173.18.0.13:6383@16383 master - 0 1717696462571 3 connected 6554-9829
42622d180a4d31609714bbfbe9708df8bb38a18a 173.18.0.12:6382@16382 master - 0 1717696462571 2 connected 3277-6553
127.0.0.1:6381> cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:10
cluster_size:5
cluster_current_epoch:10
cluster_my_epoch:1
cluster_stats_messages_ping_sent:1323
cluster_stats_messages_pong_sent:1352
cluster_stats_messages_sent:2675
cluster_stats_messages_ping_received:1343
cluster_stats_messages_pong_received:1323
cluster_stats_messages_meet_received:9
cluster_stats_messages_received:2675
127.0.0.1:6381>

```



```
root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:10
cluster_size:5
cluster_current_epoch:10
cluster_my_epoch:1
cluster_stats_messages_ping_sent:1588
cluster_stats_messages_pong_sent:1616
cluster_stats_messages_sent:3204
cluster_stats_messages_ping_received:1616
cluster_stats_messages_pong_received:1588
cluster_stats_messages_received:3204

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 cluster nodes
42622d180a4d31609714bbfbe9708df8bb38a18a 173.18.0.12:6382@16382 master - 0 1717697379000 2 connected 3277-6553
c102bc21fa3345ab1da48b89c88fd50116416809 173.18.0.11:6381@16381 myself,master - 0 1717697379000 1 connected 0-3276
65974bc3855cb6a8779027a4845ef2154e51f535 173.18.0.19:6389@16389 slave acff3170e9af085d87e48388f97ac05d6604cb99 0 1717697380081 3 connected
0ecd7c4405547906cd6382012deae5e14fabc83d 173.18.0.17:6387@16387 slave c102bc21fa3345ab1da48b89c88fd50116416809 0 1717697379076 1 connected
aab104882ad86ea09dc7cbbb5e98a9efdc316793 173.18.0.18:6388@16388 slave 42622d180a4d31609714bbfbe9708df8bb38a18a 0 1717697379578 2 connected
88802b9a38075e8a9d75eabf1602070a23edfdfc 173.18.0.16:6386@16386 slave 94ec11cc656d6ca0ebad91505daaccf65785c3d8 0 1717697379679 5 connected
acff3170e9af085d87e48388f97ac05d6604cb99 173.18.0.13:6383@16383 master - 0 1717697379578 3 connected 6554-9829
23452b9d54b5df1c3a9f541e167255fc852e2a56 173.18.0.20:6390@16390 slave e0abf3edec0f40f04467f7c9798cbf3c125d6ee5 0 1717697379578 4 connected
94ec11cc656d6ca0ebad91505daaccf65785c3d8 173.18.0.15:6385@16385 master - 0 1717697379076 5 connected 13107-16383

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -p 6381 SET foo4 bar
(error) MOVED 9426 173.18.0.13:6383

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 SET foo4 bar
OK

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 SET foo bar
OK

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 GET foo
"bar"

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster# docker exec -it redis_1 redis-cli -c -p 6381 GET foo4
"bar"

root@node1:/cloud/TEST/redis-cluster-docker/docker-redis-cluster#


```
### For Golang [redis/go-redis](https://github.com/redis/go-redis):

```golang
import "github.com/redis/go-redis/v9"

rdb := redis.NewClusterClient(&redis.ClusterOptions{
    Addrs: []string{":6381", ":6382", ":6383", ":6384", ":6385", ":6386"},

    // To route commands by latency or randomly, enable one of the following.
    //RouteByLatency: true,
    //RouteRandomly: true,
})
```

For Python [Grokzen/redis-py-cluster](https://github.com/Grokzen/redis-py-cluster):

```python
>>> from rediscluster import RedisCluster

>>> # Requires at least one node for cluster discovery. Multiple nodes is recommended.
>>> startup_nodes = [{"host": "127.0.0.1", "port": "6381"}, {"host": "127.0.0.1", "port": "6382"}] # ... and etc.
>>> rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True)

>>> rc.set("foo", "bar")
True
>>> print(rc.get("foo"))
'bar'
```
