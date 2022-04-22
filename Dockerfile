FROM nginx:1.21.6-alpine

RUN apk --no-cache add tini bash
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./non-auth.conf.template /etc/nginx/conf.d/non-auth.conf.template

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
