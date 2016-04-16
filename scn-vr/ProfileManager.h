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

@property (assign, nonatomic) BOOL liveMode;

+ (id)sharedManager;

+ (id)sharedManager:(NSString *) groupName;

- (instancetype)initWithGroup:(NSString *) groupName;

-(NSString *) nameForIndex:(int) index;
-(BOOL) isFavorite:(int) index;

-(void) selectIndex:(int) index;

-(void) deleteIndex:(int) index;

-(void) moveIndex:(int) index to:(int) toIndex;

-(int) newProfile;
-(int) newProfileForCardboardWithIPD:(float) ipd;
-(int) newProfileForHomidoWithIPD:(float) ipd;
-(int) newProfileForViewMaster2015WithIPD:(float) ipd;
-(int) newCustomProfileFor:(NSString *) name vfov:(float) vfov hfov:(float) hfov ipd:(float) ipd distortion0:(float) distortion0  distortion1:(float) distortion1;

-(BOOL) canLoadFromFile;

-(BOOL) canLoadFromGroup;

-(BOOL) loadFromDictionary:(NSDictionary *) profileSettings;

-(void) loadFromFile;

-(void) persist;

-(void) reset;

-(NSArray *) getFavorites;

-(WizardManager *) wizardManager;

-(ProfileInstance *) getCurrentProfileInstance;
-(ProfileInstance *) getLiveProfileInstance;

-(NSDictionary *) exportToDictonary;

// Wizard Edit Operations, Dangerous
-(WizardManager *) getLiveWizard;
-(void) startNewWizard;
-(void) openWizardForIndex:(int) index;

-(BOOL) isFavoriteProfile;
-(void) setFavoriteProfile:(BOOL) value;

-(void) setProfileName:(NSString *) name;
-(NSString *) getProfileName;

-(int) getWizardItemIndex:(int) wizardId;
-(float) getWizardItemFloat:(int) wizardId;
-(WizardItem *) getWizardItem:(int) wizardId;
-(int) getWizardItemInt:(int) wizardId;
-(void) setWizardItem:(int) wizardId toIndex:(int) intValue;
-(void) setWizardItem:(int) wizardId toInt:(int) intValue;

-(void) nudgeFloatWizardItem:(int) wizardId positive:(BOOL) positive;
-(void) setWizardItem:(int) wizardId toFloat:(float) floatValue;

-(void) copyWizardState;
-(int) persistWizardState;
-(void) cancelWizard;

@end
