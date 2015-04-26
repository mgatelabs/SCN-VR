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

#import "IpdValueWizarditem.h"

@implementation IpdValueWizarditem {
    IpdWizardItem * ipds;
    bool second;
}

- (instancetype)initWith:(IpdWizardItem *) ipdWizardItem second:(BOOL) secondItem
{
    self = [super initWith:secondItem ? @"Camera IPD" : @"Your IPD" info:@"Distance in MM" itemId: secondItem ? WIZARD_ITEM_IPD_VALUE2 : WIZARD_ITEM_IPD_VALUE1 type:WizardItemDataTypeInt];
    if (self) {
        second = secondItem;
        ipds = ipdWizardItem;
        self.count = 75 * 2;
        self.valueIndex = 62 * 2;
        self.valueId = @"62";
    }
    return self;
}

-(BOOL) available {
    return ipds.valueIndex == 2;
}

-(BOOL) ready {
    return ipds.valueIndex == 2;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.1f MM", index / 2.0f];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    if (second) {
        instance.cameraIPD = self.valueIndex / 2.0f;
    } else {
        instance.viewerIPD = self.valueIndex / 2.0f;
    }
}

@end
