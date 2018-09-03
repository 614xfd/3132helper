//
//  ExchangeRateView.m
//  newHNW
//
//  Created by hnwlbh on 16/10/25.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import "ExchangeRateView.h"

@implementation ExchangeRateView {
    NSArray *_nowArray;
    NSInteger _x;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _nowArray = [NSArray array];
        [self creatView];
    }
    
    return self;
}

- (void) creatView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"货币切换";
    label.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    [self addSubview:line];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];

}

- (void) nowSelect:(NSArray *)array andSelectIndex:(NSInteger)x
{
    _nowArray = [NSArray arrayWithArray:array];
    _x = x;
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == 999) {
                [view removeFromSuperview];
            }
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    view.tag = 999;
    [cell.contentView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.frame.size.width, view.frame.size.height)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
//    label.text = [NSString stringWithFormat:@"%@ %@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"SynboName"], [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"SynboNameEng"]];
    label.text = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    [view addSubview:label];
    
    if (_nowArray.count) {
        NSString *string = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
        for (int i = 0; i < _nowArray.count; i++) {
            NSString *str = [[_nowArray objectAtIndex:i] objectAtIndex:0];
            if ([string isEqualToString:str]) {
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-10-100, 0, 100, view.frame.size.height)];
                lab.text = @"已选";
                if (i == _x) {
                    lab.text = @"当前选择";
                }
                lab.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
                lab.font = [UIFont systemFontOfSize:12];
                lab.textAlignment = NSTextAlignmentRight;
                [view addSubview:lab];
            }
        }
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    [view addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate returnDictionary:[self.dataArray objectAtIndex:indexPath.row] andIndex:_x];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
