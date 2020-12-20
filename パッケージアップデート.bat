@echo off

echo パッケージアップデートジョブを開始します。
pause

echo 現在時刻：%date% %time% >>　%cd%\アップデート実行日時.txt

curl --user apc:apc1116 http://34.211.236.237:8080/job/yum-update_pipeline/build?token=ogura-apc


