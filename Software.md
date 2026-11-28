# 预装软件包清单

ImmortalWrt 25.12：

```
luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn luci-i18n-package-manager-zh-cn openssh-sftp-server
curl wget-ssl nano htop iperf3 luci-theme-argon luci-app-diskman luci-i18n-diskman-zh-cn luci-app-ttyd
luci-i18n-ttyd-zh-cn kmod-nft-queue kmod-nfnetlink-queue dnsmasq-full kmod-tun kmod-nft-tproxy
kmod-nft-socket kmod-nft-nat ip-full ipset kmod-inet-diag ca-bundle bash coreutils-nohup block-mount
kmod-fs-ext4 e2fsprogs kmod-fs-ntfs3 kmod-fs-exfat kmod-usb-storage smartmontools tcpdump
bind-dig ethtool unzip tar irqbalance kmod-tcp-bbr
```

## 各包用途

| 软件包 | 用途 |
|:--|:--|
| `luci-i18n-base-zh-cn` | 管理界面基础中文 |
| `luci-i18n-firewall-zh-cn` | 防火墙界面中文 |
| `luci-i18n-package-manager-zh-cn` | 软件包管理界面中文 |
| `luci-app-diskman` / `luci-i18n-diskman-zh-cn` | 磁盘管理插件及中文 |
| `luci-app-ttyd` / `luci-i18n-ttyd-zh-cn` | 网页终端插件及中文 |
| `luci-theme-argon` | Argon 主题 |
| `openssh-sftp-server` | SFTP 文件传输 |
| `curl` / `wget-ssl` | 命令行下载工具，支持 HTTPS |
| `nano` | 文本编辑器 |
| `htop` | 查看 CPU、内存和进程 |
| `iperf3` | 网络测速 |
| `kmod-nft-queue` | nftables 队列内核模块，将数据包送入用户态队列 |
| `kmod-nfnetlink-queue` | NFQUEUE 内核模块，配合 nft queue 实现流量接管（如透明代理） |
| `dnsmasq-full` | 替换默认 dnsmasq，支持 nftset/ipset 域名分流（透明代理几乎必需） |
| `kmod-tun` | TUN 模式必需内核模块 |
| `kmod-nft-tproxy` / `kmod-nft-socket` | TProxy 模式接管 TCP/UDP 所需 |
| `kmod-nft-nat` | nftables NAT，REDIRECT 模式及 DNS 劫持所需 |
| `ip-full` | 完整版 ip 命令，策略路由（ip rule / fwmark）所需 |
| `ipset` | ipset 集合支持，OpenClash / ShellCrash 等分流脚本兼容 |
| `kmod-inet-diag` | 连接所属进程查询，sing-box / mihomo 进程匹配规则所需 |
| `ca-bundle` | CA 证书，订阅 / 规则集 HTTPS 下载校验 |
| `bash` / `coreutils-nohup` | 代理管理脚本（OpenClash / ShellCrash 等）依赖 |
| `block-mount` | 磁盘挂载管理基础 |
| `kmod-fs-ext4` / `e2fsprogs` | ext4 读写与格式化 |
| `kmod-fs-ntfs3` / `kmod-fs-exfat` | NTFS / exFAT 移动硬盘支持 |
| `kmod-usb-storage` | USB 存储识别（x86 固件一般已内置） |
| `smartmontools` | 硬盘 SMART 健康状态 |
| `tcpdump` | 抓包，排查透明代理流量走向 |
| `bind-dig` | DNS 查询调试，验证分流是否生效 |
| `ethtool` | 查看 / 调整网卡状态 |
| `unzip` / `tar` | 解压工具 |
| `irqbalance` | 多核 x86 中断均衡，提升转发性能 |
| `kmod-tcp-bbr` | BBR 拥塞控制（部分固件已内置） |

## 透明代理内核依赖对照（sing-box / mihomo / xray）

三家内核的透明代理实现方式相同，依赖按接管模式区分：

| 接管模式 | 所需包 | 说明 |
|:--|:--|:--|
| TProxy（推荐） | `kmod-nft-tproxy` `kmod-nft-socket` `ip-full` | 三家均支持，TCP/UDP 全接管 |
| TUN | `kmod-tun` `ip-full` | 三家均支持，配置简单但吞吐略低 |
| NFQUEUE | `kmod-nft-queue` `kmod-nfnetlink-queue` | sing-box 支持；mihomo / xray 本身不支持，需配合脚本 |
| REDIRECT | `kmod-nft-nat` | 仅 TCP；xray dokodemo-door / mihomo redir-port 常用 |
| DNS 分流域名集合 | `dnsmasq-full`（nftset）或 `ipset` | 三家通用 |
| 进程匹配规则 | `kmod-inet-diag` | sing-box / mihomo 支持，xray 无此功能 |

注：`dnsmasq-full` 与默认 `dnsmasq` 冲突，25.12 使用 apk，`apk add dnsmasq-full` 会自动替换；建议先下载好包再操作，避免断网。

## 可选 LuCI 代理插件

| 插件 | 内核 | 来源 |
|:--|:--|:--|
| `luci-app-homeproxy` | sing-box | ImmortalWrt 官方源 |
| `luci-app-nikki` | mihomo | ImmortalWrt 官方源 |
| `luci-app-passwall2` | xray / sing-box | 第三方源（passwall 仓库） |
| `luci-app-openclash` | mihomo | 第三方 ipk（GitHub Releases），依赖较多 |
| ShellCrash | sing-box / mihomo / xray | 脚本安装，无 LuCI，依赖 `bash` 等 |

同一时间只启用一个透明代理服务，避免争抢 DNS 端口和防火墙规则。
