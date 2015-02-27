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

#import "VBOWrap.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation VBOWrap {
    GLuint pointBuffer;
    GLuint uvBuffer;
    GLuint indexBuffer;
    int elementCount;
}

- (instancetype)initWith:(struct VertexPoint *) points pointCount:(int) pointCount indexes:(int *) indexes indexCount:(int) indexCount
{
    self = [super init];
    if (self) {
        elementCount = indexCount;
        
        glGenBuffers(1, &pointBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, pointBuffer);
        glBufferData(GL_ARRAY_BUFFER, pointCount * sizeof(struct VertexPoint), points, GL_STATIC_DRAW);
        
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(int), indexes, GL_STATIC_DRAW);
        
    }
    return self;
}

-(void) draw {
    if (elementCount > 0) {
        
        glBindBuffer(GL_ARRAY_BUFFER, pointBuffer);
        
        //glVertexAttribPointer(distortionPositionAttribute, 2, GL_FLOAT, 0, 0, leftEyeVertices);
        //glVertexAttribPointer(distortionTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
        
        glBindBuffer(GL_ARRAY_BUFFER, pointBuffer);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(struct VertexPoint), (void *)offsetof(struct VertexPoint, x));
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(struct VertexPoint), (void *)offsetof(struct VertexPoint, ux));
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        
        //glEnableVertexAttribArray(GLKVertexAttribPosition);
        //glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 2, BUFFER_OFFSET(0));
        
        //glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        //glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 3, BUFFER_OFFSET(3));
        
        //[self checkGlErrorStatus];
        
        
        [self checkGlErrorStatus];
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        
        [self checkGlErrorStatus];
        
        glDrawElements(GL_TRIANGLES, elementCount, GL_UNSIGNED_INT, (void*)0);
        
        [self checkGlErrorStatus];
        
        glDisableVertexAttribArray(GLKVertexAttribPosition);
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
}

- (void)dealloc {
    glDeleteBuffers(1, &pointBuffer);
    //glDeleteBuffers(1, &uvBuffer);
    glDeleteBuffers(1, &indexBuffer);
    pointBuffer = 0;
    //uvBuffer = 0;
    indexBuffer = 0;
    elementCount = 0;
}

-(void) checkGlErrorStatus {
    GLenum errorState = glGetError();
    if (errorState != GL_NO_ERROR) {
        NSLog(@"GL Error Detected: %d", errorState);
    }
}

@end
