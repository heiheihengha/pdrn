nohup ./PandoraNext &
function update_license {
    curl -fLO https://dash.pandoranext.com/data/${LICENSE_URL}/license.jwt
    curl -H "Authorization: Bearer 123456" -X POST "http://127.0.0.1:8080/setup/reload"
}
# 无限循环
while true
do
    sleep 240       # 暂停240秒（4分钟）
    update_license   # 调用函数
done 