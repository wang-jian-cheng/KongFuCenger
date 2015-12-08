//
//  PersonInfoViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
@interface PersonInfoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
@private
    UIButton *boyBtn;
    UIButton *grilBtn;
}
@end
