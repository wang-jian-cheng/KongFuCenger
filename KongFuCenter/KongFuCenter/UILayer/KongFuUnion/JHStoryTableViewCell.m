//
//  JHStoryTableViewCell.m
//  KongFuCenter
//
//  Created by Rain on 15/12/4.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "JHStoryTableViewCell.h"

@implementation JHStoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"%d",1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSLog(@"%d",2);
}

@end
