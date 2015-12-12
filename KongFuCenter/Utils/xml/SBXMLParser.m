//
//  SBXMLParser.m
//  Auth
//
//  Created by s on 15/3/19.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

#import "SBXMLParser.h"

@interface SBXMLParser ()<NSXMLParserDelegate>

// 解析器对象
@property (nonatomic,strong) NSXMLParser *parser;

// 根元素
@property (nonatomic,strong) XMLElement *rootElement;

// 当前的元素
@property (nonatomic,strong) XMLElement *currentElementPointer;


@end

@implementation SBXMLParser

-(XMLElement*)parserXML:(NSData*)xmlData
{
    self.parser = [[NSXMLParser alloc]initWithData:xmlData];
    
    self.parser.delegate = self;
    
    if([self.parser parse]){
        return self.rootElement;
    }
    return nil;
}
// 文档开始

-(void)parserDidStartDocument:(NSXMLParser *)parser

{
    
    self.rootElement = nil;
    
    self.currentElementPointer = nil;
    
}

// 文档结束

-(void)parserDidEndDocument:(NSXMLParser *)parser

{
    
    self.currentElementPointer = nil;
    
}

// 元素开始

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"elementName=%@, namespaceURI=%@, qName=%@, attributeDict=%@",elementName,namespaceURI,qName,attributeDict);
    
    if(self.rootElement == nil){
        
        self.rootElement = [[XMLElement alloc]init];
        
        self.currentElementPointer = self.rootElement;
        
    }else{
        
        XMLElement *newElement = [[XMLElement alloc]init];
        
        newElement.parent = self.currentElementPointer;
        
        [self.currentElementPointer.subElements addObject:newElement];
        
        self.currentElementPointer = newElement;
        
    }
    
    self.currentElementPointer.name = elementName;
    
    self.currentElementPointer.attributes = attributeDict;
    
//    NSLog(@"name:%@" , elementName);
    
}

// 元素结束

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"elementName=%@, namespaceURI=%@,qName=%@",elementName,namespaceURI,qName);
    self.currentElementPointer = self.currentElementPointer.parent;
    
//    NSLog(@"end name:%@" , elementName);
    
}

// 解析文本,会多次解析，每次只解析1000个字符，如果多月1000个就会多次进入这个方法

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"string=%@",string);
    
    if([self.currentElementPointer.text length] > 0){
        
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
        
    }else{
        
        self.currentElementPointer.text = [NSMutableString stringWithString:string];
        
    }
}

@end
