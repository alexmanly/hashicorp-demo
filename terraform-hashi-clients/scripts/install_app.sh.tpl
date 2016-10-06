#!/usr/bin/env bash
set -e


export VAULT_ADDR=${vault_addr}
export VAULT_TOKEN=${vault_token}

/usr/bin/java -Djava.util.logging.config.file=/opt/tomcat_hashidemo/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.endorsed.dirs=/opt/tomcat_hashidemo/endorsed -classpath /opt/tomcat_hashidemo/bin/bootstrap.jar:/opt/tomcat_hashidemo/bin/tomcat-juli.jar -Dcatalina.base=/opt/tomcat_hashidemo -Dcatalina.home=/opt/tomcat_hashidemo -Djava.io.tmpdir=/opt/tomcat_hashidemo/temp org.apache.catalina.startup.Bootstrap start &



/usr/bin/java -jar /tmp/hashiapp-springboot-demo.war &
