//
//  FirstLoginViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "Dialog.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "UUDatePicker.h"
#import "RegisterViewController.h"
@interface FirstLoginViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>
//VPImageCropperDelegate
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
@private
    UIButton *boyBtn;
    UIButton *grilBtn;
    
    UIButton *weightBtn;
    UIButton *highBtn;
    
    UIButton *ageBtn;
    UIButton *learnTimeBtn;
    
    UIButton *provinceBtn;
    UIButton *cityBtn;
    UIButton *areaBtn;
    
    UITextView *introductionText;
    UIPickerView *_pickerView;
    
    
    
    NSString *provinceCode;
    NSString *provinceTxt;
    NSString *cityCode;
    NSString *cityTxt;
    NSString *countryCode;
    NSString *countryTxt;
    NSMutableArray *countryArray;
    
    
    
    NSInteger cityRow;
    NSInteger provinceRow;
    NSInteger areaRow;
    
}
@end
