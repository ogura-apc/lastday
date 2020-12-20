#!/bin/bash

#実行結果ログからサーバ名だけ配列として抽出
servers=(`cat ./installed_packages/list-installed.txt|grep ogura|awk -F "|" '{print $1}'`)

#サーバリストのホスト名総数を取得
number_of_servers=`echo ${#servers[*]}`

#実行結果ログの総行数を取得
last_column=`cat ./installed_packages/list-installed.txt | wc -l`

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
		next_server_pre=`grep $next_server -n ./installed_packages/list-installed.txt | sed -e 's/:.*//g'`
		next_server_pre=`expr $next_server_pre - 2`


		next_server_pre=`expr $next_server_pre - $check_server_column`


		#next_serverに入っているホスト名が表示される1行前の行数までを、check_serveerに入っているホスト名でテキスト出力
		cat ./installed_packages/list-installed.txt | grep -A $next_server_pre $check_server > ./installed_packages/${check_server}_list_installed.txt

		check_server_column=`expr $check_server_column + $next_server_pre + 1`

		nns=`expr $nns + 1`
		check_server=$next_server

		#★ループに戻る

	done

#▼最後のホストの処理

last_column=`expr $last_column - $check_server_column`

cat ./installed_packages/list-installed.txt | grep -A $last_column $check_server > ./installed_packages/${check_server}_list_installed.txt

#githubへプッシュ
cd /usr/etc/ansible/installed_packages

git add .
git commit -m "`date`"
git push -u installed_packages master

exit 0
#!/bin/bash

ansible all -i /usr/etc/ansible/server_list.txt -b -a "yum list installed" > /usr/etc/ansible/installed_packages/list-installed.txt
exit 0
