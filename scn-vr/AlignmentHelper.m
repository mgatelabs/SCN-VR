//
//  AlignmentMeshGenerator.m
//  scn-vr
//
//  Created by Michael Fuller on 2/15/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import "AlignmentHelper.h"
#import <GLKit/GLKit.h>

#pragma mark - Utils

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#pragma mark - Vertex Shader

NSString *const alignmentVertexShaderString = SHADER_STRING
(
 precision highp float;
 
 attribute vec4 _glesVertex;
 attribute vec2 _glesMultiTexCoord0;
 varying highp vec2 xlv_TEXCOORD0;
 void main ()
{
    gl_Position = _glesVertex;
    xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}
);

#pragma mark - Fragment Shader

NSString *const alignmentFragmentShaderString = SHADER_STRING
(
 precision highp float;
 uniform highp vec2 _mmSizes;
 varying highp vec2 xlv_TEXCOORD0;
 void main ()
{
    highp vec4 colorPoint;
    
    if (xlv_TEXCOORD0.x > 1.0 - _mmSizes.x) {
        colorPoint.x = 0.6;
        colorPoint.y = 0.6;
        colorPoint.z = 0.6;
        colorPoint.a = 1.0;
    } else {
        if (xlv_TEXCOORD0.y > 0.5 - _mmSizes.y && xlv_TEXCOORD0.y < 0.5 + _mmSizes.y && xlv_TEXCOORD0.x < _mmSizes.x * 2.0) {
            colorPoint.x = 0.6;
            colorPoint.y = 0.6;
            colorPoint.z = 0.6;
            colorPoint.a = 1.0;
        } else {
            colorPoint.x = 0.2;
            colorPoint.y = 0.2;
            colorPoint.z = 0.2;
            colorPoint.a = 1.0;
        }
    }
    
    gl_FragData[0] = colorPoint;
}
);

#pragma mark - Shader Helpers

enum
{
    UNIFORM_MMSIZE = 0
};

#pragma mark - Class

@interface AlignmentHelper () {
    GLuint _program;
    VBOWrap * mesh;
    float verSize;
    float horSize;
    float ipdOffset;
    GLint alignmentUniforms[1];
}

-(VBOWrap *) generateMesh;

@end

@implementation AlignmentHelper

#pragma mark - Up/Down

- (instancetype)initWithProfile:(ProfileInstance *) profile
{
    self = [super init];
    if (self) {
        mesh = [self generateMesh];
        [self loadShaders];
        verSize = 0.5 / profile.virtualHeightMM;
        horSize = 0.5 / (profile.virtualWidthMM / 2.0);
        ipdOffset = 1.0 - (profile.viewerIPD / 2.0) / (profile.virtualWidthMM / 2.0);
    }
    return self;
}

-(void) shutdown {
    [mesh shutdown];
    mesh = nil;
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - Draw

-(void) draw {
    
    glUseProgram(_program);
    
    glUniform2f(alignmentUniforms[UNIFORM_MMSIZE], horSize, verSize);
    
    [mesh draw];
    
    glUseProgram(0);
}

#pragma mark - Mesh

-(VBOWrap *) generateMesh {

    int numVertices = 8;
    int numFaces = 4;
    
    struct VertexPoint points [numVertices];
    struct Face3 faces [numFaces];
    struct VertexPoint * point;
    
    // Left Side
    
    point = &points[0];
    point->x = -1;
    point->y = -1;
    point->z = 0;
    point->ux = 0;
    point->uy = 0;
    
    point = &points[1];
    point->x = -1;
    point->y = 1;
    point->z = 0;
    point->ux = 0;
    point->uy = 1;
    
    point = &points[2];
    point->x = 0;
    point->y = 1;
    point->z = 0;
    point->ux = 1;
    point->uy = 1;
    
    point = &points[3];
    point->x = 0;
    point->y = -1;
    point->z = 0;
    point->ux = 1;
    point->uy = 0;
    
    faces[0].a = 0;
    faces[0].b = 1;
    faces[0].c = 2;
    
    faces[1].a = 2;
    faces[1].b = 3;
    faces[1].c = 0;
    
    // Right Side
    
    point = &points[4];
    point->x = 0;
    point->y = -1;
    point->z = 0;
    point->ux = 1;
    point->uy = 0;
    
    point = &points[5];
    point->x = 0;
    point->y = 1;
    point->z = 0;
    point->ux = 1;
    point->uy = 1;
    
    point = &points[6];
    point->x = 1;
    point->y = 1;
    point->z = 0;
    point->ux = 0;
    point->uy = 1;
    
    point = &points[7];
    point->x = 1;
    point->y = -1;
    point->z = 0;
    point->ux = 0;
    point->uy = 0;
    
    faces[2].a = 4;
    faces[2].b = 5;
    faces[2].c = 6;
    
    faces[3].a = 7;
    faces[3].b = 6;
    faces[3].c = 4;
    
    
    return [[VBOWrap alloc] initWith:points pointCount:numVertices faces:faces faceCount:numFaces];
}

#pragma mark - Shaders

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    //vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER source:alignmentVertexShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    //fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER source: alignmentFragmentShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "_glesVertex");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "_glesMultiTexCoord0");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    alignmentUniforms[UNIFORM_MMSIZE] = glGetUniformLocation(_program, "_mmSizes");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)sourceString
{
    GLint status;
    const GLchar *source = (GLchar *)[sourceString UTF8String];;
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
