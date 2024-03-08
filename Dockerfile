#
# Build on top of mongodb container and add the backup script
#
FROM docker.io/mongo:6

COPY automongobackup.sh /usr/local/bin/

ENTRYPOINT ["automongobackup.sh"]
