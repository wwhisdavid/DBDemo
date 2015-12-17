//
//  BaseDao.h
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseDao <NSObject>

- (BOOL)createTable;
- (BOOL)clearTable;
- (BOOL)deleteTable;
- (BOOL)recreateTable;

@end
