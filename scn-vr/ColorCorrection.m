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

#import "ColorCorrection.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const vertexShaderString = SHADER_STRING
(
 precision highp float;
 
 attribute vec4 _glesVertex;
 attribute vec4 _glesMultiTexCoord0;
 uniform highp vec2 _SHIFT;
 varying highp vec2 xlv_TEXCOORD0;
 void main ()
{
    highp vec2 tmpvar_1;
    tmpvar_1.x = ((_glesMultiTexCoord0.x * 0.5) + _SHIFT).x;
    tmpvar_1.y = _glesMultiTexCoord0.y;
    gl_Position = _glesVertex;
    xlv_TEXCOORD0 = tmpvar_1;
}
);

NSString *const fragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D _MainTex;
 uniform highp float _AberrationOffset;
 uniform highp vec2 _Center;
 uniform highp float _ChromaticConstant;
 varying highp vec2 xlv_TEXCOORD0;
 void main ()
{
    highp vec4 blue_1;
    highp vec4 green_2;
    highp vec4 red_3;
    highp float tmpvar_4;
    tmpvar_4 = (_AberrationOffset / 300.0);
    highp float tmpvar_5;
    tmpvar_5 = (_ChromaticConstant / 300.0);
    highp float tmpvar_6;
    tmpvar_6 = ((((float(((xlv_TEXCOORD0.x - _Center.x) >= 0.0)) * 2.0) - 1.0) * tmpvar_5) + ((xlv_TEXCOORD0.x - _Center.x) * tmpvar_4));
    highp float tmpvar_7;
    tmpvar_7 = ((((float(((xlv_TEXCOORD0.y - _Center.y) >= 0.0)) * 2.0) - 1.0) * tmpvar_5) + ((xlv_TEXCOORD0.y - _Center.y) * tmpvar_4));
    highp vec2 tmpvar_8;
    tmpvar_8.x = (xlv_TEXCOORD0.x + tmpvar_6);
    tmpvar_8.y = (xlv_TEXCOORD0.y + tmpvar_7);
    lowp vec4 tmpvar_9;
    tmpvar_9 = texture2D (_MainTex, tmpvar_8);
    red_3 = tmpvar_9;
    lowp vec4 tmpvar_10;
    tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
    green_2 = tmpvar_10;
    highp vec2 tmpvar_11;
    tmpvar_11.x = (xlv_TEXCOORD0.x - tmpvar_6);
    tmpvar_11.y = (xlv_TEXCOORD0.y - tmpvar_7);
    lowp vec4 tmpvar_12;
    tmpvar_12 = texture2D (_MainTex, tmpvar_11);
    blue_1 = tmpvar_12;
    highp vec4 tmpvar_13;
    tmpvar_13.w = 1.0;
    tmpvar_13.x = red_3.x;
    tmpvar_13.y = green_2.y;
    tmpvar_13.z = blue_1.z;
    gl_FragData[0] = tmpvar_13;
}
 
);

// Uniform index.
enum
{
    UNIFORM_MAINTEX = 0,
    UNIFORM_ABERRATIONOFFSET = 1,
    UNIFORM_CENTER = 2,
    UNIFORM_CHROMATICCONSTANT = 3,
    UNIFORM_SHIFT = 4
};
GLint uniforms[5];

@interface ColorCorrection (){

    GLuint _program;
}

- (BOOL)loadShaders;

@end

@implementation ColorCorrection

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadShaders];
    }
    return self;
}

-(void) activateShaderFor:(ProfileInstance *) pair leftEye:(BOOL) leftEye texture:(GLuint) texture {
    
    glUseProgram(_program);
    
    glUniform2f(uniforms[UNIFORM_SHIFT], leftEye ? 0.0f : 0.5f, 0.0f);
    
    glUniform1f(uniforms[UNIFORM_ABERRATIONOFFSET], pair.colorCorrection ? pair.colorCorrectionValue : 0.0f);
    
    //glUniform1f(uniforms[UNIFORM_ABERRATIONOFFSET], 0.0f);
    
    float ratio = (pair.viewerIPD * 0.5f) / pair.virtualWidthMM;
    
    glUniform2f(uniforms[UNIFORM_CENTER], 0.5f+(leftEye ? -ratio:ratio),0.5f);
    
    //if (leftEye) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture);
        glUniform1i(uniforms[UNIFORM_MAINTEX], 0);
    //} else {
    //    glActiveTexture(GL_TEXTURE1);
    //    glBindTexture(GL_TEXTURE_2D, texture);
    //    glUniform1i(uniforms[UNIFORM_MAINTEX], 1);
    //}
    //float convergeOffset = ((pair.mobile.widthMM * 0.5f) - pair.hmd.ipd) / pair.mobile.widthMM;
    //glUniform2f(uniforms[UNIFORM_], leftEye ? 0.0f : 0.5f, 0);
    //mat.SetVector("_CONVERGE",new Vector2((_leftEye?1f:-1f)*convergeOffset,0));
    //mat.SetFloat ("_AberrationOffset",deviceConfig.enableChromaticCorrection?deviceConfig.chromaticCorrection:0f);
    //mat.SetVector ("_Center",new Vector2(0.5f+(_leftEye?-ratio:ratio),0.5f));
    
    //glUniform2f(scaleUniform, (w/2.0f) * scaleFactor, (h/2.0f) * scaleFactor * as);
    //glUniform2f(scaleInUniform, (2.0f/w), (2.0f/h) / as);
    //glUniform4f(hmdWarpParamUniform, 1.0, 0.22, 0.24, 0.0);
    
    //glUniform2f(lensCenterUniform, x + (w + distortion * 0.5f)*0.5f, y + h*0.5f);
    //glUniform2f(screenCenterUniform, x + w*0.5f, y + h*0.5f);
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    //vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER source:vertexShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    //fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER source: fragmentShaderString]) {
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
    uniforms[UNIFORM_MAINTEX] = glGetUniformLocation(_program, "_MainTex");
    uniforms[UNIFORM_ABERRATIONOFFSET] = glGetUniformLocation(_program, "_AberrationOffset");
    uniforms[UNIFORM_CENTER] = glGetUniformLocation(_program, "_Center");
    uniforms[UNIFORM_CHROMATICCONSTANT] = glGetUniformLocation(_program, "_ChromaticConstant");
    uniforms[UNIFORM_SHIFT] = glGetUniformLocation(_program, "_SHIFT");
    
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

- (void)dealloc
{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
