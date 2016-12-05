//
//  testitemObject.h
//  TestTreeTables
//
//  Created by skladmin on 2016/11/21.
//  Copyright © 2016年 skladmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelDetailRoomSiftProtocol.h"
@interface testitemObject : NSObject<ItemTagDataSource>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isHigh;
@property (nonatomic, copy) NSString *isUnlimi;

@end
