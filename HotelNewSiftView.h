//
//  HotelNewSiftView.h
//  TCTravel_IPhone
//
//  Created by skladmin on 2016/11/20.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDetailRoomSiftProtocol.h"

@class HotelNewSiftView;
@protocol HotelNewSiftViewDelegate <NSObject>

- (void)HotelNewSiftView:(HotelNewSiftView *)newSiftView didPressedCertain:(BOOL)isCertain selectIds:(NSString *)strIds;

@end
@interface HotelNewSiftView : UIView

@property (nonatomic, assign) id<HotelNewSiftViewDelegate> customDelegate;

-(instancetype)initWithArrayData:(NSArray<id <SectionTagDataSource> >*)arrayData selectIds:(NSString *)strIds;


@end
