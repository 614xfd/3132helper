//
//  FourthViewController.m
//  3132helper
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"号码归属地查询";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryBtnClick {
    [self queryWithPhone:self.phoneTextField.text];
}

- (void)queryWithPhone:(NSString *)phoneNumber{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.baifubao.com/callback?cmd=1059&callback=phone&phone=%@",phoneNumber];
    NSData *infoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSString *infoStr = [[NSString alloc]initWithData:infoData encoding:NSUTF8StringEncoding];
    NSString *jsonStr = [[infoStr componentsSeparatedByString:@"("].lastObject componentsSeparatedByString:@")"].firstObject;
    NSDictionary *infoDict = [NSObject dictionaryWithJsonString:jsonStr];
    NSLog(@"%@",jsonStr);
    NSDictionary *data = infoDict[@"data"];
    if (data[@"area"]) {
        self.areaLable.text = data[@"area"];
    }
    
    if (data[@"operator"]) {
        self.operatorLabel.text = data[@"operator"];
    }
    if (data[@"promotion_info"]) {
        
        NSArray *promotionInfoList = data[@"promotion_info"];
        NSString * promotionInfo = [self getJson:promotionInfoList];
//        for (int index = 0; index < promotionInfoList.count; index ++) {
//            promotionInfo = [NSString stringWithFormat:@"%@\n%d:%@;",promotionInfo,index,promotionInfoList[index]];
//        }
//
        self.promotionInfoTextView.text = promotionInfo;
    }
    NSDictionary *meta = infoDict[@"meta"];
    
    if (meta[@"result_info"]) {
        self.resultInfoTextView.text = meta[@"result_info"];
    }
}

@end
