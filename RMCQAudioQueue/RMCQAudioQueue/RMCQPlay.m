//
//  RMCQPlay.m
//  RMCQAudioQueue
//
//  Created by 刘超 on 14-4-2.
//  Copyright (c) 2014年 刘超. All rights reserved.
//

#import "RMCQPlay.h"
@interface RMCQPlay()
{
    Byte *audioByte;
    long audioDataIndex;
    long audioDataLength;
}
@end
@implementation RMCQPlay

//回调函数(Callback)的实现
static void BufferCallback(void *inUserData,AudioQueueRef inAQ,AudioQueueBufferRef buffer){
    
    NSLog(@"processAudioData :%u", (unsigned int)buffer->mAudioDataByteSize);
    
    RMCQPlay* player=(__bridge RMCQPlay*)inUserData;
    
    [player FillBuffer:inAQ queueBuffer:buffer];
}

void soundCompleteCallBack(SystemSoundID soundID, void * clientDate) {
    NSLog(@"播放完成");
    AudioServicesDisposeSystemSoundID(soundID);
}

//缓存数据读取方法的实现
-(void)FillBuffer:(AudioQueueRef)queue queueBuffer:(AudioQueueBufferRef)buffer
{
    if(audioDataIndex + EVERY_READ_LENGTH < audioDataLength)
    {
        memcpy(buffer->mAudioData, audioByte+audioDataIndex, EVERY_READ_LENGTH);
        audioDataIndex += EVERY_READ_LENGTH;
        buffer->mAudioDataByteSize =EVERY_READ_LENGTH;
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
    
}

-(void)SetAudioFormat
{
    ///设置音频参数
    audioDescription.mSampleRate  = kSamplingRate;//采样率
    audioDescription.mFormatID    = kAudioFormatLinearPCM;
    audioDescription.mFormatFlags =  kAudioFormatFlagIsSignedInteger;//|kAudioFormatFlagIsNonInterleaved;
    audioDescription.mChannelsPerFrame = kNumberChannels;
    audioDescription.mFramesPerPacket  = 1;//每一个packet一侦数据
    audioDescription.mBitsPerChannel   = kBitsPerChannels;//av_get_bytes_per_sample(AV_SAMPLE_FMT_S16)*8;//每个采样点16bit量化
    audioDescription.mBytesPerFrame    = kBytesPerFrame;
    audioDescription.mBytesPerPacket   = kBytesPerFrame;
    
    [self CreateAudioQueue];
}

-(void)CreateAudioQueue
{
    [self Cleanup];
    //使用player的内部线程播
    AudioQueueNewOutput(&audioDescription, BufferCallback, (__bridge void *)(self), nil, nil, 0, &audioQueue);
    if(audioQueue)
    {
        ////添加buffer区
        for(int i=0;i<QUEUE_BUFFER_SIZE;i++)
        {
            int result =  AudioQueueAllocateBuffer(audioQueue, EVERY_READ_LENGTH, &audioQueueBuffers[i]);
            ///创建buffer区，MIN_SIZE_PER_FRAME为每一侦所需要的最小的大小，该大小应该比每次往buffer里写的最大的一次还大
            NSLog(@"AudioQueueAllocateBuffer i = %d,result = %d",i,result);
        }
    }
}

-(void)Cleanup
{
    if(audioQueue)
    {
        NSLog(@"Release AudioQueueNewOutput");
        
        [self Stop];
        for(int i=0; i < QUEUE_BUFFER_SIZE; i++)
        {
            AudioQueueFreeBuffer(audioQueue, audioQueueBuffers[i]);
            audioQueueBuffers[i] = nil;
        }
        audioQueue = nil;
    }
}

-(void)Stop
{
    NSLog(@"Audio Player Stop");
    
    AudioQueueFlush(audioQueue);
    AudioQueueReset(audioQueue);
    AudioQueueStop(audioQueue,TRUE);

}

-(void)Play:(Byte *)byte Length:(long)len
{
    [self Stop];
    audioByte = byte;
    audioDataLength = len;
    
    NSLog(@"Audio Play Start >>>>>");
    
    [self SetAudioFormat];
    
    AudioQueueReset(audioQueue);
    audioDataIndex = 0;
    for(int i=0; i<QUEUE_BUFFER_SIZE; i++)
    {
        [self FillBuffer:audioQueue queueBuffer:audioQueueBuffers[i]];
    }
    AudioQueueStart(audioQueue, NULL);
}
@end
