//
//  RMCQServiceViewController.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCQService.h"
#include "N9MDefine.h"
@interface RMCQServiceViewController : UIViewController
@property(nonatomic,strong)RMCQService*service;
@property(nonatomic,assign)TYPE type;
- (IBAction)startServer:(id)sender;


@end
