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

#import "HmdDeviceConfiguration.h"

@implementation HmdDeviceConfiguration

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB
{
    self = [super init];
    if (self) {
        self.name = name;
        _identity = identifier;
        _distortion = distortion;
        _correction = correction;
        _viewpoints = viewpoints;
        self.ipd = ipd;
        self.ild = ild;
        self.fov = fov;
        self.hFov = fov;
        self.vFov = fov;
        self.correctionCoefficient = correctionCoefficient;
        self.distortionFactorA = distortionFactorA;
        self.distortionFactorB = distortionFactorB;
        self.internal = NO;
        self.deviceUsed = NO;
        _extraIpdAvailable = NO;
    }
    return self;
}

@end
