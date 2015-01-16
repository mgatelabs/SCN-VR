//
//  VirtualDeviceManager.h
//  scn-vr
//
//  Created by Michael Fuller on 1/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListableArray.h"
#import "VirtualDeviceConfiguration.h"

@interface VirtualDeviceManager : NSObject

@property (strong, readonly, nonatomic) NSMutableArray * devices;

@property (weak, nonatomic, readonly) VirtualDeviceConfiguration * device;

+ (id)sharedManager;
+(NSMutableArray *) getVirtualDevices;

-(void) persist;
-(void) load;

@end
