# Dispatcher
      
#Overview
  类似于系统NSNotifiction的通知技术(观察者模式)。
##优点:
 1.观察者生命周期结束的时候，不需要主动向通知中心请求解除自己和被观察者的关系。
 2.除了selector,还可以使用block自定义action,提高代码紧凑度。
 3.可以指定action在哪个线程里执行，不论notifiction在哪个线程里post。如果不指定，默认为主线程（用于更新UI）。
 


#使用说明

1.注册事件
  
  可以选择使用block、selector
 
 
     [self.B registerSubscriberToNotifier:self.A queue:dispatch_get_main_queue() usingBlock:^(Notifiction *notifiction) {
                NSLog(@"using block %@  %@",notifiction.name,notifiction.object);
    }];    
    
     [self registerSubscriberToNotifier:self.A queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) usingSelector:@selector(handleNotifiction:)];

2.发送事件

    [self.A dispatchNotifiction:@"testesteste" notifictionName:@"test"];


3.移除通知者

    [BObject unRegisterSubscriberToNotifier:AObject];
       
4.移除所有的通知者

     [self unRegisterSubscriberToAllNotifier];
    
    
    



#required
   ios6.0