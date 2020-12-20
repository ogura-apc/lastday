#!/bin/bash

#引数を変数に代入
file_name=$1


#実行結果ログからサーバ名だけ配列として抽出
servers=(`cat ./check-update/${file_name}.txt|grep ogura|awk -F "|" '{print $1}'`)

#サーバリストのホスト名総数を取得
number_of_servers=`echo ${#servers[*]}`

#実行結果ログの総行数を取得
last_column=`cat ./check-update/${file_name}.txt | wc -l`

#サーバリスト用変数セット
ncs=0
nns=1
check_server_column=0

#サーバリストの1番目のサーバのホスト名を取得
check_server=`echo ${servers[0]}`

#★ループ

while [ $nns -lt $number_of_servers ]
        do

                #number_of_serversの値になるまで繰り返す

                #サーバリストのホスト名(チェック対象の次)を抽出
                next_server=`echo ${servers[$nns]}`

                #next_serverに入っているホスト名が表示される1行前の行数を取得
                next_server_pre=`grep $next_server -n ./check-update/${file_name}.txt | sed -e 's/:.*//g'`
                next_server_pre=`expr $next_server_pre - 2`


                next_server_pre=`expr $next_server_pre - $check_server_column`


                #next_serverに入っているホスト名が表示される1行前の行数までを、check_serveerに入っているホスト名でテキスト出力
                cat ./check-update/${file_name}.txt | grep -A $next_server_pre $check_server > ./check-update/${check_server}_${file_name}.txt

                check_server_column=`expr $check_server_column + $next_server_pre + 1`

                nns=`expr $nns + 1`
                check_server=$next_server

                #★ループに戻る

        done

#▼最後のホストの処理

last_column=`expr $last_column - $check_server_column`

cat ./check-update/${file_name}.txt | grep -A $last_column $check_server > ./check-update/${check_server}_${file_name}.txt

#githubへプッシュ
cd /usr/etc/ansible/check-update

git add .
git commit -m "`date`"
git push -u origin master

exit 0
