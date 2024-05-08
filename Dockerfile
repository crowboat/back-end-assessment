FROM node:20-alpine as base

WORKDIR /home/node/app

COPY package*.json ./

RUN npm i

# Install necessary build dependencies and tools
RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base sqlite sqlite-dev openssl-dev libuuid

# # Download SQLite source code and compile
# RUN wget https://www.sqlite.org/2024/sqlite-autoconf-3450300.tar.gz && \
#     tar xvf sqlite-autoconf-3450300.tar.gz && \
#     cd sqlite-autoconf-3450300 && \
#     ./configure --enable-uuid && \
#     make && \
#     make install

# # Clean up unnecessary files
# RUN rm -rf sqlite-autoconf-3450300 sqlite-autoconf-3450300.tar.gz

COPY . .
RUN npm run build
# RUN touch /home/node/app/src/db/Projection2021.db
RUN chmod +r src/db/csv/Projection2021.csv
COPY src/db/csv/Projection2021.csv /home/node/app/build/db/csv/Projection2021.csv
# RUN sqlite3 /home/node/app/src/db/Projection2021.db ".mode csv" ".import /home/node/app/Projection2021.csv crop_harvest_plant_history"
COPY init_script.sql /tmp/init_script.sql
RUN sqlite3 /home/node/app/build/db/Projection2021.db < /tmp/init_script.sql
RUN rm -rf /tmp/init_script.sql


