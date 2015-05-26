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

#import <Foundation/Foundation.h>
#import "MobileDeviceConfiguration.h"

typedef NS_ENUM(NSInteger, VirtualDeviceConfigurationType) {
    VirtualDeviceConfigurationTypeLandscape = 0,
    VirtualDeviceConfigurationTypeLandscape169 = 1,
    VirtualDeviceConfigurationTypePortrait = 2,
    VirtualDeviceConfigurationTypePortrait169 = 3,
    VirtualDeviceConfigurationTypeLandscapeVirtual = 4,
    VirtualDeviceConfigurationTypePortraitVirtual = 5,
    VirtualDeviceConfigurationTypeLandscapeCustom = 6,
    VirtualDeviceConfigurationTypePortraitCustom = 7,
    VirtualDeviceConfigurationTypeLandscapeSquared = 8
};

@interface VirtualDeviceConfiguration : NSObject

@property (assign, readonly) VirtualDeviceConfigurationType type;

@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * key;

@property (strong, nonatomic, readonly) MobileDeviceConfiguration * virtualDevice;

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key;

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name  key:(NSString *) key device:(MobileDeviceConfiguration *) device;

@end
