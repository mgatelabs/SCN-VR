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
#import "WizardItem.h"
#import "ProfileInstance.h"

@interface WizardManager : NSObject

@property (strong, nonatomic) NSMutableArray * baseItems;
@property (strong, nonatomic) NSMutableArray * extendedItems;
@property (strong, nonatomic) NSMutableArray * filteredItems;
@property (strong, nonatomic) NSMutableArray * visibleItems;

@property (assign, nonatomic, readonly) BOOL dirty;
@property (assign, nonatomic) int profileIndex;
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

-(void) verify;

-(void) makeDirty;

-(WizardItem *) findWizardItemWithIdentity:(int) identity;
-(int) findWizardIdexWithIdentity:(int) identity;

@end
