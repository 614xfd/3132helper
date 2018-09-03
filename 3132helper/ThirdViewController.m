//
//  ThirdViewController.m
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ThirdViewController.h"
#import "FestivalView.h"

@interface ThirdViewController () <FestivalViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UILabel *_countryNameLabel;
    UIButton *_selectCountry;
    
    NSDictionary *_dic;
    
    FestivalView *_fv;
    UIView *_bgView;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherType;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;


@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self hiddenCustomView];
    
    _dic = [NSDictionary dictionary];
    self.dataArray = [NSArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    self.headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(17, (64-20-18)/2+20, 9, 18)];
    image.image = [UIImage imageNamed:@"icon_blue_03.png"];
    image.tag = 790;
    [self.view addSubview:image];
    
    UIButton *customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customBackButton.frame = CGRectMake(0, 20, 108, 44);
    [customBackButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [customBackButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:customBackButton];
    
    _countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-self.view.frame.size.width/2, 20, self.view.frame.size.width/2-2, 44)];
    _countryNameLabel.text = @"";
    _countryNameLabel.backgroundColor = [UIColor clearColor];
    _countryNameLabel.font = [UIFont systemFontOfSize:16];
    _countryNameLabel.textColor = [UIColor whiteColor];
    _countryNameLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_countryNameLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = _countryNameLabel.frame;
    [btn addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.hidden = YES;
    [self.view addSubview:_bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgLabelTouch)];
    [_bgView addGestureRecognizer:tap];
    
    _fv = [[FestivalView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width/5*3, self.view.frame.size.height)];
    _fv.delegate = self;
    [self.view addSubview:_fv];
    [self.view bringSubviewToFront:_fv];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"xd_zb"];
    attach.bounds = CGRectMake(0, 0, 9, 12);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weather_city"]) {
        NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 选岛"]];
        NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
        [txt appendAttributedString:t];
        _countryNameLabel.attributedText = txt;
        [self showView];
        
    } else {
        NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"weather_city"] objectForKey:@"DestinationName"]]];
        NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
        [txt appendAttributedString:t];
        _countryNameLabel.attributedText = txt;
        [self cityInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"weather_city"]];
    }
    
    UILabel *line = [self.headView viewWithTag:10];
    line.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, line.frame.size.width, 0.5);
    
    UILabel *line1 = [self.headView viewWithTag:11];
    line1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    line1.frame = CGRectMake(line1.frame.origin.x, line1.frame.origin.y, line1.frame.size.width, 0.5);
}

//- (void) request
//{
//    __weak __typeof(&*self)weakSelf = self;
//    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"DestinationID", nil];
//    [[HttpTool alloc] POSTWithSystemParameters:[HttpTool spWithApi:@"API.Tools.WeaterInfoGet" andSign:[HttpTool signWithMainParameters:d]] andMainParameters:d completed:^(id JSON, NSString *stringData) {
//
//        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"IsError"]];
//        if ([isError isEqualToString:@"1"]) {
//            //            [weakSelf performSelectorOnMainThread:@selector(showMassage:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"ErrMsg"]] waitUntilDone:YES];
//        } else {
//            NSLog(@"%@", stringData);
//            weakSelf.dataArray = [[JSON objectForKey:@"WeatherInfo"] objectForKey:@"WeatherPredictions"];
//            _dic = [JSON objectForKey:@"WeatherInfo"];
//            [weakSelf performSelectorOnMainThread:@selector(creatMainView) withObject:JSON waitUntilDone:YES];
//            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//        }
//
//    } failed:^(NSError *error) {
//
//    }];
//
//}

- (void) cityInfo:(NSString *)string
{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"xd_zb"];
    attach.bounds = CGRectMake(0, 0, 9, 12);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", string]];
    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
    [txt appendAttributedString:t];
    _countryNameLabel.attributedText = txt;
    
    __weak __typeof(&*self)weakSelf = self;
//    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"ID"], @"DestinationID", nil];
//    [[HttpTool alloc] POSTWithSystemParameters:[HttpTool spWithApi:@"API.Tools.WeaterInfoGet" andSign:[HttpTool signWithMainParameters:d]] andMainParameters:d completed:^(id JSON, NSString *stringData) {
//
//        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"IsError"]];
//        if ([isError isEqualToString:@"1"]) {
//            //            [weakSelf performSelectorOnMainThread:@selector(showMassage:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"ErrMsg"]] waitUntilDone:YES];
//        } else {
//            NSLog(@"%@", stringData);
//            weakSelf.dataArray = [[JSON objectForKey:@"WeatherInfo"] objectForKey:@"WeatherPredictions"];
//            _dic = [JSON objectForKey:@"WeatherInfo"];
//            [weakSelf performSelectorOnMainThread:@selector(creatMainView) withObject:JSON waitUntilDone:YES];
//            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//        }
//
//    } failed:^(NSError *error) {
//
//    }];

    NSString *str = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?format=2&cityname=%@&key=b17a51d028a810ab26ba28e8d6885383", [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[NetworkTool sharedTool] requestWithURLString:str parameters:nil method:@"GET" completed:^(id JSON, NSString *stringData) {

        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"error_code"]];
        if ([code isEqualToString:@"0"]) {
//            weakSelf.dataArray = [[JSON objectForKey:@"WeatherInfo"] objectForKey:@"WeatherPredictions"];
            weakSelf.dataArray = [NSArray arrayWithArray:[[JSON objectForKey:@"result"] objectForKey:@"future"]];
//            self->_dic = [JSON objectForKey:@"WeatherInfo"];
            [weakSelf performSelectorOnMainThread:@selector(creatMainView) withObject:JSON waitUntilDone:YES];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
    [self hiddenView];
}

- (void) setWD : (UIImage *) image
{
    //    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    //    attach.image = image;
    //    attach.bounds = CGRectMake(0, 0, 19, 16);
    //    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    //    NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:];
    //    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
    //    [txt appendAttributedString:t];
    //    self.weatherType.attributedText = txt;
}

- (void) creatMainView
{
    self.bgImageView.image = [UIImage imageNamed:@"雨.jpg"];
    NSString *s = @"";
    if ([s hasPrefix:@"晴"]) {
        self.bgImageView.image = [UIImage imageNamed:@"晴.jpg"];
    }
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[[_dic objectForKey:@"Curr"] objectForKey:@"WeatherIcon"] objectForKey:@"WeatherBackgroundUrl"]]]];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@°", [[_dic objectForKey:@"Curr"] objectForKey:@"temp"]];
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-100000, -100000, 1, 1)];
    NSString * string= [NSString stringWithFormat:@"%@", [[[_dic objectForKey:@"Curr"] objectForKey:@"WeatherIcon"] objectForKey:@"WeatherIconUrl"]];
    NSString *urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, NULL,  kCFStringEncodingUTF8 ));
    //
    //    __weak __typeof(&*self)weakSelf = self;
    //    [image sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        [weakSelf performSelectorOnMainThread:@selector(setWD:) withObject:image waitUntilDone:YES];
    //
    //    }];
    UILabel *label = (UILabel *) [self.headView viewWithTag:20];
    label.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [[_dic objectForKey:@"Curr"] objectForKey:@"name"]]];
    
    UIImageView *image = (UIImageView *) [self.headView viewWithTag:21];
    [image sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width-30-8-image.frame.size.width,2000);
    CGSize labelsize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat f = image.frame.size.width + 8 + labelsize.width;
    image.frame = CGRectMake((self.view.frame.size.width-f)/2, image.frame.origin.y, image.frame.size.width, image.frame.size.height);
    label.frame = CGRectMake(image.frame.origin.x+image.frame.size.width+8, label.frame.origin.y, labelsize.width, label.frame.size.height);
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"xd_rc"];
    attach.bounds = CGRectMake(0, 0, 29, 16);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [NSString stringWithFormat:@" %@      ", [_dic objectForKey:@"WeatherSunrise"]]]];
    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
    [txt appendAttributedString:t];
    
    NSTextAttachment *attach1 = [[NSTextAttachment alloc] init];
    attach1.image = [UIImage imageNamed:@"xd_rl"];
    attach1.bounds = CGRectMake(0, 0, 29, 16);
    attachString = [NSAttributedString attributedStringWithAttachment:attach1];
    t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [NSString stringWithFormat:@" %@", [_dic objectForKey:@"WeatherSunset"]]]];
    [txt appendAttributedString:attachString];
    [txt appendAttributedString:t];
    
    self.timeLabel.attributedText = txt;
    
    
//    [self creatScrollView:[_dic objectForKey:@"WeatherHours"]];
}

- (void) creatScrollView : (NSArray *)array
{
    if (self.scrollView.subviews) {
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    double x = (double)self.view.frame.size.width/6.5;
    self.scrollView.contentSize = CGSizeMake(x*array.count, self.scrollView.frame.size.height);
    
//    for (int i = 0; i < array.count; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*x, 0, x, self.scrollView.frame.size.height)];
//        view.backgroundColor = [UIColor clearColor];
//        [self.scrollView addSubview:view];
//
//        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/3)];
//        time.text = [[array objectAtIndex:i] objectForKey:@"realTime"];
//        time.textColor = [UIColor whiteColor];
//        time.font = [UIFont systemFontOfSize:13];
//        time.textAlignment = NSTextAlignmentCenter;
//        [view addSubview:time];
//
//        NSString *string = [NSString stringWithFormat:@"%@", [[[array objectAtIndex:i] objectForKey:@"WeatherIcon"] objectForKey:@"WeatherIconUrl"]];
//        NSString *urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, NULL,  kCFStringEncodingUTF8 ));
//
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-40)/2, time.frame.size.height+(view.frame.size.height/3-40)/2, 40, 40)];
//        [image sd_setImageWithURL:[NSURL URLWithString:urlString]];
//        [view addSubview:image];
//
//        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height/3*2, view.frame.size.width, view.frame.size.height/3)];
//        temp.text = [NSString stringWithFormat:@"%@℃", [[array objectAtIndex:i] objectForKey:@"temp"]];
//        temp.textColor = [UIColor whiteColor];
//        temp.font = [UIFont systemFontOfSize:13];
//        temp.textAlignment = NSTextAlignmentCenter;
//        [view addSubview:temp];
//
//    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.tag = 999;
    view.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:view];
    
    
    if (indexPath.row == 0) {
        
        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.frame.size.width, view.frame.size.height)];
        day.text = @"7天预测";
        day.font = [UIFont systemFontOfSize:15];
        day.textColor = [UIColor whiteColor];
        //        day.textAlignment = NSTextAlignmentCenter;
        [view addSubview:day];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    } else {
        NSMutableString* str=[[NSMutableString alloc]initWithString:[[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"date"]];
        [str insertString:@"-" atIndex:6];
        [str insertString:@"-" atIndex:4];
        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, view.frame.size.height)];
//        day.text = [NSString stringWithFormat:@"%@ %@", [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"date"], [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"week"]];
        day.text = str;
        day.textColor = [UIColor whiteColor];
        day.font = [UIFont systemFontOfSize:13];
        [view addSubview:day];
        
        
        UILabel *weather = [[UILabel alloc] initWithFrame:CGRectMake(day.frame.size.width+day.frame.origin.x+15, 0, self.view.frame.size.width-200-30, view.frame.size.height)];
//        weather.text = [NSString stringWithFormat:@"%@转%@", [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"day_tempName"], [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"night_tempName"]];
        weather.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"weather"]];
        weather.textColor = [UIColor whiteColor];
        weather.font = [UIFont systemFontOfSize:13];
        [view addSubview:weather];
        
        CGSize size = CGSizeMake(weather.frame.size.width,2000);
        CGSize labelsize = [weather.text sizeWithFont:weather.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        weather.frame = CGRectMake(weather.frame.origin.x, weather.frame.origin.y, labelsize.width, weather.frame.size.height);
        
        
        
        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-15-100, 0, 100, view.frame.size.height)];
//        temp.text = [NSString stringWithFormat:@"%@~%@℃", [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"day"], [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"night"]];
        temp.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row-1] objectForKey:@"temperature"]];
        temp.textColor = [UIColor whiteColor];
        temp.font = [UIFont systemFontOfSize:13];
        temp.textAlignment = NSTextAlignmentRight;
        [view addSubview:temp];
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.20];
    }
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (void) showView
{
    _bgView.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        _fv.frame = CGRectMake(self.view.frame.size.width/5*2, _fv.frame.origin.y, _fv.frame.size.width, _fv.frame.size.height);
        self->_bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        
    }];
}

- (void) hiddenView
{
    [UIView animateWithDuration:1 animations:^{
        _fv.frame = CGRectMake(self.view.frame.size.width, _fv.frame.origin.y, _fv.frame.size.width, _fv.frame.size.height);
        self->_bgView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self->_bgView.hidden = YES;
    }];
}

- (void) bgLabelTouch
{
    [self hiddenView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
