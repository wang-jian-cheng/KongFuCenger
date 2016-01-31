//
//  Toolkit.m
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "Toolkit.h"

@implementation Toolkit


#pragma mark - add by wangjc

+(UIApplication*)showJuHua
{
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    
    return application;
}

+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}


+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:tempView.frame];
    [tempView addSubview:imageView];
    
    CGFloat R, G, B,A;
    
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), R,G, B, A);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startX, startY);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endX, endY);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imageView;
}

+(NSMutableArray *)getColorRGBA:(UIColor *) color
{
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        
        NSMutableArray *rgbaArr = [NSMutableArray array];
        for (int i = 0; i<numComponents; i++) {
            [rgbaArr addObject:[NSString stringWithFormat:@"%lf",components[i]]];
        }
        return rgbaArr;
    }
    else
    {
        return nil;
    }
}


+(NSString *)getUserID
{
    
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                  NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
//    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID

    NSUserDefaults *mUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [mUserDefault valueForKey:@"id"];//获取userID
    return  userID;

}

+(NSString *)judgeIsNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if([str isEqual:@""] || [str isEqual:[NSNull null]] || [str isEqual:@"(null)"]){
        return @"";
    }
    return str;
}

+(BOOL)isVip
{
    if([get_sp(@"IsPay") intValue] == 1)
        return  YES;
    else
        return NO;
}

#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - plist file 

+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key
{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];

    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        return dic[key];
    }
    else
    {
        return dic[key];
    }

}



+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
   
    
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    else
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    
}


+(void)delPlist:(NSString *)plist
{
    //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
    NSFileManager *fileMger = [NSFileManager defaultManager];
    
    NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:plist];
    
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
    
    if (bRet) {
        
        NSError *err;
        
        [fileMger removeItemAtPath:xiaoXiPath error:&err];
    }
}


#pragma mark - time 


+(NSString *)GettitleForDate:(NSString *)dateStr
{
    @try {
        NSString * resultStr=@"";
        
        if (dateStr.length>0) {
            
            NSDate * nowDate=[NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormatter dateFromString:dateStr];
            
            NSTimeInterval a_hour = 60*60;
            
            NSDate *other = [date addTimeInterval: a_hour];
            
            
            
            if ([nowDate compare:other]==NSOrderedDescending) {
                
                NSTimeInterval a_day = 24*60*60;
                
                NSDate *othersecond = [[self extractDate:date] addTimeInterval: a_day];
                if ([nowDate compare:othersecond]==NSOrderedDescending) {
                    if ([nowDate compare:[othersecond addTimeInterval:a_day]]==NSOrderedDescending) {
                        if ([nowDate compare:[[othersecond addTimeInterval:a_day] addTimeInterval:a_day] ]==NSOrderedDescending) {
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            NSString *strHour = [dateFormatter stringFromDate:date];
                            return [NSString stringWithFormat:@"%@",strHour];
                        }
                        else
                        {
                            return @"前天发布";
                        }
                    }
                    else
                    {
                        return @"昨天发布";
                    }
                }
                else
                {
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *strHour = [dateFormatter stringFromDate:date];
                    return [NSString stringWithFormat:@"%@",strHour];
                }
            }
            else
            {
                return @"刚刚发布";
            }
        }
        
        return resultStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}



+ (NSDate *)extractDate:(NSDate *)date {
    if (!date) {
        date=[NSDate date];
    }
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

#pragma mark  - old

+ (BOOL)isSystemIOS7
{
     
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0&&[[[UIDevice currentDevice] systemVersion] floatValue] < 8.0? YES : NO;
}
+ (BOOL)isSystemIOS8
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO;
}



//+ (NSString *)getSystemLanguage
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kSystemLanguage];
//}
//
//+ (void)setSystemLanguage:(NSString *)strLanguage
//{
//    if (strLanguage)
//        [[NSUserDefaults standardUserDefaults] setObject:strLanguage forKey:kSystemLanguage];
//}

//+(UIImage *)drawsimiLine:(UIImageView *)imageView
//{
//    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    CGFloat lengths[] = {5,5};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
//    CGContextAddLineToPoint(line, 310.0, 20.0);
//    CGContextStrokePath(line);
//    
//    return UIGraphicsGetImageFromCurrentImageContext();
//}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

//+ (void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}

 + (BOOL)isEnglishSysLanguage
 {
     return NO;
     //return [[self getSystemLanguage] isEqualToString:kEnglish] ? YES : NO;
 }





@end
