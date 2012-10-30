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
@synthesize inputView, inputAccessoryView;

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

-(UIToolbar *)inputAccessoryView
{
    if(!_inputAccessoryView)
    {
        return inputAccessoryView;
    }
    return _inputAccessoryView;
}
-(UIPickerView *)inputView
{
    if(!_inputView)
    {
        inputView.frame = CGRectMake(0, 244, 320, 216);
        inputView.showsSelectionIndicator = YES;
        return inputView;
    }
    return _inputView;
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
