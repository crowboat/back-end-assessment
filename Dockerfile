FROM node:20-alpine as base

WORKDIR /home/node/app

COPY package*.json ./

RUN npm i

RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base sqlite sqlite-dev openssl-dev libuuid

COPY . .
RUN npm run build
RUN chmod +r src/db/csv/Projection2021.csv
COPY src/db/csv/Projection2021.csv /home/node/app/build/db/csv/Projection2021.csv
COPY init_script.sql /tmp/init_script.sql
RUN sqlite3 /home/node/app/build/db/Projection2021.db < /tmp/init_script.sql
RUN rm -rf /tmp/init_script.sql


