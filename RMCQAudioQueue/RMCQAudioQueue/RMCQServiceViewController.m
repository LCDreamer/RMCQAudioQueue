//
//  RMCQServiceViewController.m
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import "RMCQServiceViewController.h"
#import "RMCQMessageViewController.h"
@interface RMCQServiceViewController ()

@end

@implementation RMCQServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _service=[[RMCQService alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startServer:(id)sender {
    NSThread *InitThread = [[NSThread alloc]initWithTarget:self selector:@selector(InitThreadFunc:) object:self];
    [InitThread start];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RMCQMessageViewController*messageViewController=segue.destinationViewController;
    if ([messageViewController respondsToSelector:@selector(setService:)]) {
        [messageViewController setValue:_service forKey:@"service"];
    }
}
-(void)InitThreadFunc:(id)sender
{
    [_service StartServer];
}

@end
