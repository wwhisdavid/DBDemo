//
//  DaoFactory+NPN.h
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import "DaoFactory.h"
#import "JsonDao.h"
@interface DaoFactory (NPN)

+ (id<JsonDao>)getDemoDao;

+ (id<JsonDao>)getObjectDao;

+ (id<JsonDao>)getFilterObjectDao;

+ (id<JsonDao>)getImageDao;

@end
