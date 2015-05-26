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

@implementation VirtualDeviceManager

+(NSMutableArray *) getVirtualDevices {
    
    NSMutableArray * devices = [[NSMutableArray alloc] initWithCapacity:10];
    
    [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscape name:@"Landscape" key:@"land"]];
    
    [devices addObject:[[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeSquared name:@"Landscape²" key:@"land2"]];
    
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
        
        if (c.zoomed) {
            continue;
        }
        
        if (!c.tablet) {
            [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypeLandscapeVirtual name:[@"Landscape " stringByAppendingString:c.virtualName] key:[@"vl_" stringByAppendingString:c.identifier] device:c]];
            
            if (iPad) {
                [devices addObject: [[VirtualDeviceConfiguration alloc] initWithType:VirtualDeviceConfigurationTypePortraitVirtual name:[@"Portrait " stringByAppendingString:c.virtualName] key:[@"vp_" stringByAppendingString:c.identifier] device:c]];
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
