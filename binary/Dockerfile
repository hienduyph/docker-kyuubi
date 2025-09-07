FROM docker.io/eclipse-temurin:17.0.13_11-jdk-noble

ARG kyuubi_uid=10009
ARG VERSION=1.10.0

USER root
ENV VERSION=${VERSION}
ENV KYUUBI_USER_HOME /home/kyuubi
ENV KYUUBI_HOME /opt/kyuubi
ENV KYUUBI_LOG_DIR ${KYUUBI_HOME}/logs
ENV KYUUBI_PID_DIR ${KYUUBI_HOME}/pid
ENV KYUUBI_WORK_DIR_ROOT ${KYUUBI_HOME}/work

RUN set -ex; \
   apt-get update && \
   apt install -y curl bash tini libc6 libpam-modules krb5-user libnss3 procps && \
   mkdir -p ${KYUUBI_HOME} ${KYUUBI_LOG_DIR} ${KYUUBI_PID_DIR} ${KYUUBI_WORK_DIR_ROOT} && \
   rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://dlcdn.apache.org/kyuubi/kyuubi-${VERSION}/apache-kyuubi-${VERSION}-bin.tgz" | tar xz -C ${KYUUBI_HOME} --strip-components=1

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

# setup kyuubi
RUN set -ex && \
   useradd -u ${kyuubi_uid} -g root kyuubi -d ${KYUUBI_USER_HOME} -m && \
   chmod ug+rw -R ${KYUUBI_HOME} && \
   chmod a+rwx -R ${KYUUBI_WORK_DIR_ROOT}

WORKDIR ${KYUUBI_HOME}

CMD [ "./bin/kyuubi", "run" ]

USER ${kyuubi_uid}
