//
//  WizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WIZARD_ITEM_HEADTRACKER 0
#define WIZARD_ITEM_DEVICE 1
#define WIZARD_ITEM_VIRTUAL_DEVICE 2

typedef NS_ENUM(NSInteger, WizardItemChangeAction)
{
    WizardItemChangeActionNone = 0,
    WizardItemChangeActionCascade = 1
};

typedef NS_ENUM(NSInteger, WizardItemNotReadyAction)
{
    WizardItemNotReadyActionBreak = 0,
    WizardItemNotReadyActionContinue = 1
};

@interface WizardItem : NSObject

@property (strong, nonatomic, readonly) NSString * title;
@property (strong, nonatomic, readonly) NSString * info;
@property (assign, nonatomic) int count;
@property (assign, nonatomic, readonly) int itemId;
@property (strong, nonatomic) NSString * valueId;
@property (assign, nonatomic) int valueIndex;

- (instancetype)initWith:(NSString *) title info:(NSString *) info itemId:(int) itemId;

-(WizardItemChangeAction) changeAction;
-(WizardItemNotReadyAction) notReadyAction;

-(void) chainUpdated;
-(void) reset;
-(BOOL) ready;
-(BOOL) endpoint;
-(BOOL) available;
-(void) loadForIdentity:(NSString *) identity;
-(NSString *) stringForIndex:(int) index;
-(void) selectedIndex:(int) index;

@end
