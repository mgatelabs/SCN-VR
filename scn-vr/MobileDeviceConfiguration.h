//
//  MobileDeviceConfiguration.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileDeviceConfiguration : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * virtualName;
@property (readonly, strong, nonatomic) NSString * identifier;

@property (assign, nonatomic) BOOL tablet;
@property (assign, nonatomic) BOOL internal;
@property (assign, nonatomic) BOOL custom;

@property (assign) int widthPoint;
@property (assign) int heightPoint;
@property (assign) float minNativeScale;
@property (assign) float maxNativeScale;
@property (assign) float forcedScale;
@property (assign) BOOL zoomed;

@property (assign) int widthPx;
@property (assign) int heightPx;

@property (assign) int physicalWidthPx;
@property (assign) int physicalHeightPx;

@property (assign) float dpi;
@property (assign) float physicalDpi;

@property (readonly, assign) float widthIN;
@property (readonly, assign) float heightIN;

@property (readonly, assign) float widthMM;
@property (readonly, assign) float heightMM;

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet;

- (instancetype)initAsCustom:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx tablet:(BOOL) tablet;

-(void) ready;

@end
