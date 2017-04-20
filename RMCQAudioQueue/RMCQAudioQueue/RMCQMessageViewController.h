//
//  RMCQMessageViewController.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCQService.h"
#import "RMCQClient.h"
#import "RMCQMessageViewController.h"
#import "RMCQClient.h"
#import "N9MDefine.h"
#import "RecordAmrCode.h"

#import "GCDAsyncUdpSocket.h"

#define KDataKey    @"Data"
NSMutableArray *receiveData;//接收数据的数组

@interface RMCQMessageViewController : UIViewController<UITextFieldDelegate,GCDAsyncUdpSocketDelegate>
@property(nonatomic,strong)RMCQService * service;
@property(nonatomic,strong)RMCQClient * client;
@property(nonatomic,assign)BOOL isperator;
@property (strong, nonatomic) RecordAmrCode *recordAmrCode;
@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UITextView *callMessage;
@property (weak, nonatomic) IBOutlet UITextField *sendMessage;
- (IBAction)recordStart:(id)sender;
- (IBAction)recordFinish:(id)sender;


@end
