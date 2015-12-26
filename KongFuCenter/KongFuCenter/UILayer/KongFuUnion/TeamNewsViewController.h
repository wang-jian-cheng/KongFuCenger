//
//  TeamNewsViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DataProvider.h"
#import "MJRefresh.h"
@interface TeamNewsViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
{
    int pageNo;
    int pageSize;
    
    
    //数据
    NSMutableArray *wyArray;
    int selectRow;
    NSString *kAdmin;
    BOOL isComment;
}
@property(nonatomic)NSString *teamId;//设置则显示其他战队动态
@end
