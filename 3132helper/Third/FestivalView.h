//
//  FestivalView.h
//  newHNW
//
//  Created by hnwlbh on 16/10/24.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FestivalViewDelegate <NSObject>

@optional
- (void) cityInfo : (NSString *)string;

@end

@interface FestivalView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id <FestivalViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;


@property (nonatomic, assign) BOOL isCanTouch;

@end
