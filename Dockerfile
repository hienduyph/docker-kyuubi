ARG VERSION=1.9.2
FROM docker.io/apache/kyuubi:${VERSION}-spark

RUN set -ex \
  && export SPARK_VERSION="$(ls $KYUUBI_HOME/externals | grep spark | grep -Eo '[0-9]\.[0-9]\.[0-9]' )"  \
  && export HADOOP_VERSION="$(ls $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3/jars/hadoop-client-runtime*.jar | xargs -n 1 basename | grep -Eo '[0-9]\.[0-9]\.[0-9]' )" SPARK_SHORT="$(echo ${SPARK_VERSION} | grep -Eo '^[0-9]\.[0-9]')" \
  && cd $KYUUBI_HOME/externals/spark-${SPARK_VERSION}-bin-hadoop3/jars \
  && export AWS_VERSION=1.12.744 \
  && curl -LO https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
  && curl -LO https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_VERSION}/aws-java-sdk-bundle-${AWS_VERSION}.jar

