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
@property (readonly, strong, nonatomic) NSString * identifier;

@property (assign, nonatomic) BOOL tablet;
@property (assign, nonatomic) BOOL internal;

@property (assign) int widthPx;
@property (assign) int heightPx;
@property (assign) float dpi;

@property (readonly, assign) float widthIN;
@property (readonly, assign) float heightIN;

@property (readonly, assign) float widthMM;
@property (readonly, assign) float heightMM;

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet;

-(void) ready;

@end
