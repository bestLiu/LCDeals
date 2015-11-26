//
//  LCDealTool.m
//  美团HD
//
//  Created by mac1 on 15/9/14.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCDealTool.h"
#import "FMDB.h"

@implementation LCDealTool

static FMDatabase *_db;

+ (void)initialize
{ // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        LCDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

+ (int)collectDealsCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}


+ (void)addCollect:(LCDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}
+ (void)removeCollect:(LCDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}
+ (BOOL)isCollect:(LCDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;

}
/*---------------------------------------------------分割线--------------------------------------------------------------*/
+ (NSArray *)recentDeals:(int)page
{
    int size = 20; //每页20条
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        LCDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
+ (void)addRecent:(LCDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];

}
+ (void)removeRecent:(LCDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (BOOL)recentIsExist:(LCDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

@end
