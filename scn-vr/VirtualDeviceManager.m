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

+ (id)sharedManager {
    static VirtualDeviceManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _devices = [[NSMutableArray alloc] initWithCapacity:10];
        
        [_devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape name:@"Landscape" key:@"land"]];
        
        // iPad Users get more options
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            
            [_devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape169 name:@"Landscape 16:9" key:@"land169"]];
            
            [_devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait name:@"Portrait" key:@"port"]];
            
            [_devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait169 name:@"Portrait 16:9" key:@"port169"]];
            
            NSMutableArray * tempDevices = [MobileDeviceManager getDevices];
            
            for (int i = 0; i < tempDevices.count; i++) {
                MobileDeviceConfiguration * c = [tempDevices objectAtIndex:i];
                if (!c.tablet) {
                    [_devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeVirtual name:[@"Virtual (Landscape): " stringByAppendingString:c.name] key:[@"vl_" stringByAppendingString:c.identifier] device:c]];
                    
                    [_devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitVirtual name:[@"Virtual (Portrait): " stringByAppendingString:c.name] key:[@"vp_" stringByAppendingString:c.identifier] device:c]];
                }
            }
        }
        
        [self load];
        
    }
    return self;
}

-(void) persist {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs setValue:_device.key forKey:@"scn-vr.virtual.selected"];
    [defs synchronize];
}

-(void) load {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    NSString * selectedIndentity = [defs valueForKey:@"scn-vr.virtual.selected"];
    
    _device = [_devices objectAtIndex:0];
    
    if (selectedIndentity != nil) {
        
        for (int i = 0; i < _devices.count; i++) {
            VirtualDeviceConfiguration * d = [_devices objectAtIndex:i];
            if ([d.key isEqualToString:selectedIndentity]) {
                _device = d;
                return;
            }
        }
    }
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"Virtual Device";
}

-(NSString *) getListItemNameFor:(int) index {
    MobileDeviceConfiguration * d = [_devices objectAtIndex:index];
    return d.name;
}

-(int) getListItemCount {
    return (int)_devices.count;
}

-(int) getSelectedItemIndex {
    
    if (_device == nil) {
        return - 1;
    }
    
    for (int i = 0; i < _devices.count; i++) {
        VirtualDeviceConfiguration * d = [_devices objectAtIndex:i];
        if (d == _device) {
            return i;
        }
    }
    
    NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _device = [_devices objectAtIndex:index];
    [self persist];
}        

@end
