//
//  BaseVideoCollectionViewCell.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/5.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UIButton *btn_second;
@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UIButton *btn_thrid;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_content;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *free;

@property (weak, nonatomic) IBOutlet UIButton *select;




@end
