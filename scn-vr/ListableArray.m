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

#import "ListableArray.h"

@implementation ListableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"Unknown";
}

-(NSString *) getListItemNameFor:(int) index {
    return @"Unknown";
}

-(int) getListItemCount {
    return 0;
}

-(int) getSelectedItemIndex {
    return 0;
}

-(void) selectListItemAt:(int) index {
    
}

@end
