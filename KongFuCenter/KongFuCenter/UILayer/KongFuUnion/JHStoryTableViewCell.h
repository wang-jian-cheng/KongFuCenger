//
//  JHStoryTableViewCell.h
//  KongFuCenter
//
//  Created by Rain on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHStoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDetail;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UILabel *mCommentNum;
@property (weak, nonatomic) IBOutlet UILabel *mCollectionNum;

@end
