//
//  MobileDeviceConfiguration.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "MobileDeviceConfiguration.h"
#import "Constants.h"

@implementation MobileDeviceConfiguration

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet
{
    self = [super init];
    if (self) {
        self.name = name;
        _identifier = identifier;
        self.widthPx = widthPx;
        self.heightPx = heightPx;
        
        self.physicalWidthPx = widthPx;
        self.physicalHeightPx = heightPx;
        
        self.dpi = dpi;
        self.physicalDpi = dpi;
        
        self.tablet = tablet;
        self.internal = NO;
    }
    return self;
}

-(void) ready {
    // Calculate inches
    _widthIN = self.physicalWidthPx / self.dpi;
    _heightIN = self.physicalHeightPx / self.dpi;
    
    // Calculate milimeters
    _widthMM = _widthIN * IN_2_MM;
    _heightMM = _heightIN * IN_2_MM;
}

@end
