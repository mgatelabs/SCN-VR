//
//  MobileDeviceManager.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MobileDeviceConfiguration.h"
#import "ListableArray.h"

@interface MobileDeviceManager : ListableArray

@property (weak, readonly, nonatomic) MobileDeviceConfiguration * device;

@property (strong, readonly, nonatomic) NSMutableArray * devices;

- (instancetype)init;

+ (id)sharedManager;

-(void) trimDevicesForCurrentDeviceWidth:(int) widthPx heightPx:(int) heightPx widthPoint:(int) widthPoint heightPoint:(int) heightPoint nativeScale:(float) nativeScale tablet:(BOOL) tablet;

+(MobileDeviceConfiguration *) createDevice:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet;

-(BOOL) removeDeviceWithIndex:(int) index;

-(void) cycle;

-(int) getIndexFor:(MobileDeviceConfiguration *) mobileConfiguration;

-(void) ready;

+(NSMutableArray *) getDevices;

@end
