//
//  MemberTableViewCell.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "CommonDef.h"

@interface MemberTableViewCell ()

@property (nonatomic, strong) UILabel * label;

@end

@implementation MemberTableViewCell

- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    self.image = [[UIImageView alloc] init];
    self.image.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.image];
    self.image.layer.cornerRadius = 25;
    self.image.image = [UIImage imageNamed:@"friend_avatar"];
    
    self.name = [[UILabel alloc] init];
    [self.contentView addSubview:self.name];
    self.name.textColor = [UIColor whiteColor];
    self.name.text = @"测试数据";
//    self.name.backgroundColor = [UIColor orangeColor];
    
    self.label = [[UILabel alloc] init];
    self.label.text = @"ID:";
    self.label.textColor = [UIColor whiteColor];
//    self.label.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.label];
    
    self.number = [[UILabel alloc] init];
    [self.contentView addSubview:self.number];
    self.number.textColor = [UIColor whiteColor];
//    self.number.backgroundColor = [UIColor orangeColor];
    self.number.text = @"12345678901";
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = CGRectMake(20, 10, 50, 50);
    
    self.name.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMinY(self.image.frame), 200, 22);
    
    self.label.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMaxY(self.name.frame) + 4, 25, 22);
    
    self.number.frame = CGRectMake(CGRectGetMaxX(self.label.frame), CGRectGetMaxY(self.name.frame) + 4, 200, 22);
}


@end
