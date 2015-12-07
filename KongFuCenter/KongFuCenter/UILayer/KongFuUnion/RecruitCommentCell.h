//
//  RecruitCommentCell.h
//  KongFuCenter
//
//  Created by Rain on 15/12/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecruitCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDetail;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UILabel *mReadNum;
@property (weak, nonatomic) IBOutlet UILabel *mCollectionNum;

@end
