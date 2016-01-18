//
//  ShopTableViewCell.h
//  KongFuCenter
//
//  Created by Rain on 16/1/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mOldPrice;
@end
