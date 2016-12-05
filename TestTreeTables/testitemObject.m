//
//  testitemObject.m
//  TestTreeTables
//
//  Created by skladmin on 2016/11/21.
//  Copyright © 2016年 skladmin. All rights reserved.
//

#import "testitemObject.h"

@implementation testitemObject

- (NSString * _Nonnull)itemTagId
{
    return self.itemId;
}
- (NSString * _Nullable)titleForShow
{
    return self.name;
}
- (BOOL)getSelectStatus
{
    return [self.isHigh isEqualToString:@"1"];
}
- (void)setSelectStatus:(BOOL)bSelected
{
    self.isHigh = bSelected?@"1":@"0";
}

//列表页新筛选 是否为不限
- (BOOL)isUnlimited
{
    return [self.isUnlimi isEqualToString:@"1"];
}

//解码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.isHigh forKey:@"isHigh"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.isUnlimi forKey:@"isUnlimit"];
    [aCoder encodeObject:self.itemId forKey:@"itemId"];
}
//编码
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.isHigh = [aDecoder decodeObjectForKey:@"isHigh"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.isUnlimi = [aDecoder decodeObjectForKey:@"isUnlimi"];
        self.itemId = [aDecoder decodeObjectForKey:@"itemId"];
    }
    return self;
}
@end
