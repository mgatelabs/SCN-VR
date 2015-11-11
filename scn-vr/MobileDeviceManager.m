/************************************************************************
	
 
	Copyright (C) 2015  Michael Glen Fuller Jr.
 
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
 
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ************************************************************************/

#import "MobileDeviceManager.h"
#import "SCNVRResourceBundler.h"

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
        int width = screen.bounds.size.width * screen.nativeScale;
        int height = screen.bounds.size.height * screen.nativeScale;
        
        // Get ride of devices that don't match our current screen setup
        [self trimDevicesForCurrentDeviceWidth:width heightPx:height widthPoint:screen.bounds.size.width heightPoint:screen.bounds.size.height nativeScale:screen.nativeScale tablet:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)];
    }
    return self;
}

+(NSMutableArray *) getDevices {
    
    NSMutableArray * tempList = [[NSMutableArray alloc] initWithCapacity:10];
    
    MobileDeviceConfiguration * tempConfig;
    
    // iPhone4S              640×960   326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_4S", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 4S") identifier:@"iphone4s" widthPx:960 heightPx:640 dpi:326 tablet:NO];
    tempConfig.widthPoint = 480;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = 1.99;
    tempConfig.maxNativeScale = 2.01;
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_3.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"3.5\"");
    [tempList addObject:tempConfig];
    
    // iPhone5               640×1136  326 ppi
    // iPhone5C              640×1136  326 ppi
    // iPhone5S              640×1136  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_5", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 5") identifier:@"iphone5" widthPx:1136 heightPx:640 dpi:326 tablet:NO];
    tempConfig.widthPoint = 568;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = 1.99;
    tempConfig.maxNativeScale = 2.01;
    tempConfig.virtualName = @"4\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4\"");
    [tempList addObject:tempConfig];
    
    ////////////////////////
    
    // iPhone6 (Zoomed)       750×1334  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6Z", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6 (Zoomed)") identifier:@"iphone6zoomed" widthPx:1331 heightPx:750 dpi:326 tablet:NO];
    tempConfig.virtualName = @"4.7\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4.7\"");
    tempConfig.widthPoint = 568;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = 2.21; // It will be bigger then 2
    tempConfig.maxNativeScale = 2.41;
    tempConfig.zoomed = YES;
    [tempList addObject:tempConfig];
    
    // iPhone6               750×1334  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6") identifier:@"iphone6" widthPx:1334 heightPx:750 dpi:326 tablet:NO];
    tempConfig.virtualName = @"4.7\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4.7\"");
    tempConfig.widthPoint = 667;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = 1.99;
    tempConfig.maxNativeScale = 2.01;
    [tempList addObject:tempConfig];
    
    ////////////////////////
    
    // iPhone6Plus           1080×1920 401 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6Plus", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6+ (Zoomed)") identifier:@"iphone6pluszoomed" widthPx:1920 heightPx:1080 dpi:401 tablet:NO];
    tempConfig.virtualName = @"5.5\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.5\"");
    tempConfig.widthPoint = 667;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = 2.75f; // 2.88
    tempConfig.maxNativeScale = 2.91f;
    tempConfig.zoomed = YES;
    [tempList addObject: tempConfig];
    
    
    // iPhone6Plus           1080×1920 401 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6PlusZ", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6+") identifier:@"iphone6plus" widthPx:1920 heightPx:1080 dpi:401 tablet:NO];
    tempConfig.virtualName = @"5.5\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.5\"");
    [tempList addObject: tempConfig];
    tempConfig.widthPoint = 736;
    tempConfig.heightPoint = 414;
    tempConfig.minNativeScale = 2.5; // 2.608
    tempConfig.maxNativeScale = 2.7;
    #if (TARGET_IPHONE_SIMULATOR)
    tempConfig.widthPx = 2208;
    tempConfig.heightPx = 1242;
    //tempConfig.physicalWidthPx = 2208;
    //tempConfig.physicalHeightPx = 1242;
    tempConfig.minNativeScale = 2.9;
    tempConfig.maxNativeScale = 3.1;
    tempConfig.forcedScale = 3.0f;
    #endif
    
    //iPad2                 1024x768  132 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_9.7", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 9.7\"") identifier:@"ipad2" widthPx:1024 heightPx:768 dpi:132 tablet:YES];
    [tempList addObject:tempConfig];
    
    //iPad (3gen)           2048x1536 264 ppi
    //iPad (4gen)           2048x1536 264 ppi
    //iPad Air              2048x1536 264 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_9.7_RETINA", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 9.7\" (Retina)") identifier:@"ipad" widthPx:2048 heightPx:1536 dpi:264 tablet:YES];
    [tempList addObject:tempConfig];
    
    //iPad mini             1024x768  163 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_7.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 7.9\"") identifier:@"ipadmini" widthPx:1024 heightPx:768 dpi:163 tablet:YES];
    [tempList addObject: tempConfig];
    
    //iPad mini (retina)    2048x1536 326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_7.9_RETINA", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 7.9\" (Retina)") identifier:@"ipadmini2" widthPx:2048 heightPx:1536 dpi:326 tablet:YES];
    [tempList addObject: tempConfig];
    
    //iPad Pro (retina)    2732x2048 264 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_12.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 12.9\" (Retina)") identifier:@"ipadpro" widthPx:2732 heightPx:2048 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    for (int i = 0; i < tempList.count; i++) {
        MobileDeviceConfiguration * c = [tempList objectAtIndex:i];
        c.internal = YES;
        [c ready];
    }
    
    return tempList;
}

-(void) trimDevicesForCurrentDeviceWidth:(int) widthPx heightPx:(int) heightPx widthPoint:(int) widthPoint heightPoint:(int) heightPoint nativeScale:(float) nativeScale tablet:(BOOL) tablet {
    
    if (widthPx < heightPx) {
        int temp =widthPx;
        widthPx = heightPx;
        heightPx = temp;
        temp = widthPoint;
        widthPoint = heightPoint;
        heightPoint = temp;
    }
    
    for (int i = (int)_devices.count - 1; i >= 0; i--) {
        
        BOOL removeDevice = NO;
        
        MobileDeviceConfiguration * test = [_devices objectAtIndex:i];
        // Different screen sizes or types will lead to it being discarded
        if (test.tablet != tablet) {
            removeDevice = YES;
        } else {
            
            if (test.tablet) {
                if (test.widthPx == widthPx && test.heightPx == heightPx) {
                    continue;
                } else if (test.widthPx == heightPx && test.heightPx == widthPx) {
                    continue;
                } else {
                    removeDevice = YES;
                }
            } else {
                if (nativeScale >= test.minNativeScale && nativeScale <= test.maxNativeScale) {
                    
                    if (test.widthPoint == widthPoint && test.heightPoint == heightPoint) {
                        continue;
                    } else if (test.widthPoint == heightPoint && test.heightPoint == widthPoint) {
                        continue;
                    } else {
                        removeDevice = YES;
                    }
                    
                } else {
                    removeDevice = YES;
                }
            }
        }
        if (removeDevice) {
            [_devices removeObjectAtIndex:i];
        }
    }
    
    // If we can't find a device, make up a custom device, ow man
    if (_devices.count == 0) {
        
        MobileDeviceConfiguration * tempDevice = [[MobileDeviceConfiguration alloc] initAsCustom:@"Custom" identifier:@"custom" widthPx:widthPx heightPx:heightPx tablet:tablet];
        tempDevice.forcedScale = nativeScale;
        
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
