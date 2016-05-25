//
//  Dispatcher.h
//  SwiftLOL
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfNotifier;

-(void)setMutableSetOfNotifier:(NSMutableSet *)mutableSet;

-(void)registerSubscriberToNotifier:(id)notifier   usingBlock:(void (^)(NSString *messageName,NSDictionary *message)) block;

-(void)registerSubscriberToNotifier:(id)notifier   usingSelector:(SEL)selector;

-(void)unRegisterSubscriberToNotifier:(id)notifier;

-(void)unRegisterSubscriberToAllNotifier;

-(void)dispatchMessage:(NSDictionary *)message  messageName:(NSString *)messageName;

@end


@interface Dispatcher : NSObject

+(instancetype)shareInstance;

-(void)dispatchMessage:(NSDictionary *)message  messageName:(NSString *)messageName notifier:(id )notifier;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier   usingBlock:(void (^)(NSString *messageName,NSDictionary *message)) block;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier   usingSelector:(SEL)selector;

-(void)unRegisterSubscriber:(id)subscriber   notifier:(id)notifier;

-(void)unRegisterSubscriberToALLNotifiers:(id)subscriber;

@end
