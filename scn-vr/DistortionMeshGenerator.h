//
//  DistortionMeshGenerator.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "VBOWrap.h"
#import "EyeTexture.h"
#import "ProfileInstance.h"

@interface DistortionMeshGenerator : NSObject

+(VBOWrap *) generateMeshFor:(ProfileInstance *) pair eye:(EyeTextureSide) eye;

@end
