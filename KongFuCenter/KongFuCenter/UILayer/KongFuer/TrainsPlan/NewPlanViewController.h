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
#import "PictureShowView.h"
#import "UploadDataToServer.h"
#import "TrainsPlanViewController.h"
#import "JKAssets.h"

#define PICPICKER_IMGS_KEY      @"picPicker"
#define PHOTO_IMGS_KEY          @"photoPicker"

@protocol  NewPlanDelegate<NSObject>

-(void)endOfEdit;

@end

@interface NewPlanViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,ChoosePlanTypeDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JKImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UIGestureRecognizerDelegate,UploadDataToServerDelegate,PictureShowViewDelegate>
{
    NSIndexPath *tempIndexPath;
    UIImage *photoImg;
    //img upload
    NSMutableArray * img_uploaded;
    NSInteger uploadImgIndex;
    NSMutableArray * img_prm;
    
    NSMutableDictionary *allImgsPicked;//所有照片合集
    NSMutableArray *imgPickerImgs;//照片选择器
    NSMutableArray *photoImgs;//拍照

    
    NSMutableArray *defaultImgPath;
    
    UIView *picShowView;
}
@property(nonatomic) NSDictionary *DefaultDict;
@property(nonatomic) NSString *planMode;
@property(nonatomic) id<NewPlanDelegate> delegate;
@end
