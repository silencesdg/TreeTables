//
//  ViewController.m
//  TestTreeTables
//
//  Created by skladmin on 2016/11/21.
//  Copyright © 2016年 skladmin. All rights reserved.
//

#import "ViewController.h"
#import "testitemObject.h"
#import "testSectionObject.h"
#import "HotelNewSiftView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData
{
    //第一级
    NSMutableArray *arrSection1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i++) {
        testSectionObject *sectionObj1 = [[testSectionObject alloc]init];
        sectionObj1.name = [NSString stringWithFormat:@"%dsection2Name%d",i,i];;
        sectionObj1.isMuti = i == 2 ? @"1" : @"0";
        
        //第二级
//        NSMutableArray *arrSection2 = [[NSMutableArray alloc]init];
//        for (int j = 0; j < 3; j++) {
//            testSectionObject *sectionObj2 = [[testSectionObject alloc]init];
//            sectionObj2.name = [NSString stringWithFormat:@"%d%dsection2Name%d",i,j,i];;
//            sectionObj2.isMuti = i == 2 ? @"1" : @"0";
//            
////            //第三级
////            NSMutableArray *arrItems = [[NSMutableArray alloc]init];
////            for (int k = 0; k < 3; k++) {
////                testitemObject *itemObj = [[testitemObject alloc]init];
////                itemObj.name = [NSString stringWithFormat:@"%d%d%ditemName%d",i,j,k,i];
////                itemObj.itemId = [NSString stringWithFormat:@"%d",i];
////                itemObj.isUnlimi = i == 0 ? @"1" : @"0";
////                itemObj.isHigh = @"0";
////                [arrItems addObject:itemObj];
////            }
////            
////            sectionObj2.arrItems = arrItems;
//            [arrSection2 addObject:sectionObj2];
//        }
//        
//        sectionObj1.arrSections = arrSection2;
        [arrSection1 addObject:sectionObj1];
    }
    
    NSLog(@"原数据为：%@",arrSection1);
    
    
    HotelNewSiftView *view = [[HotelNewSiftView alloc]initWithArrayData:arrSection1 frame:CGRectMake(0, 50, 300, 400)];

    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
}
@end
