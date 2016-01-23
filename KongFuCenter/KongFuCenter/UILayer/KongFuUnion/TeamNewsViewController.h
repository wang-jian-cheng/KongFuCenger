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
#import "ChatContentViewController.h"
#import "PlayVideoViewController.h"
#import "OneShuoshuoViewController.h"

typedef enum _ActionType{
    
    cancelZan = 100,
    setZan,
    cancelCollect,
    setCollect,
    setZhuanfa,
    jubao
    
}ActionType;

@interface TeamNewsViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
{
    int pageNo;
    int pageSize;
    UILabel *label;
    
    //数据
    NSMutableArray *wyArray;
    int selectRow;
    NSString *kAdmin;
    BOOL isComment;
    NSUserDefaults *userDefault;
    
    ActionType actionType;
}
@property(nonatomic)NSString *teamId;//设置则显示其他战队动态
@property(nonatomic)NSString *teamName;
@property(nonatomic)NSString *teamImg;

@end
