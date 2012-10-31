//
//  HFLessonCell.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-30.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFLessonCell : UITableViewCell {
    UIToolbar *_inputAccessoryView;
    UIPickerView *_inputView;
}

@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UITextField *textField;

@end
