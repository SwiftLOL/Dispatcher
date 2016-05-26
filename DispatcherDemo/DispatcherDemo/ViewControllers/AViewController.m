//
//  AViewController.m
//  DispatcherDemo
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "AViewController.h"
#import "Dispatcher.h"
@interface AViewController ()
@property(nonatomic,strong) NSObject *A;
@property(nonatomic,strong) NSObject *B;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"A";
    
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.A = [[NSObject alloc] init];
    self.B = [[NSObject alloc] init];
    
    [self.B registerSubscriberToNotifier:self.A usingBlock:^(Notifiction *notifiction) {
                NSLog(@"using block %@  %@",notifiction.name,notifiction.object);
    }];
    
    
    [self registerSubscriberToNotifier:self.A usingSelector:@selector(handleNotifiction:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
    
}


-(void)handleNotifiction:(Notifiction *)notifiction {
    NSLog(@"using selector %@  %@",notifiction.name,notifiction.object);
}


-(void)tapMethod
{
    
   [self.A dispatchNotifiction:@"testesteste" notifictionName:@"test"];
    
    [self unRegisterSubscriberToNotifier:self.A];
    
    //[self unRegisterSubscriberToAllNotifier];
}

@end
