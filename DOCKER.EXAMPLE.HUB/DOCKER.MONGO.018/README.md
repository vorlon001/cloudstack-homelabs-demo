# DOCKER.MONGO.018 
### CLOUDSTACK.DOCKER.EXAMPLE.HUB


### TEST CONNECT
```

docker exec -it dockermongo018_python_1 bash

pip3 install pymongo
python3

import pymongo
import time

myclient = pymongo.MongoClient('mongodb://admin:admin@front-envoy:27000,front-envoy:27001,front-envoy:27002,front-envoy:27003/?replicaSet=rs1')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]

mydict1 = { "name": "John 1", "address": "Highway 37" }
mydict2 = { "name": "John 2", "address": "Highway 38" }
mydict3 = { "name": "John 3", "address": "Highway 39" }
mydict4 = { "name": "John 4", "address": "Highway 40" }


x = mycol.insert_one(mydict1)
print(x)
x = mycol.insert_one(mydict2)
print(x)
x = mycol.insert_one(mydict3)
print(x)
x = mycol.insert_one(mydict4)
print(x)

```


### TEST TWO

```

import pymongo
import time

myclient = pymongo.MongoClient('mongodb://admin:admin@front-envoy:27000,front-envoy:27001,front-envoy:27002,front-envoy:27003/?replicaSet=rs1')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]

x = mycol.find_one()
print(x)


for x in mycol.find():
  print(x)


```


```
docker exec -it dockermongo018_python_1 bash
apt update
apt install net-tools


import pymongo
import time

myclient = pymongo.MongoClient('mongodb://admin:admin@front-envoy:27000,front-envoy:27001,front-envoy:27002,front-envoy:27003/?replicaSet=rs1')
time.sleep(2)
print(myclient.nodes)

mydb = myclient["mydatabase"]
mycol = mydb["customers"]



for n in range(2000):
    mydict = { "name": f"John {n}", "address": f"Highway {n}" }
    time.sleep(1)
    x = mycol.insert_one(mydict)
    print(x)



root@b4e990bb85b7:/# netstat -napt
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.11:36399        0.0.0.0:*               LISTEN      -
tcp        0      0 172.31.16.7:55610       172.31.16.6:27001       TIME_WAIT   -
tcp        0      0 172.31.16.7:38602       172.31.16.5:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:46060       172.31.16.6:27002       TIME_WAIT   -
tcp        0      0 172.31.16.7:42962       172.31.16.6:27000       TIME_WAIT   -
tcp        0      0 172.31.16.7:41472       172.31.16.4:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:58586       172.31.16.2:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:38596       172.31.16.5:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:42960       172.31.16.6:27000       TIME_WAIT   -
tcp        0      0 172.31.16.7:48828       172.31.16.3:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:55604       172.31.16.6:27001       TIME_WAIT   -
tcp        0      0 172.31.16.7:42688       172.31.16.6:27003       TIME_WAIT   -
tcp        0      0 172.31.16.7:58594       172.31.16.2:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:41482       172.31.16.4:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:38606       172.31.16.5:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:46072       172.31.16.6:27002       TIME_WAIT   -
tcp        0      0 172.31.16.7:48820       172.31.16.3:27017       ESTABLISHED 226/python3
tcp        0      0 172.31.16.7:42672       172.31.16.6:27003       TIME_WAIT   -
root@b4e990bb85b7:/#


root@b4e990bb85b7:/# python3
Python 3.12.3 (main, May 14 2024, 07:23:41) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import pymongo
>>> import time
>>>
>>> myclient = pymongo.MongoClient('mongodb://admin:admin@front-envoy:27000,front-envoy:27001,front-envoy:27002,front-envoy:27003/?replicaSet=rs1')
>>> time.sleep(2)
>>> print(myclient.nodes)
frozenset({('mongodb_2', 27017), ('mongodb_3', 27017), ('mongodb_1', 27017), ('mongodb_4', 27017)})
>>>



```
