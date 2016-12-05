//
//  HotelDetailRoomSiftProtocol.h
//  TCTravel_IPhone
//
//  Created by skladmin on 16/9/1.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol ItemTagDataSource <NSObject,NSCoding>

- (NSString * _Nonnull)itemTagId;
- (NSString * _Nullable)titleForShow;
- (BOOL)getSelectStatus;
- (void)setSelectStatus:(BOOL)bSelected;

@optional
//列表页新筛选 是否为不限
- (BOOL)isUnlimited;
@end

@protocol SectionTagDataSource <NSObject,NSCoding>
@required
- (NSString * _Nullable)titleForShow;
- (NSArray<id<ItemTagDataSource>> *_Nullable)arrayForItems;
- (BOOL)isMutiSelect;

@optional
//列表页新筛选 用于多叉树结构
- (NSArray<id<SectionTagDataSource>>* _Nullable)arraySections;
@end




