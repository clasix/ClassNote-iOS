//
//  HFLoginUtils.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-21.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSocketClient.h"
#import "TBinaryProtocol.h"
#import "service.h"

@interface HFRemoteUtils : NSObject{
    ClassNoteClient *server;
}

@property (nonatomic, assign) ClassNoteClient *server;

+ (HFRemoteUtils *)instance;
@end
