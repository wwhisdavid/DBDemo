# GreedJSON [![Build Status](https://travis-ci.org/greedlab/GreedJSON.svg?branch=master)](https://travis-ci.org/greedlab/GreedJSON)
parse and format JSON for ios， based on NSJSONSerialization and run time
# Installation
pod 'GreedJSON'
# Usage
```objc
#import "GreedJSON.h"
```
## [NSArray+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSArray%2BGreedJSON.h)
```objc
// NSArray to NSString
- (NSString*)gr_JSONString;
// NSArray to NSData
- (NSData*)gr_JSONData;
```
## [NSData+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSData%2BGreedJSON.h)
```objc
// NSData to NSDictionary or NSArray
- (__kindof NSObject*)gr_object
```
## [NSDictionary+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSDictionary%2BGreedJSON.h)
```objc
// NSDictionary to NSString
- (NSString*)gr_JSONString;
// NSDictionary to NSData
- (NSData*)gr_JSONData;
```
## [NSString+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSString%2BGreedJSON.h)
```objc
// NSString to NSDictionary or NSArray
- (__kindof NSObject*)gr_object
```

## [NSObject+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSObject%2BGreedJSON.h)
```objc
// model to NSDictionary
- (__kindof NSObject *)gr_dictionary;
// NSDictionary to model
+ (id)gr_objectFromDictionary:(NSDictionary*)dictionary
```

# Release Notes
* 0.0.1 first version
* 0.0.2 change method toObject to gr_object
* 0.0.3 add model to NSDictionary and NSDictionary to model
* 0.0.5 change method to propertyNames to gr_propertyNames
* 0.0.8 delete gr_allowedPropertyNames and fix some bug
* 0.0.9 set value to ni if json string is '[]',because empty will be formated to '[]' in php

# LICENSE
MIT
