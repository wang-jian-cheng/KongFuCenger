//
//  SBXMLParser.h
//  Auth
//
//  Created by s on 15/3/19.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLElement.h"

@interface SBXMLParser : NSObject

-(XMLElement*)parserXML:(NSData*)xmlData;
@end
