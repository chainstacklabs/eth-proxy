FROM nginx:1.19.7-alpine

RUN apk --no-cache add tini
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./default.conf.template /etc/nginx/conf.d/default.conf.template

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
