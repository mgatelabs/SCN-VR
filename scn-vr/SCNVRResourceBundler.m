//
//  SCNVRResourceBundler.m
//  scn-vr
//
//  Created by Michael Fuller on 11/7/15.
//  Copyright © 2015 M-Gate Labs. All rights reserved.
//

#import "SCNVRResourceBundler.h"

@implementation SCNVRResourceBundler
+(NSBundle * ) getSCNVRResourceBundle {
    static NSBundle *sharedBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SCNVRResourceBundle" ofType:@"bundle"]];
    });
    return sharedBundle;
}
@end
