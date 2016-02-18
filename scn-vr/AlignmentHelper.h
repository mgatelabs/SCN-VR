//
//  AlignmentMeshGenerator.h
//  scn-vr
//
//  Created by Michael Fuller on 2/15/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
#import "VBOWrap.h"
#import "ProfileInstance.h"

@interface AlignmentHelper : NSObject

- (instancetype)initWithProfile:(ProfileInstance *) profile;

-(void) shutdown;

-(void) draw;

@end
