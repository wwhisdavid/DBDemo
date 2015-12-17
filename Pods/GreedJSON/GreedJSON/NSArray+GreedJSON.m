//
//  NSArray+GreedJSON.m
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import "NSArray+GreedJSON.h"

@implementation NSArray (GreedJSON)

- (NSString*)gr_JSONString
{
    NSData *data = [self gr_JSONData];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }

}

- (NSData*)gr_JSONData
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"** GreedJSON ** %@",[error localizedDescription]);
        return nil;
    }
    return data;
}

@end
