//
//  PlayVideoView.h
//  KongFuCenter
//
//  Created by Rain on 16/2/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVideoView : UIView{
    
}

@property(nonatomic) NSString *title;
@property(nonatomic) NSString *videoUrl;

-(instancetype)initWithContent:(NSString *)title andVideoUrl:(NSString *)videoUrl;
-(void)show;

@end
