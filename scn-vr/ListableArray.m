//
//  ListableManager.m
//  scn-vr
//
//  Created by Michael Fuller on 12/23/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "ListableArray.h"

@implementation ListableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"Unknown";
}

-(NSString *) getListItemNameFor:(int) index {
    return @"Unknown";
}

-(int) getListItemCount {
    return 0;
}

-(int) getSelectedItemIndex {
    return 0;
}

-(void) selectListItemAt:(int) index {
    
}

@end
