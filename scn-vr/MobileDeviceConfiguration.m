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

#import "MobileDeviceConfiguration.h"
#import "Constants.h"

@implementation MobileDeviceConfiguration

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet
{
    self = [super init];
    if (self) {
        self.name = name;
        _identifier = identifier;
        _custom = NO;
        self.widthPx = widthPx;
        self.heightPx = heightPx;
        
        self.physicalWidthPx = widthPx;
        self.physicalHeightPx = heightPx;
        self.zoomed = NO;
        self.forcedScale = -1;
        
        self.dpi = dpi;
        self.physicalDpi = dpi;
        
        self.tablet = tablet;
        self.internal = NO;
    }
    return self;
}

- (instancetype)initAsCustom:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx tablet:(BOOL) tablet
{
    self = [super init];
    if (self) {
        self.name = name;
        _identifier = identifier;
        _custom = YES;
        self.widthPx = widthPx;
        self.heightPx = heightPx;
        
        self.physicalWidthPx = widthPx;
        self.physicalHeightPx = heightPx;
        
        self.dpi = 1;
        self.physicalDpi = 1;
        
        self.tablet = tablet;
        self.internal = YES;
    }
    return self;
}

-(void) ready {
    
    // Calculate inches
    _widthIN = self.physicalWidthPx / (float)self.dpi;
    _heightIN = self.physicalHeightPx / (float)self.dpi;
    
    // Calculate milimeters
    _widthMM = _widthIN * IN_2_MM;
    _heightMM = _heightIN * IN_2_MM;
}

@end
