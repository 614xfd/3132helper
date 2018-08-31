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
    
    
    [self creatMainBtn];
}
- (void)creatMainBtn{
    
    NSArray *titiles = @[@"1",@"2",@"3",@"4"];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i % 2 == 0? 50:self.view.frame.size.width / 2.0 + 50, 100 + 120 * (i / 2), 100, 100);
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titiles[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    NSArray *names = @[@"FirstViewController",@"SecondViewController",@"ThirdViewController",@"FourthViewController"];
    Class c = NSClassFromString(names[btn.tag - 100]);
    
    [self.navigationController pushViewController:[c alloc] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
