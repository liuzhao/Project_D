//
//  HomeTableViewCell.m
//  Project_D
//
//  Created by Liu Zhao on 15/9/28.
//  Copyright © 2015年 Liu Zhao. All rights reserved.
//

#import "HomeTableViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, SCREEN_WIDTH - 105, 20)];
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.5];
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, SCREEN_WIDTH - 105, 40)];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:13.5];
        [self.contentView addSubview:_detailLabel];
        
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 57, 57)];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImageView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnailImageView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
