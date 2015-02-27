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

#import "DistortionQualityWizardItem.h"

@implementation DistortionQualityWizardItem

- (instancetype)initWith:(DistortionWizardItem *) distortion
{
    self = [super initWith:@"... Quality" info:@"Our distortion effect is handled through a mesh, not a shader, so a high quality mesh will provide more accurate results, but impact system performance." itemId:WIZARD_ITEM_DISTORTION_QUALITY type:WizardItemDataTypeInt];
    if (self) {
        self.distortion = distortion;

        self.count = 6;
    
        self.valueIndex = 3;
        self.valueId = [self stringForIndex:self.valueIndex];
    }
    return self;
}

-(void) reset {
    self.valueIndex = 3;
    self.valueId = [self stringForIndex:self.valueIndex];
}

-(void) chainUpdated {
    
}

-(BOOL) available {
    return [self.distortion available] && self.distortion.valueIndex != 1;
}

-(BOOL) ready {
    return [self.distortion ready] && self.distortion.valueIndex != 1;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return @"Lowest 4x4";
        case 1:
            return @"Lower 8x8";
        case 2:
            return @"Low 12x12";
        case 3:
            return @"Decent 16x16";
        case 4:
            return @"High 18x18";
        case 5:
            return @"Highest 20x20";
        default:
            return @"Unknown";
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    int value;
    
    switch (self.valueIndex) {
        case 0:
            value = 4;
            break;
        case 1:
            value = 8;
            break;
        case 2:
            value = 12;
            break;
        case 3:
            value = 16;
            break;
        case 4:
            value = 18;
            break;
        case 5:
            value = 20;
            break;
        default:
            value = 16;
            break;
    }
    
    [instance.extended setValue:[NSNumber numberWithInt:value] forKey:@"vr.distortion.quality"];
}

@end
