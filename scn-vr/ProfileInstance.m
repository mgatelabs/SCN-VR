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

#import "ProfileInstance.h"

@implementation ProfileInstance

- (instancetype)init
{
    self = [super init];
    if (self) {
        _extended = [[NSMutableDictionary alloc] initWithCapacity:10];
        _ssMode = ProfileInstanceSS1X;
        _meshQuality = 16;
    }
    return self;
}

-(int) getExtendedValueFor:(NSString *) key withDefaultInt:(int) value {
    NSNumber * current = [_extended valueForKey:key];
    if (current == nil) {
        NSLog(@"No value for key: %@", key);
        return value;
    }
    return [current intValue];
}

-(float) getExtendedValueFor:(NSString *) key withDefaultFloat:(float) value {
    NSNumber * current = [_extended valueForKey:key];
    if (current == nil) {
        NSLog(@"No value for key: %@", key);
        return value;
    }
    return [current floatValue];
}

-(NSString *) getExtendedValueFor:(NSString *) key withDefaultNSString:(NSString *) value {
    NSString * current = [_extended valueForKey:key];
    if (current == nil) {
        NSLog(@"No value for key: %@", key);
        return value;
    }
    return current;
}

-(void) setExtendedValueFor:(NSString *) key withInt:(int) value {
    [_extended setObject:[NSNumber numberWithInt:value] forKey:key];
}

-(void) setExtendedValueFor:(NSString *) key withFloat:(float) value {
    [_extended setObject:[NSNumber numberWithFloat:value] forKey:key];
}

-(void) setExtendedValueFor:(NSString *) key withNSString:(NSString *) value {
    [_extended setObject:value forKey:key];
}

- (void)dealloc {
    _extended = nil;
}

-(void) calculateIpdAdjustment {
    if (self.centerIPD) {
        _leftIpdAdjustment = 0;
        _rightIpdAdjustment = 0;
    } else {
        float halfDeviceWidth = self.virtualWidthMM / 2.0f;
        float halfIPDWidth = self.viewerIPD / 2.0f;
        
        float origOffsetOffsetX = (halfIPDWidth / halfDeviceWidth);
        
        // Flip the Space
        float leftOffsetX = 1.0f - origOffsetOffsetX;
        leftOffsetX *= 2.0f;
        leftOffsetX -= 1.0f;
        _leftIpdAdjustment = leftOffsetX;
        
        float rightOffsetX = origOffsetOffsetX;
        rightOffsetX *= 2.0f;
        rightOffsetX -= 1.0f;
        _rightIpdAdjustment = rightOffsetX;
    }
}

@end
