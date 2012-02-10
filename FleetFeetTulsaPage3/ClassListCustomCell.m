//
//  ClassListCustomCell.m
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassListCustomCell.h"

@implementation ClassListCustomCell

@synthesize classTitleLabel,classLocationLabel,classDateTimeLabel, checkmarkImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
