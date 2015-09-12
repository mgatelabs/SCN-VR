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

#import "SCNEye.h"

@implementation SCNEye

- (instancetype)initAs:(EyeTexture *) dest pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context
{
    self = [super init];
    if (self) {
        _dest = dest;
        
        if (_dest.side != EyeTextureSideMono) {
            float eyeDistance = ((pair.cameraIPD / 1000.0f) / 2.0f);
            if (_dest.side == EyeTextureSideLeft) {
                eyeDistance *= -1;
            }
            _eyeDistance = eyeDistance;
            // Move eye into place
            self.transform = SCNMatrix4MakeTranslation(_eyeDistance, 0.0, 0.0);
        }
        
        self.hidden = NO;
        
        // Make a new camera
        SCNCamera * camera = [SCNCamera camera];
        camera.xFov = pair.hFov;
        camera.yFov = pair.vFov;
        camera.zNear = 0.01f;
        camera.zFar = 2048.0f;
        
        camera.orthographicScale = 2;
        
        switch (dest.side) {
            case EyeTextureSideLeft: {
                camera.categoryBitMask = 1;
            } break;
            case EyeTextureSideRight: {
                camera.categoryBitMask = 2;
            } break;
            case EyeTextureSideMono: {
                camera.categoryBitMask = 1;
            } break;
        }

        self.camera = camera;
    }
 
    return self;
}

-(void) zeroIPD {
    self.transform = SCNMatrix4Identity;
}

-(void) resetIPD {
    // Move eye into place
    self.transform = SCNMatrix4MakeTranslation(_eyeDistance, 0.0, 0.0);
}

-(void) ortho:(BOOL) value {
    self.camera.usesOrthographicProjection = value;
}

- (void)dealloc
{
    //self.camera = nil;
    _dest = nil;
}

@end
