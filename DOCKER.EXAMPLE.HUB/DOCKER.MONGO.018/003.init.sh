#!/usr/bin/bash

function throw()
{
   errorCode=$?
   echo "Error: ($?) LINENO:$1"
   exit $errorCode
}

function check_error {
  if [ $? -ne 0 ]; then
    echo "Error: ($?) LINENO:$1"
    exit 1
  fi
}


openssl rand -base64 768 > mongo-replication.key || throw ${LINENO}

chmod 400 mongo-replication.key || throw ${LINENO}
chown 999:999 mongo-replication.key || throw ${LINENO}

mkdir -p scripts || throw ${LINENO}

cat <<EOF>scripts/init-replica-set.js
use admin;
rs.initiate(
    {_id: "rs1", version: 1,
        members: [
            { _id: 0, host : "mongodb_1:27017" },
            { _id: 1, host : "mongodb_2:27017" },
            { _id: 2, host : "mongodb_3:27017" },
            { _id: 3, host : "mongodb_4:27017" }
        ]
    }
);
EOF


cat <<EOF>scripts/init-admin-user.js
use admin;
db.createUser({
	user: 'admin',
	pwd: 'admin',
	roles: [ { role: 'root', db: 'admin' } ]
});
EOF


cat <<EOF>scripts/init-user.js
db.auth('admin', 'admin');
db = db.getSiblingDB('my_database');
db.createUser({
  user: 'servicelogin',
  pwd: 'servicepassword',
  roles: [
    {
      role: 'dbOwner',
      db: 'my_database',
    },
  ],
});
db.createUser({
  user: 'adminservicelogin',
  pwd: 'adminservicepassword',
  roles: [
    {
      role: 'dbOwner',
      db: 'my_database',
    },
  ],
});
EOF

docker-compose up -d mongodb_1 mongodb_2 mongodb_3 mongodb_4 front-envoy python|| throw ${LINENO}
echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}


docker-compose exec mongodb_1 bash -c "mongosh < /scripts/init-replica-set.js" || throw ${LINENO}
echo "sleep 15sec" || throw ${LINENO}
sleep 15 || throw ${LINENO}


docker-compose exec mongodb_1 bash -c "mongosh < /scripts/init-admin-user.js" || throw ${LINENO}
echo "sleep 15sec" || throw ${LINENO}
sleep 15 || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker-compose exec mongodb_1 bash -c "mongosh --host mongodb_1:27017 --username admin --password admin --authenticationDatabase admin admin --eval \"rs.status();\"" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker-compose exec mongodb_1 bash -c "mongosh --host mongodb_1:27017 --username admin --password admin --authenticationDatabase admin admin < /scripts/init-user.js" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

echo "RUN:docker-compose exec mongodb_1 bash -c \"mongosh --host mongodb_1,mongodb_2,mongodb_3 --username admin --password admin --authenticationDatabase admin\"" || throw ${LINENO}
echo "RUN:docker-compose exec mongodb_1 bash -c \"mongosh --host mongodb_1,mongodb_2,mongodb_3 --username adminservicelogin --password adminservicepassword --authenticationDatabase my_database\"" || throw ${LINENO}


docker-compose restart mongodb_1

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker-compose exec mongodb_2 bash -c "mongosh --host mongodb_2:27017 --username admin --password admin --authenticationDatabase admin admin --eval \"rs.status();\"" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker-compose exec mongodb_2 bash -c "mongosh --host mongodb_2:27017 --username admin --password admin --authenticationDatabase admin admin --eval \"rs.remove('mongodb_1:27017')\"" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}


docker-compose exec mongodb_2 bash -c "mongosh --host mongodb_2:27017 --username admin --password admin --authenticationDatabase admin admin --eval \"rs.status();\"" || throw ${LINENO}


exit
