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



static void * mutableSetOfObserverKey = &mutableSetOfObserverKey;

@implementation NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfObserver
{
    NSMutableSet *mutableSet = objc_getAssociatedObject(self, mutableSetOfObserverKey);
    if(!mutableSet)
    {
        mutableSet = [NSMutableSet set];
        [self setMutableSetOfObserver:mutableSet];
    }
    return mutableSet;
}


-(void)setMutableSetOfObserver:(NSMutableSet *)mutableSet
{
    objc_setAssociatedObject(self, mutableSetOfObserverKey, mutableSet, OBJC_ASSOCIATION_RETAIN);
}

@end






@interface ObserverInfor : NSObject

@end

@implementation ObserverInfor
{
    @public
    __weak  id  controller;
    void (^block)(NSString *messageName,NSDictionary *message);
     SEL   selector;
}


@end


@implementation Dispatcher
{
    NSMapTable <id,NSHashTable<ObserverInfor *>*> *_mapTable;
    
    
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




-(void)addObserver:(id)observer  messageFromObject:(id)object     usingBlock:(void (^)(NSString *messageName,NSDictionary *message)) block
{
    ObserverInfor *infor = [[ObserverInfor alloc] init];
    infor->block=block;
    infor->controller=observer;
    
    [[observer mutableSetOfObserver] addObject:infor];
    
    
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:object];
    if(!hashTable)
    {
        hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality];
        [_mapTable setObject:hashTable forKey:object];

    }
    [hashTable addObject:infor];

    OSSpinLockUnlock(&_lock);
}


-(void)addObserver:(id)observer  messageFromObject:(id)object   usingSelector:(SEL)selector
{
    ObserverInfor *infor = [[ObserverInfor alloc] init];
    infor->selector=selector;
    infor->controller=observer;
    [[observer mutableSetOfObserver] addObject:infor];

    
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:object];
    if(!hashTable)
    {
        hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality];
        [_mapTable setObject:hashTable forKey:object];
    }
    [hashTable addObject:infor];
    
    OSSpinLockUnlock(&_lock);
}






-(void)dispatchMessage:(NSDictionary *)message  messageName:(NSString *)messageName fromObject:(id )object
{
    OSSpinLockLock(&_lock);
    
    NSHashTable *hashTable = [_mapTable objectForKey:object];
    if(hashTable)
    {
        for (ObserverInfor *infor in hashTable)
        {
            
            if(infor->selector)
            {
                if([infor->controller respondsToSelector:infor->selector])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [infor->controller performSelector:infor->selector withObject:messageName withObject:message];
#pragma clang diagnostic pop
                }
            }else if(infor->block)
            {
                infor->block(messageName,message);
            }
        }
    }

    
    OSSpinLockUnlock(&_lock);
}


@end
