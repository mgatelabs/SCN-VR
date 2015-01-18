//
//  ProfileManager.h
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WizardManager.h"

@interface ProfileManager : NSObject

@property (strong, nonatomic, readonly) NSString * profileFilePath;

@property (strong, nonatomic, readonly) NSMutableArray * profiles;
@property (assign, nonatomic, readonly) int index;

@property (assign, nonatomic, readonly) int count;

+ (id)sharedManager;

-(NSString *) nameForIndex:(int) index;

-(void) selectIndex:(int) index;

-(void) deleteIndex:(int) index;

-(int) newProfile;

-(void) load;

-(void) persist;

-(void) reset;

-(WizardManager *) wizardManager;

-(ProfileInstance *) getCurrentProfileInstance;

@end
