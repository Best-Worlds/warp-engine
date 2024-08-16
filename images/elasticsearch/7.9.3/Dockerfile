FROM elasticsearch:7.9.3

RUN bin/elasticsearch-plugin install analysis-phonetic
RUN bin/elasticsearch-plugin install analysis-icu

EXPOSE 9200 9300
CMD ["elasticsearch"]