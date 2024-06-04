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



a=(
"mongodb-server-1 172.21.0.10 rs1"
"mongodb-server-2 172.21.0.20 rs1"
"mongodb-server-3 172.21.0.30 rs1"
)

cd src

createConfigMongo() {

VMHostname=$1
VMIPaddress=$2
VMReplicaSet=$3

cat<<EOF>${VMHostname}.conf
storage:
  dbPath: /data
  journal:
    enabled: true

net:
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/ssl/${VMHostname}.pem
    CAFile: /etc/ssl/ca.crt
    clusterFile: /etc/ssl/${VMHostname}.pem
    clusterCAFile: /etc/ssl/ca.crt

  port: 27017
  bindIpAll: true
  ipv6: false

processManagement:
  timeZoneInfo: /usr/share/zoneinfo
  fork: false

security:
  authorization: enabled
  clusterAuthMode: x509

replication:
  replSetName: "${VMReplicaSet}"

EOF

}

createConfigVMs() {
  for rowdata in "${a[@]}"; do
    echo $rowdata
    echo ${rowdata[0]} ${rowdata[1]}

    vmnames=${rowdata[0]}

    createConfigMongo $vmnames

  done
}


createConfigVMs

cd ..
