//
//  VBOWrap.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

struct Vector3 {
    float x;
    float y;
    float z;
};

struct Vector2 {
    float x;
    float y;
};

struct VertexPoint {
    float x;
    float y;
    float z;
    float ux;
    float uy;
};

@interface VBOWrap : NSObject

- (instancetype)initWith:(struct VertexPoint *) points pointCount:(int) pointCount indexes:(int *) indexes indexCount:(int) indexCount;

-(void) draw;

-(void) checkGlErrorStatus;

@end
