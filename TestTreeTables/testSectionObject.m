//
//  testSectionObject.m
//  TestTreeTables
//
//  Created by skladmin on 2016/11/21.
//  Copyright © 2016年 skladmin. All rights reserved.
//

#import "testSectionObject.h"

@implementation testSectionObject

- (NSString * _Nullable)titleForShow
{
    return self.name;
}
- (NSArray<id<ItemTagDataSource>> *_Nullable)arrayForItems
{
    return self.arrItems;
}
- (BOOL)isMutiSelect
{
    return [self.isMuti isEqualToString:@"1"];
}

- (NSArray<id<SectionTagDataSource>>* _Nullable)arraySections
{
    return self.arrSections;
}

//解码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.isMuti forKey:@"isMuti"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.arrItems forKey:@"arrItems"];
    [aCoder encodeObject:self.arrSections forKey:@"arrSections"];
}
//编码
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.isMuti = [aDecoder decodeObjectForKey:@"isMuti"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.arrItems = [aDecoder decodeObjectForKey:@"arrItems"];
        self.arrSections = [aDecoder decodeObjectForKey:@"arrSections"];
    }
    return self;
}

@end
