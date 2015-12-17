//
//  JsonFMDBQueue.m
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import "JsonFMDBQueue.h"
#import "FMDatabaseAdditions.h"

@implementation JsonFMDBQueue

- (instancetype)initWithTableName:(NSString *)tableName isBlob:(BOOL)isBlob
{
    self = [super init];
    if (self) {
        self.tableName = [NSString stringWithFormat:@"%@_json",tableName];
        _createKeyIndex = YES; // key 索引
        _createFilterIndex = YES;
        _createSortIndex = NO;
        _blobData = isBlob;
        [self createTable];
    }
    return self;
}

- (instancetype)initWithTableName:(NSString *)tableName
{
    self = [super init];
    if (self) {
        self.tableName = [NSString stringWithFormat:@"%@_json",tableName];
        _createKeyIndex = YES; // key 索引
        _createFilterIndex = YES;
        _createSortIndex = NO;
        _blobData = NO;
        [self createTable];
    }
    return self;
}

- (BOOL)createTable
{
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db){
        if (![db tableExists:self.tableName]) {
            NSString *sql;
            if (_blobData) {
                sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value BLOB, filter TEXT ,sort INTEGER)",self.tableName];
            }
            else{
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

- (BOOL)saveWithModel:(GRDatabaseDefaultModel *)model
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

- (NSString *)getValueByKey:(NSString*)key
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@ WHERE key = \"%@\" LIMIT 1",self.tableName,key];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs stringForColumn:@"value"];
        }
    }];
    return value;
}

- (NSString *)getValueByKey:(NSString *)key filter:(NSString *)filter
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@ WHERE key = \"%@\"", self.tableName, key] ;
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendString:@" LIMIT 1"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs stringForColumn:@"value"];
        }
    }];
    return value;
}

- (NSArray*)getAllKeys
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",self.tableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *key = [rs stringForColumn:@"key"];
            [array addObject:key];
        }
    }];
    return array;
}

- (BOOL)delByKey:(NSString*)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE key = \"%@\"",self.tableName,key];
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByKey:(NSString *)key filter:(NSString *)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE key = \"%@\"",self.tableName,key];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

#pragma mark - sort

- (NSArray*)getAllKeysBySort:(BOOL)sort
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql;
        if (sort) {
            sql = [NSString stringWithFormat:@"SELECT key FROM %@ ORDER by sort",self.tableName];
        } else {
            sql = [NSString stringWithFormat:@"SELECT key FROM %@ ORDER by sort DESC",self.tableName];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *key = [rs stringForColumn:@"key"];
            [array addObject:key];
        }
    }];
    return array;
}

- (NSString*)getLastKey
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@ ORDER BY sort LIMIT 1",self.tableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

- (NSString*)getFirstKey
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@ ORDER BY sort DESC LIMIT 1",self.tableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

- (NSDictionary *)getDictByKey:(NSString *)key
{
    NSString *value = [self getValueByKey:key];
    NSData *jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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

- (NSString *)getPath
{
    return self.dbPath;
}
@end
