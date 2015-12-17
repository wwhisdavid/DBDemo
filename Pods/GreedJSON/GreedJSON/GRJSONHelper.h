//
//  GRJSONHelper.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

@interface GRJSONHelper : NSObject

+ (BOOL)isPropertyReadOnly:(Class)aClass propertyName:(NSString*)propertyName;

/**
 *  get the class of a property [propertyName] for the class [aClass]
 *
 *  @param propertyName property
 *  @param aClass        class
 *
 *  @return the class of a property
 */
+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)aClass;

/**
 *  all properties in aClass and super class
 *
 *  @param aClass Class
 *
 *  @return properties
 */
+ (NSMutableArray *)allPropertyNames:(Class)aClass;

/**
 *  the properties in aClass, no super class
 *
 *  @param aClass Class
 *
 *  @return properties
 */
+ (NSArray *)propertyNames:(Class)aClass;

+ (NSMutableArray*)allIgnoredPropertyNames:(Class)aClass;
+ (NSMutableDictionary*)allReplacedPropertyNames:(Class)aClass;
+ (NSMutableDictionary*)allClassInArray:(Class)aClass;

#pragma mark - Foundation

+ (NSSet *)foundationClasses;
+ (BOOL)isClassFromFoundation:(Class)aClass;

@end
