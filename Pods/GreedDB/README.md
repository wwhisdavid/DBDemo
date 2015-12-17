<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [GreedDB [![Join the chat at https://gitter.im/greedlab/GreedDB](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/greedlab/GreedDB?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/greedlab/GreedDB.svg?branch=master)](https://travis-ci.org/greedlab/GreedDB)](#greeddb-join-the-chat-at-httpsgitterimgreedlabgreeddbhttpsbadgesgitterimjoinchatsvghttpsgitterimgreedlabgreeddbutm_sourcebadge&utm_mediumbadge&utm_campaignpr-badge&utm_contentbadge-build-statushttpstravis-ciorggreedlabgreeddbsvgbranchmasterhttpstravis-ciorggreedlabgreeddb)
- [Installation](#installation)
- [Usage](#usage)
  - [[GRDatabaseDefaultQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultQueue.h)](#grdatabasedefaultqueuehttpsgithubcomgreedlabgreeddbblobmastergreeddbgrdatabasedefaultqueueh)
  - [[GRDatabaseMultFilterQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseMultFilterQueue.h)](#grdatabasemultfilterqueuehttpsgithubcomgreedlabgreeddbblobmastergreeddbgrdatabasemultfilterqueueh)
- [Release Notes](#release-notes)
- [LICENSE](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# GreedDB [![Join the chat at https://gitter.im/greedlab/GreedDB](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/greedlab/GreedDB?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/greedlab/GreedDB.svg?branch=master)](https://travis-ci.org/greedlab/GreedDB) 

 A storage for ios. based on [FMDB](https://github.com/ccgus/fmdb) and [GreedJSON](https://github.com/greedlab/GreedJSON). can save NSDictionary,NSArray,NSData,NSString,NSNumber or NSObject  directly
# Installation
pod 'GreedDB'
# Usage
## [GRDatabaseDefaultQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultQueue.h)
storage for the model [GRDatabaseDefaultModel](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultModel.h)
``` objc
- (void)initDefault
{
    self.database = [[GRDatabaseDefaultQueue alloc] init];
    NSLog(@"%@",_database.dbPath);
    
    [_database setTableName:@"testDefault"];
    [_database setCreateFilterIndex:YES];
    [_database setCreateKeyIndex:YES];
    [_database setCreateSortIndex:YES];
    
    [_database recreateTable];
}

- (void)saveDefault
{
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"string";
    model.integer =  1;
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@1];
    [dbModel setValue:model];
    [dbModel setFilter:filter];
    
    [_database saveWithModel:dbModel];
}

- (void)updateDefault
{
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"update";
    model.integer =  2;
    
    [_database updateValue:model byKey:@1 filter:filter];
}

- (void)getDefault
{
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    NSArray *array = [_database getValuesByKey:@1 filter:filter];
    
    NSLog(@"%@",array);
}
```
## [GRDatabaseMultFilterQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseMultFilterQueue.h)
used for getting value from mult filters. eg :search with more keys

``` objc
- (void)initMultFilter
{
    self.multFilterQueue = [[GRDatabaseMultFilterQueue alloc] init];
    NSLog(@"%@",_multFilterQueue.dbPath);
    [_multFilterQueue setValueName:[GRTestMultFilterModel valueName]];
    [_multFilterQueue setFilterNames:[GRTestMultFilterModel filterNames]];
    [_multFilterQueue setTableName:@"testMultFilter"];
    [_multFilterQueue recreateTable];
}

- (void)saveMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.value = @"value";
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    [_multFilterQueue saveWithValueFiltersDictionary:[model gr_dictionary]];
}

- (void)getMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    NSArray *array = [_multFilterQueue getValuesByFiltersDictionary:[model gr_noNUllDictionary]];
    NSLog(@"%@",array);
}

- (void)delMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    [_multFilterQueue delByValueFiltersDictionary:[model gr_noNUllDictionary]];
}
```
# Release Notes
* 0.0.1 first version
* 0.0.2 add limit to GRDatabaseDefaultQueue
* 0.0.3 replace MJExtension with GreedJSON
* 0.0.5 whether create index is customed now

# LICENSE
MIT
