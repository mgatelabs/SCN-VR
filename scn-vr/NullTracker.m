//
//  NullTracker.m
//  scn-vr
//
//  Created by Michael Fuller on 9/5/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import "NullTracker.h"
#import "SCNVRResourceBundler.h"

@interface NullTracker() {
    GLKQuaternion result;
}

@end

@implementation NullTracker

- (instancetype)init
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"TRACKER_NULL", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Null Tracker") identity:@"null"];
    if (self) {
        GLKQuaternion rotationFix = GLKQuaternionMakeWithAngleAndAxis(-M_PI_2, 0, 0, 1);
        
        result = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    }
    return self;
}

-(void) capture {
    self.orientation = result;
}

-(void) start {
    // NO-OP
}

@end
