//
//  VideoDetailForMatchViewController.h
//  KongFuCenter
//
//  Created by 王建成 on 15/12/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomButton.h"
@interface VideoDetailForMatchViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat _keyHeight;
    NSIndexPath *tempIndexPath;
    NSMutableArray * videoCommentArray;//评论列表
    CGFloat commentWidth;
    UITextView *commentTextView;
    
    int pageNo;
    int pageSize;
}
@property(nonatomic,strong) NSString *videoID;
@property(nonatomic,strong) NSString *matchId;
@property(nonatomic,strong) NSString *matchUserId;
@property(nonatomic,strong) NSString *matchTeamId;
@end
