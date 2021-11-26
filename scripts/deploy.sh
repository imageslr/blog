set -e

# notify before exit
notify() {
  EXIT_CODE=$? # 获取退出状态
  STATUS="Success"
  if [ $EXIT_CODE -ne 0 ] 
  then 
    STATUS="Failed" 
  fi
  echo $STATUS

  # 获取提交信息
  GIT_MESSAGE=`git log --format=format:%s -1 ${GIT_COMMIT}`
  CHANGE_ID=`echo $GIT_COMMIT | cut -c 1-10`
  JSON="{\"msg_type\": \"text\", \"content\": {\"text\": \"Blog Jenkins Build $STATUS\nChangeId: $CHANGE_ID\nMessage: $GIT_MESSAGE\"}}"

  # 发送飞书通知
  curl --location --request POST "https://open.feishu.cn/open-apis/bot/v2/hook/$FEISHU_TOKEN" \
  --header 'Content-Type: application/json' \
  --data "$JSON"
}
trap notify EXIT

# install
bundle install

# clean
bundle config set --local path 'vendor/bundle'
bundle exec jekyll clean

# build
JEKYLL_ENV="production" TZ="Asia/Shanghai" bundle exec jekyll build

# deploy
rm -rf /var/www/html/*
cp -a ./_site/* /var/www/html