//
//  Dispatcher.h
//  SwiftLOL
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Notifiction : NSObject


@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) id        object;

-(Notifiction *)initWithName:(NSString *)name  object:(id) object;
@end




@interface NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfNotifier;

-(void)setMutableSetOfNotifier:(NSMutableSet *)mutableSet;

-(void)registerSubscriberToNotifier:(id)notifier   usingBlock:(void (^)(Notifiction *notifiction)) block;

-(void)registerSubscriberToNotifier:(id)notifier   usingSelector:(SEL)selector;

-(void)unRegisterSubscriberToNotifier:(id)notifier;

-(void)unRegisterSubscriberToAllNotifier;

-(void)dispatchNotifiction:(id)notifiction  notifictionName:(NSString *)notifictionName;

@end


@interface Dispatcher : NSObject

+(instancetype)shareInstance;

-(void)dispatchNotifiction:(id )notifiction  notifictionName:(NSString *)notifictionName notifier:(id )notifier;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier   usingBlock:(void (^)(Notifiction *notifiction)) block;

-(void)registerSubscriber:(id)subscriber  notifier:(id)notifier   usingSelector:(SEL)selector;

-(void)unRegisterSubscriber:(id)subscriber   notifier:(id)notifier;

-(void)unRegisterSubscriberToALLNotifiers:(id)subscriber;

@end
