#!/bin/bash

# 待测url的存放路径.
urlPath=conf;

# 测试结果存放文件. 
errorUrl="data/errorURL";
urlCount="data/urlCount";
errorUrlWap="data/errorURLWap";

# 清空上次测试的结果数据.
rm -rf $errorUrl;
rm -rf $errorUrlWap;

# 计数变量，用于记录当前测试的是第几个url.
count=0;

# 待测试的url的主机名.
#hostname="http://tc-iknow-fmon23.tc.baidu.com:8080";
#hostname="http://jx-iknow-tips00.jx.baidu.com:8080";
#hostname="http://tc-iknow-fmon00.tc.baidu.com:8080";
#hostname="http://cq01-testing-iknow15.vm.baidu.com:8080";
hostname="http://tc-iknow-web00.tc.baidu.com:8081";

echo "Ready?";
for ((i=5; i>0; --i))
do
	echo $i;
	sleep 1;
done
echo "GO.....";

useragent="Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko)";

# 对待测路径中的所有文件中的每个url执行测试，并把测试结果存入结果文件中.
for urlFile in $(ls $urlPath)
do
	# 开始url测试，并且把测试结果保存在文件中.
	while read line
	do
		uri=$line;
		code=$(curl --output /dev/null --silent --head --referer "$hostname$uri" --write-out '%{http_code}' "$hostname$uri");
		if [ $code -ne 200 ];
		then
			echo $code " " $uri >> $errorUrl;
		fi
		
		code=$(curl --output /dev/null --silent --head --user-agent "$useragent" --referer "$hostname$uri" --write-out '%{http_code}' "$hostname$uri");
		if [ $code -ne 200 ];
		then
			echo $code " " $uri >> $errorUrlWap;
		fi

		isShowInfo=$((count%1));
		if [ $isShowInfo -eq 0 ];
		then
			echo $count > $urlCount;
		fi
		
		count=$((count+1));
		sleep 1;
	done < $urlPath/$urlFile;	
done

