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
#import <UIKit/UIKit.h>
#import "MobileDeviceConfiguration.h"
#import "ListableArray.h"

@interface MobileDeviceManager : ListableArray

@property (weak, readonly, nonatomic) MobileDeviceConfiguration * device;

@property (strong, readonly, nonatomic) NSMutableArray * devices;

- (instancetype)init;

+ (id)sharedManager;

-(void) trimDevicesForCurrentDeviceWidth:(int) widthPx heightPx:(int) heightPx widthPoint:(int) widthPoint heightPoint:(int) heightPoint nativeScale:(float) nativeScale tablet:(BOOL) tablet;

+(MobileDeviceConfiguration *) createDevice:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet;

-(BOOL) removeDeviceWithIndex:(int) index;

-(void) cycle;

-(int) getIndexFor:(MobileDeviceConfiguration *) mobileConfiguration;

-(void) ready;

+(NSMutableArray *) getDevices;

@end
