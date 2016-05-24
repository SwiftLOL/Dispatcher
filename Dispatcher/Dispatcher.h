//
//  Dispatcher.h
//  SwiftLOL
//
//  Created by wangJiaJia on 16/5/24.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Dispatcher)

-(NSMutableSet *)mutableSetOfObserver;

-(void)setMutableSetOfObserver:(NSMutableSet *)mutableSet;
@end


@interface Dispatcher : NSObject

+(instancetype)shareInstance;

-(void)dispatchMessage:(NSDictionary *)message  messageName:(NSString *)messageName fromObject:(id )object;

-(void)addObserver:(id)observer  messageFromObject:(id)object   usingBlock:(void (^)(NSString *messageName,NSDictionary *message)) block;

-(void)addObserver:(id)observer  messageFromObject:(id)object   usingSelector:(SEL)selector;

@end
