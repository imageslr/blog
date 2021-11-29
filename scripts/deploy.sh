set -e

# notify before exit
notify() {
  EXIT_CODE=$? # 获取退出状态
  STATUS="Success"
  COLOR="blue"
  if [ $EXIT_CODE -ne 0 ] 
  then 
    STATUS="Failed" 
    COLOR="red"
  fi
  echo $STATUS

  # 获取提交信息
  GIT_MESSAGE=`git log --format=format:%s -1 ${GIT_COMMIT}`
  CHANGE_ID=`echo $GIT_COMMIT | cut -c 1-10`


  # 发送飞书通知
  # 飞书机器人 webhook 指南：
  #    https://open.feishu.cn/document/ukTMukTMukTM/ucTM5YjL3ETO24yNxkjN
  # 飞书消息卡片可视化编辑：
  #    https://open.feishu.cn/tool/cardbuilder?lang=zh-CN
  # JSON 序列化：
  #    https://www.bejson.com/zhuanyi/
  JSON="{\"msg_type\":\"interactive\",\"card\":{\"config\":{\"wide_screen_mode\":true},\"elements\":[{\"tag\":\"div\",\"text\":{\"content\":\"**ChangeID：**$CHANGE_ID\n**Message：**$GIT_MESSAGE\",\"tag\":\"lark_md\"}}],\"header\":{\"template\":\"$COLOR\",\"title\":{\"content\":\"[$STATUS]  Jenkins Build\",\"tag\":\"plain_text\"}}}}"
  

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