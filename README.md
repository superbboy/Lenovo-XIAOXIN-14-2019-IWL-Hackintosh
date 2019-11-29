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
| 网卡 | Dell 1820A CN-096JNT (替换原有Intel Wireless-AC 9560) |
| 读卡器 | Realtek RTS522A |
| 外置USB网卡 | Realtek |
| 触控板 | GPIO INT34BB |

## 教程
参考 [黑色小兵 Lenovo Air 13 IWL Hackintosh](https://github.com/daliansky/Lenovo-Air13-IWL-Hackintosh) 
* 开始用的CLOVER，后来换成OpenCore
* 系统是直接从原来的T460s TimeMachine备份直接恢复（10.14.6），然后升级到10.15.1

## 正常工作
* 核显
* 内置显示器亮度调节，快捷键也可以使用
* USB
* 声卡
* 电源

## 不正常工作
* 无线网卡：更换为DW1820a（Vendor:0x14E4, Device:0x43A3, Sub Vendor:0x1028, Sub Device:0x0022)，参考[DW1820A/BCM94350ZAE/BCM94356ZEPA50DX插入的正确姿势](https://blog.daliansky.net/DW1820A_BCM94350ZAE-driver-inserts-the-correct-posture.html)做了调整，但是目前无法正常工作
* 触控板：设备名称为TPAD，尝试使用[VoodooI2C触摸板驱动教程 | 望海之洲](https://www.penghubingzhou.cn/2019/01/06/VoodooI2C%20DSDT%20Edit/)和 [10-1-OCI2C-TPXX补丁方法](https://github.com/daliansky/OC-little/tree/master/10-1-OCI2C-TPXX%E8%A1%A5%E4%B8%81%E6%96%B9%E6%B3%95)仍然无法工作
* 蓝牙：更新到[BrcmPatchRAM3](https://github.com/acidanthera/BrcmPatchRAM)，蓝牙可以正常显示，但是设备一连接就断开
* 读卡器： 加载了[Sinetek-rtsx](https://github.com/sinetek/Sinetek-rtsx)，可以看到设备信息，但是无法使用。这个Kext在之前的T460s上是可以正常驱动读卡器的


## 设备补丁
### HDMI接口外接显示器
按照黑色小兵的提供的配置，外接显示器没有反应，用HackinTool检查不到设备连接信息。

由于笔记本只有一个HDMI接口，最后参考[教程：利用Hackintool打开第8代核显HDMI/DVI输出的正确姿势](https://blog.daliansky.net/Tutorial-Using-Hackintool-to-open-the-correct-pose-of-the-8th-generation-core-display-HDMI-or-DVI-output.html) 收尾部分，逐步尝试修改总线ID和类型信息，得到下面配置可以点亮外接显示器:

| 索引 | 总线ID | 管道 | 类型 |
| :-- | :-- | :-- | :-- |
| 0 | 0x00 | 18 | LVDS | 
| 1 | 0x05 | 18 | DP |
| 2 | 0x02 (原为0x04) | 18 | HDMI (原为DP）|

同时由于笔记本HDMI接口不支持4K输出，最后得出的显卡补丁信息如下

```
            <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
            <dict>
                <key>AAPL,ig-platform-id</key>
                <data>AACbPg==</data>
                <key>device-id</key>
                <data>mz4AAA==</data>
                <key>disable-external-gpu</key>
                <data>AQAAAA==</data>
                <key>framebuffer-patch-enable</key>
                <data>AQAAAA==</data>
                <key>framebuffer-con2-enable</key>
                <data>AQAAAA==</data>
                <key>framebuffer-con2-busid</key>
                <data>AgAAAA==</data>
                <key>framebuffer-con2-type</key>
                <data>AAgAAA==</data>
                <key>framebuffer-fbmem</key>
                <data>AACQAA==</data>
                <key>framebuffer-stolenmem</key>
                <data>AAAwAQ==</data>
            </dict>
```

### 声卡
声卡型号和小新Air 13的不一样，HackinTool显示为LayoutID有11和18两种。经过测试，11没有内置麦克风，18有，因此最后选择了18。声卡的补丁信息如下：

```
            <key>PciRoot(0x0)/Pci(0x1f,0x3)</key>
            <dict>
                <key>layout-id</key>
                <data>EgAAAA==</data>
            </dict>
```