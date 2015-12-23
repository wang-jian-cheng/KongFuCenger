//
//  NewPlanViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ChoosePlanTypeViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "VPImageCropperViewController.h"
@interface NewPlanViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,ChoosePlanTypeDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JKImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSIndexPath *tempIndexPath;
    UIImage *photoImg;
}
@end
