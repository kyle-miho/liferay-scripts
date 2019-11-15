IJ_CLONE_PATH=/home/kyle/Liferay/liferay-intellij

ij () {
	${IJ_CLONE_PATH}/intellij "$@"
}

echo building
ij
