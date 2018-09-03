//
//  ViewController.m
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"3132助手";
    
    [self creatMainBtn];
}
- (void)creatMainBtn{
    
    NSArray *titiles = @[@{@"title":@"安全相册",@"img":@"helper01"},
                         @{@"title":@"安全相册",@"img":@"helper02"},
                         @{@"title":@"安全相册",@"img":@"helper04"},
                         @{@"title":@"号码归属地",@"img":@"helper03"},
                         @{@"title":@"快递查询",@"img":@"helper05"}
                         ];
    for (int i = 0; i < titiles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i % 2 == 0? (self.view.frame.size.width - 120 * 2) / 4.0:self.view.frame.size.width / 2.0 + (self.view.frame.size.width - 120 * 2) / 4.0, 140 + 160 * (i / 2), 120, 140);
//        btn.backgroundColor = [UIColor lightGrayColor];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:titiles[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        NSDictionary *data = titiles[i];
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:data[@"img"]]];
        imgV.frame = CGRectMake(10, 0, 100, 100);
        [btn addSubview:imgV];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 120, 30)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = data[@"title"];
        [btn addSubview:titleLab];
    }
}

- (void)btnClick:(UIButton *)btn{
    NSArray *names = @[@"FirstViewController",@"SecondViewController",@"ThirdViewController",@"FourthViewController",@"FifthViewController"];
    Class c = NSClassFromString(names[btn.tag - 100]);
    
    [self.navigationController pushViewController:[c alloc] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
