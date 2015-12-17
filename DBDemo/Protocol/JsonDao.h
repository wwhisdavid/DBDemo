//
//  JsonDao.h
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "GRDatabaseDefaultModel.h"
@protocol JsonDao <BaseDao>

/**
 *  save model
 */
- (BOOL)saveWithModel:(GRDatabaseDefaultModel *)model;

- (NSString *)getValueByKey:(NSString*)key;

- (NSArray*)getAllKeys;

- (BOOL)delByKey:(NSString*)key;

- (NSString *)getValueByKey:(NSString*)key filter:(NSString *)filter;

- (BOOL)delByKey:(NSString*)key filter:(NSString *)filter;

#pragma mark - sort

- (NSArray*)getAllKeysBySort:(BOOL)sort;

- (NSString*)getLastKey;

- (NSString*)getFirstKey;

- (NSString *)getPath;

@optional

- (NSDictionary *)getDictByKey:(NSString *)key;

@end
