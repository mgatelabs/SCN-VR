//
//  HmdMobileDevicePair.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "HmdMobileDevicePair.h"
#import "Constants.h"

@implementation HmdMobileDevicePair

- (instancetype)initWith:(HmdDeviceConfiguration *) hmd mobile:(MobileDeviceConfiguration *) mobile virtualDevice:(VirtualDeviceConfiguration *) virtualDevice
{
    self = [super init];
    if (self) {
        _hmd = hmd;
        _mobile = mobile;
        _virtualDevice = virtualDevice;
        
        switch (_virtualDevice.type) {
            case VirtualDeviceConfigurationTypeLandscape:
                _landscape = YES;
                
                _widthPx = _mobile.physicalWidthPx;
                _heightPx = _mobile.physicalHeightPx;
                
                _widthIN = _mobile.widthIN;
                _heightIN = _mobile.heightIN;
                
                _widthMM = _mobile.widthMM;
                _heightMM = _mobile.heightMM;
                
                _offsetPx = 0;
                _offsetPy = 0;
                
                break;
            case VirtualDeviceConfigurationTypeLandscape169:
                _landscape = YES;
                
                _widthPx = _mobile.physicalWidthPx;
                _heightPx = (_widthPx * 9) / 16;
                
                _offsetPx = 0;
                _offsetPy = (mobile.physicalHeightPx - _heightPx) / 2;
                
                _widthIN = _widthPx / _mobile.dpi;
                _heightIN = _heightPx / _mobile.dpi;
                
                // Calculate milimeters
                _widthMM = _widthIN * IN_2_MM;
                _heightMM = _heightIN * IN_2_MM;
                
                break;
            case VirtualDeviceConfigurationTypePortrait:
                _landscape = NO;
                
                _widthPx = _mobile.physicalHeightPx;
                _heightPx = _mobile.physicalWidthPx;
                
                _widthIN = _mobile.heightIN;
                _heightIN = _mobile.widthIN;
                
                _widthMM = _mobile.heightMM;
                _heightMM = _mobile.widthMM;
                
                _offsetPx = 0;
                _offsetPy = 0;
                
                break;
            case VirtualDeviceConfigurationTypePortrait169:
                _landscape = NO;
                
                _widthPx = _mobile.physicalHeightPx;
                _heightPx = (_widthPx * 9) / 16;
                
                _offsetPx = 0;
                _offsetPy = (mobile.physicalWidthPx - _heightPx) / 2;
                
                _widthIN = _widthPx / _mobile.dpi;
                _heightIN = _heightPx / _mobile.dpi;
                
                // Calculate milimeters
                _widthMM = _widthIN * IN_2_MM;
                _heightMM = _heightIN * IN_2_MM;
                
                break;
            case VirtualDeviceConfigurationTypeLandscapeVirtual: {
                _landscape = YES;
                
                // Need to go from MM to MM
                
                float targetWidthMM = _virtualDevice.virtualDevice.widthMM;
                float targetHeightMM = _virtualDevice.virtualDevice.heightMM;
                
                // GO from MM to Inches
                float targetWidthIN = targetWidthMM / IN_2_MM;
                float targetHeightIN = targetHeightMM / IN_2_MM;
                
                _widthPx = targetWidthIN * _mobile.dpi;
                _heightPx = targetHeightIN * _mobile.dpi;
                
                _widthIN = _widthPx / _mobile.dpi;
                _heightIN = _heightPx / _mobile.dpi;
                
                // Calculate milimeters
                _widthMM = _widthIN * IN_2_MM;
                _heightMM = _heightIN * IN_2_MM;
                
                _offsetPx = (_mobile.widthPx - _widthPx) / 2;
                _offsetPy = (_mobile.heightPx - _heightPx) / 2;
                
            } break;
            case VirtualDeviceConfigurationTypePortraitVirtual: {
                _landscape = NO;
                
                
                float targetWidthMM = _virtualDevice.virtualDevice.widthMM;
                float targetHeightMM = _virtualDevice.virtualDevice.heightMM;
                
                // GO from MM to Inches
                float targetWidthIN = targetWidthMM / IN_2_MM;
                float targetHeightIN = targetHeightMM / IN_2_MM;
                
                _widthPx = targetWidthIN * _mobile.dpi;
                _heightPx = targetHeightIN * _mobile.dpi;
                
                _widthIN = _widthPx / _mobile.dpi;
                _heightIN = _heightPx / _mobile.dpi;
                
                // Calculate milimeters
                _widthMM = _widthIN * IN_2_MM;
                _heightMM = _heightIN * IN_2_MM;
                
                _offsetPx = (_mobile.heightPx / 2) - (_widthPx / 2);
                _offsetPy = (_mobile.widthPx/ 2) - (_heightPx / 2);
                
            } break;
        }
        
    }
    return self;
}

@end
