//
//  GRDatabaseDefaultQueue.h
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseBaseQueue.h"
#import "GRDatabaseDefaultModel.h"

/**
 *  process database
 */
@interface GRDatabaseDefaultQueue : GRDatabaseBaseQueue

/**
 *  whether value is NSData. default NO
 */
@property(nonatomic,assign)BOOL blobValue;

/**
 *  create key index when creating table. default NO
 */
@property(nonatomic,assign)BOOL createKeyIndex;

/**
 *  create filter index when creating table. default NO
 */
@property(nonatomic,assign)BOOL createFilterIndex;

/**
 *  create sort index when creating table. default NO
 */
@property(nonatomic,assign)BOOL createSortIndex;

#pragma mark - save

/**
 *  save model
 *
 *  first call delByKey:filter:
 *  then call saveWithModel:
 *
 *  @param model    model
 *
 *  @return whether success
 */
- (BOOL)delByFilterAndSaveWithModel:(GRDatabaseDefaultModel*)model;

/**
 *  save model
 *
 *  first call delByKey:
 *  then call saveWithModel:
 *
 *  @param model    model
 *
 *  @return whether success
 */
- (BOOL)delAndSaveWithModel:(GRDatabaseDefaultModel*)model;

/**
 *  save model
 */
- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model;

/**
 * sort: YES - ascend , NO - descend
 * filter: if nil get the value of filter is null
 * limit: if limit = 0 do not limit
 */
#pragma mark - sort - filter

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter sort:(BOOL)sort limit:(NSUInteger)limit;
- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter sort:(BOOL)sort;

- (NSMutableArray*)getKeysByFilter:(id)filter sort:(BOOL)sort limit:(NSUInteger)limit;
- (NSMutableArray*)getKeysByFilter:(id)filter sort:(BOOL)sort;

- (id)getFirstKeyByFilter:(id)filter;
- (id)getLastKeyByFilter:(id)filter;

/**
 * sort: YES - ascend , NO - descend
 * filter: no filter
 * limit: if limit = 0 do not limit
 */
#pragma mark - sort  - no filter

- (NSMutableArray*)getValuesByKey:(id)key sort:(BOOL)sort limit:(NSUInteger)limit;
- (NSMutableArray*)getValuesByKey:(id)key sort:(BOOL)sort;

- (NSMutableArray*)getKeysBySort:(BOOL)sort limit:(NSUInteger)limit;
- (NSMutableArray*)getKeysBySort:(BOOL)sort;

- (id)getFirstKey;
- (id)getLastKey;

/**
 * sort: no sort
 * filter: if nil get the value of filter is null
 * limit: if limit = 0 do not limit
 */
#pragma mark - no sort - filter

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter limit:(NSUInteger)limit;
- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter;

- (NSMutableArray*)getKeysByFilter:(id)filter limit:(NSUInteger)limit;
- (NSMutableArray*)getKeysByFilter:(id)filter;

- (id)getValueByKey:(id)key filter:(id)filter;

- (BOOL)updateValue:(id)value byKey:(id)key filter:(id)filter;

- (BOOL)delByFilter:(id)filter;
- (BOOL)delByKey:(id)key filter:(id)filter;

/**
 * sort: no sort
 * filter: no filter
 * limit: if limit = 0 do not limit
 */
#pragma mark - no sort - no filter

- (NSMutableArray*)getValuesByKey:(id)key limit:(NSUInteger)limit;
- (NSMutableArray*)getValuesByKey:(id)key;

- (NSMutableArray*)getKeysByLimit:(NSUInteger)limit;
- (NSMutableArray*)getKeys;

/**
 * sort: no or have sort
 * filter: no filter
 * limit: no limit
 */
#pragma mark - no or have sort - no filter

- (id)getValueByKey:(id)key;

- (BOOL)updateValue:(id)value byKey:(id)key;

- (BOOL)delByKey:(id)key;

@end
