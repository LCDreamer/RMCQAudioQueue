//
//  RMCQClient.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LinkInfoBlock) (BOOL isSucceed);
typedef void(^callMessageInfoBlock)(NSString*messageInfo);
typedef void(^callDataBlock) (NSMutableData*data);

@interface RMCQClient : NSObject
{
    CFSocketRef _socket;
}
@property(nonatomic,copy)LinkInfoBlock linkInfoBlock;
@property(nonatomic,copy)callMessageInfoBlock messageInfoBlock;
@property(nonatomic,copy)callDataBlock dataBlock;
-(void) SendMessage:(NSString*)message;
-(void) SendData:(NSMutableData*)datas;
-(void)CreateConnect:(NSString*)strAddress;

@end
