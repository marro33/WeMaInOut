//
//  tableCell.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/14.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "tableCell.h"

@implementation tableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (kScreenWidth - 10)/2.0, self.height)];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftLabel.right, 0, (kScreenWidth - 10)/2.0, self.height)];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_rightLabel];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
