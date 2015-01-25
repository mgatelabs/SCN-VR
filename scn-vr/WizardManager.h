//
//  WizardManager.h
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WizardItem.h"
#import "ProfileInstance.h"

@interface WizardManager : NSObject

@property (strong, nonatomic) NSMutableArray * baseItems;
@property (strong, nonatomic) NSMutableArray * extendedItems;
@property (strong, nonatomic) NSMutableArray * filteredItems;
@property (strong, nonatomic) NSMutableArray * visibleItems;

@property (assign, nonatomic, readonly) BOOL dirty;

@property (assign, nonatomic, readonly) int profileItemCount;
@property (assign, nonatomic, readonly) int extenedItemCount;

-(void) item:(int) item changedTo:(int) index;
-(int) item:(int) item;
-(void) reset;
-(void) filter;

-(NSMutableDictionary *) extractItem;
-(void) insertItem:(NSDictionary *) payload;

-(ProfileInstance *) buildProfileInstance;

-(void) addExtendedItem:(WizardItem *) item;

@end
