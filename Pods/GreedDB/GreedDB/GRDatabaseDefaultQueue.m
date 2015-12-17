//
//  GRDatabaseDefaultQueue.m
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefaultQueue.h"
#import "FMDatabaseAdditions.h"
#import "NSObject+GreedDB.h"

@implementation GRDatabaseDefaultQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _blobValue = NO;
        _createKeyIndex = NO;
        _tableName = @"defaultQueue";
    }
    return self;
}

#pragma mark - GRDatabaseBaseQueue

- (BOOL)createTable
{
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db){
        if (![db tableExists:self.tableName]) {
            NSString *sql;
            if (_blobValue) {
                sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value BLOB, filter TEXT ,sort INTEGER)",self.tableName];
            } else {
                sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value TEXT, filter TEXT ,sort INTEGER)",self.tableName];
            }
            
            result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"error to run %@",sql);
            } else {
                if (_createKeyIndex) {
                    NSString *sql = [NSString stringWithFormat:@"CREATE INDEX %@_index_key ON %@ (key)",self.tableName,self.tableName];
                    result = [db executeUpdate:sql];
                    if (!result) {
                        NSLog(@"error to run %@",sql);
                    }
                }
                
                if (_createFilterIndex) {
                    NSString *sql = [NSString stringWithFormat:@"CREATE INDEX %@_index_filter ON %@ (filter)",self.tableName,self.tableName];
                    result = [db executeUpdate:sql];
                    if (!result) {
                        NSLog(@"error to run %@",sql);
                    }
                }
                
                if (_createSortIndex) {
                    NSString *sql = [NSString stringWithFormat:@"CREATE INDEX %@_index_sort ON %@ (sort)",self.tableName,self.tableName];
                    result = [db executeUpdate:sql];
                    if (!result) {
                        NSLog(@"error to run %@",sql);
                    }
                }
            }
        }
    }];
    return result;
}

#pragma mark - save

- (BOOL)delByFilterAndSaveWithModel:(GRDatabaseDefaultModel*)model
{
    [self delByKey:model.key filter:model.filter];
    return [self saveWithModel:model];
}

- (BOOL)delAndSaveWithModel:(GRDatabaseDefaultModel*)model;
{
    [self delByKey:model.key];
    return [self saveWithModel:model];
}

- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES(:key, :value, :filter, :sort) ",self.tableName];
        result = [db executeUpdate:sql withParameterDictionary:[model dbDictionary]];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

#pragma mark - sort - filter

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter sort:(BOOL)sort limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter sort:(BOOL)sort
{
    return [self getValuesByKey:key filter:filter sort:sort limit:0];
}

- (NSMutableArray*)getKeysByFilter:(id)filter sort:(BOOL)sort limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id key = [rs objectForColumnName:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getKeysByFilter:(id)filter sort:(BOOL)sort
{
    return [self getKeysByFilter:filter sort:sort limit:0];
}

- (id)getFirstKeyByFilter:(id)filter
{
    NSMutableArray *array = [self getKeysByFilter:filter sort:YES limit:1];
    return array.count ? [array firstObject] : nil;
}

- (id)getLastKeyByFilter:(id)filter;
{
    NSMutableArray *array = [self getKeysByFilter:filter sort:NO limit:1];
    return array.count ? [array firstObject] : nil;
}

/**
 * sort: YES - ascend , NO - descend
 * filter: no filter
 */
#pragma mark - sort  - no filter

- (NSMutableArray*)getValuesByKey:(id)key sort:(BOOL)sort limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getValuesByKey:(id)key sort:(BOOL)sort
{
    return [self getValuesByKey:key sort:sort limit:0];
}

- (NSMutableArray*)getKeysBySort:(BOOL)sort limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id key = [rs objectForColumnName:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getKeysBySort:(BOOL)sort
{
    return [self getKeysBySort:sort limit:0];
}

- (id)getFirstKey
{
    NSMutableArray *array = [self getKeysBySort:YES limit:1];
    return array.count ? [array firstObject] : nil;
}

- (id)getLastKey
{
    NSMutableArray *array = [self getKeysBySort:NO limit:1];
    return array.count ? [array firstObject] : nil;
}

/**
 * sort: no sort
 * filter: if nil get the value of filter is null
 */
#pragma mark - no sort - filter

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getValuesByKey:(id)key filter:(id)filter
{
    return [self getValuesByKey:key filter:filter limit:0];
}

- (NSMutableArray*)getKeysByFilter:(id)filter limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id key = [rs objectForColumnName:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getKeysByFilter:(id)filter
{
    return [self getKeysByFilter:filter limit:0];
}

- (id)getValueByKey:(id)key filter:(id)filter
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs objectForColumnName:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(id)value byKey:(id)key filter:(id)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET value = ?",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        result = [db executeUpdate:sql,[value gr_autoJSONString]];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByFilter:(id)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByKey:(id)key filter:(id)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

/**
 * sort: no sort
 * filter: no filter
 */
#pragma mark - no sort - no filter

- (NSMutableArray*)getValuesByKey:(id)key limit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getValuesByKey:(id)key
{
    return [self getValuesByKey:key limit:0];
}

- (NSMutableArray*)getKeysByLimit:(NSUInteger)limit
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@",self.tableName];
        
        if (limit) {
            [sql appendFormat:@" LIMIT %@",@(limit)];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id key = [rs objectForColumnName:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array;
}

- (NSMutableArray*)getKeys
{
    return [self getKeysByLimit:0];
}

#pragma mark - no or have sort - no filter

- (id)getValueByKey:(id)key
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs objectForColumnName:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(id)value byKey:(id)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET value = ?",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        result = [db executeUpdate:sql,[value gr_JSONString]];
        
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByKey:(id)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}


@end
