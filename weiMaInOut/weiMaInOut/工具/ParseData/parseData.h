//
//  parseData.h
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface parseData : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong)NSDictionary *resultDic;

- (instancetype)initWithData:(NSString *)string withName:(NSString *)elementName;

@end
