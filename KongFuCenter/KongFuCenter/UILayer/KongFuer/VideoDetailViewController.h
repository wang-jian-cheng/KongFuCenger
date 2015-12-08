//
//  VideoDetailViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"

@interface VideoDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
}
@end
