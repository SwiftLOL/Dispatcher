//
//  Dispatcher.h
//  SwiftLOL
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
    1.同时发生多个通知事件，按序异步还是同步post出去？
    2.对于同一个通知，是异步还是同步post 给相应的观察者们？
    3.通知回调发生在哪个线程？
    4.订阅者得到通知之后，如果响应失败了怎么办？
    5.如何保证所有的响应者都能成功得到通知。

*/



@interface Notifiction : NSObject


@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) id        object;

-(Notifiction *)initWithName:(NSString *)name  object:(id) object;
@end




@interface NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfNotifier;

-(void)setMutableSetOfNotifier:(NSMutableSet *)mutableSet;

-(void)registerSubscriberToNotifier:(id)notifier   queue:(dispatch_queue_t)queue usingBlock:(void (^)(Notifiction *notifiction)) block ;

-(void)registerSubscriberToNotifier:(id)notifier  queue:(dispatch_queue_t)queue usingSelector:(SEL)selector;

-(void)unRegisterSubscriberToNotifier:(id)notifier;

-(void)unRegisterSubscriberToAllNotifier;

-(void)dispatchNotifiction:(id)notifiction  notifictionName:(NSString *)notifictionName;

@end


@interface Dispatcher : NSObject

+(instancetype)shareInstance;

-(void)dispatchNotifiction:(id )notifiction  notifictionName:(NSString *)notifictionName notifier:(id )notifier;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier  queue:(dispatch_queue_t)queue  usingBlock:(void (^)(Notifiction *notifiction)) block;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier  queue:(dispatch_queue_t)queue  usingSelector:(SEL)selector;

-(void)unRegisterSubscriber:(id)subscriber   notifier:(id)notifier;

-(void)unRegisterSubscriberToALLNotifiers:(id)subscriber;

@end
