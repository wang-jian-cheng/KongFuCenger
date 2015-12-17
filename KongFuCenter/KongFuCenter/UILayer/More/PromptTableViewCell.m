//
//  PromptTableViewCell.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PromptTableViewCell.h"
#import "CommonDef.h"
@implementation PromptTableViewCell

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
    self.image.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.image];
    self.image.layer.cornerRadius = 10;
    
    self.name = [[UILabel alloc] init];
    self.name.textColor = YellowBlock;
//    self.name.backgroundColor = [UIColor orangeColor];
    self.name.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.name];
    self.name.text = @"测试数据";
    
    self.detail = [[UILabel alloc] init];
    self.detail.textColor = [UIColor whiteColor];
    self.detail.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.detail];
//    self.detail.backgroundColor = [UIColor orangeColor];
    self.detail.text = @"测试数据，测试数据！";

    self.date = [[UILabel alloc] init];
    self.date.textColor = Separator_Color;
    self.date.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.date];
    self.date.text = @"12月17日";
    
    self.pic_label = [[UILabel alloc] init];
    self.pic_label.numberOfLines = 3;
    self.pic_label.backgroundColor = BACKGROUND_COLOR;
    self.pic_label.textColor = Separator_Color;
    self.pic_label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.pic_label];
    self.pic_label.text = @"测试数据,测试数据,测试数据,测试数据,测试数据";
    
    self.pic = [[UIImageView alloc] init];
    [self.contentView addSubview:self.pic];
//    self.pic.image = [UIImage imageNamed:@"temp@2x"];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = CGRectMake(15, 10, 65, 65);
    
    self.name.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, 10, 145, 22);
    
    self.detail.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMaxY(self.name.frame) + 3, 145, 20);
    
    self.date.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMaxY(self.detail.frame) + 3, 145, 20);
    
    self.pic_label.frame = CGRectMake(self.contentView.frame.size.width - 15 - 65, 10, 65, 65);
    
    self.pic.frame = CGRectMake(self.contentView.frame.size.width - 15 - 65, 10, 65, 65);
    
}



@end
