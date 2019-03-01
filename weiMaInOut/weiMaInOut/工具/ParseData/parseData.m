//
//  parseData.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "parseData.h"

@implementation parseData
{
    NSString *jsonString;
    NSString *tmpStr;
    NSString *nameString;
}

- (instancetype)initWithData:(NSString *)string withName:(NSString *)elementName
{
    self=[super init];
    _resultDic = [NSDictionary new];
    nameString = elementName;
    [self parserData:string];
    return self;
}

//解析数据
-(void)parserData:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser=[[NSXMLParser alloc]initWithData:data];
    parser.delegate=self;
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"解析完成");
    _resultDic = [jsonString JSONValue];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:nameString]==YES) {
        tmpStr = @"";
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    tmpStr=[tmpStr stringByAppendingString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:nameString]==YES) {
        jsonString = tmpStr;
    }
}

@end
