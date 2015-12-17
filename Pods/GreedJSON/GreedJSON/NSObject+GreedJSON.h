//
//  NSObject+GreedJSON.h
//  Pods
//
//  Created by Bell on 15/11/3.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GreedJSON)

#pragma mark - property getter

/**
 *  the property names only in this class
 */
- (NSArray*)gr_propertyNames;

/**
 *  the property names in this class and all super classes
 */
- (NSMutableArray*)gr_allPropertyNames;

- (NSMutableArray*)gr_allIgnoredPropertyNames;
- (NSMutableDictionary*)gr_allReplacedPropertyNames;
- (NSMutableDictionary*)gr_allClassInArray;

#pragma mark - Property init

/**
 *  whether use [NSNull null] to replace nil
 *  default NO
 *
 *  @return BOOL
 */
+ (BOOL)gr_useNullProperty;

+ (NSArray*)gr_ignoredPropertyNames;

/**
 *  @{propertyName:dictionaryKey}
 *
 */
+ (NSDictionary*)gr_replacedPropertyNames;

+ (NSDictionary *)gr_classInArray;

#pragma mark - Foundation

- (BOOL)gr_isFromFoundation;

#pragma mark - parse

/**
 *  update Model with NSDictionary
 */
- (instancetype)gr_setDictionary:(NSDictionary*)dictionary;

/**
 *  NSDictionary to Model
 */
+ (id)gr_objectFromDictionary:(NSDictionary*)dictionary;

/**
 *  get NSMutableDictionary for the model based from NSObject, if gr_isFromFoundation will return self
 *
 *  @return if gr_isFromFoundation return self,else return NSMutableDictionary
 */
- (__kindof NSObject *)gr_dictionary;

@end
