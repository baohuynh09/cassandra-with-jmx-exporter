FROM cassandra:3.0.18

RUN mkdir /prometheus

# Currently we use javaagent-0.12.0. Please use latest we rebuild
ADD "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.12.0/jmx_prometheus_javaagent-0.12.0.jar" /prometheus
RUN chmod 644 /prometheus/jmx_prometheus_javaagent-0.12.0.jar

# Don't use default cassandra.yml since some metrics is laking of
#ADD "https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/cassandra.yml" /prometheus
COPY cassandra.yml /prometheus
RUN chmod 644 /prometheus/cassandra.yml

# Tell cassandra to run JMX exporter as an agent (with config cassandra.yml)
# And expose metrics at port 61621
RUN echo 'JVM_OPTS="$JVM_OPTS -javaagent:'/prometheus/jmx_prometheus_javaagent-0.12.0.jar=61621:/prometheus/cassandra.yml'"' >> /etc/cassandra/cassandra-env.sh

EXPOSE 61621
