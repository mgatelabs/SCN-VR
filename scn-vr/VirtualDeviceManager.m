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

#import "VirtualDeviceManager.h"
#import "MobileDeviceManager.h"
#import "SCNVRResourceBundler.h"

@implementation VirtualDeviceManager

+(NSMutableArray *) getVirtualDevices {
    
    NSMutableArray * devices = [[NSMutableArray alloc] initWithCapacity:10];
    
    [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape name:NSLocalizedStringFromTableInBundle(@"VIRTUAL_LANDSCAPE", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Landscape") key:@"land"]];
    
    [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeSquared name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_LANDSCAPE2", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Landscape²")  key:@"land2"]];
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    // iPad Users get more options
    if (iPad) {
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape169 name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_LANDSCAPE_169", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Landscape 16:9")  key:@"land169"]];
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_PORTRAIT", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Portrait")  key:@"port"]];
        
        [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortrait169 name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_PORTRAIT_169", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Portrait 16:9") key:@"port169"]];
    }
    
    NSMutableArray * tempDevices = [MobileDeviceManager getDevices];
    
    NSString * landscapeNameFormat = NSLocalizedStringFromTableInBundle(@"VIRTUAL_LANDSCAPE_FORMAT", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Landscape %@");
    
    NSString * portraitNameFormat = NSLocalizedStringFromTableInBundle(@"VIRTUAL_PORTRAIT_FORMAT", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Portrait %@");
    
    for (int i = 0; i < tempDevices.count; i++) {
        MobileDeviceConfiguration * c = [tempDevices objectAtIndex:i];
        
        if (c.zoomed) {
            continue;
        }
        
        if (!c.tablet) {
            
            [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeVirtual name:[NSString stringWithFormat:landscapeNameFormat, c.virtualName] key:[@"vl_" stringByAppendingString:c.identifier] device:c]];
            
            if (iPad) {
                [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitVirtual name:[NSString stringWithFormat:portraitNameFormat, c.virtualName] key:[@"vp_" stringByAppendingString:c.identifier] device:c]];
            }
        }
    }
    
    [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeCustom name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_LANDSCAPE_CUSTOM", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Custom Landscape") key:@"cl"]];
    
    if (iPad) {
        [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitCustom name: NSLocalizedStringFromTableInBundle(@"VIRTUAL_PORTRAIT_CUSTOM", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Custom Portrait") key:@"cp"]];
    }
    
    return devices;
}

@end
