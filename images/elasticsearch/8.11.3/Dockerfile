FROM elasticsearch:8.11.3

RUN bin/elasticsearch-plugin install analysis-phonetic
RUN bin/elasticsearch-plugin install analysis-icu

EXPOSE 9200 9300
CMD ["elasticsearch"]

COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/
