//
//  MyDreamViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@interface MyDreamViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
}
@end
