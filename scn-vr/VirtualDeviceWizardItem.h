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

#import "WizardItem.h"
#import "PhysicalDeviceWizardItem.h"
#import "VirtualDeviceConfiguration.h"

@interface VirtualDeviceWizardItem : WizardItem

@property (strong, nonatomic, readonly) NSMutableArray * sourceItems;
@property (strong, nonatomic, readonly) NSMutableArray * items;
@property (weak, nonatomic, readonly) VirtualDeviceConfiguration * virtualDevice;
@property (strong, nonatomic, readonly) ProfileInstance * tempProfileInstance;

- (instancetype)initWith:(PhysicalDeviceWizardItem *) deviceWizardItem;

-(void) filterDevices;

-(void) updateTargetInfo;

-(float) getTargetVirtualWidthMM;
-(float) getTargetVirtualHeightMM;
-(float) getPhysicalWidthMM;
-(float) getPhysicalHeightMM;

@end
