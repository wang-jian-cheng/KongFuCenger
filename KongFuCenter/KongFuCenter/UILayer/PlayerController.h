//
//  PlayerController.h
//  Vitamio-Demo
//
//  Created by erlz nuo on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h>
#import "Vitamio.h"
#import "PlayerControllerDelegate.h"




@interface PlayerController : UIViewController <VMediaPlayerDelegate>

@property (nonatomic, assign) id<PlayerControllerDelegate> delegate;
-(void)goBackButtonAction;
@property (nonatomic, assign) IBOutlet UIView  	*backView;
@property (weak, nonatomic) IBOutlet UIButton *playandpuase;

@property (nonatomic, assign) IBOutlet UIButton *modeBtn;
-(void)nextVideo:(NSURL *)url andTitle:(NSString *)title;
@end
