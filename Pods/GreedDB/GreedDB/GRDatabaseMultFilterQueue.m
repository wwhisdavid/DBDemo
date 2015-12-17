//
//  GRDatabaseMultFilterQueue.m
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseMultFilterQueue.h"
#import "FMDatabaseAdditions.h"

@implementation GRDatabaseMultFilterQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableName = @"multFilterQueue";
        _valueName = @"value";
    }
    return self;
}

#pragma mark - GRDatabaseBaseQueue

- (BOOL)createTable
{
    if (_filterNames.count == 0) {
        return NO;
    }
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db){
        if (![db tableExists:self.tableName]) {
            NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@",self.tableName];
            
            [sql appendFormat:@" (%@ TEXT,",self.valueName];
            for (NSInteger index = 0; index < _filterNames.count; index++) {
                NSString *filter = [_filterNames objectAtIndex:index];
                [sql appendString: (index == _filterNames.count - 1) ? [NSString stringWithFormat:@" %@ TEXT)",filter] : [NSString stringWithFormat:@" %@ TEXT,",filter]];
            }
            result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"error to run : %@",sql);
            } else {
                if (_createFilterIndex) {
                    for (NSInteger index = 0; index < _filterNames.count; index++) {
                        NSString *filter = [_filterNames objectAtIndex:index];
                        NSString *filterIndex = [NSString stringWithFormat:@"%@Index",filter];
                        {
                            NSString *sql = [NSString stringWithFormat:@"CREATE INDEX %@ ON %@ (%@)",filterIndex,self.tableName,filter];
                            result = [db executeUpdate:sql];
                            if (!result) {
                                NSLog(@"error to run : %@",sql);
                            }
                        }
                    }
                }
            }
        }
    }];
    return result;
}

#pragma mark - public

- (BOOL)saveWithValueFiltersDictionary:(NSDictionary*)dictionary
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES",self.tableName];
        [sql appendFormat:@" (:%@,",self.valueName];
        for (NSInteger index = 0; index < _filterNames.count; index++) {
            NSString *filter = [_filterNames objectAtIndex:index];
            [sql appendString: (index == _filterNames.count - 1) ? [NSString stringWithFormat:@" :%@)",filter] : [NSString stringWithFormat:@" :%@,",filter]];
        }
        result = [db executeUpdate:sql withParameterDictionary:dictionary];
        if (!result) {
            NSLog(@"error to run : %@",sql);
        }
    }];
    return result;
}

- (NSMutableArray*)getValuesByFiltersDictionary:(NSDictionary*)dictionary
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@",_valueName, _tableName];
        NSArray *keys = [dictionary allKeys];
        for (NSInteger index = 0; index < keys.count; index++) {
            NSString *key = [keys objectAtIndex:index];
            [sql appendString:(index == 0) ? @" WHERE" : @" AND"];
            [sql appendFormat:@" %@ = ?",key];
        }
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:[dictionary allValues]];
        while ([rs next]) {
            id value = [rs objectForColumnIndex:0];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (BOOL)delByValueFiltersDictionary:(NSDictionary*)dictionary;
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        NSArray *keys = [dictionary allKeys];
        for (NSInteger index = 0; index < keys.count; index++) {
            NSString *key = [keys objectAtIndex:index];
            [sql appendString:(index == 0) ? @" WHERE" : @" AND"];
            [sql appendFormat:@" %@ = ?",key];
        }
        result = [db executeUpdate:sql withArgumentsInArray:[dictionary allValues]];
        if (!result) {
            NSLog(@"error to run : %@",sql);
        }
    }];
    return result;
}

@end
