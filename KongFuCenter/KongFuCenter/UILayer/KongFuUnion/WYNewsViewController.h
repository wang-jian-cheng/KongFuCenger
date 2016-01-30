//
//  WYNewsViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/15.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"


#define WyNewsKey @"WyNews"

@interface WYNewsViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *cacheArrForWrite;
    NSMutableDictionary *tempCommentDict;
    
    NSString *newMessageId;
}
@end
