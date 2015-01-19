//
//  WizardManager.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardManager.h"
#import "TrackerWizardItem.h"
#import "PhysicalDeviceWizardItem.h"
#import "VirtualDeviceWizardItem.h"
#import "HmdWizardItem.h"
#import "IpdWizardItem.h"
#import "IpdValueWizarditem.h"
#import "ColorWizardItem.h"
#import "ColorValueWizardItem.h"
#import "DistortionWizardItem.h"
#import "DistortionValueWizardItem.h"

@implementation WizardManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dirty = NO;
        
        _baseItems = [[NSMutableArray alloc] initWithCapacity:10];
        _filteredItems = [[NSMutableArray alloc] initWithCapacity:10];
        _visibleItems = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Head Tracking
        [_baseItems addObject:[[TrackerWizardItem alloc] init]];
        
        // Physical Device Selection
        PhysicalDeviceWizardItem * device = [[PhysicalDeviceWizardItem alloc] init];
        [_baseItems addObject: device];
        
        // Virtual Devices
        [_baseItems addObject: [[VirtualDeviceWizardItem alloc] initWith:device]];
        
        // HMD Selection
        HmdWizardItem * hmds = [[HmdWizardItem alloc] init];
        [_baseItems addObject: hmds];
        
        // IPD
        IpdWizardItem * ipd = [[IpdWizardItem alloc] initWith:hmds];
        [_baseItems addObject: ipd];
        
        // Value 1
        IpdValueWizarditem * ipdValue1 = [[IpdValueWizarditem alloc] initWith:ipd second:NO];
        [_baseItems addObject: ipdValue1];
        
        // Value 2
        IpdValueWizarditem * ipdValue2 = [[IpdValueWizarditem alloc] initWith:ipd second:YES];
        [_baseItems addObject: ipdValue2];
        
        // Color Correction
        ColorWizardItem * color = [[ColorWizardItem alloc] initWith:hmds];
        [_baseItems addObject:color];
        
        // Color Value
        ColorValueWizardItem * colorValue = [[ColorValueWizardItem alloc] initWith:color];
        [_baseItems addObject:colorValue];
        
        // Distortion
        DistortionWizardItem * distortion = [[DistortionWizardItem alloc] initWith:hmds];
        [_baseItems addObject:distortion];
        
        // Distortion Value 1
        DistortionValueWizardItem * distortionalue1 = [[DistortionValueWizardItem alloc] initWith:distortion second:NO];
        [_baseItems addObject: distortionalue1];
        
        // Distortion Value 2
        DistortionValueWizardItem * distortionValue2 = [[DistortionValueWizardItem alloc] initWith:distortion second:YES];
        [_baseItems addObject: distortionValue2];
        
        [self filter];
    }
    return self;
}

-(void) item:(int) item changedTo:(int) index {
    
    _dirty = YES;
    
    WizardItem * wizardItem = [_visibleItems objectAtIndex:item];
    [wizardItem selectedIndex:index];
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        [item chainUpdated];
    }
    
    [self filter];
}

-(int) item:(int) item {
    WizardItem * wizardItem = [_visibleItems objectAtIndex:item];
    return wizardItem.valueIndex;
}

// Filter items based upon how well they did
-(void) filter {
    // Clean the filter
    [_filteredItems removeAllObjects];
    [_visibleItems removeAllObjects];
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        
        if ([item ready]) {
            [_filteredItems addObject:item];
        } else {
            if ([item available]) {
                [_filteredItems addObject:item];
            }
            WizardItemNotReadyAction notReadyAct = [item notReadyAction];
            if (notReadyAct == WizardItemNotReadyActionBreak) {
                break;
            }
        }
    }
    
    for (int i = 0; i < _filteredItems.count; i++) {
        WizardItem * item = [_filteredItems objectAtIndex:i];
        if (item.count > 1) {
            [_visibleItems addObject:item];
        }
    }
}

-(void) reset {
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        [item reset];
    }
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        [item chainUpdated];
    }
    
    [self filter];
}

-(NSMutableDictionary *) extractItem {
    NSMutableDictionary * values = [NSMutableDictionary dictionaryWithCapacity:_filteredItems.count];
    
    for (int i = 0; i < _filteredItems.count; i++) {
        WizardItem * item = [_filteredItems objectAtIndex:i];
        [values setValue:[NSNumber numberWithInt:item.valueIndex] forKey:[NSString stringWithFormat:@"%d", item.itemId]];
    }
    
    return values;
}

-(void) insertItem:(NSDictionary *) payload {
    
    _dirty = NO;
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        NSNumber * numb = [payload valueForKey:[NSString stringWithFormat:@"%d", item.itemId]];
        if (numb != nil) {
            [item selectedIndex:[numb intValue]];
        }
        [item chainUpdated];
        
        for (int j = i + 1; j < _baseItems.count; j++) {
            WizardItem * temp = [_baseItems objectAtIndex:j];
            [temp chainUpdated];
        }
    }
    
    [self filter];
}

-(ProfileInstance *) buildProfileInstance {
    ProfileInstance * instance = [[ProfileInstance alloc] init];
    
    for (int i = 0; i < _filteredItems.count; i++) {
        WizardItem * item = [_filteredItems objectAtIndex:i];
        [item updateProfileInstance:instance];
    }
    
    return instance;
}

@end
