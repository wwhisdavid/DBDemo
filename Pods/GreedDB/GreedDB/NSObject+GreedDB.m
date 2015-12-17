//
//  NSObject+GreedDB.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "NSObject+GreedDB.h"
#import "GreedJSON.h"

@implementation NSObject (GreedDB)

#pragma mark - public

+ (id)ModelWithJsonString:(NSString*)jsonString
{
    NSDictionary *dictionary = [jsonString gr_object];
    return [[self class] gr_objectFromDictionary:dictionary];
}

- (NSString *)gr_autoJSONString
{
    if (self) {
        if ([self isKindOfClass:[NSString class]]) {
            return (NSString*)self;
        } else if ([self isKindOfClass:[NSDictionary class]]) {
            return [(NSDictionary*)self gr_JSONString];
        } else if ([self isKindOfClass:[NSArray class]]) {
            return [(NSArray*)self gr_JSONString];
        } else if ([self isKindOfClass:[NSData class]]) {
            /* modified */
            NSString *data =  [[NSString alloc] initWithData:(NSData*)self encoding:NSUTF8StringEncoding];
            if(!data) data = [(NSData *)self base64EncodedStringWithOptions:0];
            return data;
        } else if ([self isKindOfClass:[NSNumber class]]) {
            return [(NSNumber*)self stringValue];
        } else {
            NSDictionary *dictionary = [self gr_dictionary];
            return [dictionary gr_JSONString];
        }
    } else {
        return nil;
    }
}

- (NSMutableDictionary*)gr_noNUllDictionary
{
    NSMutableDictionary *dictionary = [self gr_dictionary];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == [NSNull null]) {
            [dictionary removeObjectForKey:key];
        }
    }];
    return dictionary;
}

@end
