FROM golang:alpine as go

RUN apk add --update ca-certificates git
RUN go get github.com/github/hub

FROM node:13.2.0-alpine3.10

RUN apk add --update yarn ca-certificates git curl jq py-pip bash && pip install yq 
COPY --from=go /go/bin/hub /usr/local/bin/hub

WORKDIR /cf-cli

COPY package.json /cf-cli
COPY check-version.js /cf-cli

RUN yarn --prod install

COPY . /cf-cli

RUN yarn generate-completion

RUN apk del yarn && npm uninstall npm -g

RUN ln -s $(pwd)/lib/interface/cli/codefresh /usr/local/bin/codefresh

ENTRYPOINT ["codefresh"]
