//
//  FestivalView.m
//  newHNW
//
//  Created by hnwlbh on 16/10/24.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import "FestivalView.h"
#import "NetworkTool.h"
#import "BaseLabel.h"

@implementation FestivalView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self request];
        [self creatView];
    }
    
    return self;
}

- (void) creatView
{
    BaseLabel *label = [[BaseLabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"选择目的地";
    label.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:label];
}

- (void) request
{
    __weak __typeof(&*self)weakSelf = self;
//    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"page_no", @"1000", @"page_size", @"0", @"ParentID", @"1", @"DestinationType", nil];
//    [[HttpTool alloc] POSTWithSystemParameters:[HttpTool spWithApi:@"API.nStragegy.nDestinationsListGet" andSign:[HttpTool signWithMainParameters:d]] andMainParameters:d completed:^(id JSON, NSString *stringData) {
//
//        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"IsError"]];
//        if ([isError isEqualToString:@"1"]) {
////            [weakSelf performSelectorOnMainThread:@selector(showMassage:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"ErrMsg"]] waitUntilDone:YES];
//        } else {
//            weakSelf.dataArray = [JSON objectForKey:@"nDestinations"];
//            [weakSelf performSelectorOnMainThread:@selector(creatTableVlew) withObject:nil waitUntilDone:YES];
//        }
//
//    } failed:^(NSError *error) {
//
//    }];
    [[NetworkTool sharedTool] requestWithURLString:@"http://v.juhe.cn/weather/citys?key=b17a51d028a810ab26ba28e8d6885383" parameters:nil method:@"GET" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"error_code"]];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"");
            NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"result"]];
            weakSelf.provinceArray = [NSMutableArray array];
            weakSelf.cityArray = [NSMutableArray array];
            NSMutableArray *mArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
                if (weakSelf.provinceArray.count) {
                    NSString *str = [dic objectForKey:@"province"];
                    if ([str isEqualToString:[weakSelf.provinceArray lastObject]]) {
                        [mArray addObject:dic];
                    } else {
                        [weakSelf.cityArray addObject:[NSArray arrayWithArray:mArray]];
                        [mArray removeAllObjects];
                        [weakSelf.provinceArray addObject:[dic objectForKey:@"province"]];
                        [mArray addObject:dic];
                    }
                    if (i == array.count-1) {
                        [weakSelf.cityArray addObject:mArray];
                    }
                } else {
                    [weakSelf.provinceArray addObject:[dic objectForKey:@"province"]];
                    [mArray addObject:dic];
                }
            }
            NSLog(@"%@0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0%@", weakSelf.provinceArray, weakSelf.cityArray);
            [weakSelf performSelectorOnMainThread:@selector(creatTableVlew) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];

}

- (void) creatTableVlew
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[[self.dataArray objectAtIndex:section] objectForKey:@"subDestinations"] count];
    return [[self.cityArray objectAtIndex:section] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.dataArray.count;
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
    
    BaseLabel *label = [[BaseLabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width, view.frame.size.height)];
//    label.font = [UIFont systemFontOfSize:14];
    [label setMYFont:14];
    label.textColor = [UIColor grayColor];
//    label.text = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"subDestinations"] objectAtIndex:indexPath.row] objectForKey:@"DestinationName"];
    label.text = [[[self.cityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"district"];
    [view addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width-10, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    [view addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tvhf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    if (!tvhf) {
        tvhf = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"head"];
    } else {
        for (UIView *view in tvhf.contentView.subviews) {
            if (view.tag == 888) {
                [view removeFromSuperview];
            }
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    view.tag = 888;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, (view.frame.size.height-13)/2, 13, 13)];
    image.image = [UIImage imageNamed:@"jr_gj"];
    [view addSubview:image];
    
    BaseLabel *label = [[BaseLabel alloc] initWithFrame:CGRectMake(image.frame.size.width + image.frame.origin.x, 0, view.frame.size.width-20, view.frame.size.height)];
//    label.font = [UIFont systemFontOfSize:14];
    [label setMYFont:16];
    label.textColor = [UIColor colorWithRed:59/255.0 green:157/255.0 blue:219/255.0 alpha:1];
//    label.text = [[self.dataArray objectAtIndex:section] objectForKey:@"DestinationName"];
    label.text = [self.provinceArray objectAtIndex:section];
    [view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.frame;
    btn.tag = section;
    [btn addTarget:self action:@selector(headTouch:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:btn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width-10, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    [view addSubview:line];
    
    [tvhf.contentView addSubview:view];
    
    return tvhf;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.delegate cityInfo:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"subDestinations"] objectAtIndex:indexPath.row]];
    [self.delegate cityInfo:[[[self.cityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"district"]];
}

- (void) headTouch : (UIButton *)btn
{
    if (self.isCanTouch) {
        [self.delegate cityInfo:[self.dataArray objectAtIndex:btn.tag]];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
