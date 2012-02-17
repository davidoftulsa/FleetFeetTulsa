//
//  StudentListCustomCell.m
//  FleetFeetTulsaPage3
//
//  Created by Liliana Crossley on 2/1/12.
//  Copyright (c) 2012 CCS. All rights reserved.
//

#import "StudentListCustomCell.h"

@implementation StudentListCustomCell

@synthesize StudentNameLabel, StudentEmailLabel, StudentIdLabel;

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
