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

- (instancetype)initWithArrayData:(NSArray<id <SectionTagDataSource> >*)arrayData frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.arrayData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arrayData]];
        self.frame = frame;
        [self creatBaseView];
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
- (void)heightOfTree:(NSArray *)array start:(NSInteger)currentHeight
{
    
    if (array.count == 0){
        self.treeHeight = MAX(self.treeHeight, currentHeight);
        currentHeight--;
        return;
    }
    else {
        currentHeight++;
        for (id temp in array) {
            
            if ([temp respondsToSelector:@selector(arraySections)] && [temp arraySections].count > 0) {

                [self heightOfTree:[temp arraySections] start:currentHeight];

            }
            else if ([temp respondsToSelector:@selector(arrayForItems)] && [temp arrayForItems].count > 0) {
                
                [self heightOfTree:[temp arrayForItems] start:currentHeight];
            }
            else {
                [self heightOfTree:nil start:currentHeight];
            }
        }
    }
}

//暂时只支持不超过屏宽的布局，不可横向滑动
- (void)creatBaseView
{
    self.arrayTables = [[NSMutableArray alloc]init];
    self.treeHeight = 0;
    [self heightOfTree:self.arrayData start:0];
    NSInteger height = self.treeHeight;
    CGFloat tblHeight = 300;
    CGFloat tblWidth = 50;
    for (int i = 0; i < height; i++) {
        UITableView *tbl = [[UITableView alloc]initWithFrame:CGRectMake(i*tblWidth, 0, (i == height - 1) ? (self.frame.size.width - i*tblWidth): tblWidth, tblHeight)];
        tbl.tag = tblTagBase + i;
        tbl.delegate = self;
        tbl.dataSource = self;
        [tbl registerNib:[UINib nibWithNibName:kHotelNewSiftSectionCell bundle:nil] forCellReuseIdentifier:kHotelNewSiftSectionCell];
        [self addSubview:tbl];
        [self.arrayTables addObject:tbl];
    }
}

- (nullable NSArray *)getNodeArrayWithSelectTrace:(NSArray *)arrayIndex
{
    NSArray *arrayRows = self.arrayData;
    for (int i = 0; i < arrayIndex.count; i++) {
        //父节点索引
        int parentNodeIndex = [self.arrSelectSectionIndex[i] intValue];
        //父节点的子节点数为0时 若parentNodeIndex为0 会造成越界
        if (parentNodeIndex >= arrayRows.count) break;
        //获取父节点
        id node = arrayRows[parentNodeIndex];
        if ([node respondsToSelector:@selector(arraySections)] && [node arraySections].count > 0) {
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
    HotelNewSiftSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotelNewSiftSectionCell forIndexPath:indexPath];
    NSInteger height = tableView.tag - tblTagBase;
    NSArray *arraySelectTraceToParent = [self.arrSelectSectionIndex subarrayWithRange:NSMakeRange(0, height)];
    //当前table对应的列表数据
    NSArray *arrayCurrentNode = [self getNodeArrayWithSelectTrace:arraySelectTraceToParent];
    id node = arrayCurrentNode[indexPath.row];
    BOOL sectionSelect = self.arrSelectSectionIndex.count > height ? ([self.arrSelectSectionIndex[height] integerValue] == indexPath.row):NO;
    [cell configureData:node selectForSection:sectionSelect];
    return cell;
    
}

-(NSMutableArray *)arrSelectSectionIndex
{
    if (!_arrSelectSectionIndex) {
        _arrSelectSectionIndex = [[NSMutableArray alloc]init];
    }
    
    if (_arrSelectSectionIndex.count < MAX(self.treeHeight-1, 1)) {
        for (int i = 0; i <  MAX(self.treeHeight-1, 1) - _arrSelectSectionIndex.count; i++) {
            [_arrSelectSectionIndex addObject:@(0)];
        }
    }
    return _arrSelectSectionIndex;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = tableView.tag - tblTagBase;
    NSArray *arraySelectTraceToParent = [self.arrSelectSectionIndex subarrayWithRange:NSMakeRange(0, height)];
    //当前table对应的列表数据
    NSArray *arrayCurrentNode = [self getNodeArrayWithSelectTrace:arraySelectTraceToParent];
    id node = arrayCurrentNode[indexPath.row];
    NSLog(@"点击了%@",[node titleForShow]);
    if ([node respondsToSelector:@selector(arraySections)]) {
        //树枝
        self.arrSelectSectionIndex = [NSMutableArray arrayWithArray:arraySelectTraceToParent];
        [self.arrSelectSectionIndex replaceObjectAtIndex:height withObject:@(indexPath.row)];
        for (NSInteger i = height; i < self.arrayTables.count; i++) {
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
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.arrSelectSectionIndex[height - 1] integerValue] inSection:0];
        [(UITableView *)[self viewWithTag:tableView.tag - 1] reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//点击确定
- (void)didPressedCertain
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
//    if (delegateHasMethod.hasPressedMethod) {
//        [self.customDelegate HotelNewSiftView:self didPressedCertain:YES selectIds:<#(NSString *)#>]
//    }
}
//点击清空
- (void)didPressedClear
{
    if (delegateHasMethod.hasPressedMethod) {
        [self.customDelegate HotelNewSiftView:self didPressedCertain:NO selectIds:nil];
    }
}

@end
