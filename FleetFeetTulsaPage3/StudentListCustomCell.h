//
//  StudentListCustomCell.h
//  FleetFeetTulsaPage3
//
//  Created by Liliana Crossley on 2/1/12.
//  Copyright (c) 2012 CCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentListCustomCell : UITableViewCell {
    IBOutlet UILabel *StudentNameLabel;
    IBOutlet UILabel *StudentEmailLabel;
    IBOutlet UILabel *StudentIdLabel;
}

@property (nonatomic,retain) UILabel *StudentNameLabel;
@property (nonatomic,retain) UILabel *StudentEmailLabel;
@property (nonatomic, retain) UILabel * StudentIdLabel;
@end
