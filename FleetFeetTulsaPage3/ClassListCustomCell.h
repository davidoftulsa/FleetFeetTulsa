//
//  ClassListCustomCell.h
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassListCustomCell : UITableViewCell{
    IBOutlet UILabel *classTitleLabel;
    IBOutlet UILabel *classLocationLabel;    
    IBOutlet UILabel *classDateTimeLabel;  
    IBOutlet UIImageView *checkmarkImage;
}

@property (nonatomic,retain) UILabel *classTitleLabel;
@property (nonatomic,retain) UILabel *classLocationLabel;
@property (nonatomic,retain) UILabel *classDateTimeLabel;
@property (nonatomic,retain) UIImageView *checkmarkImage;




@end
