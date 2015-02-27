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

#import "VirtualDeviceConfiguration.h"

@implementation VirtualDeviceConfiguration

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key
{
    self = [super init];
    if (self) {
        _type = type;
        _key = key;
        _name = name;
        _virtualDevice = nil;
    }
    return self;
}

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key device:(MobileDeviceConfiguration *) device
{
    self = [super init];
    if (self) {
        _type = type;
        _key = key;
        _name = name;
        _virtualDevice = device;
    }
    return self;
}

@end
