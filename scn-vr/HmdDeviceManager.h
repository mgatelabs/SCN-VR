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
#import "HmdDeviceConfiguration.h"
#import "ListableArray.h"

@interface HmdDeviceManager: NSObject

//@property (weak, readonly, nonatomic) HmdDeviceConfiguration * hmd;

//@property (strong, readonly, nonatomic) NSMutableArray * hmds;

+ (id)sharedManager;

//-(HmdDeviceConfiguration *) addHmd:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB;

+(HmdDeviceConfiguration *) addHmdTo:(NSMutableArray *) dest name:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB;

/*
-(BOOL) removeHmdWithIndex:(int) index;

-(void) cycle;

-(int) getIndexFor:(HmdDeviceConfiguration *) hmdConfiguration;

-(void) persist;

-(void) load;
*/

+(NSMutableArray *) getHMDs;

@end
