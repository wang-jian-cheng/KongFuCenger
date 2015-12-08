//
//  MushaMatchCell.h
//  KongFuCenter
//
//  Created by Rain on 15/12/8.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MushaMatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDetail;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UILabel *mEndDate;
@property (weak, nonatomic) IBOutlet UIButton *mState;
@end
