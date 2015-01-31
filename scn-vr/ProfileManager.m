//
//  ProfileManager.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfileManager.h"
#import "ProfileConfiguration.h"

@implementation ProfileManager {
    WizardManager * wizard;
}

+ (id)sharedManager {
    static ProfileManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        wizard = [[WizardManager alloc] init];
        
        _profileFilePath = [@"~/Library/profiles.json" stringByExpandingTildeInPath];
        
        _profiles = [[NSMutableArray alloc] initWithCapacity:5];
        _index = -1;
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:self.profileFilePath]) {
            [self load];
        } else {
            // Create a default profile
            
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

-(void) selectIndex:(int) index {
    _index = index;
    [self persist];
}

-(void) deleteIndex:(int) index {
    [_profiles removeObjectAtIndex:index];
    _count = (int)_profiles.count;
    if (index == _index) {
        _index = 0;
    } else if (index < _index) {
        _index--;
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

-(void) load {
    
    NSDictionary * profileSettings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:_profileFilePath] options:0 error:nil];
    
    NSNumber * indexNumber = [profileSettings valueForKey:@"index"];
    
    
    NSMutableArray * profileItems = [profileSettings valueForKey:@"profiles"];
    
    for (int i = 0; i < profileItems.count; i++) {
        NSDictionary * profileData = [profileItems objectAtIndex:i];
        ProfileConfiguration * configuration = [[ProfileConfiguration alloc] init];
        
        configuration.name = [profileData valueForKey:@"name"];
        NSNumber * identityNumber = [profileData valueForKey:@"identity"];
        configuration.identity = [identityNumber intValue];
        configuration.values = [NSMutableDictionary dictionaryWithDictionary:[profileData valueForKey:@"values"]];
        
        [_profiles addObject:configuration];
    }
    
    _index = (int)[indexNumber intValue];
    
    _count = (int)_profiles.count;
}

-(void) persist {
    
    NSMutableArray * profileItems = [[NSMutableArray alloc] initWithCapacity:_profiles.count];
    
    // Make sure we always have presets
    if (_profiles.count == 0) {
        // Must always have presets
        [self reset];
    }
    
    for (int i = 0; i < _profiles.count; i++) {
        ProfileConfiguration * profile = [_profiles objectAtIndex:i];
        
        NSMutableDictionary * profileData = [NSMutableDictionary dictionaryWithCapacity:3];
        
        [profileData setValue:profile.name forKey:@"name"];
        [profileData setValue:[NSNumber numberWithInt:profile.identity] forKey:@"identity"];
        [profileData setValue:profile.values forKey:@"values"];
        
        [profileItems addObject:profileData];
    }
    
    NSMutableDictionary * profileSettings = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [profileSettings setValue:[NSNumber numberWithInt:_index] forKey:@"index"];
    [profileSettings setValue:profileItems forKey:@"profiles"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:profileSettings options:0 error:nil];
    
    [jsonData writeToFile:_profileFilePath options:0 error:nil];
    
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
    pc.name = @"New Profile";
    
    pc.identity = minProfileIdentity;
    // The defaults should be SBS Landscape
    [wizard reset];
    pc.values = [wizard extractItem];
    
    int returnIndex = (int)_profiles.count;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
    
    return returnIndex;
}

-(void) reset {
    
    [_profiles removeAllObjects];
    
    [wizard reset];
    
    ProfileConfiguration * pc = [[ProfileConfiguration alloc] init];
    pc.name = @"Default";
    pc.identity = 0;
    // The defaults should be SBS Landscape
    pc.values = [wizard extractItem];
    
    _index = 0;
    
    [_profiles addObject:pc];
    
    _count = (int)_profiles.count;
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

@end
