//
//  RMCQMessageViewController.m
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import "RMCQMessageViewController.h"
#import "RMCQRecord.h"
#import "RMCQPlay.h"

#define kDefaultPort  8080

#define kDefaultIP @"192.168.1.103"


@interface RMCQMessageViewController (){
    RMCQRecord *recorder;
    RMCQPlay *player;
    //	Play *player;
    BOOL flag;
}

@end

@implementation RMCQMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapBackground];
    _callMessage.userInteractionEnabled = NO;
    _sendMessage.returnKeyType = UIReturnKeySend;//变为搜索按钮
    _sendMessage.delegate = self;
    
    //GCDAsyncUdpSocket
    GCDAsyncUdpSocket *udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.udpSocket = udpSocket;
    //绑定端口
    
    NSError * error = nil;
    [_udpSocket bindToPort:kDefaultPort error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [_udpSocket beginReceiving:&error];
    }
    
    //先把接收数组清空
    if (receiveData) {
        receiveData = nil;
    }
    receiveData = [[NSMutableArray alloc] init];
    
    if (_recordAmrCode == nil) {
        _recordAmrCode = [[RecordAmrCode alloc] init];
    }
    __weak RMCQMessageViewController*mesage=self;
    
    _service.messageInfoBlock=^(NSString*messageInfo){
        dispatch_async(dispatch_get_main_queue(), ^{
            mesage.callMessage.textColor=[UIColor whiteColor];
            NSString *str;
            str = [messageInfo stringByAppendingString:@"\n"];
            [mesage.callMessage insertText:str];
            [mesage.callMessage setTextAlignment:NSTextAlignmentLeft];
        });
    };
    
    _client.messageInfoBlock=^(NSString*messageInfo){
        dispatch_async(dispatch_get_main_queue(), ^{
            mesage.callMessage.textColor=[UIColor whiteColor];
            NSString *str;
            str = [messageInfo stringByAppendingString:@"\n"];
            [mesage.callMessage insertText:str];
            [mesage.callMessage setTextAlignment:NSTextAlignmentLeft];
        });
        
    };
    
    _service.dataBlock=^(NSData*data){
        dispatch_async(dispatch_get_main_queue(), ^{
           [mesage playAudioQueue:data];
        });
        
        
    };
    _client.dataBlock=^(NSData*data){
        dispatch_async(dispatch_get_main_queue(), ^{
            [mesage playAudioQueue:data];
        });
    };

    recorder = [[RMCQRecord alloc]init];
    flag = NO;
    
    _isperator=NO;
    
     [_sendMessage addTarget:self action:@selector(recordCancel:) forControlEvents: UIControlEventTouchDragExit | UIControlEventTouchUpOutside];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    [self sendMessages];
}

-(void)sendMessages{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString*selfMessage=[NSString stringWithFormat:@"发送者:%@",_sendMessage.text];
        NSString *str = [selfMessage stringByAppendingString:@"\n"];
        _callMessage.textColor=[UIColor whiteColor];
        [_callMessage insertText:str];
        [_callMessage setTextAlignment:NSTextAlignmentLeft];
    });
    [_service SendMessage:_sendMessage.text];
    [_client SendMessage:_sendMessage.text];
}

-(void)sendData{
  
    NSData *pcmData = [[NSData alloc] initWithBytes:[recorder getBytes] length:recorder.audioDataLength];
    //pcm数据不为空时，编码为amr格式
    if (pcmData && pcmData.length > 0) {
        NSData *amrData = [self.recordAmrCode encodePCMDataToAMRData:pcmData];
        [self.udpSocket sendData:amrData toHost:kDefaultIP port:kDefaultPort withTimeout:-1 tag:0];
    }
}

- (IBAction)textFiledReturnEditing:(id)sender {
    [_sendMessage resignFirstResponder];
}

-(void)playAudioQueue:(NSData*)data{
    
    
    NSData *pcmData = [self.recordAmrCode decodeAMRDataToPCMData:data];
    NSUInteger length = [pcmData length];
    Byte *testByte = (Byte *)[pcmData bytes];
    [_recordButton setTitle:@"播放" forState:UIControlStateNormal];
    player = [[RMCQPlay alloc]init];
    [player Play:testByte Length:length];
}

- (IBAction)recordStart:(id)sender {
   [_recordButton setTitle:@"录制中" forState:UIControlStateNormal];
   [recorder start];
}

- (IBAction)recordFinish:(id)sender {
    
     [self sendData];
    
    [recorder stop];
    [recorder reset];
    [recorder dispose];
    
}
- (void) recordCancel:(id)sender{
     [_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
}


- (IBAction)backGroundTap:(id)sender {
    [self tapOnce];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![_sendMessage.text isEqualToString:@""] && _sendMessage.text.length  != 0) {
        [self sendMessages];
    }
    return YES;
}
-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce//手势方法
{
    [_sendMessage resignFirstResponder];
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    //这里因为对录制的PCM数据编码为amr格式并添加RTP包头之后的大小，大家可以根据自己的协议，在包头中封装上数据长度再来解析。
    //PS：因为socket在发送过程中会粘包，如发送数据AAA,然后再发送BBB,可能会一次收到AAABBB，也可能会一次收到AAA，另一次收到BBB，所以针对这种情况要判断接收数据大小，来拆包
    
    [self playAudioQueue:data];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}




@end
