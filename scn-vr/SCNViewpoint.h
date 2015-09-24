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

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import "SCNEye.h"
#import "RenderTexture.h"
#import "EyeTexture.h"
#import "RenderBase.h"
#import "ProfileInstance.h"

@interface SCNViewpoint : SCNNode

@property (readonly, nonatomic, weak) SCNNode * neck;

@property (readonly, nonatomic, weak) SCNEye * leftEye;

@property (readonly, nonatomic, weak) SCNEye * rightEye;

@property (weak, readonly, nonatomic) RenderTexture * sourceTexture;
@property (weak, readonly, nonatomic) EyeTexture * leftEyeSource;
@property (weak, readonly, nonatomic) EyeTexture * rightEyeSource;

@property (assign, nonatomic, readonly) BOOL limitedIPD;

- (instancetype)initAsGhost:(EyeTexture *) left right:(EyeTexture *) right pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context;

-(void) zeroIPD;
-(void) resetIPD;
-(void) ortho:(BOOL) value;

@end
