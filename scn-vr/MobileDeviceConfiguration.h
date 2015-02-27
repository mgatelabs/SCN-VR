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

@interface MobileDeviceConfiguration : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * virtualName;
@property (readonly, strong, nonatomic) NSString * identifier;

@property (assign, nonatomic) BOOL tablet;
@property (assign, nonatomic) BOOL internal;
@property (assign, nonatomic) BOOL custom;

@property (assign) int widthPoint;
@property (assign) int heightPoint;
@property (assign) float minNativeScale;
@property (assign) float maxNativeScale;
@property (assign) float forcedScale;
@property (assign) BOOL zoomed;

@property (assign) int widthPx;
@property (assign) int heightPx;

@property (assign) int physicalWidthPx;
@property (assign) int physicalHeightPx;

@property (assign) float dpi;
@property (assign) float physicalDpi;

@property (readonly, assign) float widthIN;
@property (readonly, assign) float heightIN;

@property (readonly, assign) float widthMM;
@property (readonly, assign) float heightMM;

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx dpi:(float) dpi tablet:(BOOL) tablet;

- (instancetype)initAsCustom:(NSString *) name identifier:(NSString *) identifier widthPx:(int) widthPx heightPx:(int) heightPx tablet:(BOOL) tablet;

-(void) ready;

@end
