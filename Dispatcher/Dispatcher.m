//
//  Dispatcher.m
//  SwiftLOL
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "Dispatcher.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>




@implementation Notifiction

-(Notifiction *)initWithName:(NSString *)name  object:(id) object
{
    self=[self init];
    if(self)
    {
        self.object=object;
        self.name =name;
    }
    
    return self;
}

@end





static void * mutableSetOfNotifierKey = &mutableSetOfNotifierKey;


@implementation NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfNotifier
{
    NSMutableSet *mutableSet = objc_getAssociatedObject(self, mutableSetOfNotifierKey);
    if(!mutableSet)
    {
        mutableSet = [NSMutableSet set];
        [self setMutableSetOfNotifier:mutableSet];
    }
    return mutableSet;
}


-(void)setMutableSetOfNotifier:(NSMutableSet *)mutableSet
{
    objc_setAssociatedObject(self, mutableSetOfNotifierKey, mutableSet, OBJC_ASSOCIATION_RETAIN);
}



-(void)registerSubscriberToNotifier:(id)notifier   usingBlock:(void (^)(Notifiction *notifiction)) block
{
    [[Dispatcher shareInstance] registerSubscriber:self notifier:notifier usingBlock:block];
}



-(void)registerSubscriberToNotifier:(id)notifier   usingSelector:(SEL)selector
{
    [[Dispatcher shareInstance] registerSubscriber:self notifier:notifier usingSelector:selector];
}


-(void)unRegisterSubscriberToNotifier:(id)notifier
{
    [[Dispatcher shareInstance] unRegisterSubscriber:self notifier:notifier];
}



-(void)unRegisterSubscriberToAllNotifier
{
    [[Dispatcher shareInstance] unRegisterSubscriberToAllNotifier];
}



-(void)dispatchNotifiction:(id)notifiction  notifictionName:(NSString *)notifictionName
{
    [[Dispatcher shareInstance] dispatchNotifiction:notifiction notifictionName:notifictionName notifier:self];
}


@end








@interface SubscriberInfor : NSObject

@end

@implementation SubscriberInfor
{
    @public
    __weak  id  controller;
    void (^block)(Notifiction *notifiction);
     SEL   selector;
}


@end


@implementation Dispatcher
{
    NSMapTable <id,NSHashTable<SubscriberInfor *>*> *_mapTable;
    
    
    OSSpinLock _lock;
}



+(instancetype)shareInstance
{
    static Dispatcher *disPatcher=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        disPatcher=[[[self class] alloc] init];
    });

    return disPatcher;
}


-(instancetype)init
{
    self=[super init];
    if(self)
    {
        _mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        
        _lock = OS_SPINLOCK_INIT;
    }
    return self;
}




-(void)registerSubscriber:(id)subscriber notifier:(id)notifier usingBlock:(void (^)(Notifiction *notifiction))block
{
    SubscriberInfor *infor = [[SubscriberInfor alloc] init];
    infor->block=block;
    infor->controller=subscriber;
    
    [[subscriber mutableSetOfNotifier] addObject:infor];
    
    
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:notifier];
    if(!hashTable)
    {
        hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality];
        [_mapTable setObject:hashTable forKey:notifier];

    }
    [hashTable addObject:infor];

    OSSpinLockUnlock(&_lock);
}


-(void)registerSubscriber:(id)subscriber notifier:(id)notifier usingSelector:(SEL)selector
{
    SubscriberInfor *infor = [[SubscriberInfor alloc] init];
    infor->selector=selector;
    infor->controller=subscriber;
    [[subscriber mutableSetOfNotifier] addObject:infor];

    
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:notifier];
    if(!hashTable)
    {
        hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality];
        [_mapTable setObject:hashTable forKey:notifier];
    }
    [hashTable addObject:infor];
    
    OSSpinLockUnlock(&_lock);
}



-(void)unRegisterSubscriber:(id)subscriber   notifier:(id)notifier
{
    OSSpinLockLock(&_lock);
    
    
    NSHashTable *hash = [_mapTable objectForKey:notifier];
    
    for (SubscriberInfor *infor in hash.allObjects) {
        if(infor->controller==subscriber)
        {
            [hash removeObject:infor];
            NSMutableSet *set = [subscriber mutableSetOfNotifier];
            [set removeObject:infor];

            break;
        }
    }

    OSSpinLockUnlock(&_lock);
}




-(void)unRegisterSubscriberToALLNotifiers:(id)subscriber
{
    OSSpinLockLock(&_lock);
    
    NSMutableSet *set = [subscriber mutableSetOfNotifier];
    
    
    for (id object in set.allObjects) {
        NSHashTable *hash = [_mapTable objectForKey:object];
        for (SubscriberInfor *infor in hash.allObjects) {
            if(infor->controller==subscriber)
            {
                [hash removeObject:infor];
                NSMutableSet *set = [subscriber mutableSetOfNotifier];
                [set removeObject:infor];
                
                break;
            }

        }
    }
    
    OSSpinLockUnlock(&_lock);
}




-(void)dispatchNotifiction:(id )notifiction  notifictionName:(NSString *)notifictionName notifier:(id )notifier
{
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:notifier];
    if(hashTable)
    {
        for (SubscriberInfor *infor in hashTable)
        {
            
            if(infor->selector)
            {
                if([infor->controller respondsToSelector:infor->selector])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [infor->controller performSelector:infor->selector withObject:[[Notifiction alloc] initWithName:notifictionName object:notifiction]];
#pragma clang diagnostic pop
                }
            }else if(infor->block)
            {
                infor->block([[Notifiction alloc] initWithName:notifictionName object:notifiction]);
            }
        }
    }

    OSSpinLockUnlock(&_lock);
}


@end
