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

#import "SCNViewpoint.h"

@implementation SCNViewpoint

- (instancetype)initAsGhost:(EyeTexture *) left right:(EyeTexture *) right pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context
{
    self = [super init];
    if (self) {
        _leftEyeSource = left;
        _rightEyeSource = right;
        self.hidden = NO;
        
        SCNNode * neck = [SCNNode node];
        [self addChildNode:neck];
        _neck = neck;
        
        switch (pair.viewportCount) {
            case 1: {
                
                SCNEye * leftEye = [[SCNEye alloc] initAs:_leftEyeSource pair:pair scene:scene context:context];
                _leftEye = leftEye;
                leftEye.hidden = NO;
                [_neck addChildNode:_leftEye];
                
                _rightEye = nil;
                
            } break;
            case 2: {
            
                SCNEye * leftEye = [[SCNEye alloc] initAs:_leftEyeSource pair:pair scene:scene context:context];
                _leftEye = leftEye;
                [_neck addChildNode:_leftEye];
                                
                SCNEye * rightEye = [[SCNEye alloc] initAs:_rightEyeSource pair:pair scene:scene context:context];
                _rightEye = rightEye;
                [_neck addChildNode:_rightEye];
                
            } break;
        }
    }
    return self;
}

-(void) zeroIPD {
    _limitedIPD = YES;
    if (_leftEye != nil) {
        [_leftEye zeroIPD];
    }
    if (_rightEye != nil) {
        [_rightEye zeroIPD];
    }
}

-(void) resetIPD {
    _limitedIPD = NO;
    if (_leftEye != nil) {
        [_leftEye resetIPD];
    }
    
    if (_rightEye != nil) {
        [_rightEye resetIPD];
    }
}

-(void) ortho:(BOOL) value {
    if (_leftEye != nil) {
        [_leftEye ortho:value];
    }
    
    if (_rightEye != nil) {
        [_rightEye ortho:value];
    }
}

- (void)dealloc
{
    _leftEyeSource = nil;
    _rightEyeSource = nil;
    _sourceTexture = nil;
    
    if (_leftEye != nil) {
        [_leftEye removeFromParentNode];
        _leftEye = nil;
    }
    
    if (_rightEye != nil) {
        [_rightEye removeFromParentNode];
        _rightEye = nil;
    }
    
    if (_neck != nil) {
        //[_neck removeFromParentNode];
        _neck = nil;
    }
}

@end
