//
//  CommentOrderViewController.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MyTextView.h"
#import "OrderDefine.h"
@interface CommentOrderViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MyTextViewDelegate>
{
    NSIndexPath *tempIndexPath;
    
}
@property (nonatomic,strong) NSArray * GoodsArray;//接收传过来的商品数组
@property (nonatomic,strong) NSString *billId;
@property (nonatomic,strong) NSString *billDetail;
@end
