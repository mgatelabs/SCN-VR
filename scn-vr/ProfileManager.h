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
#import "WizardManager.h"

@interface ProfileManager : NSObject

@property (strong, nonatomic, readonly) NSString * profileFilePath;

@property (strong, nonatomic, readonly) NSMutableArray * profiles;
@property (assign, nonatomic, readonly) int index;

@property (assign, nonatomic, readonly) int count;

@property (strong, nonatomic, readonly) NSString * groupName;

+ (id)sharedManager;

+ (id)sharedManager:(NSString *) groupName;

- (instancetype)initWithGroup:(NSString *) groupName;

-(NSString *) nameForIndex:(int) index;

-(void) selectIndex:(int) index;

-(void) deleteIndex:(int) index;

-(void) moveIndex:(int) index to:(int) toIndex;

-(int) newProfile;
-(int) newProfileForCardboardWithIPD:(float) ipd;
-(int) newProfileForHomidoWithIPD:(float) ipd;

-(BOOL) canLoadFromFile;

-(BOOL) canLoadFromGroup;

-(BOOL) loadFromDictionary:(NSDictionary *) profileSettings;

-(void) loadFromFile;

-(void) persist;

-(void) reset;

-(NSArray *) getFavorites;

-(WizardManager *) wizardManager;

-(ProfileInstance *) getCurrentProfileInstance;

-(NSDictionary *) exportToDictonary;

@end
