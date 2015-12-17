//
//  GRDatabaseMultFilterQueue.h
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseBaseQueue.h"

/**
 *  get the key from mult filters. eg : used for search with mult keys
 */
@interface GRDatabaseMultFilterQueue : GRDatabaseBaseQueue

@property(nonatomic,strong)NSArray<NSString*> *filterNames;
@property(nonatomic,strong)NSString *valueName;

/**
 *  create filter index when creating table. default NO
 */
@property(nonatomic,assign)BOOL createFilterIndex;


- (BOOL)saveWithValueFiltersDictionary:(NSDictionary*)dictionary;

- (NSMutableArray*)getValuesByFiltersDictionary:(NSDictionary*)dictionary;

- (BOOL)delByValueFiltersDictionary:(NSDictionary*)dictionary;

@end
