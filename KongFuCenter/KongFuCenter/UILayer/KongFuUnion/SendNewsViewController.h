//
//  SendNewsViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/25.
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

@interface SendNewsViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,ChoosePlanTypeDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JKImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UIGestureRecognizerDelegate,UploadDataToServerDelegate>{
    
    NSIndexPath *tempIndexPath;
    UIImage *photoImg;
    //img upload
    NSMutableArray * img_uploaded;
    NSInteger uploadImgIndex;
    NSMutableArray * img_prm;
    
}

@end
