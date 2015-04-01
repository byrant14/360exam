#!/bin/sh
#对我来说有难度，查了以下想尝试，结果手头只有一台电脑。就找了一个解决方案。代码来自http://www.oschina.net/code/snippet_54100_3230
#需要安装nc、screen和expect
#登录内网服务器，将这个脚本保存为autossh.sh，打开screen，然后执行：authssh.sh [user@]remote[:port]，再输入ssh密码。
 
if [ "$1x" != "connectx" ]; then
 
    if [ -z $1 ]; then
        echo "Usage: $0 [username@]host[:port]" 2>&1
        exit 0
    fi
 
    echo -n "Password: "
 
    stty -echo; read pass; stty echo; echo ""
 
    expect -- << EOF
        spawn $0 connect $1
 
        while 1 {
            expect {
                "password:" {
                    send "$pass\r"
                }
                "yes/no" {
                    send "yes\r"
                }
                "Permission denied" {
                    puts "Password error."
                    break
                }
            }
        }
EOF
else
    shift
    port=`echo $1 | perl -nle 'print /\:(\d+)$/ ? $1 : "22"'`
    while [ 1 ]
        do ssh -p $port -CN -D 0.0.0.0:7070 $1 target "while nc -zv localhost 7070; do sleep 20; done"
        sleep 20
    done
fi

