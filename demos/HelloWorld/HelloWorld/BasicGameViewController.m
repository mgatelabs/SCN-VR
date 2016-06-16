//
//  BasicGameViewController.m
//  HelloWorld
//
//  Created by Michael Fuller on 4/5/15.
//  Copyright (c) 2015 Demo. All rights reserved.
//

#import "BasicGameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BasicGameViewController ()

@end

@implementation BasicGameViewController



-(SCNScene *) generateScene {
    SCNScene * scene = [SCNScene scene];
    
    SCNNode * world = [SCNNode node];
    
    [scene.rootNode addChildNode:world];
    
    
    SCNText * text = [SCNText textWithString:@"Hello World" extrusionDepth:1];
    SCNNode * textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-20, 20, 0);
    textNode.categoryBitMask = 3;
    text.alignmentMode = kCAAlignmentCenter;
    text.firstMaterial.diffuse.contents = [UIColor redColor];
    
    GLKQuaternion textOrientation = GLKQuaternionMakeWithAngleAndAxis(1.57079633f, 1, 0, 0);
    textNode.orientation = SCNVector4Make(textOrientation.x, textOrientation.y, textOrientation.z, textOrientation.w);
    
    [world addChildNode:textNode];
    
    /*
    SCNNode * globalRotation = [SCNNode node];
    SCNMatrix4 fix1 = SCNMatrix4MakeRotation(M_PI_2, 1, 0, 0);
    SCNMatrix4 fix2 = SCNMatrix4MakeRotation(M_PI, 0, 0, 1);
    globalRotation.transform = SCNMatrix4Mult(fix1, fix2);
    [world addChildNode:globalRotation];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"mov_bbb_sample" ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AVPlayerItem* playerItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer* player = [AVPlayer playerWithPlayerItem:playerItem];
    SKVideoNode* playerNode = [[SKVideoNode alloc] initWithAVPlayer:player];
    
    playerNode.position = CGPointMake(2500 * 0.5, 2500 * 0.5);
    playerNode.size = CGSizeMake(2500, 2500);
    
    SKScene* spriteScene = [[SKScene alloc] initWithSize:playerNode.size];
    spriteScene.scaleMode = SKSceneScaleModeAspectFit;
    [spriteScene addChild:playerNode];
    
    SCNNode* videoNode = [SCNNode new];
    videoNode.categoryBitMask = 3;
    videoNode.geometry = [SCNSphere sphereWithRadius:30];
    videoNode.geometry.firstMaterial.diffuse.contents = spriteScene;
    videoNode.geometry.firstMaterial.doubleSided = TRUE;
    
    SCNMatrix4 matrix = SCNMatrix4MakeRotation(M_PI, 0.0, 0.0, 1.0);
    matrix = SCNMatrix4Translate(matrix, 1.0, 1.0, 0.0);
    videoNode.pivot = SCNMatrix4MakeRotation(M_PI_2, 0.0, -1.0, 0.0);
    videoNode.geometry.firstMaterial.diffuse.contentsTransform = matrix;
    videoNode.position = SCNVector3Make(0, 0, 0);
    [player play];
     
    [globalRotation addChildNode:videoNode];
    */
    
    
    
    
    return scene;
}

-(void) afterGenerateScene {
    SCNViewpoint * viewpoint = [self generateGhostViewpoint];
    [self.scene.rootNode addChildNode:viewpoint];
    
    [self setViewpointTo:viewpoint];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    if (_requestExit) {
        [self exitLogic];
    }
}


-(void) exitLogic {
    [self setPaused:true];
    [self performSegueWithIdentifier:@"exitToHome" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] < 1) return;
    
    if ([touches count] >= 3) {
        _requestExit = YES;
    }
    
    CGPoint point = [[touches anyObject] locationInView:[self view]];
    
    float adjustedX = point.x * self.nativeScale;
    float adjustedY = (self.profile.landscapeView ? self.profile.physicalHeightPX : self.profile.physicalWidthPX) - (point.y * self.nativeScale);
    
    BOOL resetView = NO;
    
    if (self.profile.basicView == YES) {
        
        BOOL inVirtualView = (adjustedX > self.profile.virtualOffsetLeft && adjustedX < self.profile.virtualOffsetLeft + self.profile.virtualWidthPX) && (adjustedY > self.profile.virtualOffsetBottom && adjustedY < self.profile.virtualOffsetBottom + self.profile.virtualHeightPX);
        
        if (self.profile.viewportCount == 1) {
            
            if (inVirtualView) {
                //forcedTapX = adjustedX - self.profile.virtualOffsetLeft;
                //forcedTayY = adjustedY - self.profile.virtualOffsetBottom;
            } else {
                resetView = YES;
            }
            
        } else {
            
            if (inVirtualView) {
                
                BOOL inLeftEye = (adjustedX > self.profile.virtualOffsetLeft && adjustedX < self.profile.virtualOffsetLeft + (self.profile.virtualWidthPX / 2)) && (adjustedY > self.profile.virtualOffsetBottom && adjustedY < self.profile.virtualOffsetBottom + self.profile.virtualHeightPX);
                if (inLeftEye) {
                    // Tap
                    //forcedTapX = adjustedX - self.profile.virtualOffsetLeft;
                    //forcedTayY = adjustedY - self.profile.virtualOffsetBottom;
                } else {
                    resetView = YES;
                }
                
            } else {
                resetView = YES;
            }
        }
    } else {
        resetView = YES;
    }
    
    if (resetView) {
        [self.profile.tracker calibrate];
    }
}

@end
