FROM postgres:16-alpine

RUN apk add --no-cache dcron tzdata

COPY docker/postgres-maintenance/truncate-message-history.sh /usr/local/bin/truncate-message-history.sh

RUN chmod +x /usr/local/bin/truncate-message-history.sh

CMD ["/bin/sh", "-ec", "printf 'SHELL=/bin/sh\nPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\n%s /usr/local/bin/truncate-message-history.sh >> /proc/1/fd/1 2>> /proc/1/fd/2\n' \"$${MESSAGE_HISTORY_TRUNCATE_CRON:-0 3 * * *}\" > /etc/crontabs/root && exec crond -f -l 2"]
