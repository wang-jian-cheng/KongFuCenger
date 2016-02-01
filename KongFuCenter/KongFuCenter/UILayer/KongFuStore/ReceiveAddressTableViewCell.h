//
//  ReceiveAddressTableViewCell.h
//  KongFuCenter
//
//  Created by Rain on 16/1/31.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLbl;
@property (weak, nonatomic) IBOutlet UIButton *isDefaultAddressBtn;

@end
