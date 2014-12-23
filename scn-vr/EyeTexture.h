//
//  EyeTexture.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderTexture.h"

typedef NS_ENUM(NSInteger, EyeTextureSide) {
    EyeTextureSideLeft = 0,
    EyeTextureSideRight = 1,
    EyeTextureSideMono = 2
};

@interface EyeTexture : NSObject

@property (assign, readonly) EyeTextureSide side;

@property (assign, readonly) int x;
@property (assign, readonly) int y;
@property (assign, readonly) int w;
@property (assign, readonly) int h;

@property (weak, nonatomic) RenderTexture * dest;

- (instancetype)initAs:(EyeTextureSide) side dest:(RenderTexture *) dest;

-(void) bind;

-(void) view;

@end
