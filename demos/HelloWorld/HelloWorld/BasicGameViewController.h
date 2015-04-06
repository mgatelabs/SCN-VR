//
//  BasicGameViewController.h
//  HelloWorld
//
//  Created by Michael Fuller on 4/5/15.
//  Copyright (c) 2015 Demo. All rights reserved.
//

#import "SCNVirtualRealityViewController.h"

@interface BasicGameViewController : SCNVirtualRealityViewController

@property (assign) BOOL requestExit;

-(void) exitLogic;

@end
