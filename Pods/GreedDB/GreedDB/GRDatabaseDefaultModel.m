//
//  GRDatabaseDefaultModel.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefaultModel.h"
#import "NSObject+GreedDB.h"

@implementation GRDatabaseDefaultModel

+ (NSArray *)gr_ignoredPropertyNames
{
    return @[@"value"];
}

+ (BOOL)gr_useNullProperty
{
    return YES;
}

- (NSMutableDictionary *)dbDictionary
{
    NSMutableDictionary *keyValues = [self gr_dictionary];
    NSString *value = [_value gr_autoJSONString];
    if (value) {
        [keyValues setValue:value forKey:@"value"];
    } else {
        [keyValues setValue:[NSNull null] forKey:@"value"];
    }
    return keyValues;
}

@end
