//
//  HFLoginUtils.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-21.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFLoginUtils.h"
#import "TSocketClient.h"
#import "TBinaryProtocol.h"
#import "service.h"

@implementation HFLoginUtils

@synthesize server;

+ (HFLoginUtils *)instance  {
    static HFLoginUtils *instance;
    @synchronized(self) {
        if(!instance) {
            instance = [[HFLoginUtils alloc] init];
        }
    }
        
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Talk to a server via socket, using a binary protocol
        TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"localhost" port:9090];
        TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        server = [[ClassNoteClient alloc] initWithProtocol:protocol];
    }
    return self;
}

@end
