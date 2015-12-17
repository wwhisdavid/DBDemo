//
//  JsonFMDBQueue.h
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import <GreedDB/GreedDB.h>
#import "JsonDao.h"
@interface JsonFMDBQueue : GRDatabaseBaseQueue<JsonDao>

@property (nonatomic, assign) BOOL createKeyIndex;
@property (nonatomic, assign) BOOL createFilterIndex;
@property (nonatomic, assign) BOOL createSortIndex;
@property (nonatomic, assign) BOOL blobData;

- (instancetype)initWithTableName:(NSString*)tableName;
- (instancetype)initWithTableName:(NSString*)tableName isBlob:(BOOL)isBlob;

@end
