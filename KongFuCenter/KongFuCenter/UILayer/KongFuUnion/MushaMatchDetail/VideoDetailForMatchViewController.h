//
//  VideoDetailForMatchViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
@interface VideoDetailForMatchViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
}
@end
