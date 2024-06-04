# DOCKER.MONGO.018 
### CLOUDSTACK.DOCKER.EXAMPLE.HUB
### base on https://github.com/pkdone/sharded-mongodb-docker

```
docker-compose up --build -d
```



### TEST CONNECT
```

docker exec -it dockermongo020_python_1 bash
apt update
apt install net-tools

```


```
docker exec -it dockermongo020_python_1 bash
pip3 install pymongo
python3
```


```
import pymongo
import time

myclient = pymongo.MongoClient('mongodb://mongos-router0:27017,mongos-router1:27017/database')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]


for n in range(10000):
    mydict = { "name": f"John {n}", "address": f"Highway {n}" }
    time.sleep(1)
    x = mycol.insert_one(mydict)
    print(x)
```

```
root@aa0b5fbeee88:/# netstat -napt
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.11:42875        0.0.0.0:*               LISTEN      -
tcp        0      0 172.31.18.5:57986       172.31.18.6:27017       ESTABLISHED 519/python3
tcp        0      0 172.31.18.5:39602       172.31.18.6:27017       ESTABLISHED 519/python3
tcp        0      0 172.31.18.5:50644       172.31.18.14:27017      ESTABLISHED 519/python3
tcp        0      0 172.31.18.5:50650       172.31.18.14:27017      ESTABLISHED 519/python3
tcp        0      0 172.31.18.5:50656       172.31.18.14:27017      ESTABLISHED 519/python3
tcp        0      0 172.31.18.5:39600       172.31.18.6:27017       ESTABLISHED 519/python3
root@aa0b5fbeee88:/#
```


```
import pymongo
import time

myclient = pymongo.MongoClient('mongodb://mongos-router0:27017,mongos-router1:27017/database')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]

for x in mycol.find():
  print(x)
```


### TEST TWO

```
import pymongo
import time

myclient = pymongo.MongoClient('mongodb://front-envoy:27001,front-envoy:27002/database')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]


for n in range(10000):
    mydict = { "name": f"John {n}", "address": f"Highway {n}" }
    time.sleep(1)
    x = mycol.insert_one(mydict)
    print(x)
```



```
import pymongo
import time

myclient = pymongo.MongoClient('mongodb://front-envoy:27001,front-envoy:27002/database')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]

for x in mycol.find():
  print(x)
```


```
root@node1:/KVM# docker exec -it dockermongo020_python_1 bash
root@aa0b5fbeee88:/# netstat -napt
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.11:42875        0.0.0.0:*               LISTEN      -
tcp        0      0 172.31.18.5:50412       172.31.18.2:27001       TIME_WAIT   -
tcp        0      0 172.31.18.5:34450       172.31.18.2:27001       TIME_WAIT   -
tcp        0      0 172.31.18.5:34224       172.31.18.2:27001       ESTABLISHED 306/python3
tcp        0      0 172.31.18.5:34460       172.31.18.2:27001       TIME_WAIT   -
tcp        0      0 172.31.18.5:59002       172.31.18.2:27001       TIME_WAIT   -
tcp        0      0 172.31.18.5:40500       172.31.18.2:27001       ESTABLISHED 306/python3
tcp        0      0 172.31.18.5:40504       172.31.18.2:27001       ESTABLISHED 306/python3
root@aa0b5fbeee88:/#

```
