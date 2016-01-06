//
//  PushView.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushView : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) NSString *nStr;
- (IBAction)click:(id)sender;


@end
