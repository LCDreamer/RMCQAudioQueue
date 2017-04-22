项目使用相关知识。 
1、使用AudioToolbox采集音频数据和播放音频数据。 2、自己封装了一个socket。实现了TCP传输文字信息接口。 3、用第三方的AsyncSocket。传输音频数据。 用RecordAmrCode。实现amr编码和解码。 4、将PCM格式Data进行编码，转换为AMR格式

-(NSData *)encodePCMDataToAMRData:(NSData *)pcmData; //讲AMR格式Data解码，转换为PCM格式

-NSData *）decodeAMRDataToPCMData：（NSData *）amrData; 二项目的使用

使用方法。
在RMCQMessageViewController.h类中记得配置服务器端的IP地址。kDefaultIP @“192.168.1.103”这里填写实际的IP.
