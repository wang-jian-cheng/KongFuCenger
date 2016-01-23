//
//  UnionNewsDetailViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
#import "RCLabel.h"
#import "UserHeadView.h"
@interface UnionNewsDetailViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
    CGFloat commentWidth;
    UITextView *commentTextView;
    UIWebView *webView;
    UIButton *collectBtn;
    
    BOOL zan;
}
@property(nonatomic) NSString *webId;
@property(nonatomic) NSString *readNum;
@property(nonatomic) NSString *collectNum;
@property(nonatomic) NSString *isFavorite;
@property(nonatomic) NSString *content;
@end
