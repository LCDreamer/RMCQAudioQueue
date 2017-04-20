//
//  RMCQPlay.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 14-4-2.
//  Copyright (c) 2014年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

// Audio Settings
#define kNumberBuffers      3
#define t_sample             SInt16
#define kSamplingRate       20000
#define kNumberChannels     1
#define kBitsPerChannels    (sizeof(t_sample) * 8)
#define kBytesPerFrame      (kNumberChannels * sizeof(t_sample))
//#define kFrameSize          (kSamplingRate * sizeof(t_sample))
#define kFrameSize          1000


#define QUEUE_BUFFER_SIZE  2//队列缓冲个数
#define EVERY_READ_LENGTH  10240 //每次从文件读取的长度
#define MIN_SIZE_PER_FRAME 10240 //每侦最小数据长度

@interface RMCQPlay : NSObject
{
    //音频参数
    AudioStreamBasicDescription audioDescription;
    // 音频播放队列
    AudioQueueRef audioQueue;
    // 音频缓存
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE];
}

-(void)Play:(Byte *)audioByte Length:(long)len;
-(void)Stop;

@end
