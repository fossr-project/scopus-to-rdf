FROM frolvlad/alpine-bash

RUN <<EOF
apk -U upgrade
apk add jq
apk add --update nodejs npm
npm install -g jsonld-cli
EOF

COPY config ./config
COPY bin ./bin

CMD ["./bin/map-all.sh"]
