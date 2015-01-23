//
//  DistortionMeshGenerator.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "DistortionMeshGenerator.h"

@interface DistortionMeshGenerator () {
    
}
@end


@implementation DistortionMeshGenerator

+(VBOWrap *) generateMeshFor:(ProfileInstance *) pair eye:(EyeTextureSide) eye {
    int _lines = 4;
    int _columns = 4;
    BOOL leftEye = eye == EyeTextureSideLeft || eye == EyeTextureSideMono;
    
    float k1, k2;
    if (pair.distortionCorrection == NO) {
        k1 = k2 = 0;
    } else {
        k1 = pair.distortionCorrectionValue1;
        k2 = pair.distortionCorrectionValue2;
    }
    int numVertices = (_lines + 1) * (_columns + 1);
    int numFaces = _lines * _columns;
    //struct Vector3 vertices [numVertices];
    //struct Vector2 uvs [numVertices];
    
    struct VertexPoint points [numVertices];
    
    int indexCount = numFaces * 6;
    int indexes[indexCount];
    
    //Vector3[] vertices = new Vector3[numVertices];
    //Vector2[] uvs = new Vector2[numVertices];
    //int[] tri = new int[numFaces*6];
    //If IPD is smaller than half of the width, we take width/2 for IPD
    //Otherwise meshes are outward-oriented
    
    float halfDeviceWidth = pair.virtualWidthMM / 2.0f;
    float halfIPDWidth = pair.viewerIPD / 2.0f;
    float calculatedOffsetX = (halfIPDWidth / halfDeviceWidth) - 0.5f;
    if (leftEye) {
        calculatedOffsetX *= -1;
    }
    
    if (pair.centerIPD) {
        calculatedOffsetX = 0;
    }
    
    float widthIPDRatio;
    
    //widthIPDRatio = pair.viewerIPD / pair.virtualWidthMM;
    
    //float widthIPDRatio = (pair.viewerIPD <= pair.virtualWidthMM * 0.5f)?(pair.viewerIPD / pair.virtualWidthMM) : 0.5f;
    
    widthIPDRatio = 0.5f;
    
    
    
    CGPoint center = CGPointMake(leftEye ? 1 - widthIPDRatio: widthIPDRatio, 0.5f);
    int x, y;
    
    //Creation of the vertices
    int numQuad = 0;
    float maxX = (leftEye?1:0);
    float maxY = 0;
    
    struct Vector2 vertex;
    
    for (y=0; y<=_lines; y++) {
        for(x=0; x<=_columns; x++){
            int index = y*(_lines+1)+x;
            //Vector2 vertex = new Vector2();
            
            float rSqr = powf (center.x-((float)x/(float)_columns),2) + powf (center.y-((float)y/(float)_lines),2);
            float rMod = 1+k1*rSqr+k2*rSqr*rSqr;
            
            vertex.x = (float)((float)x/(float)_columns-center.x)/(float)rMod+center.x-0.5f;
            vertex.y = (float)((float)y/(float)_lines-center.y)/(float)rMod+center.y-0.5f;
            if(leftEye){
                if(vertex.x < maxX) {
                    maxX = vertex.x;
                }
            } else {
                if(vertex.x > maxX) {
                    maxX = vertex.x;
                }
            }
            if(vertex.y>maxY) {
                maxY=vertex.y;
            }
            points[index].x = vertex.x;
            points[index].y = vertex.y;
            points[index].z = 0;
            
            points[index].ux = (float)x/(float)_columns;
            points[index].uy = (float)y/(float)_lines;
            
            if(x<_columns && y<_lines){
                for(int v=0; v < 6; v++){
                    indexes[numQuad*6+v] = index + ((v>=2 && v!=3) ? _columns : 0) + ((v==0) ? 0 : (v/5)+1);
                }
                numQuad++;
            }
        }
    }
    
    
    float scaleFactor = 1.0f/ MAX(leftEye?-1*(1-maxX):maxX,maxY);
    
    for(int i=0; i< numVertices; i++) {
        points[i].x *=scaleFactor;
        points[i].x += calculatedOffsetX;
        points[i].y *=scaleFactor;
        //points[i].z *=scaleFactor;
    }
    
    
    return [[VBOWrap alloc] initWith:points pointCount:numVertices indexes:indexes indexCount:indexCount];
}

@end
