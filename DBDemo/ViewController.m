//
//  ViewController.m
//  DBDemo
//
//  Created by wwhisdavid on 15/12/15.
//  Copyright © 2015年 wwhisdavid. All rights reserved.
//

#import "ViewController.h"
#import "GRDatabaseDefaultModel.h"
#import "DaoFactory+NPN.h"
#import "JsonFMDBQueue.h"
#import "GRDatabaseBaseQueue.h"
#import "Student.h"
#import "sqlite3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
    [self testDemo1]; // 存储普通字典数据
    [self testDemo2]; // 存储对象
    [self testDemo3]; // 带筛选存取数据
    [self testDemo4]; // 存储二进制文件（这里以图片为例）
    
    [self fetchData1]; // 从数据库获取普通字典数据
    [self fetchData2]; // 从数据库获取对象
    [self fetchData3]; // 取出筛选数据
    [self fetchData4]; // 读取二进制文件
    
    [self testSQL]; // SQLite数据库演示
    
    [self testFMDB]; // FMDB演示
}

- (void)testFMDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"FMDB.sqlite3"]; // 声明数据库路径
    
    FMDatabase *db = [[FMDatabase alloc] initWithPath:path]; // 创建数据库
    [db open]; // 打开
    
//    FMResultSet *set = [db executeQuery:query]; // 查询
//    [db executeUpdate:sql]; // 除查询外操作
//    [db executeUpdateWithFormat:@"%@", ....]; // 带format查询
//    
//    [set stringForColumn:];
}

- (void)testSQL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MyDB.sqlite3"]; // 声明数据库路径
    
    sqlite3 *db; // 声明数据库
    int status = sqlite3_open(path.UTF8String, &db); // 打开数据库
    if (status == SQLITE_OK) { // 表示打开成功
        const char *sql = "CREATE TABLE IF NOT EXISTS MYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATA TEXT)"; // 编辑sql代码，这是一个创表操作。
        char *errorMsg = NULL;
        sqlite3_exec(db, sql, NULL, NULL, &errorMsg); // 执行非查询语句
        if(errorMsg){
            
        }
        else{
        
        }
    }
    
    const char *query = "SELECT ID, DATA FROM FIELDS ORDER BY ROW"; // 查询操作语句（插入相同）
    
    sqlite3_stmt *statement;
    
    int status2 = sqlite3_prepare_v2(db, query, -1, &statement, NULL); // 执行查询操作，statement中包含查询结果
    if(status2 == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            const unsigned char *data = sqlite3_column_text(statement, 1); // 执行一次，移动一次step指针 。得到第一列的第一个结果数据。
        }
        sqlite3_finalize(statement);
    }
    
    //关闭数据库
    sqlite3_close(db);
    
}

// 模拟从网络获取的dict
- (void)testDemo1
{
    GRDatabaseDefaultModel *model = [[GRDatabaseDefaultModel alloc] init];
    for (int i = 0; i < 10; i ++) {
        NSDictionary *tempDict = [self getRandomDict];
        model.value = tempDict;
        model.key = [NSNumber numberWithInt:i];
        [[DaoFactory getDemoDao] delByKey:model.key];
        [[DaoFactory getDemoDao] saveWithModel:model];
    }
    
    NSLog(@"*********%@*************", [[DaoFactory getDemoDao] getPath]);
}

// 模拟对象存储
- (void)testDemo2
{
    GRDatabaseDefaultModel *model = [[GRDatabaseDefaultModel alloc] init];
    for (int i = 0; i < 10; i ++) {
        Student *stu = [[Student alloc] init];
        NSDictionary *tempDict = [self getRandomDict];
        stu.name = tempDict[@"name"];
        stu.age = tempDict[@"age"];
        
        model.value = stu;
        model.key = [NSNumber numberWithInt:i];
        [[DaoFactory getObjectDao] delByKey:model.key];
        [[DaoFactory getObjectDao] saveWithModel:model];
    }
}

// 模拟带filter的存取
- (void)testDemo3
{
    GRDatabaseDefaultModel *model = [[GRDatabaseDefaultModel alloc] init];
    for (int i = 0; i < 10; i ++) {
        Student *stu = [[Student alloc] init];
        NSDictionary *tempDict = [self getRandomDict];
        stu.name = tempDict[@"name"];
        stu.age = tempDict[@"age"];
        
        model.sort = 1;
        model.filter = @"tianming";
        model.value = stu;
        model.key = [NSNumber numberWithInt:i];
        
        [[DaoFactory getFilterObjectDao] delByKey:model.key filter:@"tianming"];
        [[DaoFactory getFilterObjectDao] saveWithModel:model];
    }
}

- (void)testDemo4
{
    NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"logo"]);
    GRDatabaseDefaultModel *model = [[GRDatabaseDefaultModel alloc] init];
    
    model.value = imgData; // 二进制的编解码目前框架只支持到文本utf-8，对于多媒体数据需要进行base64编解码再存储，这个问题暂时还没解决，这里强制修改了框架，只供参考。
    model.key = @10086;
    [[DaoFactory getImageDao] delByKey:@"10086"];
    [[DaoFactory getImageDao] saveWithModel:model];
}

// 获取数据库中所有字典
- (void)fetchData1
{
    NSArray *keys = [[DaoFactory getDemoDao] getAllKeys];
    for (NSString *key in keys) {
        NSDictionary *dict = [[DaoFactory getDemoDao] getDictByKey:key];
        NSLog(@"this is a tested dict:%@", dict);
    }
}

- (void)fetchData2
{
    NSArray *keys = [[DaoFactory getDemoDao] getAllKeys];
    for (NSString *key in keys) {
        NSDictionary *dict = [[DaoFactory getObjectDao] getDictByKey:key];
        NSLog(@"this is a tested dict:%@", dict);
        // 在这里解析字典转模型
    }
}

// 这里取出了tianming对应的数据
- (void)fetchData3
{
    NSArray *keys = [[DaoFactory getFilterObjectDao] getAllKeys];
    for (NSString *key in keys) {
        NSString *value = [[DaoFactory getFilterObjectDao] getValueByKey:key filter:@"tianming"];
        NSLog(@"this is a tested dict:%@", value);
        // 在这里解析字典转模型
    }
}

- (void)fetchData4
{
    NSArray *keys = [[DaoFactory getImageDao] getAllKeys];
    for (NSString *key in keys) {
        NSString *value = [[DaoFactory getImageDao] getValueByKey:key];
        // 在这里解析字典转模型
        NSLog(@"%@", value);
        NSData *image = [[NSData alloc] initWithBase64EncodedString:value options:0];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        img.image = [UIImage imageWithData:image];
        [self.view addSubview:img];
    }
}
// 获取随机字典 key:name, age...
- (NSDictionary *)getRandomDict
{
    NSArray *letters = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableString *name = [NSMutableString stringWithString:@"npn_"];
    
    for (int i = 0; i < 7; i ++) {
        int r = arc4random() % 7;
        NSString *temp = letters[r];
        [name appendString:temp];
    }
    [dict setValue:name forKey:@"name"];
    
    NSNumber *age = [NSNumber numberWithInt:arc4random() % 20];
    
    [dict setValue:age forKey:@"age"];
    
    return [dict copy];
}

@end
