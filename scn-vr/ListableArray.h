//
//  ListableManager.h
//  scn-vr
//
//  Created by Michael Fuller on 12/23/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ListableManagerType)
{
    ListableManagerTypeSimple = 0,
    ListableManagerTypeDetail = 1,
    ListableManagerTypeList = 2
};

@interface ListableArray : NSObject

-(ListableManagerType) getListType;
-(NSString *) getListName;
-(NSString *) getListItemNameFor:(int) index;
-(int) getListItemCount;
-(int) getSelectedItemIndex;
-(void) selectListItemAt:(int) index;

@end
