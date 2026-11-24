# ImmortalWrt 旁路由配置

用 uci-defaults 脚本在固件首次启动时自动完成旁路由配置（改 IP、关 DHCP、开 NAT 伪装等），插上就能用。

## 文件说明

| 文件 | 用途 |
|:--|:--|
| `Bypass-25.12.sh` | 首次启动配置脚本，填入固件选择器 |
| `Software.md` | 预装软件包清单及用途 |
| `Expansion.md` | 固件镜像扩容指南 |

## 快速开始

1. 打开固件选择器：<https://firmware-selector.immortalwrt.org/>
2. 输入设备型号，选择 25.12 版本。
3. 在「预安装的软件包」中填入推荐软件包，见 [Software.md](./Software.md)。

<img src="./预安装的软件包.png" alt="预安装的软件包" />

4. 把 [`Bypass-25.12.sh`](./Bypass-25.12.sh) 的内容复制到「首次启动时运行的脚本（uci-defaults）」。

<img src="./首次启动时运行的脚本（uci-defaults）.png" alt="首次启动时运行的脚本" />

5. 点击「请求构建」，下载 **COMBINED-EFI (SQUASHFS)** 镜像。

## 默认网络参数

| 项 | 值 |
|:--|:--|
| 旁路由 IP | `192.168.110.110` |
| 网关 / DNS | `192.168.110.1`（主路由） |
| DHCP | 关闭（由主路由分配） |

脚本还会开启 LAN 口 NAT 伪装（masq），否则流量会被主路由直接回传给客户端、绕过旁路由，导致上网很慢；并配置 NTP 时间同步。

## 客户端设置

客户端的网关和 DNS 都要指向 `192.168.110.110`（可手动设置，或在主路由 DHCP 中下发）。**DNS 必须指向旁路由，否则分流不生效。**

## 访问管理

- Web：`http://192.168.110.110`
- SSH：`ssh root@192.168.110.110`
- 默认无密码，首次登录需设置

## 自定义

改 IP 等参数可编辑 `Bypass-25.12.sh` 开头的 `LAN_IP`、`MAIN_GATEWAY` 后重新构建；或启动后用 UCI 命令临时修改：

```bash
uci set network.lan.ipaddr='192.168.110.111'
uci set network.lan.gateway='192.168.110.1'
uci commit network
```
