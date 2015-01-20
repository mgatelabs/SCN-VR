//
//  WizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"

@implementation WizardItem

- (instancetype)initWith:(NSString *) title info:(NSString *) info itemId:(int) itemId type:(WizardItemDataType)type
{
    self = [super init];
    if (self) {
        _title = title;
        _info = info;
        _count = 0;
        _itemId = itemId;
        _type = type;
    }
    return self;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionCascade;
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionBreak;
}

-(void) chainUpdated {
    
}

-(void) reset {
    
}

-(BOOL) endpoint {
    return false;
}

-(BOOL) ready {
    return false;
}

-(BOOL) available {
    return false;
}

-(void) loadForInt:(int) value {
    
}

-(void) loadForIdentity:(NSString *) identity {
    
}

-(NSString *) stringForIndex:(int) index {
    return @"";
}

-(void) selectedIndex:(int) index {
    
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
}

@end
