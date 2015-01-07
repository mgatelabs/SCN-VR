//
//  TrackerBase.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TrackerBase : NSObject

@property (readonly, strong, nonatomic) NSString * name;
@property (readonly, strong, nonatomic) NSString * identity;

@property (assign, nonatomic) GLKQuaternion orientation;

@property (assign, nonatomic) BOOL landscape;

- (instancetype)initWith:(NSString *) name identity:(NSString *) identity;

-(void) start;

-(void) stop;

-(void) calibrate;

-(void) capture;

@end
