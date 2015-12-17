//
//  NSDictionary+GreedJSON.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GreedJSON)

- (NSString*)gr_JSONString;
- (NSData*)gr_JSONData;

@end
