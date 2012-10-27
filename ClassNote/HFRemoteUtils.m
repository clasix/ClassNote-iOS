//
//  HFLoginUtils.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-21.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFRemoteUtils.h"

@implementation HFRemoteUtils

@synthesize server;

+ (HFRemoteUtils *)instance  {
    static HFRemoteUtils *instance;
    @synchronized(self) {
        if(!instance) {
            instance = [[HFRemoteUtils alloc] init];
        }
    }
        
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Talk to a server via socket, using a binary protocol
        TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"localhost" port:8080];
        TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        server = [[ClassNoteClient alloc] initWithProtocol:protocol];
    }
    return self;
}

@end
