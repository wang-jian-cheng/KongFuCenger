//
//  VideoZhiBoViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/1/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum _videoZhiBoState{
    Mode_NoStart,
    Mode_Playing,
    Mode_End
}VideoZhiBoState;

@interface VideoZhiBoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *videoLiveID;
@property(nonatomic) VideoZhiBoState videoZhiBoState;

@end
