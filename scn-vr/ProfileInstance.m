//
//  ProfileInstance.m
//  scn-vr
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfileInstance.h"

@implementation ProfileInstance

- (instancetype)init
{
    self = [super init];
    if (self) {
        _extended = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

-(int) getExtendedValueFor:(NSString *) key withDefaultInt:(int) value {
    NSNumber * current = [_extended valueForKey:key];
    if (current == nil) {
        return value;
    }
    return [current intValue];
}

-(NSString *) getExtendedValueFor:(NSString *) key withDefaultNSString:(NSString *) value {
    NSString * current = [_extended valueForKey:key];
    if (current == nil) {
        return value;
    }
    return current;
}

- (void)dealloc
{
    _extended = nil;
}

@end
