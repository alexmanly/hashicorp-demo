#!/usr/bin/env bash
set -e

# Download App into the tomcat webapps directory
curl -L "${app_download_url}" > /opt/tomcat_hashidemo/webapps/hashiapp-demo.war

export VAULT_ADDR=$(curl http://${consul_url}/v1/kv/service/app/vault_addr?raw)

export VAULT_TOKEN=${vault_token}

/usr/bin/java -Djava.util.logging.config.file=/opt/tomcat_hashidemo/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.endorsed.dirs=/opt/tomcat_hashidemo/endorsed -classpath /opt/tomcat_hashidemo/bin/bootstrap.jar:/opt/tomcat_hashidemo/bin/tomcat-juli.jar -Dcatalina.base=/opt/tomcat_hashidemo -Dcatalina.home=/opt/tomcat_hashidemo -Djava.io.tmpdir=/opt/tomcat_hashidemo/temp org.apache.catalina.startup.Bootstrap start &

# Download App into the tomcat webapps directory
curl -L "${app_springboot_download_url}" > /tmp/hashiapp-springboot-demo.war

/usr/bin/java -jar /tmp/hashiapp-springboot-demo.war &

