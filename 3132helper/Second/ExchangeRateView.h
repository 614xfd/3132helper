//
//  ExchangeRateView.h
//  newHNW
//
//  Created by hnwlbh on 16/10/25.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeRateViewDelegate <NSObject>

@optional

- (void) returnDictionary : (NSDictionary *)dic andIndex : (NSInteger)x;

@end

@interface ExchangeRateView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id <ExchangeRateViewDelegate> delegate;

- (void) nowSelect : (NSArray *)array andSelectIndex : (NSInteger)x;

@end
