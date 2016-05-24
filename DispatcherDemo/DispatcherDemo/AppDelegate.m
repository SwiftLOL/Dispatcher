//
//  AppDelegate.m
//  DispatcherDemo
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "AppDelegate.h"
#import "AViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
