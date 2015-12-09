//
//  PersonInfoViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UserHeadView.h"
#import "Dialog.h"
@interface PersonInfoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
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
}
@end
