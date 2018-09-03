//
//  SecondViewController.m
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "SecondViewController.h"
#import "ExchangeRateView.h"
#import "BaseLabel.h"
#import "BaseTextField.h"

@interface SecondViewController () <ExchangeRateViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    ExchangeRateView *_erv;
    UIView *_bgView;
    
    NSInteger _select;
    BOOL _isHaveDian;
    
    NSArray *_numberArray;
    UIView *_v;
    
    BOOL _isSec;
    UIView *_yd_view;
    NSTimer *_timer;
    BOOL _isLeft;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SecondViewController

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"汇率";
    self.dataArray = [NSMutableArray array];
    _select = 0;
    [self requestCountry];
}

- (void) requestCountry
{
//    __weak __typeof(&*self)weakSelf = self;
//    NSDictionary *d = [NSDictionary dictionary];
//    [[HttpTool alloc] POSTWithSystemParameters:[HttpTool spWithApi:@"API.Tools.ExChangeCountrysListGet" andSign:[HttpTool signWithMainParameters:d]] andMainParameters:d completed:^(id JSON, NSString *stringData) {
//
//        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"IsError"]];
//        if ([isError isEqualToString:@"1"]) {
//            //            [weakSelf performSelectorOnMainThread:@selector(showMassage:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"ErrMsg"]] waitUntilDone:YES];
//        } else {
//            [weakSelf performSelectorOnMainThread:@selector(creatView:) withObject:JSON waitUntilDone:YES];
//        }
//
//    } failed:^(NSError *error) {
//
//    }];
}

- (void) creatView : (NSDictionary *)dic
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.hidden = YES;
    [self.view addSubview:_bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgLabelTouch)];
    [_bgView addGestureRecognizer:tap];
    
    _erv = [[ExchangeRateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width/3*2, self.view.frame.size.height)];
    _erv.dataArray = [dic objectForKey:@"ExChangeCountrys"];
    _erv.delegate = self;
    [self.view addSubview:_erv];
    [self.view bringSubviewToFront:_erv];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"exchangerate_cityInfo"]) {
        NSArray *array = [dic objectForKey:@"ExChangeCountrys"];
        for (int i = 0; i < array.count && i < 5; i++) {
            [self.dataArray addObject:[array objectAtIndex:i]];
        }
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *array = [dic objectForKey:@"ExChangeCountrys"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[ud objectForKey:@"exchangerate_cityInfo"]];
        for (int i = 0; i < array.count && self.dataArray.count < 6; i++) {
            NSString *CountryName= [[array objectAtIndex:i] objectForKey:@"CountryName"];
            for (int j = 0; j < arr.count; j++) {
                if ([CountryName isEqualToString:[[arr objectAtIndex:j] objectForKey:@"CountryName"]]) {
                    [self.dataArray addObject:[array objectAtIndex:i]];
                }
            }
        }
        _select = [[ud objectForKey:@"exchangerate_select"] integerValue];
        _numberArray = [ud objectForKey:@"exchangerate_number"];
    }
    [self.tableView reloadData];
    
    //    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    //    [self.view addGestureRecognizer:swipeGesture];
    //
    //    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //    [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
    //    [self.view addGestureRecognizer:swipeGesture2];
    
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
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height<=667) {
        rect = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-216-64)/5) ;
    } else {
        rect = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-226-64)/5) ;
    }
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.tag = 999;
    [cell.contentView addSubview:view];
    
    BaseLabel *bgLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(-1, 0.5, self.view.frame.size.width+2, view.frame.size.height-0.5)];
    //    bgLabel.font = [UIFont systemFontOfSize:22];
    [bgLabel setMYFont:22];
    bgLabel.textColor = [UIColor whiteColor];
    bgLabel.textAlignment = NSTextAlignmentCenter;
    bgLabel.backgroundColor = [UIColor colorWithRed:92/255.0 green:173/255.0 blue:239/255.0 alpha:1];
    [view addSubview:bgLabel];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"hl_qh.png"];
    attach.bounds = CGRectMake(0, 0, 19, 16);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithString:@"切换货币 "];
    [txt appendAttributedString:attachString];
    bgLabel.attributedText = txt;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:btn];
    
    [bgLabel.layer setBorderWidth:1];
    [bgLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.tag = 1000+indexPath.row;
    [view addSubview:bgView];
    
    if (_select == indexPath.row) {
        bgView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    }
    
    NSString *str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)[NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"Logo"]], NULL, NULL,  kCFStringEncodingUTF8 ));
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, (view.frame.size.height-30)/2, 46, 30)];
    [image sd_setImageWithURL:[NSURL URLWithString:str]];
    [bgView addSubview:image];
    [image.layer setMasksToBounds:YES];
    [image.layer setCornerRadius:3];
    
    BaseLabel *country = [[BaseLabel alloc] initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+10, image.frame.origin.y, 100, 18)];
    //    country.font = [UIFont systemFontOfSize:16];
    [country setMYFont:18];
    country.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"SynboNameEng"];
    country.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
    [bgView addSubview:country];
    
    BaseLabel *name = [[BaseLabel alloc] initWithFrame:CGRectMake(country.frame.origin.x, country.frame.origin.y+country.frame.size.height+4, country.frame.size.width, 10)];
    name.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"SynboName"]];
    //    name.font = [UIFont systemFontOfSize:10];
    [name setMYFont:10];
    name.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    [bgView addSubview:name];
    
    BaseTextField *tf = [[BaseTextField alloc] initWithFrame:CGRectMake(country.frame.origin.x+country.frame.size.width+10, country.frame.origin.y, self.view.frame.size.width-country.frame.origin.x-country.frame.size.width-10-15, 30)];
    tf.textAlignment = NSTextAlignmentRight;
    //    tf.font = [UIFont systemFontOfSize:22];
    [tf setMYFont:22];
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.tag = indexPath.row+2000;
    tf.delegate = self;
    [bgView addSubview:tf];
    
    if (_numberArray.count) {
        tf.text = [_numberArray objectAtIndex:indexPath.row];
        tf.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
        if (indexPath.row == _select) {
            //            tf.font = [UIFont systemFontOfSize:30];
            [tf setMYFont:30];
            
            [tf becomeFirstResponder];
            tf.textColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
        }
    } else {
        if (indexPath.row == _select) {
            tf.text = @"100.00";
            //            tf.font = [UIFont systemFontOfSize:30];
            [tf setMYFont:30];
            
            tf.textColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
            [tf becomeFirstResponder];
        } else {
            UITableViewCell *c = (UITableViewCell *)[self.tableView viewWithTag:_select+3000];
            UITextField *t = (UITextField *)[c viewWithTag:_select+2000];
            double d = [t.text doubleValue];
            tf.text = [NSString stringWithFormat:@"%.3lf", d/[[[self.dataArray objectAtIndex:_select] objectForKey:@"Rebate"] doubleValue]*[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"Rebate"] doubleValue]];
            tf.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    [bgView addSubview:line];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [bgView addGestureRecognizer:swipeGesture];
    UIView *swipeView = [swipeGesture view];
    swipeView.tag = indexPath.row+1000;
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [btn addGestureRecognizer:swipeGesture2];
    UIView *swipeView2 = [swipeGesture2 view];
    swipeView2.tag = indexPath.row;
    
    cell.tag = 3000+indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _isSec = [[ud objectForKey:@"ER_isSec"] boolValue];
    if (!_isSec && indexPath.row == 2) {
        UITapGestureRecognizer *yd_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenYD)];
        
        _yd_view = [[UIView alloc] initWithFrame:self.view.frame];
        _yd_view.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_yd_view] ;
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:_yd_view];
        [_yd_view addGestureRecognizer:yd_tap];
        
        UILabel *yd_lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64+rect.size.height*2)];
        yd_lab1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        yd_lab1.userInteractionEnabled = YES;
        [_yd_view addSubview:yd_lab1];
        [yd_lab1 addGestureRecognizer:yd_tap];
        
        
        UILabel *yd_lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, yd_lab1.frame.size.height+rect.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        yd_lab2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        yd_lab2.userInteractionEnabled = YES;
        [_yd_view addSubview:yd_lab2];
        [yd_lab2 addGestureRecognizer:yd_tap];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-204)/2, yd_lab2.frame.origin.y, 204, 116)];
        image.image = [UIImage imageNamed:@"hl_yd.png"];
        image.userInteractionEnabled = YES;
        [_yd_view addSubview:image];
        [image addGestureRecognizer:yd_tap];
        [self YD];
        [ud setObject:@"YES" forKey:@"ER_isSec"];
        [ud synchronize];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height<=667) {
        return (self.view.frame.size.height-216-64)/5;
    }
    return (self.view.frame.size.height-226-64)/5;
}

- (void) textFieldDidBeginEditing:(BaseTextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:_select+3000];
    BaseTextField *tf = (BaseTextField *)[cell viewWithTag:_select+2000];
    //    tf.font = [UIFont systemFontOfSize:22];
    [tf setMYFont:22];
    tf.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    
    UIView *view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
    view.backgroundColor = [UIColor whiteColor];
    
    _select = textField.tag-2000;
    //    textField.font = [UIFont systemFontOfSize:30];
    [textField setMYFont:30];
    textField.textColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    
    cell = (UITableViewCell *)[self.tableView viewWithTag:_select+3000];
    view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void) returnDictionary:(NSDictionary *)dic andIndex:(NSInteger)x
{
    [self hiddenView];
    [self.dataArray replaceObjectAtIndex:x withObject:dic];
    //    self.dataArray re
    [self.tableView reloadData];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.dataArray forKey:@"exchangerate_cityInfo"];
    [ud setObject:[NSString stringWithFormat:@"%ld", _select] forKey:@"exchangerate_select"];
    [ud synchronize];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    NSLog(@"%@",@"亲，第一个数字不能为小数点");
                    textField.text = @"0.";
                    _isHaveDian = YES;
                    [textField.text stringByReplacingCharactersInRange:range withString:@"0."];
                    return NO;
                }
                //                if (single == '0') {
                //                    NSLog(@"%@",@"亲，第一个数字不能为0");
                //                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                //                    return NO;
                //                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    NSLog(@"%@",@"亲，您已经输入过小数点了");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 3) {
                        return YES;
                    }else{
                        NSLog(@"%@",@"亲，您最多输入两位小数");
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


- (void) textFieldDidChange : (UITextField *)textField
{
    //    [HttpTool cancelRequest];
    if (textField.text.length && textField.text != nil) {
        [self exchangeCalculateWithString:textField.text andIndex:textField.tag-2000];
    } else {
        
    }
    
}

- (void) exchangeCalculateWithString : (NSString *)string andIndex : (NSInteger)x
{
    double d = [string doubleValue];
    for (int i = 0; i < 5; i++) {
        if (i != x) {
            UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:i+3000];
            UITextField *tf = (UITextField *)[cell viewWithTag:i+2000];
            tf.text = [NSString stringWithFormat:@"%.3lf", d/[[[self.dataArray objectAtIndex:x] objectForKey:@"Rebate"] doubleValue]*[[[self.dataArray objectAtIndex:i] objectForKey:@"Rebate"] doubleValue]];
        }
    }
}

- (void) showView : (id)btn
{
    [_erv nowSelect:self.dataArray andSelectIndex:[[btn view] tag]-1000];
    //    for (int i = 0; i < 5; i++) {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:_select+3000];
    UITextField *tf = (UITextField *)[cell viewWithTag:_select+2000];
    [tf resignFirstResponder];
    //    }
    _bgView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _erv.frame = CGRectMake(self.view.frame.size.width/3, _erv.frame.origin.y, _erv.frame.size.width, _erv.frame.size.height);
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        
    }];
}

- (void) hiddenView
{
    [UIView animateWithDuration:0.5 animations:^{
        _erv.frame = CGRectMake(self.view.frame.size.width, _erv.frame.origin.y, _erv.frame.size.width, _erv.frame.size.height);
        _bgView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        _bgView.hidden = YES;
        UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:_select+3000];
        UITextField *tf = (UITextField *)[cell viewWithTag:_select+2000];
        [tf becomeFirstResponder];
        
        [UIView animateWithDuration:1 animations:^{
            _v.frame = CGRectMake(0, _v.frame.origin.y, _v.frame.size.width, _v.frame.size.height);
        } completion:^(BOOL finished) {
        }];
        
    }];
    
}

- (void) bgLabelTouch
{
    [self hiddenView];
}

- (void) swipeGesture : (id) sender
{
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        UIView *view = [swipe view];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake(-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            [self showView:sender];
        }];
        _v = view;
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        
        UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:[swipe view].tag+3000];
        UIView *view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [UIView commitAnimations];
        
    } else {
        NSLog(@"");
    }
}

- (void) YD
{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ShowYD) userInfo:nil repeats:YES];
}

- (void) ShowYD
{
    if (_isLeft) {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:3002];
        UIView *view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        view.frame = CGRectMake(-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [UIView commitAnimations];
        _isLeft = NO;
    } else {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:3002];
        UIView *view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [UIView commitAnimations];
        _isLeft = YES;
    }
}

- (void) hiddenYD
{
    [_timer invalidate];
    _timer = nil;
    UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:3002];
    UIView *view = (UIView *)[cell viewWithTag:cell.tag+1000-3000];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [UIView commitAnimations];
    [_yd_view removeFromSuperview];
    _yd_view = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
