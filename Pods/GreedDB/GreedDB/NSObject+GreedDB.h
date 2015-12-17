//
//  NSObject+GreedDB.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GreedJSON/GreedJSON.h>

@interface NSObject (GreedDB)

+ (id)ModelWithJsonString:(NSString*)jsonString;

- (NSString *)gr_autoJSONString;
- (NSMutableDictionary*)gr_noNUllDictionary;

@end
