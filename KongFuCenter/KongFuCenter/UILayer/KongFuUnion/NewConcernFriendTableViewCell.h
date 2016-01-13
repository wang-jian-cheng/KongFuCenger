//
//  NewConcernFriendTableViewCell.h
//  KongFuCenter
//
//  Created by Rain on 16/1/13.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewConcernFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImgView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UIButton *mConcernBtn;

@end
