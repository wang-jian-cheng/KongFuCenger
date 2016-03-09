//
//  Model.h
//  Contacts
//
//  Created by vmeet on 15/2/12.
//  Copyright (c) 2015年 vmeet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, assign) int recordID;
@property (nonatomic,retain) NSString *friendID;
@property (nonatomic,retain) UIImage *photo;
@end
