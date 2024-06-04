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
rs.initiate({
  "_id": "rs1",
  "version": 1,
  "writeConcernMajorityJournalDefault": true,
  "members": [
    {
      "_id": 0,
      "host": "172.21.0.10:27017",
    },
    {
      "_id": 1,
      "host": "172.21.0.20:27017",
    },
    {
      "_id": 2,
      "host": "172.21.0.30:27017",
      arbiterOnly: true
    }
  ]
});
EOF


cat <<EOF>scripts/init-user-access.js
use admin;
db.createUser({
  user: "mdb_admin",
  pwd: "mdb_pass",
  roles: [
    {role: "root", db: "admin"},
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db:"admin" },
    { role: "clusterAdmin",  db: "admin" }
  ]
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

docker-compose up -d || throw ${LINENO}

echo "sleep 20sec." || throw ${LINENO}
sleep 20 || throw ${LINENO}

docker exec -it dockermongo014_mongodb_1_1 bash -c "mongosh --tls --tlsCertificateKeyFile /etc/ssl/mongodb-server-1.pem --tlsCAFile /etc/ssl/ca.crt < /scripts/init-replica-set.js" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}


docker exec -it dockermongo014_mongodb_1_1 bash -c "mongosh --tls --tlsCertificateKeyFile /etc/ssl/mongodb-server-1.pem --tlsCAFile /etc/ssl/ca.crt < /scripts/init-user-access.js" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker exec -it dockermongo014_mongodb_1_1 bash -c "mongosh --tls --tlsCertificateKeyFile /etc/ssl/mongodb-server-1.pem --tlsCAFile /etc/ssl/ca.crt -u mdb_admin -p mdb_pass --sslAllowInvalidHostnames --eval \"rs.status();\"" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}

docker exec -it dockermongo014_mongodb_1_1 bash -c "mongosh --tls --tlsCertificateKeyFile /etc/ssl/mongodb-server-1.pem --tlsCAFile /etc/ssl/ca.crt -u mdb_admin -p mdb_pass --sslAllowInvalidHostnames < /scripts/init-user.js" || throw ${LINENO}

echo "sleep 10sec" || throw ${LINENO}
sleep 10 || throw ${LINENO}



echo "RUN:docker exec -it dockermongo014_mongodb_1_1 bash -c \"mongosh --host mongodb_1,mongodb_2,mongodb_3 --tls --tlsCertificateKeyFile /etc/ssl/client.pem --tlsCAFile /etc/ssl/ca.crt -u servicelogin -p servicepassword --sslAllowInvalidHostnames --authenticationDatabase my_database\""

echo "RUN:docker exec -it dockermongo014_mongodb_1_1 bash -c \"mongosh --host mongodb_1,mongodb_2,mongodb_3 --tls --tlsCertificateKeyFile /etc/ssl/mongodb-server-1.pem --tlsCAFile /etc/ssl/ca.crt -u mdb_admin -p mdb_pass --sslAllowInvalidHostnames\""

