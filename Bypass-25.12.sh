#!/bin/sh
exec >/tmp/setup.log 2>&1

# 旁路由自身 IP
LAN_IP="192.168.110.110/24"
# 主路由网关（请改成你实际的主路由 IP）
MAIN_GATEWAY="192.168.110.1"

# 设置 LAN IP
uci set network.lan.ipaddr="$LAN_IP"
uci set network.lan.gateway="$MAIN_GATEWAY"
uci set network.lan.dns="$MAIN_GATEWAY"
uci commit network

# 关闭旁路由 DHCP（由主路由统一分配）
uci set dhcp.lan.ignore='1'
uci commit dhcp

# 防火墙开启 LAN 动态伪装
uci set firewall.@zone[0].masq='1'
uci commit firewall

# NTP 时间同步
uci set system.ntp.enabled='1'
uci set system.ntp.enable_server='0'
uci -q delete system.ntp.server
uci add_list system.ntp.server='ntp.aliyun.com'
uci add_list system.ntp.server='time1.cloud.tencent.com'
uci add_list system.ntp.server='cn.pool.ntp.org'
uci commit system

exit 0
