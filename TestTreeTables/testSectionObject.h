//
//  testSectionObject.h
//  TestTreeTables
//
//  Created by skladmin on 2016/11/21.
//  Copyright © 2016年 skladmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "testitemObject.h"
#import "HotelDetailRoomSiftProtocol.h"

@interface testSectionObject : NSObject<SectionTagDataSource>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isMuti;
@property (nonatomic, strong) NSArray *arrItems;
@property (nonatomic, strong) NSArray *arrSections;

@end
