//
//  VirtualDeviceManager.m
//  scn-vr
//
//  Created by Michael Fuller on 1/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "VirtualDeviceManager.h"
#import "MobileDeviceManager.h"

@implementation VirtualDeviceManager

+(NSMutableArray *) getVirtualDevices {
    
    NSMutableArray * devices = [[NSMutableArray alloc] initWithCapacity:10];
    
    [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape name:@"Landscape" key:@"land"]];
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    // iPad Users get more options
    if (iPad) {
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape169 name:@"Landscape 16:9" key:@"land169"]];
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait name:@"Portrait" key:@"port"]];
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait169 name:@"Portrait 16:9" key:@"port169"]];
    }
    
    NSMutableArray * tempDevices = [MobileDeviceManager getDevices];
    
    for (int i = 0; i < tempDevices.count; i++) {
        MobileDeviceConfiguration * c = [tempDevices objectAtIndex:i];
        if (!c.tablet) {
            [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeVirtual name:[@"Virtual (Landscape): " stringByAppendingString:c.name] key:[@"vl_" stringByAppendingString:c.identifier] device:c]];
            
            if (iPad) {
                [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitVirtual name:[@"Virtual (Portrait): " stringByAppendingString:c.name] key:[@"vp_" stringByAppendingString:c.identifier] device:c]];
            }
        }
    }
    
    
    [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeCustom name:@"Custom Landscape" key:@"cl"]];
    
    if (iPad) {
        [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitCustom name:@"Custom Portrait" key:@"cp"]];
    }
    
    return devices;
}

@end
