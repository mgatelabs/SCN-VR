//
//  MobileDeviceManager.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "MobileDeviceManager.h"

@implementation MobileDeviceManager

+ (id)sharedManager {
    static MobileDeviceManager *sharedMyManager = nil;
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
        
        [_devices addObjectsFromArray:[MobileDeviceManager getDevices]];
        
        UIScreen * screen = [UIScreen mainScreen];
        
        // Use this to trim bad devices
        int width = screen.bounds.size.width * screen.scale;
        int height = screen.bounds.size.height * screen.scale;
        
        // Get ride of devices that don't match our current screen setup
        [self trimDevicesForCurrentDeviceWidth:width heightPx:height tablet:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)];
    }
    return self;
}

+(NSMutableArray *) getDevices {
    
    NSMutableArray * tempList = [[NSMutableArray alloc] initWithCapacity:10];
    
    // iPhone4S              640×960   326 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPhone 4S" identifier:@"iphone4s" widthPx:960 heightPx:640 dpi:326 tablet:NO]];
    
    // iPhone5               640×1136  326 ppi
    // iPhone5C              640×1136  326 ppi
    // iPhone5S              640×1136  326 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPhone 5" identifier:@"iphone5" widthPx:1136 heightPx:640 dpi:326 tablet:NO]];
    
    // iPhone6               750×1334  326 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPhone 6" identifier:@"iphone6" widthPx:1334 heightPx:750 dpi:326 tablet:NO]];
    
    // iPhone6Plus           1080×1920 401 ppi
    MobileDeviceConfiguration * iphone6p = [MobileDeviceManager createDevice:@"iPhone 6+" identifier:@"iphone6plus" widthPx:2208 heightPx:1242 dpi:401 tablet:NO];
    [tempList addObject: iphone6p];
    #if !(TARGET_IPHONE_SIMULATOR)
    iphone6p.physicalWidthPx = 1920;
    iphone6p.physicalHeightPx = 1080;
    iphone6p.dpi = 326;
    #endif
    
    //iPad2                 1024x768  132 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPad 2" identifier:@"ipad2" widthPx:1024 heightPx:768 dpi:132 tablet:YES]];
    
    //iPad (3gen)           2048x1536 264 ppi
    //iPad (4gen)           2048x1536 264 ppi
    //iPad Air              2048x1536 264 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPad" identifier:@"ipad" widthPx:2048 heightPx:1536 dpi:264 tablet:YES]];
    
    //iPad mini             1024x768  163 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPad (Mini)" identifier:@"ipadmini" widthPx:1024 heightPx:768 dpi:163 tablet:YES]];
    
    //iPad mini (retina)    2048x1536 326 ppi
    [tempList addObject:[MobileDeviceManager createDevice:@"iPad (Mini Retina)" identifier:@"ipadmini2" widthPx:2048 heightPx:1536 dpi:326 tablet:YES]];
    
    for (int i = 0; i < tempList.count; i++) {
        MobileDeviceConfiguration * c = [tempList objectAtIndex:i];
        c.internal = YES;
        [c ready];
    }
    
    return tempList;
}

-(void) trimDevicesForCurrentDeviceWidth:(int) widthPx heightPx:(int) heightPx tablet:(BOOL) tablet {
    
    if (widthPx < heightPx) {
        int temp =widthPx;
        widthPx = heightPx;
        heightPx = temp;
    }
    
    for (int i = (int)_devices.count - 1; i >= 0; i--) {
        MobileDeviceConfiguration * test = [_devices objectAtIndex:i];
        // Different screen sizes or types will lead to it being discarded
        if (test.tablet != tablet) {
            [_devices removeObjectAtIndex:i];
        } else if (test.widthPx == widthPx && test.heightPx == heightPx) {
            
        } else if (test.widthPx == heightPx && test.heightPx == widthPx) {
            
        } else {
            [_devices removeObjectAtIndex:i];
        }
    }
    
    // If we can't find a device, make up a custom device, ow man
    if (_devices.count == 0) {
        
        MobileDeviceConfiguration * tempDevice = [[MobileDeviceConfiguration alloc] initAsCustom:@"Custom" identifier:@"custom" widthPx:widthPx heightPx:heightPx tablet:tablet];
        
        [_devices addObject:tempDevice];
    }
    
    _device = [_devices objectAtIndex:0];
}

+(MobileDeviceConfiguration *) createDevice:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi  tablet:(BOOL) tablet {
    
    MobileDeviceConfiguration * device = [[MobileDeviceConfiguration alloc] initAs:name identifier:identifier widthPx:widthPx heightPx:heightPx dpi:dpi tablet:tablet];
    
    return device;
}

-(BOOL) removeDeviceWithIndex:(int) index {
    if (index >= 0 && index < _devices.count) {
        MobileDeviceConfiguration * device = [_devices objectAtIndex:index];
        if (device.internal) {
            return NO;
        }
        [_devices removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

-(void) cycle {
    int nextIndex = [self getIndexFor:_device];
    nextIndex = (nextIndex + 1) % self.devices.count;
    _device = [self.devices objectAtIndex:nextIndex];
}

-(int) getIndexFor:(MobileDeviceConfiguration *) mobileConfiguration {
    for (int i = 0; i < self.devices.count; i++) {
        MobileDeviceConfiguration * temp = [self.devices objectAtIndex:i];
        if (temp == mobileConfiguration) {
            return i;
        }
    }
    return 0;
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"Device";
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
        MobileDeviceConfiguration * d = [_devices objectAtIndex:i];
        if (d == _device) {
            return i;
        }
    }
    
    NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _device = [_devices objectAtIndex:index];
}


-(void) ready {
    for (int i = 0; i < _devices.count; i++) {
        MobileDeviceConfiguration * m = [_devices objectAtIndex:i];
        [m ready];
    }
}

@end
