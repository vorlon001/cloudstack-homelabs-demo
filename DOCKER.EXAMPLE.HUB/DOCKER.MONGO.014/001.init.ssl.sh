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



cd ssl
rm -R *

# ------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------ 

function initCertCA {

echo "00" > ca.srl
openssl genrsa -out ca.key 8192


openssl req -x509 -new -extensions v3_ca -key ca.key -days 7300 \
 -subj "/C=RU/ST=Russia/L=URAL/OU=iBLOG.Pro/CN=Root CA" -out ca.crt

openssl x509 -in ca.crt --text

cat ca.crt > ca.pem
}


function createCertVM {

VMHostname=$1
VMCertName=$2
VMIPaddress=$3

openssl req -nodes -newkey rsa:4096 -sha256 -keyout ${VMCertName}.key \
 -subj "/C=RU/ST=Russia/L=URAL/OU=iBLOG.Pro/CN=${VMHostname}" \
 -addext "subjectAltName = DNS.1:${VMHostname}, IP.1:${VMIPaddress}, DNS.2: localhost, IP.2:127.0.0.1" -out ${VMCertName}.csr


openssl x509 -req -extfile <(printf "subjectAltName=DNS.1:${VMHostname},IP.1:${VMIPaddress},DNS.2:localhost,IP.2:127.0.0.1") \
 -in ${VMCertName}.csr -CA ca.crt -CAkey ca.key -out ${VMCertName}.crt

cat ${VMCertName}.crt ${VMCertName}.key > ${VMCertName}.pem

}

# ------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

# Init a 4x5 matrix
a=(
"mongodb_1 mongodb-server-1 172.21.0.10"
"mongodb_2 mongodb-server-2 172.21.0.20"
"mongodb_3 mongodb-server-3 172.21.0.30"

)

createCertsVMs() {
  for rowdata in "${a[@]}"; do
    echo $rowdata
    echo ${rowdata[0]} ${rowdata[1]}
    createCertVM ${rowdata[0]} ${rowdata[1]} ${rowdata[2]}
  done
}

initCertCA
createCertsVMs


# ------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

# ------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

# ------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

openssl req -new -nodes -newkey rsa:4096 -sha256 -keyout client.key \
 -subj "/C=RU/ST=Russia/L=URAL/OU=iBLOG.Pro/CN=client" \
 -addext "subjectAltName = DNS:client, DNS:localhost" \
 -addext "keyUsage=keyEncipherment,dataEncipherment" \
 -addext "extendedKeyUsage=serverAuth" -out client.csr

openssl x509 -req -extfile <(printf "subjectAltName=DNS.1:client,DNS.2:localhost,IP.1: 172.21.0.1") \
 -in client.csr -CA ca.crt -CAkey ca.key -out client.crt

cat client.crt client.key > client.pem

cd ..



