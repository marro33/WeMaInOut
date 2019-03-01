//
//  ZJButton.m
//  bbb
//
//  Created by ZJ on 16/9/25.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "ZJButton.h"

@implementation ZJButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect

{
    CGRect imageFrame = CGRectMake(0, 5, contentRect.size.height-10, contentRect.size.height-10);
    return imageFrame;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{

    CGRect titleFrame = CGRectMake(contentRect.size.height-10, 0, contentRect.size.width-contentRect.size.height, contentRect.size.height);
    return titleFrame;
 
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
