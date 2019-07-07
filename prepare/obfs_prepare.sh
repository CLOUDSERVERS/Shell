install_prepare_libev_obfs(){
    if ! autoconf_version || centosversion 6; then
        echo
        echo -e "${Info} autoconf 版本小于 2.67，Shadowsocks-libev 插件 simple-obfs 的安装将被终止."
        echo
        exit 1
    fi
    
    while true
    do
        echo -e "请为simple-obfs选择obfs\n"
        for ((i=1;i<=${#OBFUSCATION_WRAPPER[@]};i++ )); do
            hint="${OBFUSCATION_WRAPPER[$i-1]}"
            echo -e "${Green}  ${i}.${suffix} ${hint}"
        done
        echo
        read -e -p "(默认: ${OBFUSCATION_WRAPPER[0]}):" libev_obfs
        [ -z "$libev_obfs" ] && libev_obfs=1
        expr ${libev_obfs} + 1 &>/dev/null
        if [ $? -ne 0 ]; then
            echo
            echo -e "${Error} 请输入一个数字"
            echo
            continue
        fi
        if [[ "$libev_obfs" -lt 1 || "$libev_obfs" -gt ${#OBFUSCATION_WRAPPER[@]} ]]; then
            echo
            echo -e "${Error} 请输入一个数字在 [1-${#OBFUSCATION_WRAPPER[@]}] 之间"
            echo
            continue
        fi
        shadowsocklibev_obfs=${OBFUSCATION_WRAPPER[$libev_obfs-1]}
        echo
        echo -e "${Red}  obfs = ${shadowsocklibev_obfs}${suffix}"
        echo
        break
    done
    
    echo
    echo -e "请为simple-obfs输入用于混淆的域名"
    echo
    read -e -p "(默认: www.bing.com):" obfs_site
    [ -z "$obfs_site" ] && obfs_site="www.bing.com"
    echo
    echo -e "${Red}  obfs-host = ${obfs_site}${suffix}"
    echo
    
    while true
    do
        echo
        echo -e "是否开启simple-obfs故障转移(failover)功能"
        echo
		read -p "(默认: 否) [y/n]: " is_enabled_failover
        [ -z "${is_enabled_failover}" ] && is_enabled_failover="N"
        case "${is_enabled_failover:0:1}" in
            y|Y)
                is_enabled_failover="true"
                break
                ;;
            n|N)
                is_enabled_failover="false"
                break
                ;;
            *)
                echo
                echo -e "${Error} 输入有误，请重新输入!"
                echo
                continue
                ;;
        esac
	done
    
    if is_enabled_failover; then
        if [[ ${libev_obfs} == "1" ]]; then
            echo
            read -e -p "请输入用于caddy搭建本地服务器所需的域名:" domain
            echo
            echo -e "${Red}  domain = ${domain}${suffix}"
            echo
        elif [[ ${libev_obfs} == "2" ]]; then    
            echo
            read -e -p "请输入用于caddy搭建本地服务器所需的域名:" domain
            echo
            echo -e "${Red}  domain = ${domain}${suffix}"
            echo
            
            echo
            read -e -p "请输入用于caddy自动申请证书所需的Email:" email
            echo
            echo -e "${Red}  email = ${domain}${suffix}"
            echo
        fi
    fi   
}