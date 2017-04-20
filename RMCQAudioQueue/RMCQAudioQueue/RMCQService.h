//
//  RMCQService.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
typedef void(^callMessageInfoBlock)(NSString*messageInfo);
typedef void(^callDataBlock) (NSMutableData*data);

CFWriteStreamRef outputStream;
@interface RMCQService : NSObject{
    CFSocketRef _socket;
}
@property (retain, nonatomic) id delegate;
@property(nonatomic,copy)callMessageInfoBlock messageInfoBlock;
@property(nonatomic,copy)callDataBlock dataBlock;

-(void) StartServer;
-(void) SendMessage:(NSString*)message;
-(void) SendData:(NSMutableData*)datas;

@end
