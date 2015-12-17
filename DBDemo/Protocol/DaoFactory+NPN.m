//
//  DaoFactory+NPN.m
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import "DaoFactory+NPN.h"
#import "JsonFMDBQueue.h"

@implementation DaoFactory (NPN)

+ (id<JsonDao>)getDemoDao
{
    static id<JsonDao> dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[JsonFMDBQueue alloc] initWithTableName:@"Demo"];
    });
    return dao;
}

+ (id<JsonDao>)getObjectDao
{
    static id<JsonDao> dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[JsonFMDBQueue alloc] initWithTableName:@"Object"];
    });
    return dao;
}

+ (id<JsonDao>)getFilterObjectDao
{
    static id<JsonDao> dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[JsonFMDBQueue alloc] initWithTableName:@"FilterObject"];
    });
    return dao;
}

+ (id<JsonDao>)getImageDao
{
    static id<JsonDao> dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[JsonFMDBQueue alloc] initWithTableName:@"Image" isBlob:YES];
    });
    return dao;
}


@end
