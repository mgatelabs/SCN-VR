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

@implementation WizardItem

- (instancetype)initWith:(NSString *) title info:(NSString *) info itemId:(int) itemId type:(WizardItemDataType)type
{
    self = [super init];
    if (self) {
        _title = title;
        _info = info;
        _count = 0;
        _itemId = itemId;
        _type = type;
        _sectionIndex = 0;
    }
    return self;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionCascade;
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionBreak;
}

-(void) chainUpdated {
    
}

-(void) reset {
    
}

-(BOOL) endpoint {
    return false;
}

-(BOOL) ready {
    return false;
}

-(BOOL) available {
    return false;
}

-(void) loadForInt:(int) value {
    
}

-(void) loadForIdentity:(NSString *) identity {
    
}

-(int) prepValueToSave {
    return self.valueIndex;
}

-(NSString *) stringForIndex:(int) index {
    return @"";
}

-(void) selectedIndex:(int) index {
    
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
}

@end
