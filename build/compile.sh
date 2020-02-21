git status

# copy over dependencies
cp ~/Liferay/scripts/properties/build/app.server.kyle.properties $(pwd)
cp ~/Liferay/scripts/properties/build/test-properties/test.kyle.properties $(pwd)

#compile
ant all