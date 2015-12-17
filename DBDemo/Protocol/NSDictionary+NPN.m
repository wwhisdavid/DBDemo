//
//  NSDictionary+NPN.m
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import "NSDictionary+NPN.h"

@implementation NSDictionary (NPN)

- (NSString *)jsonString
{
    NSData *data = [self jsonData];
    if (data) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        return nil;
    }
}

- (NSData*)jsonData
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    return data;
}
@end
