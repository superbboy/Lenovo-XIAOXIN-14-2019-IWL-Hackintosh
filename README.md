# Lenovo-XIAOXIN-14-2019-IWL-Hackintosh
联想小新14-2019 IWL黑苹果

## 电脑配置

| 规格 | 详细信息 |
| :----- | :----- |
| 电脑型号 | Lenovo XiaoXin-14IWL 2019 |
| 处理器 | Intel i5-8265U 1.8GHz | 
| 内存 | 板载4G + 插槽ADATA DDR4 2666 16GB（替换原有三星DDR4 2666 4G）|
| 硬盘 | 三星970 EVO 1TB（替换原有三星 PM981 1TB） | 
| 核显 | Intel UHD Graphics 620 Whiskey Lake - U GT2 |
| 独显 | NVIDIA GeForce MX230(屏蔽) |
| 内置显示器 | LG 14寸 1920x1080 FHD |
| 外接显示器 | BenQ BL2410 1920x1080 FHD （通过笔记本HDMI接口）|
| 声卡 | Realtek ALC257 |
| 网卡+蓝牙 | Dell 1820A CN-096JNT (替换原有Intel Wireless-AC 9560) |
| 读卡器 | Realtek RTS522A |


## 教程
由于之前的版本在用了大半年后出现各种问题，AppStore不能更新，突然系统卡死等等，因此萌发了重做系统的想法。
本次参考 [黑色小兵 Lenovo Air 13 IWL Hackintosh](https://github.com/daliansky/Lenovo-Air13-IWL-Hackintosh) 2.0.0版本
* 由于AppStore无法访问，使用[【Len's DMG】macOS Catalina 10.15.6 19G73 With Clover 5119 and OC 0.6.0镜像](http://bbs.pcbeta.com/viewthread-1864197-1-1.html)镜像，并制作启动盘
* 使用OC引导，没有使用镜像的OC0.6.0，整个OC部分都是直接用[黑色小兵 Lenovo Air 13 IWL Hackintosh](https://github.com/daliansky/Lenovo-Air13-IWL-Hackintosh) 的0.5.9版本，但是基于本身的情况做了调整，具体看[本机调整](https://github.com/superbboy/Lenovo-XIAOXIN-14-2019-IWL-Hackintosh/blob/master/Config.md)
* 由于是双系统，安装系统之前，先解决了Windows10的激活问题。参考[关于OpenCore引导双系统的一些总结和讨论](http://bbs.pcbeta.com/viewthread-1830968-1-1.html)
* 系统重新安装后，复用之前版本MLB/ROM/SystemSerialNumber


## 目前状态

| 设备 | 状态 | 备注 |
| :-- | :-- | :-- |
| 核显 | 正常 | 
| 内置显示器 | 正常 | 亮度调节和快捷键均可用 |
| USB端口 | 正常 | 摄像头内建 | 
| 声卡 | 正常 | 
| 休眠 | 基本正常 | 目前暂时正常 | 
| 无线网卡 | 正常 |  |
| 蓝牙 | 正常 | 可以和iPhone连接，Air Drop也正常，蓝牙耳机也正常 |
| 触控板 | 能驱动响应慢 | 基本鼠标功能没有啥问题，但是响应太慢 |

## 版本历史

2019-12-06: 第一版完整版

2019-12-14: 优化无线网卡配置，不在模拟AirportBrcm4360，而是直接用AirportBrcmNIC驱动，冷启动也不再需要先进windows

2020-08-07: 替换为OC（PlatformInfo部分的信息处理了一下）

