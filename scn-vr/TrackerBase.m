//
//  TrackerBase.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "TrackerBase.h"

@implementation TrackerBase

- (instancetype)initWith:(NSString *) name identity:(NSString *) identity
{
    self = [super init];
    if (self) {
        _name = name;
        _identity = identity;
        _orientation = GLKQuaternionIdentity;
    }
    return self;
}

-(void) start {
    NSLog(@"This is not a valid tracker, please override");
}

-(void) stop {
    NSLog(@"This is not a valid tracker, please override");
}

-(void) calibrate {
    [self stop];
    [self start];
}

-(void) capture {
    NSLog(@"This is not a valid tracker, please override");
}

@end
