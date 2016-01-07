//
//  ApplyForMatchViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

@interface ApplyForMatchViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
}
@property(nonatomic,strong) NSString *matchId;
@end
