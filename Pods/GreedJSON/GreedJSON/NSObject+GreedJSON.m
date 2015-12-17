//
//  NSObject+GreedJSON.m
//  Pods
//
//  Created by Bell on 15/11/3.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "NSObject+GreedJSON.h"
#import <objc/runtime.h>
#import "GRJSONHelper.h"

@implementation NSObject (GreedJSON)

#pragma mark - property getter

- (NSArray*)gr_propertyNames
{
    return [GRJSONHelper propertyNames:[self class]];
}

- (NSMutableArray*)gr_allPropertyNames
{
    return [GRJSONHelper allPropertyNames:[self class]];
}

- (NSMutableArray*)gr_allIgnoredPropertyNames
{
    return [GRJSONHelper allIgnoredPropertyNames:[self class]];
}

- (NSMutableDictionary*)gr_allReplacedPropertyNames
{
    return [GRJSONHelper allReplacedPropertyNames:[self class]];
}

- (NSMutableDictionary*)gr_allClassInArray
{
    return [GRJSONHelper allClassInArray:[self class]];
}

#pragma mark - Property init

+ (BOOL)gr_useNullProperty
{
    return NO;
}

+ (NSArray*)gr_ignoredPropertyNames
{
    NSArray *array = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        array = [superClass gr_ignoredPropertyNames];
    }
    return array;
}

+ (NSDictionary*)gr_replacedPropertyNames
{
    NSDictionary *dictionary = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        dictionary = [superClass gr_replacedPropertyNames];
    }
    return dictionary;
}

+ (NSDictionary *)gr_classInArray
{
    NSDictionary *dictionary = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        dictionary = [superClass gr_classInArray];
    }
    return dictionary;
}

#pragma mark - Foundation

- (BOOL)gr_isFromFoundation
{
    return [GRJSONHelper isClassFromFoundation:[self class]];
}

#pragma mark - parse

- (instancetype)gr_setDictionary:(NSDictionary*)dictionary
{
    Class aClass = [self class];
    NSArray *ignoredPropertyNames = [self gr_allIgnoredPropertyNames];
    NSDictionary *replacedPropertyNames = [self gr_allReplacedPropertyNames];
    
    NSArray *propertyNames = [GRJSONHelper allPropertyNames:aClass];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = (NSString *)obj;
        if (ignoredPropertyNames && [ignoredPropertyNames containsObject:key]) {
            return;
        }
        if ([GRJSONHelper isPropertyReadOnly:aClass propertyName:key]) {
            return;
        }
        
        NSString *dictKey= nil;
        dictKey = [replacedPropertyNames objectForKey:key];
        if (!dictKey) {
            dictKey = key;
        }
        
        id value = [dictionary valueForKey:dictKey];
        if (value == [NSNull null] || value == nil) {
            return;
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) { // handle dictionary
            Class klass = [GRJSONHelper propertyClassForPropertyName:key ofClass:aClass];
            if (klass == [NSDictionary class]) {
                [self setValue:value forKey:key];
            } else {
                [self setValue:[[klass class] gr_objectFromDictionary:value] forKey:key];
            }
        } else if ([value isKindOfClass:[NSArray class]]) { // handle array
            NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)value count]];
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj class] isSubclassOfClass:[NSDictionary class]]) {
                    Class arrayItemClass = [[self gr_allClassInArray] objectForKey:key];
                    if (!arrayItemClass || arrayItemClass == [NSDictionary class]) {
                        [childObjects addObject:obj];
                    } else {
                        NSObject *child = [[arrayItemClass class] gr_objectFromDictionary:obj];
                        [childObjects addObject:child];
                    }
                } else {
                    [childObjects addObject:obj];
                }
            }];
            if (childObjects.count) {
                [self setValue:childObjects forKey:key];
            }
        } else {
            // handle all others
            [self setValue:value forKey:key];
        }
    }];
    return self;
}

+ (instancetype)gr_objectFromDictionary:(NSDictionary*)dictionary
{
    return [[[self alloc] init] gr_setDictionary:dictionary];
}

- (__kindof NSObject *)gr_dictionary
{
    if ([self gr_isFromFoundation]) {
        return self;
    }
    
    Class aClass = [self class];
    NSArray *ignoredPropertyNames = [self gr_allIgnoredPropertyNames];
    NSDictionary *replacedPropertyNames = [self gr_allReplacedPropertyNames];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *propertyNames = [GRJSONHelper allPropertyNames:[self class]];
    
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = (NSString*)obj;
        if (ignoredPropertyNames && [ignoredPropertyNames containsObject:obj]) {
            return;
        }
        id value = [self valueForKey:key];
        NSString *dictKey= nil;
        dictKey = [replacedPropertyNames objectForKey:key];
        if (!dictKey) {
            dictKey = key;
        }
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSUInteger count = ((NSArray*)value).count;
                if (count) {
                    NSMutableArray *internalItems = [[NSMutableArray alloc] initWithCapacity:count];
                    [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [internalItems addObject:[obj gr_dictionary]];
                    }];
                    [dic setObject:internalItems forKey:dictKey];
                }
            } else if ([value gr_isFromFoundation]) {
                [dic setObject:value forKey:dictKey];
            } else {
                [dic setObject:[value gr_dictionary] forKey:dictKey];
            }
        } else {
            if ([aClass gr_useNullProperty]) {
                [dic setObject:[NSNull null] forKey:dictKey];
            }
        }
    }];
    
    return dic;
}

#pragma mark - private

@end
