//
//  ProfileConfiguration.h
//  scn-vr
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileConfiguration : NSObject

@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) int identity;
@property (strong, nonatomic) NSMutableDictionary * values;

@end
