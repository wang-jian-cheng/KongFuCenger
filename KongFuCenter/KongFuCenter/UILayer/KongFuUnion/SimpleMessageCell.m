//
//  SimpleMessageCell.m
//  rongyun
//
//  Created by 王明辉 on 16/1/20.
//  Copyright © 2016年 王明辉. All rights reserved.
//

#import "SimpleMessageCell.h"
#import "UIImageView+WebCache.h"


#define Test_Message_Font_Size 20

@interface SimpleMessageCell (){
    UIButton *mImgBtn;
}

- (void)initialize;

@end

@implementation SimpleMessageCell
- (NSDictionary *)attributeDictionary {
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    } else {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionary {
    return [self attributeDictionary];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.baseContentView addSubview:self.bubbleBackgroundView];
    
    
    self.textLabel = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    self.textLabel.backgroundColor = [UIColor whiteColor];
    
//    self.textLabel.attributeDictionary = [self attributeDictionary];
//    self.textLabel.highlightedAttributeDictionary = [self highlightedAttributeDictionary];
    [self.textLabel setFont:[UIFont systemFontOfSize:Text_Message_Font_Size]];
    
    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textLabel setTextColor:[UIColor blackColor]];
    //[self.textLabel setBackgroundColor:[UIColor yellowColor]];
    self.bgimage = [[UIImageView alloc]initWithFrame:CGRectZero];
    RCTextMessage *_textMessage = (RCTextMessage *)self.model.content;
    NSArray *mVideoArray = [_textMessage.content componentsSeparatedByString:@";"];
    NSString * urlstring = mVideoArray[0];//@"http://img.zcool.cn/community/03320dd554c75c700000158fce17209.jpg@600w_1l_2o";
    [self.bgimage sd_setImageWithURL:[NSURL URLWithString:urlstring]];
    //self.bgimage.backgroundColor = [UIColor greenColor];
    self.bgimage.frame = CGRectMake(70, 5, SCREEN_WIDTH - 120, 150);
    [self.bubbleBackgroundView addSubview:self.bgimage];
    
    UIImageView *playIv = [[UIImageView alloc] initWithFrame:CGRectMake(70 + (SCREEN_WIDTH - 120 - 15) / 2, 5 + (150 - 15) / 2, 15, 15)];
    playIv.image = [UIImage imageNamed:@"play"];
    [self.bubbleBackgroundView addSubview:playIv];
    
    mImgBtn = [[UIButton alloc] initWithFrame:self.bgimage.frame];
    [self.bubbleBackgroundView addSubview:mImgBtn];
    
    //[self.bgimage addSubview:self.textLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
-(void)mImgBtnEvent:(UIButton *)imgBtn{
    if([self.customDelegate respondsToSelector:@selector(clickImgEvent:)]){
        [self.customDelegate clickImgEvent:imgBtn.titleLabel.text];
    }
}


- (void)setAutoLayout {
    RCTextMessage *_textMessage = (RCTextMessage *)self.model.content;
    if (_textMessage) {
        //self.textLabel.text = _textMessage.content;
        NSArray *mimgArray = [_textMessage.content componentsSeparatedByString:@";"];
        [self.bgimage sd_setImageWithURL:[NSURL URLWithString:mimgArray[0]]];
        
        mImgBtn.titleLabel.text = [NSString stringWithFormat:@"%@",mimgArray[1]];
        [mImgBtn addTarget:self action:@selector(mImgBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        //DebugLog(@”[RongIMKit]: RCMessageModel.content is NOT RCTextMessage object”);
    }
    // ios 7
    CGSize __textSize =
    //self.baseContentView.bounds.size.width -
//    (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
//    35
    [_textMessage.content
     boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-40,
                                     MAXFLOAT)
     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
     NSStringDrawingUsesFontLeading
     attributes:@{
                  NSFontAttributeName : [UIFont systemFontOfSize:Text_Message_Font_Size]
                  } context:nil]
    .size;
    __textSize = CGSizeMake(ceilf(__textSize.width), ceilf(__textSize.height));
    CGSize __labelSize = CGSizeMake(__textSize.width + 5, __textSize.height + 5);
    
//    CGFloat __bubbleWidth = __labelSize.width + 15 + 20 < 50 ? 50 : (__labelSize.width + 15 + 20);
    CGFloat __bubbleWidth = [UIScreen mainScreen].bounds.size.width-40;
//    CGFloat __bubbleHeight = __labelSize.height + 5 + 5 < 35 ? 35 : (__labelSize.height + 5 + 5);
    CGFloat __bubbleHeight = 200;
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth, __bubbleHeight);
    
    CGRect messageContentViewRect = self.baseContentView.frame;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
//        messageContentViewRect.size.width = [UIScreen mainScreen].bounds.size.width-40;
        
        self.baseContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        
        self.textLabel.frame = CGRectMake(0, 5, __labelSize.width, __labelSize.height);
//        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                                        image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.baseContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        
        self.textLabel.frame = CGRectMake(15, 5, __labelSize.width, __labelSize.height);
        
//        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
//        self.bubbleBackgroundView.image = [UIImage imageNamed:@"empty-document"];
        
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                                                        image.size.height * 0.2, image.size.width * 0.8)];
    }
    
}
- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
//    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
//    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
//    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
//    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}
- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        //DebugLog(@”long press end”);
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

//+ (CGSize)getTextLabelSize:(SimpleMessage *)message {
//    if ([message.content length] > 0) {
//        float maxWidth = [UIScreen mainScreen].bounds.size.width -(10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
//        CGRect textRect = [message.content
//                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
//                           options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
//                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Test_Message_Font_Size]}
//                           context:nil];
//        textRect.size.height = ceilf(textRect.size.height);
//        textRect.size.width = ceilf(textRect.size.width);
//        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
//    } else {
//        return CGSizeZero;
//    }
//}
//
//+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
//    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
//    
//    if (bubbleSize.width + 12 + 20 > 50) {
//        bubbleSize.width = bubbleSize.width + 12 + 20;
//    } else {
//        bubbleSize.width = 50;
//    }
//    if (bubbleSize.height + 5 + 5 > 35) {
//        bubbleSize.height = bubbleSize.height + 5 + 5;
//    } else {
//        bubbleSize.height = 35;
//    }
//    
//    return bubbleSize;
//}
//
//+ (CGSize)getBubbleBackgroundViewSize:(SimpleMessage *)message {
//    CGSize textLabelSize = [[self class] getTextLabelSize:message];
//    return [[self class] getBubbleSize:textLabelSize];
//}

@end
