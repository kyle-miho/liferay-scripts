if exist "%CATALINA_HOME%/jre${jdk.windows.version}/win" (
	if not "%JAVA_HOME%" == "" (
		set JAVA_HOME=
	)

	set "JRE_HOME=%CATALINA_HOME%/jre${jdk.windows.version}/win"
)

set "CATALINA_OPTS=%CATALINA_OPTS% -Dfile.encoding=UTF8 -Djava.net.preferIPv4Stack=true -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xms4096m -Xmx4096m -XX:MaxNewSize=256m -XX:NewSize=512m -XX:MaxMetaspaceSize=900m -XX:MetaspaceSize=900m -XX:SurvivorRatio=7"
set "JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=8099 -Dcom.sun.management.jmxremote.ssl=false"

set "CATALINA_OPTS=%CATALINA_OPTS% %JMX_OPTS%"
