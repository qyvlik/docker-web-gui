FROM node:alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
  apk add --update python make g++ && \
   rm -rf /var/cache/apk/*

WORKDIR /src

ADD ./backend /src/backend

RUN cd /src/backend && \
    rm -rf /src/backend/web/* && \
    npm install --registry=https://registry.npm.taobao.org

ADD ./client /src/client

RUN cd /src/client && \
    npm install --registry=https://registry.npm.taobao.org && \
    npm run build

RUN cp -rf /src/client/build/* /src/backend/web/*

ADD ./app.js /src/app.js

CMD ["node", "/src/app.js"]

EXPOSE 3230