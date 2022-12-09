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

#import "MobileDeviceManager.h"
#import "SCNVRResourceBundler.h"

@implementation MobileDeviceManager

+ (id)sharedManager {
    static MobileDeviceManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _devices = [[NSMutableArray alloc] initWithCapacity:10];
        
        [_devices addObjectsFromArray:[MobileDeviceManager getDevices]];
        
        UIScreen * screen = [UIScreen mainScreen];
        
        // Use this to trim bad devices
        int width = screen.bounds.size.width * screen.nativeScale;
        int height = screen.bounds.size.height * screen.nativeScale;
        
        // Get ride of devices that don't match our current screen setup
        [self trimDevicesForCurrentDeviceWidth:width heightPx:height widthPoint:screen.bounds.size.width heightPoint:screen.bounds.size.height nativeScale:screen.nativeScale tablet:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)];
    }
    return self;
}

#define MIN_2X 1.99
#define MAX_2X 2.01

#define MIN_3X 2.99
#define MAX_3X 3.01

+(NSMutableArray *) getDevices {
    
    NSMutableArray * tempList = [[NSMutableArray alloc] initWithCapacity:10];
    
    MobileDeviceConfiguration * tempConfig;
    
    // iPhone4S              640×960   326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_4S", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 4S") identifier:@"iphone4s" widthPx:960 heightPx:640 dpi:326 tablet:NO];
    tempConfig.widthPoint = 480;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = MIN_2X;
    tempConfig.maxNativeScale = MAX_2X;
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_3.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"3.5\"");
    [tempList addObject:tempConfig];
    
    // iPhone5               640×1136  326 ppi
    // iPhone5C              640×1136  326 ppi
    // iPhone5S              640×1136  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_5", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 5") identifier:@"iphone5" widthPx:1136 heightPx:640 dpi:326 tablet:NO];
    tempConfig.widthPoint = 568;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = MIN_2X;
    tempConfig.maxNativeScale = MAX_2X;
    tempConfig.virtualName = @"4\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4\"");
    [tempList addObject:tempConfig];
    
    ////////////////////////
    
    // iPhone6 (Zoomed)       750×1334  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6Z", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6 (Zoomed)") identifier:@"iphone6zoomed" widthPx:1331 heightPx:750 dpi:326 tablet:NO];
    tempConfig.virtualName = @"4.7\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4.7\"");
    tempConfig.widthPoint = 568;
    tempConfig.heightPoint = 320;
    tempConfig.minNativeScale = 2.21; // It will be bigger then 2
    tempConfig.maxNativeScale = 2.41;
    tempConfig.zoomed = YES;
    [tempList addObject:tempConfig];
    
    // iPhone6               750×1334  326 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6") identifier:@"iphone6" widthPx:1334 heightPx:750 dpi:326 tablet:NO];
    //tempConfig.virtualName = @"4.7\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4.7\"");
    tempConfig.widthPoint = 667;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = MIN_2X;
    tempConfig.maxNativeScale = MAX_2X;
    [tempList addObject:tempConfig];
    
    ////////////////////////
    
    // iPhone6Plus           1080×1920 401 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6Plus", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6+ (Zoomed)") identifier:@"iphone6pluszoomed" widthPx:1920 heightPx:1080 dpi:401 tablet:NO];
    //tempConfig.virtualName = @"5.5\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.5\"");
    tempConfig.widthPoint = 667;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = 2.75f; // 2.88
    tempConfig.maxNativeScale = 2.91f;
    tempConfig.zoomed = YES;
    [tempList addObject: tempConfig];
    
    // iPhone6Plus           1080×1920 401 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_6PlusZ", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 6+") identifier:@"iphone6plus" widthPx:1920 heightPx:1080 dpi:401 tablet:NO];
    tempConfig.virtualName = @"5.5\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.5\"");
    [tempList addObject: tempConfig];
    tempConfig.widthPoint = 736;
    tempConfig.heightPoint = 414;
    tempConfig.minNativeScale = 2.5; // 2.608
    tempConfig.maxNativeScale = 2.7;
    #if (TARGET_IPHONE_SIMULATOR)
    tempConfig.widthPx = 2208;
    tempConfig.heightPx = 1242;
    //tempConfig.physicalWidthPx = 2208;
    //tempConfig.physicalHeightPx = 1242;
    tempConfig.minNativeScale = MIN_3X;
    tempConfig.maxNativeScale = MAX_3X;
    tempConfig.forcedScale = 3.0f;
    #endif
    
    ////////////////////////
    
    // iPhone X           1125×2436 458 ppi
    // iPhone 11, 5.8", 1125 x 2436 PX @ 458 ppi, 3x, 375 x 812
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_X", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone X") identifier:@"iphonex" widthPx:2436 heightPx:1125 dpi:458 tablet:NO];
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.8INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.8\"");
    tempConfig.widthPoint = 812;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = MIN_3X;
    tempConfig.maxNativeScale = MAX_3X;
    tempConfig.zoomed = YES;
    [tempList addObject: tempConfig];
    
    // iPhone Xr           828 × 1792 326 ppi
    // iPhone 11, 6.1", 828 x 1792 PX @ 326 ppi, 2x, 414 x 896
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_Xr", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone Xr") identifier:@"iphonexr" widthPx:1792 heightPx:828 dpi:326 tablet:NO];
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.1INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.1\"");
    tempConfig.widthPoint = 896;
    tempConfig.heightPoint = 414;
    tempConfig.minNativeScale = MIN_2X;
    tempConfig.maxNativeScale = MAX_2X;
    tempConfig.zoomed = NO;
    [tempList addObject: tempConfig];
    
    // iPhone 11 Zoomed 812×1792 323 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_11z", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 11 Zoomed") identifier:@"iphone11z" widthPx:1792 heightPx:828 dpi:323 tablet:NO];
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.1INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.1\"");
    tempConfig.widthPoint = 812;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = 2.15f;
    tempConfig.maxNativeScale = 2.3f;
    tempConfig.zoomed = YES;
    [tempList addObject: tempConfig];
    
    // iPhone 11 Pro Max, 6.5" (414 x 896 points @3x)
    // iPhone XS Max, 6.5", 1242×2688 @ 458 ppi (414 x 896 points @3x)
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_XsMax", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone XsMax") identifier:@"iphonexsmax" widthPx:2688 heightPx:1242 dpi:458 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.5\"");
        tempConfig.widthPoint = 896;
        tempConfig.heightPoint = 414;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    // Phone XS Max Zoomed
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_XsMaxZo", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone XsMax Zoomed") identifier:@"iphonexsmaxzo" widthPx:2688 heightPx:1242 dpi:458 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.5INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.5\"");
        tempConfig.widthPoint = 812;
        tempConfig.heightPoint = 375;
        tempConfig.minNativeScale = 3.300f;
        tempConfig.maxNativeScale = 3.320f;
        tempConfig.zoomed = YES;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 12
    // iPhone 12 Pro         1170×2532 @ 460 ppi
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_12Pro", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 12Pro") identifier:@"iphone12pro" widthPx:2532 heightPx:1170 dpi:460 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.1INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.1\"");
        tempConfig.widthPoint = 844;
        tempConfig.heightPoint = 390;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 12 Mini,  5.4", 1080 x 2340 (476 ppi), 3x, 375 x 812
    
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_12MINI", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 12 Mini") identifier:@"iphone12mini" widthPx:2340 heightPx:1080 dpi:476 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.4INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.4\"");
        tempConfig.widthPoint = 780;
        tempConfig.heightPoint = 360;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 12 Mini (Zoomed),  5.4", 1080 x 2340 (476 ppi), 3.375x, 320 x 693
    
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_12MINIZO", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 12 Mini (Zoomed)") identifier:@"iphone12minizo" widthPx:2340 heightPx:1080 dpi:476 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.4INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.4\"");
        tempConfig.widthPoint = 693;
        tempConfig.heightPoint = 320;
        tempConfig.minNativeScale = 3.3600;
        tempConfig.maxNativeScale = 3.3800;
        tempConfig.zoomed = YES;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 12 Pro Max           1284×2778 @ 458 ppi
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_12Max", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 12 Max") identifier:@"iphone12max" widthPx:2778 heightPx:1284 dpi:458 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.7\"");
        tempConfig.widthPoint = 926;
        tempConfig.heightPoint = 428;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    
    // iPhone SE 2020
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_SE2020", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone SE (2020)") identifier:@"iphoneSE20" widthPx:1334 heightPx:750 dpi:326 tablet:NO];
    //tempConfig.virtualName = @"5.8\"";
    tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_4.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"4.7\"");
    tempConfig.widthPoint = 667;
    tempConfig.heightPoint = 375;
    tempConfig.minNativeScale = MIN_2X;
    tempConfig.maxNativeScale = MAX_2X;
    tempConfig.zoomed = NO;
    [tempList addObject: tempConfig];
    
    // iPhone 13,       6.1", 1170 x 2532 (460 ppi), 3x, 390 x 844
    // iPhone 13 Pro,   6.1", 1170 x 2532 (460 ppi), 3x, 390 x 844
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_13", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 13") identifier:@"iphone13" widthPx:2532 heightPx:1170 dpi:460 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.1INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.1\"");
        tempConfig.widthPoint = 844;
        tempConfig.heightPoint = 390;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 13 Mini,  5.4", 1080 x 2340 (476 ppi), 2.88x, 375 x 812
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_13MINI", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 13 Mini") identifier:@"iphone13mini" widthPx:2340 heightPx:1080 dpi:476 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_5.4INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"5.4\"");
        tempConfig.widthPoint = 812;
        tempConfig.heightPoint = 375;
        tempConfig.minNativeScale = 2.87f;
        tempConfig.maxNativeScale = 2.89f;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }

    // iPhone 13 Pro Max, 6.7", 1284 x 2778 (458 ppi), 3x, 428 x 926
    // Iphone 12 Pro Max, 6.7" (428 x 926 points @3x)
    
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_13PROMAX", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 13 Pro Max") identifier:@"iphone13promax" widthPx:2778 heightPx:1284 dpi:458 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.7INCH", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.7\"");
        tempConfig.widthPoint = 926;
        tempConfig.heightPoint = 428;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = NO;
        [tempList addObject: tempConfig];
    }
    
    // iPhone 14 Pro Max (Zoomed), 6.7", 1290 x 2796 (458 ppi), 3x, 430 x 932
    
    {
        tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPHONE_14MAXZO", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPhone 14 Max (Zoomed)") identifier:@"iphone14promaxzo" widthPx:2796 heightPx:1290 dpi:458 tablet:NO];
        tempConfig.virtualName = NSLocalizedStringFromTableInBundle(@"SIZE_6.7INCHZO", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"6.7 (Zoomed)\"");
        tempConfig.widthPoint = 932;
        tempConfig.heightPoint = 430;
        tempConfig.minNativeScale = MIN_3X;
        tempConfig.maxNativeScale = MAX_3X;
        tempConfig.zoomed = YES;
        [tempList addObject: tempConfig];
    }
    
    ///---------------------------------
    /// iPads
    /// -------------------------------
    
    //iPad2                 1024x768  132 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_9.7", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 9.7\"") identifier:@"ipad2" widthPx:1024 heightPx:768 dpi:132 tablet:YES];
    [tempList addObject:tempConfig];
    
    //iPad (3gen)           2048x1536 264 ppi
    //iPad (4gen)           2048x1536 264 ppi
    //iPad Air              2048x1536 264 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_9.7_RETINA", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 9.7\" (Retina)") identifier:@"ipad" widthPx:2048 heightPx:1536 dpi:264 tablet:YES];
    [tempList addObject:tempConfig];
    
    //iPad mini             1024x768  163 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_7.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 7.9\"") identifier:@"ipadmini" widthPx:1024 heightPx:768 dpi:163 tablet:YES];
    [tempList addObject: tempConfig];
    
    // iPad Mini (retina)    2048x1536 326 ppi
    // iPad Mini 7.9" (2019), 1536 x 2048, 2X, 768 x 1024
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_7.9_RETINA", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 7.9\" (Retina)") identifier:@"ipadmini2" widthPx:2048 heightPx:1536 dpi:324 tablet:YES];
    [tempList addObject: tempConfig];
    
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_10.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 10.2\"") identifier:@"ipad102" widthPx:2160 heightPx:1640 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_10.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 10.5\"") identifier:@"ipadair105" widthPx:2224 heightPx:1668 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_10.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 10.9\"") identifier:@"ipadair109" widthPx:2360 heightPx:1640 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_11.0", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 11.0\"") identifier:@"ipadpro110" widthPx:2388 heightPx:1668 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    //iPad Pro (retina)    2732x2048 264 ppi
    tempConfig = [MobileDeviceManager createDevice: NSLocalizedStringFromTableInBundle(@"IOS_IPAD_12.9", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"iPad 12.9\" (Retina)") identifier:@"ipadpro" widthPx:2732 heightPx:2048 dpi:264 tablet:YES];
    [tempList addObject: tempConfig];
    
    for (int i = 0; i < tempList.count; i++) {
        MobileDeviceConfiguration * c = [tempList objectAtIndex:i];
        c.internal = YES;
        [c ready];
    }
    
    return tempList;
}

-(void) trimDevicesForCurrentDeviceWidth:(int) widthPx heightPx:(int) heightPx widthPoint:(int) widthPoint heightPoint:(int) heightPoint nativeScale:(float) nativeScale tablet:(BOOL) tablet {
    
    if (widthPx < heightPx) {
        int temp =widthPx;
        widthPx = heightPx;
        heightPx = temp;
        temp = widthPoint;
        widthPoint = heightPoint;
        heightPoint = temp;
    }
    
    for (int i = (int)_devices.count - 1; i >= 0; i--) {
        
        BOOL removeDevice = NO;
        
        MobileDeviceConfiguration * test = [_devices objectAtIndex:i];
        // Different screen sizes or types will lead to it being discarded
        if (test.tablet != tablet) {
            removeDevice = YES;
        } else {
            
            if (test.tablet) {
                if (test.widthPx == widthPx && test.heightPx == heightPx) {
                    continue;
                } else if (test.widthPx == heightPx && test.heightPx == widthPx) {
                    continue;
                } else {
                    removeDevice = YES;
                }
            } else {
                if (nativeScale >= test.minNativeScale && nativeScale <= test.maxNativeScale) {
                    
                    if (test.widthPoint == widthPoint && test.heightPoint == heightPoint) {
                        continue;
                    } else if (test.widthPoint == heightPoint && test.heightPoint == widthPoint) {
                        continue;
                    } else {
                        removeDevice = YES;
                    }
                    
                } else {
                    removeDevice = YES;
                }
            }
        }
        if (removeDevice) {
            [_devices removeObjectAtIndex:i];
        }
    }
    
    // If we can't find a device, make up a custom device, ow man
    if (_devices.count == 0) {
        
        MobileDeviceConfiguration * tempDevice = [[MobileDeviceConfiguration alloc] initAsCustom:@"Custom" identifier:@"custom" widthPx:widthPx heightPx:heightPx tablet:tablet];
        tempDevice.forcedScale = nativeScale;
        
        [_devices addObject:tempDevice];
    }
    
    _device = [_devices objectAtIndex:0];
}

+(MobileDeviceConfiguration *) createDevice:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi  tablet:(BOOL) tablet {
    
    MobileDeviceConfiguration * device = [[MobileDeviceConfiguration alloc] initAs:name identifier:identifier widthPx:widthPx heightPx:heightPx dpi:dpi tablet:tablet];
    
    return device;
}

-(BOOL) removeDeviceWithIndex:(int) index {
    if (index >= 0 && index < _devices.count) {
        MobileDeviceConfiguration * device = [_devices objectAtIndex:index];
        if (device.internal) {
            return NO;
        }
        [_devices removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

-(void) cycle {
    int nextIndex = [self getIndexFor:_device];
    nextIndex = (nextIndex + 1) % self.devices.count;
    _device = [self.devices objectAtIndex:nextIndex];
}

-(int) getIndexFor:(MobileDeviceConfiguration *) mobileConfiguration {
    for (int i = 0; i < self.devices.count; i++) {
        MobileDeviceConfiguration * temp = [self.devices objectAtIndex:i];
        if (temp == mobileConfiguration) {
            return i;
        }
    }
    return 0;
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"Device";
}

-(NSString *) getListItemNameFor:(int) index {
    MobileDeviceConfiguration * d = [_devices objectAtIndex:index];
    return d.name;
}

-(int) getListItemCount {
    return (int)_devices.count;
}

-(int) getSelectedItemIndex {
    
    if (_device == nil) {
        return - 1;
    }
    
    for (int i = 0; i < _devices.count; i++) {
        MobileDeviceConfiguration * d = [_devices objectAtIndex:i];
        if (d == _device) {
            return i;
        }
    }
    
    NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _device = [_devices objectAtIndex:index];
}


-(void) ready {
    for (int i = 0; i < _devices.count; i++) {
        MobileDeviceConfiguration * m = [_devices objectAtIndex:i];
        [m ready];
    }
}

@end
