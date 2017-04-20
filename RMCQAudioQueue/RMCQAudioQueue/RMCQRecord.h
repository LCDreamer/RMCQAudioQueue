//
//  RMCQRecord.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 14-4-2.
//  Copyright (c) 2014年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#define kNumberBuffers 3

#define t_sample SInt16

#define kSamplingRate 20000
#define kNumberChannels 1
#define kBitsPerChannels (sizeof(t_sample) * 8)
#define kBytesPerFrame (kNumberChannels * sizeof(t_sample))
//#define kFrameSize (kSamplingRate * sizeof(t_sample))
#define kFrameSize 1000

typedef struct AQCallbackStruct
{
	AudioStreamBasicDescription mDataFormat;
	AudioQueueRef queue;
	AudioQueueBufferRef mBuffers[kNumberBuffers];
	AudioFileID outputFile;
	
	unsigned long frameSize;
	long long recPtr;
	int run;
} AQCallbackStruct;

@interface RMCQRecord : NSObject{
	AQCallbackStruct aqc;
	AudioFileTypeID fileFormat;
	long audioDataLength;
    Byte audioByte[999999];
    long audioDataIndex;
}
- (id) init;
- (void) start;
- (void) stop;
-(void) reset;
-(void) dispose;
- (void) pause;
-(void)close;
- (Byte*) getBytes;
- (void) processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef) queue;

@property (nonatomic, assign) AQCallbackStruct aqc;
@property (nonatomic, assign) long audioDataLength;
@end
