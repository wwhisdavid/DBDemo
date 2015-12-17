//
//  NSData+GreedJSON.m
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import "NSData+GreedJSON.h"

@implementation NSData (GreedJSON)

- (id)gr_object
{
    NSError *error;

    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"** GreedJSON ** %@",[error localizedDescription]);
        return nil;
    }
    return object;
}

- (id)gr_objectWithOptions:(NSJSONReadingOptions)options
{
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:self options:options error:&error];
    if (error) {
        NSLog(@"** GreedJSON ** %@",[error localizedDescription]);
        return nil;
    }
    return object;
}

@end
