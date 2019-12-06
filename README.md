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
参考 [黑色小兵 Lenovo Air 13 IWL Hackintosh](https://github.com/daliansky/Lenovo-Air13-IWL-Hackintosh) 1.3.0版本
* 开始用的CLOVER，后来换成OpenCore。不过由于OpenCore会修改Windows下的信息，暂时还是回到CLOVER。
* 系统是直接从原来的T460s TimeMachine备份直接恢复（10.14.6），然后升级到10.15.1
* 基于笔记本的情况设置做了调整，具体看[本机调整](https://github.com/superbboy/Lenovo-XIAOXIN-14-2019-IWL-Hackintosh/blob/master/Config.md)

## 目前状态

| 设备 | 状态 | 备注 |
| :-- | :-- | :-- |
| 核显 | 正常 | 
| 内置显示器 | 正常 | 亮度调节和快捷键均可用 |
| USB端口 | 正常 | 摄像头内建 | 
| 声卡 | 正常 | 
| 休眠 | 基本正常 | 目前偶尔会遇到醒来无法看不到密码输入框 | 
| 无线网卡 | 基本正常 | 冷启动需要先进入windows 10，然后重启再进入macos，要不然会panic |
| 蓝牙 | 正常 | 可以和iPhone连接，Air Drop也正常，蓝牙耳机也正常 |
| 触控板 | 正常 | 基本鼠标功能没有啥问题，响应稍微慢一点，手势也基本可用 |
| 读卡器 | 基本正常 | 读取文件有点慢，eject有点问题，只是作为一个备用方案，有空再研究 |

## 版本历史

2019-12-06: 第一版完整版


