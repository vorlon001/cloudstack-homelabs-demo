FROM envoyproxy/envoy:v1.30.1


RUN apt-get update && apt-get -q install -y \
    curl

CMD /usr/local/bin/envoy -c /etc/front-envoy.yaml --service-cluster front-proxy
