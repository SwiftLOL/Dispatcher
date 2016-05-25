# Dispatcher
      
#Overview
   Dispatcher是用于在相互独立模块间通信的一种通知技术。
   最大的优点是，当一个对象被内存回收的时候，不需要手动移除所有的通知者，系统会自动断开通知者和订阅者之间的关系，不会造成内存泄漏。
  订阅通知的时候，除了可以使用selector自定义消息到来时的action外，还可以使用block，提高代码的紧凑性。
   
  将注册成为订阅者、派发通知、移除通知者都集成到了NSObject上，任何对象之间都可以建立关系。
  
  订阅通知的时候，不需要指定事件名，通知者不论发生什么事件，都会把消息派发给订阅者，订阅者自己过滤处理。
  一般订阅者和通知者之间的事件类型不止一种，这样做的目的可以减少些重复代码量。



#使用说明

1.注册事件
  
  可以选择使用block、selector
 
 
 
 
      [self.B registerSubscriberToNotifier:self.A usingBlock:^(NSString *messageName,           NSDictionary *message) {
                NSLog(@"using block %@  %@",messageName,message);
    }];

     [self registerSubscriberToNotifier:self.A usingSelector:@selector(recieveMessageName:message:)];



2.发送事件



    [self.A dispatchMessage:@{@"A":@"isDispatching message"} messageName:@"test"];


3.移除通知者

    [self unRegisterSubscriberToNotifier:self.A];
       
4.移除所有的通知者

    [self unRegisterSubscriberToAllNotifier];

    
    
    



#required
   ios6.0