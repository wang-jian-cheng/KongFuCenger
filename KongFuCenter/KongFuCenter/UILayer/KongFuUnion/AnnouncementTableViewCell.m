//
//  AnnouncementTableViewCell.m
//  KongFuCenter
//
//  Created by 鞠超 on 15/12/16.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AnnouncementTableViewCell.h"
#import "CommonDef.h"
@interface AnnouncementTableViewCell ()

@property (nonatomic, strong) UIImageView * image;

@property (nonatomic, strong) UIImageView * image1;

@end

@implementation AnnouncementTableViewCell

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
    self.image.layer.cornerRadius = 25;
//    self.image.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.image];
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.image.layer.borderWidth = 1;
    
    self.image1 = [[UIImageView alloc] init];
    self.image1.image = [UIImage imageNamed:@"zdgg"];
    [self.contentView addSubview:self.image1];
    
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"12月30日临沂体育馆";
    self.name.textColor = [UIColor whiteColor];
//    self.name.backgroundColor = [UIColor orangeColor];
    self.name.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:self.name];
    
    self.detail = [[UILabel alloc] init];
//    self.detail.backgroundColor = [UIColor orangeColor];
//    self.detail.text = @"测试数据,测试数据,测试数据,测试数据,测试数据,测试数据,测试数据,测试数据,测试数据";
    self.detail.textColor = Separator_Color;
    self.detail.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.detail];
    
    self.date = [[UILabel alloc] init];
    self.date.textColor = Separator_Color;
    self.date.text = @"2015/12/17 ";
//    self.date.backgroundColor = [UIColor orangeColor];
    self.date.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.date];
    
    self.time = [[UILabel alloc] init];
    self.time.textColor = Separator_Color;
    self.time.text = @"09:06";
    self.time.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.time];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = CGRectMake(10, 15, 50, 50);
    
    self.image1.frame = CGRectMake(22.5, 27.5, 25, 25);
    
    self.name.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMinY(self.image.frame), self.contentView.frame.size.width - 30 - 50, 22);
    
    self.detail.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMaxY(self.name.frame) + 3, self.contentView.frame.size.width - 30 - 50, 22);
    
    self.date.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 10, CGRectGetMaxY(self.detail.frame) + 1, 100, 22);
    
    self.time.frame = CGRectMake(CGRectGetMaxX(self.date.frame), CGRectGetMaxY(self.detail.frame) + 1, 100, 22);
    
}

@end
