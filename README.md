# CZH_PDWA
APP/NO.1

//显示tab
[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        for(UIView *view in self.tabBarController.view.subviews){
            if([view isKindOfClass:[UITabBar class]]){
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          view.frame.origin.y - kTabBarHeight,
                                          view.frame.size.width,
                                          view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          view.frame.origin.y,
                                          view.frame.size.width,
                                          view.frame.size.height - kTabBarHeight)];
            }
        }
    }];
//隐藏tab
[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        for(UIView *view in self.tabBarController.view.subviews){
            if([view isKindOfClass:[UITabBar class]]){
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          view.frame.origin.y + kTabBarHeight,
                                          view.frame.size.width,
                                          view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          view.frame.origin.y,
                                          view.frame.size.width,
                                          view.frame.size.height + kTabBarHeight)];
            }
        }
    }];
