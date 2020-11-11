#Usage:
#1.将此文件拷贝到工程根目录
#2.cd到工程根目录, 执行 sh AutoPush.sh

# Source Spec名称
SOURCE_SPEC_NAME="iTutorSpecs"

# 获取项目名称
PROJECT_DIR_PATH=$(pwd)
PROJECT_NAME=${PROJECT_DIR_PATH##*/}

POD_SPEC="${PROJECT_NAME}.podspec"
POD_SPEC_JSON="${PROJECT_NAME}.podspec.json"

POD_SPEC_PATH="${PROJECT_DIR_PATH}/${POD_SPEC}"
POD_SPEC_JSON_PATH="${PROJECT_DIR_PATH}/${POD_SPEC_JSON}"

if [ -f "${POD_SPEC_JSON}" ]; then
rm ${POD_SPEC_JSON}
fi

pod ipc spec ${POD_SPEC_PATH} >> ${POD_SPEC_JSON_PATH}

# Push Tag
VERSION=`cat ${POD_SPEC_JSON_PATH} |awk -F"[:]" '/version/{print $2}' |awk -F "[,]" '{print $1}' |sed 's/\"//g'`
git tag ${VERSION}
git push origin ${VERSION}

if [ -f "${POD_SPEC_JSON}" ]; then
rm ${POD_SPEC_JSON}
fi

# 错误信息
function exitWithMessage(){
echo "--------------------------------"
echo "发生错误, ${1}"
echo "--------------------------------"
exit ${2}
}

# Repo 相关
PROJECT_F_DIR_PATH=$(dirname $(pwd))
REPO_DIR_PATH="${PROJECT_F_DIR_PATH}/${SOURCE_SPEC_NAME}"

cd ${REPO_DIR_PATH}

git checkout master
git pull origin master

# 创建工程Repo目录
IS_NEW_MODULE=false
if [ ! -d "${PROJECT_NAME}" ]; then
mkdir -p ${PROJECT_NAME}
IS_NEW_MODULE=true
fi

cd ${PROJECT_NAME}

# 创建对应版本的文件夹
if [ ! -d "${VERSION}" ]; then
mkdir -p ${VERSION}
else
exitWithMessage "当前已经存在${VERSION}版本" 1
fi

cd ${VERSION}

# 复制.podspec文件
cp ${POD_SPEC_PATH} .

# Push Repo
cd ../..

git checkout master
git pull origin master

git add .

if [ ${IS_NEW_MODULE} = true ]; then
git commit -m "[ADD] ${PROJECT_NAME} ${VERSION}"
else
git commit -m "[UPDATE] ${PROJECT_NAME} ${VERSION}"
fi

git push --set-upstream origin master
