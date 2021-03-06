FROM balenalib/aarch64-alpine

ENV LEANOTE_VERSION=2.6.1
ENV SITE_LENG=uk

RUN apk --update add curl mongodb-tools && \
    curl -L http://sourceforge.net/projects/leanote-bin/files/${LEANOTE_VERSION}/leanote-linux-arm-v${LEANOTE_VERSION}.bin.tar.gz/download >> \
    /usr/local/leanote-linux-arm.bin.tar.gz && \
    curl -L https://raw.githubusercontent.com/mariusv/docker-leanote/master/leanote_install_data.tar.gz >> \
    /usr/local/leanote_install_data.tar.gz && \
    apk del --purge curl && \
    rm -rf /var/cache/apk/* \
    && tar -xzvf /usr/local/leanote-linux-arm.bin.tar.gz -C / \
    && rm -f /usr/local/leanote-linux-arm.bin.tar.gz \
    && mkdir -p /leanote/data/public/upload \
    && mkdir -p /leanote/data/files \
    && mkdir -p /leanote/data/mongodb_backup \
    && rm -r /leanote/public/upload \
    && rm -r /leanote/mongodb_backup \
    && ln -s /leanote/data/public/upload /leanote/public/upload \
    && ln -s /leanote/data/files /leanote/files \
    && ln -s /leanote/data/mongodb_backup /leanote/mongodb_backup \
    && tar zxf /usr/local/leanote_install_data.tar.gz -C /leanote \
    && rm -f /usr/local/leanote_install_data.tar.gz \
    && chmod +x /leanote/bin/run.sh
RUN hash=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-64};echo;); \
    sed -i "s/app.secret=.*$/app.secret=$hash #/" /leanote/conf/app.conf; \
    sed -i "s/db.host=.*$/db.host=db/" /leanote/conf/app.conf; \
    sed -i "s/site.url=.*$/site.url=\${SITE_URL} /" /leanote/conf/app.conf; 
 #   sed -i "s/i18n.default_language=.*$/i18n.default_language=uk /" /leanote/conf/app.conf;


VOLUME /leanote/data/

EXPOSE 9000
WORKDIR  /leanote/bin
ENTRYPOINT ["sh", "run.sh"]
