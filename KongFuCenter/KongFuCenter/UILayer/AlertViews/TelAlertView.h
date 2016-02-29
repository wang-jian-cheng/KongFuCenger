//
//  TelAlertView.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseALertView.h"
#import "DeltaView.h"

@interface TelAlertView : BaseALertView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
-(instancetype)initWithPhones:(NSArray *)phoneArr andShowPoint:(CGPoint)point;
- (void)dismiss ;
@end
