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

#import "ProfileManager.h"
#import "ProfileConfiguration.h"
#import "SCNVRResourceBundler.h"

@implementation ProfileManager {
    WizardManager * wizard;
    BOOL wizardStateUpdate;
    int wizardStateIndex;
    ProfileConfiguration * wizardProfile;
    NSString * wizardProfileName;
    BOOL wizardFavoriteStatus;
}

+ (id)sharedManager {
    return [ProfileManager sharedManager: nil];
}

+ (id)sharedManager:(NSString *) groupName {
    static ProfileManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initWithGroup:groupName];
    });
    return sharedMyManager;
}

- (instancetype)initWithGroup:(NSString *) groupName
{
    self = [super init];
    if (self) {
        
        _groupName = groupName;
        
        wizard = [[WizardManager alloc] init];
        
        _profileFilePath = [@"~/Library/profiles.json" stringByExpandingTildeInPath];
        
        _profiles = [[NSMutableArray alloc] initWithCapacity:5];
        _index = -1;
        
        if ([self canLoadFromGroup]) {
            
        } else if ([self canLoadFromFile]) {
            [self persist];
        } else {
            [self reset];
            [self persist];
        }
        
        if (_profiles.count == 0) {
            [self reset];
            [self persist];
        }        
    }
    return self;
}

-(NSString *) nameForIndex:(int) index {
    ProfileConfiguration * p = [_profiles objectAtIndex:index];
    return p.name;
}

-(NSString *) valueForIndex:(int) index andKey:(NSString *) key {
    if (_profiles.count <= index) return @"";
    ProfileConfiguration * p = [_profiles objectAtIndex:index];
    NSString * value = [p.values valueForKey:key];
    return value == nil ? @"" : [NSString stringWithFormat:@"%@", value];
    
}

-(BOOL) isFavorite:(int) index {
    ProfileConfiguration * p = [_profiles objectAtIndex:index];
    return p.favorite;
}

-(void) selectIndex:(int) index {
    _index = index;
    [self persist];
}

-(void) deleteIndex:(int) index {
    if (index >= 0 && index < _profiles.count) {
        [_profiles removeObjectAtIndex:index];
        _count = (int)_profiles.count;
        if (index == _index) {
            _index = 0;
        } else if (index < _index) {
            _index--;
        }
    }
}

-(void) moveIndex:(int) index to:(int) toIndex {
    
    ProfileConfiguration * pc = [_profiles objectAtIndex:index];
    [_profiles removeObjectAtIndex:index];
    [_profiles insertObject:pc atIndex:toIndex];
    
    if (index == _index) {
        _index = toIndex;
    } else if (index > _index && toIndex > _index) {
        // No Operation, Moved On Top Index
    } else if (index < _index && toIndex < _index) {
        // No Operation, Moved Under Index
    } else if (index < _index && toIndex >= _index) {
        // Moved item from under index to above index
        _index--;
    } else if (index > _index && toIndex <= _index) {
        // Moved item from above to under index
        _index++;
    }
}

-(BOOL) canLoadFromFile {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.profileFilePath]) {
        [self loadFromFile];
        return YES;
    }
    return NO;
}

-(BOOL) canLoadFromGroup {
    
    NSUserDefaults * defs;
    
    if (_groupName != nil) {
        defs = [[NSUserDefaults alloc] initWithSuiteName:_groupName];
    } else {
        defs = [NSUserDefaults standardUserDefaults];
    }
    
    NSDictionary * tempDict = [defs valueForKey:@"profiles.items"];
    
    if (tempDict != nil && [tempDict objectForKey:@"index"] != nil && [tempDict objectForKey:@"profiles"] != nil) {
        return [self loadFromDictionary:tempDict];
    }
    
    return NO;
}

-(void) loadFromFile {
    NSDictionary * profileSettings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:_profileFilePath] options:0 error:nil];
    [self loadFromDictionary:profileSettings];
}

-(BOOL) loadFromDictionary:(NSDictionary *) profileSettings {
    NSNumber * indexNumber = [profileSettings valueForKey:@"index"];

    NSMutableArray * profileItems = [profileSettings valueForKey:@"profiles"];
    
    [_profiles removeAllObjects];
    
    if (profileItems != nil && indexNumber != nil) {
    
        for (int i = 0; i < profileItems.count; i++) {
            NSDictionary * profileData = [profileItems objectAtIndex:i];
            ProfileConfiguration * configuration = [[ProfileConfiguration alloc] init];
            
            if ([profileData valueForKey:@"name"] != nil && [profileData valueForKey:@"identity"] != nil && [profileData valueForKey:@"values"] != nil) {
                
                if ([profileData valueForKey:@"fav"] != nil) {
                    NSNumber * favValue = [profileData valueForKey:@"fav"];
                    configuration.favorite = favValue.boolValue;
                }
                
                configuration.name = [profileData valueForKey:@"name"];
                NSNumber * identityNumber = [profileData valueForKey:@"identity"];
                configuration.identity = [identityNumber intValue];
                configuration.values = [NSMutableDictionary dictionaryWithDictionary:[profileData valueForKey:@"values"]];
                
                [_profiles addObject:configuration];
            }
        }
    
        _index = (int)[indexNumber intValue];
    
        _count = (int)_profiles.count;
        return true;
    }
    return false;
}

-(void) persist {
    NSDictionary * profileSettings = [self exportToDictonary];
    NSUserDefaults * defs;
    if (_groupName != nil) {
        defs = [[NSUserDefaults alloc] initWithSuiteName:_groupName];
    } else {
        defs = [NSUserDefaults standardUserDefaults];
    }
    [defs setObject:profileSettings forKey:@"profiles.items"];
    [defs synchronize];
}

-(NSDictionary *) exportToDictonary {
    NSMutableArray * profileItems = [[NSMutableArray alloc] initWithCapacity:_profiles.count];
    
    // Make sure we always have presets
    if (_profiles.count == 0) {
        // Must always have presets
        [self reset];
    }
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * profile = [_profiles objectAtIndex:i];
        
        NSMutableDictionary * profileData = [NSMutableDictionary dictionaryWithCapacity:3];
        
        [profileData setObject:profile.name forKey:@"name"];
        [profileData setObject:[NSNumber numberWithBool:profile.favorite] forKey:@"fav"];
        [profileData setObject:[NSNumber numberWithInt:profile.identity] forKey:@"identity"];
        [profileData setObject:profile.values forKey:@"values"];
        
        [profileItems addObject:profileData];
    }
    
    NSMutableDictionary * profileSettings = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [profileSettings setObject:[NSNumber numberWithInt:_index] forKey:@"index"];
    [profileSettings setObject:profileItems forKey:@"profiles"];
    
    return profileSettings;
}

/**
  * Get all selected favorites, except for the current item, if it's a favorite
  */
-(NSArray *) getFavorites {
    NSMutableArray * results = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc = _profiles[i];
        if (pc.favorite) {
            if (self.index != i) {
                pc.referenceIndex = i;
                [results addObject:pc];
            }
        }
    }
    return results;
}

-(int) newProfile {
    
    int minProfileIdentity = 0;
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc= [_profiles objectAtIndex:i];
        if (pc.identity > minProfileIdentity) {
            minProfileIdentity = pc.identity + 1;
        }
    }
        
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(int) newProfileForCardboardWithIPD:(float) ipd {
    int minProfileIdentity = 0;
    int wizardIndex;
    WizardItem * wi;
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc= [_profiles objectAtIndex:i];
        if (pc.identity > minProfileIdentity) {
            minProfileIdentity = pc.identity + 1;
        }
    }
    
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:3];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(int) newProfileForHomidoWithIPD:(float) ipd {
    int minProfileIdentity = 0;
    int wizardIndex;
    WizardItem * wi;
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc= [_profiles objectAtIndex:i];
        if (pc.identity > minProfileIdentity) {
            minProfileIdentity = pc.identity + 1;
        }
    }
    
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:7];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(int) newProfileForViewMaster2015WithIPD:(float) ipd {
    int minProfileIdentity = 0;
    int wizardIndex;
    WizardItem * wi;
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc= [_profiles objectAtIndex:i];
        if (pc.identity > minProfileIdentity) {
            minProfileIdentity = pc.identity + 1;
        }
    }
    
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:8];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(int) newCustomProfileFor:(NSString *) name vfov:(float) vfov hfov:(float) hfov ipd:(float) ipd distortion0:(float) distortion0  distortion1:(float) distortion1 {

    int minProfileIdentity = 0;
    int wizardIndex;
    WizardItem * wi;
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * pc= [_profiles objectAtIndex:i];
        if (pc.identity > minProfileIdentity) {
            minProfileIdentity = pc.identity + 1;
        }
    }
    
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = (name != nil && name.length > 0) ? name : NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    
    // Default to cardboard
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:3];
    
    // IPD
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = [NSNumber numberWithFloat:ipd];
    
    // Field of view
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_FOV];
    [wizard item: wizardIndex changedTo:1];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_FOV_H];
    wi.slideValue = [NSNumber numberWithFloat:hfov];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_FOV_V];
    wi.slideValue = [NSNumber numberWithFloat:vfov];
    
    // Distortion
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_DISTORTION];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_DISTORTION_VALUE1];
    wi.slideValue = [NSNumber numberWithFloat:distortion0];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_DISTORTION_VALUE2];
    wi.slideValue = [NSNumber numberWithFloat:distortion1];
    
    // Color
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_COLOR];
    [wizard item: wizardIndex changedTo:1];
    
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(void) reset {
    
    //NSLog(@"Resetting Profile State");
    
    int wizardIndex;
    WizardItem * wi;
    
    [_profiles removeAllObjects];
    
    // Default Side By Side
    [wizard reset];
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.favorite = YES;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-SBS", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default - Side by Side");
    pc.identity = 0;
    // The defaults should be SBS Landscape
    pc.values = [wizard extractItem];
    
    _index = 0;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    // Cardboard
    [wizard reset];
    pc = [[ProfileConfiguration alloc] init];
    pc.favorite = YES;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-Cardboard", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default - Cardboard");
    pc.identity = 1;
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:3];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:1];
    
    pc.values = [wizard extractItem];
    
    [_profiles addObject:pc];
    
    // Cardboard
    [wizard reset];
    pc = [[ProfileConfiguration alloc] init];
    pc.favorite = NO;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-FemaleCardboard", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Female - Cardboard");
    pc.identity = 2;
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:3];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = @58.0f;
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = @58.0f;
    
    [wizard filter];
    
    pc.values = [wizard extractItem];
    
    [_profiles addObject:pc];
    
    // Homido
    [wizard reset];
    pc = [[ProfileConfiguration alloc] init];
    pc.favorite = YES;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-Homido", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default - Homido");
    pc.identity = 3;
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:7];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:1];
    
    pc.values = [wizard extractItem];
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    // Homido
    [wizard reset];
    pc = [[ProfileConfiguration alloc] init];
    pc.favorite = NO;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-FemaleHomido", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Female - Homido");
    pc.identity = 3;
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:7];
    
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_IPD];
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE1];
    wi.slideValue = @58.0f;
    [wizard item: wizardIndex changedTo:2];
    
    wi = [wizard findWizardItemWithIdentity:WIZARD_ITEM_IPD_VALUE2];
    wi.slideValue = @58.0f;
    
    [wizard filter];
    
    pc.values = [wizard extractItem];
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    // Child
    [wizard reset];
    pc = [[ProfileConfiguration alloc] init];
    pc.favorite = YES;
    pc.name = NSLocalizedStringFromTableInBundle(@"Profile-Child", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default - Child");
    pc.identity = 4;
    wizardIndex = [wizard findWizardIdexWithIdentity:WIZARD_ITEM_HMD];
    [wizard item: wizardIndex changedTo:0];
    
    pc.values = [wizard extractItem];
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
}

-(void) addBuiltIn {

}

-(WizardManager *) wizardManager {
    return wizard;
}

-(ProfileInstance *) getCurrentProfileInstance {
    
    ProfileConfiguration * pc= [_profiles objectAtIndex:self.index];
    
    [wizard reset];
    
    [wizard insertItem:pc.values];
    
    return [wizard buildProfileInstance];
}

-(ProfileInstance *) getLiveProfileInstance {
    return [wizard buildProfileInstance];
}

#pragma mark - External Editing

-(WizardManager *) getLiveWizard {
    return wizard;
}

-(void) startNewWizard {
    [wizard reset];
    wizardStateUpdate = NO;
    wizardStateIndex = -1;
    wizardProfile = [[ProfileConfiguration alloc] init];
    
    wizardProfileName = NSLocalizedStringFromTableInBundle(@"New Profile", @"SCN-VRStrings", [SCNVRResourceBundler getSCNVRResourceBundle], @"New Profile title");
    wizardFavoriteStatus = NO;
}

-(void) setProfileName:(NSString *) name {
    if (name != nil && name.length > 0) {
        wizardProfileName = name;
    }
}

-(NSString *) getProfileName {
    if (wizardProfileName != nil) {
        return wizardProfileName;
    }
    return @"Unknown";
}

-(BOOL) isFavoriteProfile {
    return wizardFavoriteStatus;
}

-(void) setFavoriteProfile:(BOOL) value {
    wizardFavoriteStatus = value;
}

-(void) openWizardForIndex:(int) index {
    [wizard reset];
    wizardStateUpdate = YES;
    wizardStateIndex = index;
    if (index >= 0 && index < _profiles.count) {
        wizardProfile = _profiles[index];
        wizardProfileName = wizardProfile.name;
        wizardFavoriteStatus = wizardProfile.favorite;
        [wizard insertItem:wizardProfile.values];
        wizard.profileIndex = index;
    } else {
        [self startNewWizard];
    }
}

-(int) getWizardItemIndex:(int) wizardId {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        if (!(wi.type == WizardItemDataTypeString || wi.type == WizardItemDataTypeInt)) {
            NSLog(@"Wizard %d is not an index type", wizardId);
        }
        return wi.valueIndex;
    }
    return -1;
}

-(WizardItem *) getWizardItem:(int) wizardId {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        return wi;
    }
    NSLog(@"getWizardItem: Could not locate wizard item: %d", wizardId);
    return nil;
}

-(float) getWizardItemFloat:(int) wizardId {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        if (wi.type != WizardItemDataTypeSlideFloat) {
            NSLog(@"Wizard %d is not an float type", wizardId);
        }
        return wi.slideValue.floatValue;
    }
    NSLog(@"getWizardItemFloat: Could not locate wizard item: %d", wizardId);
    return -1;
}

-(int) getWizardItemInt:(int) wizardId {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        if (wi.type != WizardItemDataTypeSlideInt) {
            NSLog(@"Wizard %d is not an int type", wizardId);
        }
        return wi.slideValue.intValue;
    }
    NSLog(@"getWizardItemInt: Could not locate wizard item: %d", wizardId);
    return -1;
}

-(NSString *) getWizardItemString:(int) wizardId {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        if (wi.type != WizardItemDataTypeString) {
            NSLog(@"Wizard %d is not an String type", wizardId);
        }
        return wi.valueId;
    }
    NSLog(@"getWizardItemString: Could not locate wizard item: %d", wizardId);
    return @"";
}

-(void) setWizardItem:(int) wizardId toIndex:(int) intValue {
    int wizardIndex = [wizard findWizardIdexWithIdentity:wizardId];
    if (wizardIndex >= 0) {
        [wizard item: wizardIndex changedTo:intValue];
    } else {
        NSLog(@"Error, Did not find Wizard Item with id: %d", wizardId);
    }
}

-(void) setWizardItem:(int) wizardId toFloat:(float) floatValue {
    
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        wi.slideValue = [NSNumber numberWithFloat:floatValue];
    } else {
        NSLog(@"Error, Did not find Wizard Item with id: %d", wizardId);
    }
}

-(void) setWizardItem:(int) wizardId toInt:(int) intValue{
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        wi.slideValue = [NSNumber numberWithInt:intValue];
    } else {
        NSLog(@"Error, Did not find Wizard Item with id: %d", wizardId);
    }
}

-(void) nudgeFloatWizardItem:(int) wizardId positive:(BOOL) positive {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        float newValue = wi.slideValue.floatValue + (wi.slideStep.floatValue * (positive ? 1 : -1));
        if (newValue >= wi.slideMin.floatValue && newValue <= wi.slideMax.floatValue) {
            wi.slideValue = [NSNumber numberWithFloat:newValue];
        }
    } else {
        NSLog(@"Error, Did not find Wizard Item with id: %d", wizardId);
    }
}

-(void) nudgeIndexWizardItem:(int) wizardId positive:(BOOL) positive {
    WizardItem * wi = [wizard findWizardItemWithIdentity:wizardId];
    if (wi != nil) {
        if (positive && wi.valueIndex + 1 < wi.count) {
            [wi selectedIndex:wi.valueIndex + 1];
        } else if (!positive && wi.valueIndex - 1 >= 0) {
            [wi selectedIndex:wi.valueIndex - 1];
        }
    } else {
        NSLog(@"Error, Did not find Wizard Item with id: %d", wizardId);
    }
}

-(void) copyWizardState {
    wizardStateUpdate = NO;
    wizardStateIndex = -1;
    wizardProfile = [[ProfileConfiguration alloc] init];
    wizardProfileName = [NSString stringWithFormat:@"%@ Copy", wizardProfileName];
    [self persistWizardState];
}

-(int) persistWizardState {
    // Set properties
    wizardProfile.name = wizardProfileName;
    wizardProfile.favorite = wizardFavoriteStatus;
    if (wizardStateUpdate) {
        [wizardProfile setValues:[wizard extractItem]];
        [self persist];
        return wizardStateIndex;
    } else {
        int minProfileIdentity = 0;
        int wizardIndex;
        WizardItem * wi;
        
        for (int i = 0; i < _profiles.count; i++) {
            ProfileConfiguration * pc= [_profiles objectAtIndex:i];
            if (pc.identity > minProfileIdentity) {
                minProfileIdentity = pc.identity + 1;
            }
        }
        
        wizardProfile.values = [wizard extractItem];
        
        int returnIndex = (int)_profiles.count;
        
        [_profiles addObject:wizardProfile];
        
        _count = (int)_profiles.count;

        [self persist];
        
        return returnIndex;
    }
}

-(void) cancelWizard {
    [wizard reset];
    wizardStateUpdate = NO;
    wizardStateIndex = -1;
    wizardProfileName = nil;
    wizardFavoriteStatus = NO;
}

@end
