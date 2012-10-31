//
//  HFLessonCell.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-30.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFLessonCell.h"

@implementation HFLessonCell
@synthesize iconImage;
@synthesize textField;

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

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)dealloc {
    [iconImage release];
    [textField release];
    [super dealloc];
}
@end
