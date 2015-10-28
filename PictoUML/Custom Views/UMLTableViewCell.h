//
//  PollTableViewCell.h
//  ThisMatters
//
//  Created by TopeD on 7/22/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMLTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventLabel;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;

@end
