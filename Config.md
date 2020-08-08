# 联想小新14-2019 IWL配置调整

配置调整基于[黑色小兵 Lenovo Air 13 IWL Hackintosh](https://github.com/daliansky/Lenovo-Air13-IWL-Hackintosh) 2.0.0版本进行

## Kext调整
基于2.0.0调整了如下C/k/O下面的kext

| 名称 | 操作 |
| :-- | :-- |
| USBPorts.kext | 调整端口配置 |


## 配置调整
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
声卡型号和小新Air 13的不一样，HackinTool显示为LayoutID有11和18两种。经过测试，18对家里的iPhone耳机兼容性更好（11需要按住通话才能听到人声），因此最后选择了18。声卡的补丁信息如下：

```
            <key>PciRoot(0x0)/Pci(0x1f,0x3)</key>
            <dict>
                <key>layout-id</key>
                <data>EgAAAA==</data>
            </dict>
```
### USB端口定制
USB端口和小新Air 13的差不多，唯一不同的就是摄像头是在HS06，因此直接修改USBPorts.kext/Contents/Info.plist，将原有的HS05部分内容替换为如下内容：
```
					<key>HS06</key>
					<dict>
						<key>UsbConnector</key>
						<integer>255</integer>
						<key>port</key>
						<data>BgAAAA==</data>
					</dict>
```


### 无线网卡
同样更换为DW1820a，不过买的不是CN-0VW3T3，然后CN-096JNT（Vendor:0x14E4, Device:0x43A3, Sub Vendor:0x1028, Sub Device:0x0022)。这个卡属于奇葩卡，折腾好好久，目前算是基本可用，但是不完美。
1. 目前没有屏蔽针脚
2. 参考[DW1820A/BCM94350ZAE/BCM94356ZEPA50DX插入的正确姿势](https://blog.daliansky.net/DW1820A_BCM94350ZAE-driver-inserts-the-correct-posture.html)对OC进行配置，包括
   * 启动参数设置brcmfx-driver=2，brcmfx-country=#a
   * 添加PCI设备信息，使用本来的43a3。注意小新14-2019 IWL网卡是挂在PciRoot(0x0)/Pci(0x1d,0x2)/Pci(0x0,0x0)下面。**重点是 pci-aspm-default 这个参数，之前使用43a3总是启动卡住，需要改成brcmfx-driver=1、compatible设置为4353才能正常驱动。**

```
            <dict>
                <key>compatible</key>
                <string>pci14e4,43a3</string>
                <key>device_type</key>
                <string>Airport Extreme</string>
                <key>model</key>
                <string>DW1820A (BCM4350) 802.11ac Wireless</string>
                <key>name</key>
                <string>Airport</string>
                <key>pci-aspm-default</key>
                <integer>0</integer>
            </dict>
```

### 蓝牙
蓝牙现有配置直接可以使用Air Drop，满足基本需求。

### 触控板
尝试了最新使用了黑色小兵提供最新版本中的触控板补丁，仍然无法驱动本机的触控板。因此还是根据之前研究的结果生成OC触控板补丁

下面是原来的CLOVER的研究过程（2019-12）

设备名称为TPAD（MSFT0001)，开始尝试使用[VoodooI2C触摸板驱动教程 | 望海之洲](https://www.penghubingzhou.cn/2019/01/06/VoodooI2C%20DSDT%20Edit/)和 [10-1-OCI2C-TPXX补丁方法](https://github.com/daliansky/OC-little/tree/master/10-1-OCI2C-TPXX%E8%A1%A5%E4%B8%81%E6%96%B9%E6%B3%95)，一直无法工作。

尝试下载代码编译，但是遇到一个比较坑的问题，总是无法从系统日志 (`log show --debug --last boot |grep Voodoo`)里面获取足够多的信息，只能看到VoodooGPIO部分信息，但是从verbose模式却是又可以看到信息。也尝试手工加载，但是由于对于代码不熟悉，总是找不到问题所在。

最后爬了两天[VoodooI2C支持讨论组](https://gitter.im/alexandred/VoodooI2C)，总算得出三个信息：
1. 有时候CLOVER总是加载kext太早，可以放到/L/E里面
2. pci8086,9de8默认的SBFG pin 0x0038是无法正常工作，需要修改为0x0108
3. SSCN/FMCN缺乏，也可能会影响

将VoodooI2C.kext/VoodooI2CHID.kext放到/L/E之后，能够看到日志了，问题得到迅速定位。
#### SSCN/FMCN缺失
日志中首先出现的错误信息就是SSCN/FMCN：
```
VoodooI2CControllerNub::pci8086,9de8 SSCN not implemented in ACPI tables
VoodooI2CControllerNub::pci8086,9de8 FMCN not implemented in ACPI tables
VoodooI2CControllerDriver::pci8086,9de8 Warning: Error getting bus config, using defaults where necessary
VoodooI2CControllerDriver::pci8086,9de8 I2C Transaction error details
VoodooI2CControllerDriver::pci8086,9de8 slave address not acknowledged (7bit mode)
VoodooI2CControllerDriver::pci8086,9de8 I2C Transaction error: 0x08800001 - aborting
Request for HID descriptor failed
Could not get HID descriptor
```

对于这个错误，[VoodooI2C触摸设备驱动教程补充](https://www.penghubingzhou.cn/2019/07/24/VoodooI2C%20DSDT%20Edit%20FAQ/)有明确的修复方法，按照SSDT-I2CxConf修复。注意的一点就是I2C0/I2C1都要修复，要不然还是会有问题，因为本机实际上还有个9de9的设备。

#### GPIO pin问题
修复上面的问题之后，重新启动，出现新问题：
```
VoodooGPIOCannonLakeLP::Registering hardware pin 49 for GPIO IRQ pin 56
VoodooGPIOXXX:: pin 49 cannot be used as IRQ
```
根据之前得到的信息，很简单，直接将原来的pinlist替换为0x0108，再次重新启动，终于顺利驱动。

这里补充一下0x0108的来源：
[VoodooI2C触摸板驱动教程 | 望海之洲](https://www.penghubingzhou.cn/2019/01/06/VoodooI2C%20DSDT%20Edit/)里面对于Whiskylake的GPIO计算是有说明的，但是GPIO pin转换公式的连接不对，应该是和Conffee Lake一样[GPIO Pin转换公式](https://github.com/coolstar/VoodooGPIO/blob/master/VoodooGPIO/CannonLake-LP/VoodooGPIOCannonLakeLP.hpp#L381)：
* 原始的APIC Pin: 0x50
* 查询[表一](https://github.com/coreboot/coreboot/blob/master/src/soc/intel/cannonlake/include/soc/gpio_defs.h#L105): 0x50对应GPP_C8_IRQ
* 查询[表二](https://github.com/coreboot/coreboot/blob/master/src/soc/intel/cannonlake/include/soc/gpio_soc_defs.h#L253): GPP_C8对应189
* 查询[GPIO Pin转换公式](https://github.com/coolstar/VoodooGPIO/blob/master/VoodooGPIO/CannonLake-LP/VoodooGPIOCannonLakeLP.hpp#L382): GPP_C对应基数181、GPIO基数256
* 根据公式计算：189-181+256=264=0x0108 

#### 收尾工作
将VoodooI2C相关kext从/L/E放回 C/k/O，合并I2C补丁，同样顺利驱动。

