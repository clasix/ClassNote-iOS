//
//  HFLoginUtils.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-21.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "service.h"

@interface HFLoginUtils : NSObject{
    ClassNoteClient *server;
}

@property (nonatomic, assign) ClassNoteClient *server;

+ (HFLoginUtils *)instance;
@end
