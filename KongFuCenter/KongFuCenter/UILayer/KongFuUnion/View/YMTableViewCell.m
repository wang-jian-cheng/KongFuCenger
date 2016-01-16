//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"
#import "WFReplyBody.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"
#import "UIImageView+WebCache.h"

#define kImageTag 9999


@implementation YMTableViewCell
{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:TableHeader / 2];
        [layer setBorderWidth:0];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:_userHeaderImage];
        
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20, 5, screenWidth - 120, TableHeader/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:15.0];
        _userNameLbl.textColor = [UIColor whiteColor];//[UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:_userNameLbl];
        
        _delIcon = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 50, 15, 20, 20)];
        [self.contentView addSubview:_delIcon];
        
        
        
        _userIntroLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20, 5 + TableHeader/2 , screenWidth - 120, TableHeader/2)];
        _userIntroLbl.numberOfLines = 1;
        _userIntroLbl.font = [UIFont systemFontOfSize:14.0];
        _userIntroLbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:_userIntroLbl];
        
        
        
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        
        replyImageView = [[UIImageView alloc] init];
        
        replyImageView.backgroundColor = BACKGROUND_COLOR;//[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];
        
//        _replyBtn = [YMButton buttonWithType:0];
//        [_replyBtn setImage:[UIImage imageNamed:@"fw_r2_c2.png"] forState:0];
//        [self.contentView addSubview:_replyBtn];
        
        _zanNum = [[UILabel alloc] init];
        _zanNum.textAlignment = NSTextAlignmentRight;
        _zanNum.font = [UIFont systemFontOfSize:14];
        _zanNum.textColor = [UIColor whiteColor];
        _zanNum.text = @"12345";
        [self.contentView addSubview:_zanNum];
        
        _zanBtn = [UIButton buttonWithType:0];
        //[_zanBtn setImage:[UIImage imageNamed:@"wyzan"] forState:0];
        [self.contentView addSubview:_zanBtn];
        
        _vLine = [[UILabel alloc] init];
        _vLine.backgroundColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.55 alpha:1];
        [self.contentView addSubview:_vLine];
        
        _CommentBtn = [UIButton buttonWithType:0];
        [_CommentBtn setImage:[UIImage imageNamed:@"wyhf"] forState:0];
        [self.contentView addSubview:_CommentBtn];
        
        _CommentBtnHF = [UIButton buttonWithType:0];
        _CommentBtnHF.titleLabel.font = [UIFont systemFontOfSize:14];
        [_CommentBtnHF setTitle:@"回复" forState:UIControlStateNormal];
        [self.contentView addSubview:_CommentBtnHF];
        
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan.png"];
        [self.contentView addSubview:_favourImage];
        
        _commentDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentDate.textColor = [UIColor whiteColor];
        _commentDate.font = [UIFont systemFontOfSize:14];
        //_commentDate.text = @"刚刚发布";
        [self.contentView addSubview:_commentDate];
        
        _videoImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_videoImg];
        
        _videoTime = [[UILabel alloc] init];
        _videoTime.textColor = YellowBlock;
        _videoTime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_videoTime];
        
        _startImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_startImg];
    }
    return self;
}

- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)setYMViewWith:(YMTextData *)ymData{
    
    tempDate = ymData;
    
#pragma mark -  //头像 昵称 简介
    //_userHeaderImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempDate.messageBody.posterImgstr]]];//[UIImage imageNamed:tempDate.messageBody.posterImgstr];
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:tempDate.messageBody.posterImgstr] placeholderImage:[UIImage imageNamed:@"me"]];
    _userNameLbl.text = tempDate.messageBody.posterName;
    WFMessageBody *m = ymData.messageBody;
    if ([[NSString stringWithFormat:@"%@",m.userID] isEqual:[NSString stringWithFormat:@"%@",get_sp(@"id")]]) {
        [_delIcon setImage:[UIImage imageNamed:@"del@2x.png"] forState:UIControlStateNormal];
        _delIcon.tag = [m.mID intValue];
    }else{
        [_delIcon setImage:nil forState:UIControlStateNormal];
    }
    _userIntroLbl.text = tempDate.messageBody.posterIntro;
    
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
    
#pragma mark - // /////////添加说说view
    
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X + 15, 15 + TableHeader, screenWidth - 2 * offSet_X, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X + 15, 15 + TableHeader, screenWidth - 2 * offSet_X, hhhh);
    
    [_ymShuoshuoArray addObject:textView];
    
    //按钮
    foldBtn.frame = CGRectMake(offSet_X - 10, 15 + TableHeader + hhhh + 10 , 50, 20 );
    
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [foldBtn setTitle:@"收起" forState:0];
    }
    
#pragma mark - /////// //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
    
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(((screenWidth - 240)/4)*(i%3 + 1) + 80*(i%3), TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30), 80, ShowImage_H)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag + i;
        //image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
        //image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ymData.showImageArray objectAtIndex:i]]]];
        [image sd_setImageWithURL:[NSURL URLWithString:[ymData.showImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"me"]];
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
        
    }
    
#pragma mark - /////点赞部分
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymFavourArray removeAllObjects];
    
    
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    
    float backView_Y = 0;
    float backView_H = 0;
    
    //显示视频
    if([self isExitVideo:ymData]){
        //MoviePlayer *moviePlayerview = [[MoviePlayer alloc] initWithFrame:CGRectMake(offSet_X + 30, 64, SCREEN_WIDTH, 4*_cellHeight) URL:[NSURL URLWithString:VideoPath]];
        
        //MoviePlayer *view = [[MoviePlayer alloc] initWithFrame:CGRectMake(offSet_X + 30, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - 2 * offSet_X - 30, 0) URL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]];
        //[self.contentView addSubview:view];
        
        //_moViePlayer = [[MoviePlayer alloc] initWithFrame:CGRectMake(10, 100,SCREEN_WIDTH - 20,200) URL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]];
        
        //_videoImg.frame = CGRectMake(offSet_X + 30, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - 2 * offSet_X - 30, 80);
        //_videoImg.image = [UIImage imageNamed:@"me"];
        @try {
            NSString *url = [ymData.showVideoArray[0] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [_videoImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
            _startImg.image = [UIImage imageNamed:@"play"];
            _videoTime.text = [NSString stringWithFormat:@"%@s",[ymData.showVideoArray[2] componentsSeparatedByString:@":"][2]];
        }
        @catch (NSException *exception) {
            _videoTime.text = @"00s";
        }
        @finally {
            
        }
    }else{
        _videoImg.image = nil;
        _startImg.image = nil;
        _videoTime.text = @"";
    }
    
    
    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X + 30, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ([ymData.showVideoArray[0] isEqual:@""]?0:80), screenWidth - 2 * offSet_X - 30, 0)];
    favourView.delegate = self;
    favourView.attributedData = ymData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.canClickAll = NO;
    favourView.textColor = [UIColor redColor];
    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
    favourView.frame = CGRectMake(offSet_X + 30,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ([ymData.showVideoArray[0] isEqual:@""]?0:80), screenWidth - offSet_X * 2 - 30, ymData.favourHeight);
    [self.contentView addSubview:favourView];
    backView_H += ((ymData.favourHeight == 0)?(-kReply_FavourDistance):ymData.favourHeight);
    [_ymFavourArray addObject:favourView];
    
    //点赞图片的位置
    _favourImage.frame = CGRectMake(offSet_X + 8, favourView.frame.origin.y, (ymData.favourHeight == 0)?0:20,(ymData.favourHeight == 0)?0:20);
    
    
#pragma mark - ///// //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
            //  NSLog(@"here");
            
        }
        
    }
    
    [_ymTextArray removeAllObjects];
    
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance), screenWidth - offSet_X * 2, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30);
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        
        
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance) + ([self isExitVideo:ymData]?127:0), screenWidth - offSet_X * 2, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        origin_Y += [_ilcoreText getTextHeight] + 5 ;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count - 1)*5;
    
    
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        _videoImg.frame = CGRectMake(offSet_X, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 80, 80);
        _startImg.frame = CGRectMake(offSet_X + (80 - 15) / 2, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24 + (80 - 15) / 2, 15, 15);
        _videoTime.frame = CGRectMake(offSet_X + 80 - 30, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24 + 80 - 21, 30, 21);
        replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance + (![self isExitVideo:ymData]?0:127), 0, 0);
        //_replyBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 40, 18);
        _zanNum.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 41 - 100,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 100, 15);
        _zanBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 40,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 18, 15);
        _vLine.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 18,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 1, 15);
        _CommentBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 13,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 18, 15);
        _CommentBtnHF.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 + 5,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 40, 15);
        //_commentDate.frame = CGRectMake(offSet_X, replyImageView.frame.origin.y - 24, 100, 18);
        _commentDate.frame = CGRectMake(offSet_X, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+ (![self isExitVideo:ymData]?0:127), 100, 18);
        
    }else{
        _videoImg.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 24, 80, 80);
        _startImg.frame = CGRectMake(offSet_X + (80 - 15) / 2, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 24 + (80 - 15) / 2, 15, 15);
        _videoTime.frame = CGRectMake(offSet_X + 80 - 30, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 24 + 80 - 21, 30, 21);
        replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance + (![self isExitVideo:ymData]?0:127), screenWidth - offSet_X * 2, backView_H + 20 - 8);//微调
        //_replyBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6, replyImageView.frame.origin.y - 24, 40, 18);
        _zanNum.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 41 - 100, replyImageView.frame.origin.y - 24, 100, 15);
        _zanBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 40, replyImageView.frame.origin.y - 24, 18, 15);
        _vLine.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 18, replyImageView.frame.origin.y - 24, 1, 15);
        _CommentBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 - 13, replyImageView.frame.origin.y - 24, 18, 15);
        _CommentBtnHF.frame = CGRectMake(screenWidth - offSet_X - 40 + 6 + 5, replyImageView.frame.origin.y - 24, 40, 15);
        _commentDate.frame = CGRectMake(offSet_X, replyImageView.frame.origin.y - 24, 100, 18);
        
    }
    
    
}

-(BOOL)isExitVideo:(YMTextData *)ymData{
    NSLog(@"%@",ymData);
    return ymData.showVideoArray !=nil&&![ymData.showVideoArray[1] isEqual:@""]&&ymData.showVideoArray.count>0;
}

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
    
}


- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if (index == -1) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = clickString;
    }else{
        [_delegate longClickRichText:_stamp replyIndex:index];
    }
    
}


- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if ([clickString isEqualToString:@""] && index != -1) {
        //reply
        //NSLog(@"reply");
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
        if ([clickString isEqualToString:@""]) {
            //
        }else{
            [WFHudView showMsg:clickString inView:nil];
        }
    }
    
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
    
    
}

@end
