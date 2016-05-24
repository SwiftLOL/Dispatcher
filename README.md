# Dispatcher
      
#Overview
   Dispatcher是自定义的一个简单的通知系统，主要用于相互独立的系统模块间通信。实现了系统自带的NSNotifictionCenter的功能，可以自定义action，无需在对象释放的时候，从通知中心移除对象，不会造成内存泄漏。对象和对象之间建立通信关系的时候，不需要指定特定类型的消息，一旦有事件发生，不论什么事件都会被传递给注册了此对象事件的所有对象。







#使用说明

1.注册事件
  
  可以选择使用block、selector
 
 
 
 
    [[Dispatcher shareInstance] addObserver:self.B messageFromObject:self.A usingBlock:^(NSString *messageName, NSDictionary *message) {
        NSLog(@"using block %@  %@",messageName,message);
    }];
    
    
    [[Dispatcher shareInstance] addObserver:self messageFromObject:self.A usingSelector:@selector(recieveMessageName:message:)];



2.发送事件



    [[Dispatcher shareInstance] dispatchMessage:@{@"test":@"test"} messageName:@"test" fromObject:self.A];
    
    
    



#required
   ios6.0