FROM fabiocicerchia/nginx-lua:1.21.6-alpine-compat

RUN apk --no-cache add tini bash gettext
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./*.template /tmp/

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
