//
//  RMCQClientViewController.h
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCQClient.h"
#import "RMCQMessageViewController.h"
#include "N9MDefine.h"
@interface RMCQClientViewController : UIViewController
@property(nonatomic,strong)RMCQClient*client;
@property (weak, nonatomic) IBOutlet UITextField *serverIP;
@property(nonatomic,assign)TYPE type;
- (IBAction)linkToServer:(id)sender;

@end
