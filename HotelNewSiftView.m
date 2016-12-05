//
//  HotelNewSiftView.m
//  TCTravel_IPhone
//
//  Created by skladmin on 2016/11/20.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//

#import "HotelNewSiftView.h"
#import "HotelNewSiftSectionCell.h"

static NSInteger tblTagBase = 12732;

static NSString * const kHotelNewSiftSectionCell = @"HotelNewSiftSectionCell";


@interface HotelNewSiftView()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    struct{
        BOOL hasPressedMethod;
    }delegateHasMethod;
}

@property (nonatomic, strong) NSArray<id <SectionTagDataSource>> *arrayData;
@property (nonatomic, strong) NSMutableArray *arrayTables;
@property (nonatomic, copy) NSString *strSelectIds;
@property (nonatomic, strong) NSMutableArray *arrSelectSectionIndex;//选择的节点在树结构中的位置
@property (nonatomic, assign) NSInteger treeHeight;
@end

@implementation HotelNewSiftView


- (instancetype)initWithArrayData:(NSArray<id <SectionTagDataSource> >*)arrayData selectIds:(NSString *)strIds
{
    self = [super init];
    if (self) {
        self.arrayData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arrayData]];
        self.strSelectIds = strIds;

    }
    return self;
}

- (void)setCustomDelegate:(id<HotelNewSiftViewDelegate>)customDelegate
{
    if (customDelegate != _customDelegate) {
        _customDelegate = customDelegate;
        delegateHasMethod.hasPressedMethod = [customDelegate respondsToSelector:@selector(HotelNewSiftView:didPressedCertain:selectIds:)];
    }
}

- (void)configSelectIds:(NSString *)strIds node:(id)node
{
    if ([node respondsToSelector:@selector(arrayForItems)] && [node arrayForItems].count > 0) {
        
        return;
    }

}

- (void)reload
{
    for (UITableView *tbl in self.arrayTables) {
        [tbl reloadData];
    }
}
//获取树高度
- (NSInteger)heightOfTree:(NSArray *)array start:(NSInteger)currentHeight
{
    static NSInteger height = 0;
    if (array.count == 0) return height = MAX(height, currentHeight) ;
    
    for (id temp in array) {
        if ([temp conformsToProtocol:@protocol(SectionTagDataSource)] && [temp respondsToSelector:@selector(arraySections)]) {
            [self heightOfTree:[temp arraySections] start:currentHeight++];
        }
    }
    return 0;
}

//暂时只支持不超过屏宽的布局，不可横向滑动
- (void)creatBaseView
{
    self.treeHeight = 0;
    self.arrayTables = [[NSMutableArray alloc]init];
    NSInteger height = [self heightOfTree:self.arrayData start:0];
    //默认选中第一个
    self.arrSelectSectionIndex = [[NSMutableArray alloc]initWithObjects:@(0), nil];
    CGFloat tblHeight = 300;
    CGFloat tblWidth = 50;
    for (int i = 0; i < height; i++) {
        UITableView *tbl = [[UITableView alloc]initWithFrame:CGRectMake(i*tblWidth, 0, (i == height - 1) ? self.frame.size.width - i*tblWidth: tblWidth, tblHeight)];
        tbl.tag = tblTagBase + i;
        [self addSubview:tbl];
    }
}

- (nullable NSArray *)getNodeArrayWithSelectTrace:(NSArray *)arrayIndex
{
    NSArray *arrayRows = self.arrayData;
    for (int i = 0; i < arrayIndex.count; i++) {
        //父节点索引
        int parentNodeIndex = [self.arrSelectSectionIndex[i] intValue];
        //父节点的子节点数为0时 若parentNodeIndex为0 会造成越界
        if (parentNodeIndex >= arrayRows.count) return nil;
        //获取父节点
        id node = arrayRows[parentNodeIndex];
        if ([node arraySections].count > 0) {
            arrayRows = [node arraySections];
        }else {
            arrayRows = [node arrayForItems] ;
        }
    }
    return arrayRows;
}

#pragma mark - UITableViewDelegate\UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //第几层 tableView.tag
    //第几个节点 self.arrSelectSectionIndex
    //返回本节点子节点个数
    NSArray *arraySelectTraceToParent = [self.arrSelectSectionIndex subarrayWithRange:NSMakeRange(0, tableView.tag - tblTagBase)];
    return [self getNodeArrayWithSelectTrace:arraySelectTraceToParent].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableview数量 比arrSelectSectionIndex.count多一个
    HotelNewSiftSectionCell *cell = (HotelNewSiftSectionCell *)[tableView cellWithCellNibName:kHotelNewSiftSectionCell];
    NSInteger height = tableView.tag - tblTagBase;
    NSArray *arraySelectTraceToParent = [self.arrSelectSectionIndex subarrayWithRange:NSMakeRange(0, height)];
    //当前table对应的列表数据
    NSArray *arrayCurrentNode = [self getNodeArrayWithSelectTrace:arraySelectTraceToParent];
    id node = arrayCurrentNode[indexPath.row];
    BOOL sectionSelect = self.arrSelectSectionIndex.count > height ? ([self.arrSelectSectionIndex[height] integerValue] == indexPath.row):NO;
    [cell configureData:node selectForSection:sectionSelect];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = tableView.tag - tblTagBase;
    NSArray *arraySelectTraceToParent = [self.arrSelectSectionIndex subarrayWithRange:NSMakeRange(0, height)];
    //当前table对应的列表数据
    NSArray *arrayCurrentNode = [self getNodeArrayWithSelectTrace:arraySelectTraceToParent];
    id node = arrayCurrentNode[indexPath.row];
    if ([node arraySections].count > 0) {
        //树枝
        self.arrSelectSectionIndex = [NSMutableArray arrayWithArray:arraySelectTraceToParent];
        [self.arrSelectSectionIndex addObject:@(indexPath.row)];
        for (int i = 0; i < self.arrayTables.count; i++) {
             [(UITableView *)[self viewWithTag:tblTagBase+i] reloadData];
        }
    }
    else {
        //叶子
        if ([node isUnlimited]) {
            //点击了不限 清空其他选择项
            for (id<ItemTagDataSource>item in arrayCurrentNode) {
                [item setSelectStatus:NO];
            }
            [node setSelectStatus:YES];
        }
        else {
            //普通叶子
            NSArray *arraySelectTraceToGrand = [arraySelectTraceToParent subarrayWithRange:NSMakeRange(0, MAX(0, height-1))];
            //当前table对应的列表数据
            NSArray *arrayParentNode = [self getNodeArrayWithSelectTrace:arraySelectTraceToGrand];
            id <SectionTagDataSource> parentNode = arrayParentNode[[[arraySelectTraceToParent lastObject] integerValue]];
            if ([parentNode isMutiSelect]) {
                //多选
                [node setSelectStatus:![node getSelectStatus]];
            }
            else {
                //单选
                for (id<ItemTagDataSource>item in arrayCurrentNode) {
                    [item setSelectStatus:NO];
                }
                [node setSelectStatus:YES];
            }
            
        }
        [tableView reloadData];
        [(UITableView *)[self viewWithTag:tableView.tag - 1] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:[self.arrSelectSectionIndex[height - 1] integerValue]]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}
//点击确定
- (void)didPressedCertain
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    if (delegateHasMethod.hasPressedMethod) {
        [self.customDelegate HotelNewSiftView:self didPressedCertain:YES selectIds:<#(NSString *)#>]
    }
}
//点击清空
- (void)didPressedClear
{
    if (delegateHasMethod.hasPressedMethod) {
        [self.customDelegate HotelNewSiftView:self didPressedCertain:NO selectIds:nil];
    }
}

@end
