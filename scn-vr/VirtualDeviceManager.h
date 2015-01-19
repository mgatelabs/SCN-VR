//
//  VirtualDeviceManager.h
//  scn-vr
//
//  Created by Michael Fuller on 1/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VirtualDeviceConfiguration.h"

@interface VirtualDeviceManager : NSObject

+(NSMutableArray *) getVirtualDevices;

@end
