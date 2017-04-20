//
//  RMCQClientViewController.m
//  RMCQAudioQueue
//
//  Created by 刘超 on 15/1/1.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import "RMCQClientViewController.h"

@interface RMCQClientViewController ()

@end

@implementation RMCQClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _client=[[RMCQClient alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)linkToServer:(id)sender {
    [_client CreateConnect:_serverIP.text];
    _client.linkInfoBlock=^(BOOL isSucceed){
        if (isSucceed) {
        }
    };
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     RMCQMessageViewController*messageViewController=segue.destinationViewController;
    if ([messageViewController respondsToSelector:@selector(setClient:)]) {
        [messageViewController setValue:_client forKey:@"client"];
    }
}
@end
