ARG VERSION=1.10.0
FROM docker.io/apache/kyuubi:${VERSION}

USER root
ARG VERSION=1.10.0
ENV VERSION=${VERSION}

RUN set -ex \
  && export SPARK_VERSION="3.5.6"  \
  && mkdir -p $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3 \
  && curl -fsSL https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | tar xz -C $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3 --strip-components=1 \
  && export HADOOP_VERSION="$(ls $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3/jars/hadoop-client-runtime*.jar | xargs -n 1 basename | grep -Eo '[0-9]\.[0-9]\.[0-9]' )" SPARK_SHORT="$(echo ${SPARK_VERSION} | grep -Eo '^[0-9]\.[0-9]')" \
  && cd $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3/jars \
  && export AWS_VERSION=1.12.777 \
  && curl -LO https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
  && curl -LO https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_VERSION}/aws-java-sdk-bundle-${AWS_VERSION}.jar

RUN cd $KYUUBI_HOME/externals/engines/jdbc \
  && curl -LO https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar \
  && curl -LO https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.4/postgresql-42.7.4.jar

WORKDIR ${KYUUBI_HOME}

USER kyuubi
