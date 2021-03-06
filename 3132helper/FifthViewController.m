//
//  FifthViewController.m
//  3132helper
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "FifthViewController.h"
#import "AFNetworking.h"
#import "MD5.h"
#import "ChooseExpressViewController.h"
#import "ExpressInfo.h"
#import "ExpressTracesViewController.h"


#define eBusinessID @"1261753"
#define appKey @"d715f778-086b-4a25-95be-59dff451abab"
#define reqURL @"http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx"
@interface FifthViewController ()

@property (nonatomic, strong)NSDictionary* expressNameAndCode;

@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"快递查询";
    self.expressNameAndCode = [NSDictionary dictionaryWithObjectsAndKeys:@"AXD",@"安信达快递",@"AYCA",@"澳邮专线",@"BQXHM",@"北青小红帽",
                          @"BFDF",@"百福东方",@"BTWL",@"百世快运",@"HTKY",@"百世快递",@"CNPEX",@"CNPEX中邮快递",@"CCES",@"CCES快递",
                          @"COE",@"COE东方快递",@"CJKD",@"城际快递",@"CITY100",@"城市100",@"CSCY",@"长沙创一",@"DBL",@"德邦",@"DSWL",
                          @"D速物流",@"DTWL",@"大田物流",@"EMS",@"EMS",@"FEDEX",@"FEDEX联邦(国内件）",@"FEDEX_GJ",@"FEDEX联邦(国际件）",
                          @"PANEX",@"泛捷快递",@"FKD",@"飞康达",@"GDEMS",@"广东邮政",@"GSD",@"共速达",@"GTO",@"国通快递",@"GTSD",@"高铁速递",
                          @"HOTSCM",@"鸿桥供应链",@"HPTEX",@"海派通物流公司",@"HFWL",@"汇丰物流",@"ZHQKD",@"汇强快递",@"HLWL",@"恒路物流",
                          @"hq568",@"华强物流",@"HXLWL",@"华夏龙物流",@"HYLSD",@"好来运快递",@"JGSD",@"京广速递",@"JIUYE",@"九曳供应链",
                          @"JJKY",@"佳吉快运",@"JLDT",@"嘉里物流",@"JTKD",@"捷特快递",@"JXD",@"急先达",@"JYKD",@"晋越快递",@"JYM",@"加运美",
                          @"JYWL",@"佳怡物流",@"FAST",@"快捷速递",@"QUICK",@"快客快递",@"KYWL",@"跨越物流",@"LB",@"龙邦快递",@"LHT",
                          @"联昊通速递",@"MHKD",@"民航快递",@"MLWL",@"明亮物流",@"NEDA",@"能达速递",@"PADTF",@"平安达腾飞快递",@"PCA",
                          @"PCA Express",@"QCKD",@"全晨快递",@"QFKD",@"全峰快递",@"UAPEX",@"全一快递",@"QRT",@"全日通快递",@"RFD",@"如风达",
                          @"RFEX",@"瑞丰速递",@"SUBIDA",@"速必达物流",@"SAD",@"赛澳递",@"SAWL",@"圣安物流",@"SBWL",@"盛邦物流",@"SDWL",
                          @"上大物流",@"SF",@"顺丰快递",@"SFWL",@"盛丰物流",@"SHWL",@"盛辉物流",@"ST",@"速通物流",@"STO",@"申通快递",@"STWL",
                          @"速腾快递",@"SURE",@"速尔快递",@"HOAU",@"天地华宇",@"HHTT",@"天天快递",@"TSSTO",@"唐山申通",@"UEQ",@"UEQ Express",
                          @"WJWL",@"万家物流",@"WXWL",@"万象物流",@"XBWL",@"新邦物流",@"XFEX",@"信丰快递",@"XYT",@"希优特",@"XJ",@"新杰物流",
                          @"UC",@"优速快递",@"AMAZON",@"亚马逊物流",@"YADEX",@"源安达快递",@"YCWL",@"远成物流",@"YD",@"韵达快递",@"YDH",
                          @"义达国际物流",@"YFEX",@"越丰物流",@"YFHEX",@"原飞航物流",@"YFSD",@"亚风快递",@"YTKD",@"运通快递",@"YTO",@"圆通速递",
                          @"YXKD",@"亿翔快递",@"YZPY",@"邮政平邮/小包",@"ZENY",@"增益快递",@"ZJS",@"宅急送",@"ZTE",@"众通快递",@"ZTKY",@"中铁快运",
                          @"ZTO",@"中通速递",@"ZTWL",@"中铁物流",@"ZYWL",@"中邮物流", nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.expressComName.length > 1) {
        [self.companyBtn setTitle:self.expressComName forState:UIControlStateNormal];
    }
}


- (IBAction)expressSearch:(id)sender {
    //1.编写上传参数
    NSString* shipperCode = [self.expressNameAndCode objectForKey:self.expressComName];
    NSString* logisticCode = self.orderNumberTextField.text;

    NSString* requestData = [NSString stringWithFormat:@"{\"OrderCode\":\"\",\"ShipperCode\":\"%@\",\"LogisticCode\":\"%@\"}",
                             shipperCode,logisticCode];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSString* dataSignTmp = [[NSString alloc]initWithFormat:@"%@%@",requestData,appKey];
    NSString* dataSign = [NSObject base64String:[MD5 md5String:dataSignTmp] ];
    [params setObject:[requestData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"RequestData"];
    [params setObject:eBusinessID forKey:@"EBusinessID"];
    [params setObject:@"1002" forKey:@"RequestType"];
    [params setObject:[dataSign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"DataSign"];
    [params setObject:@"2" forKey:@"DataType"];
    //2.上传参数并获得返回值
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:reqURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //3. 获得网络数据赋值给ExpressInfo对象
        NSMutableArray* expressTraces = [[NSMutableArray alloc]init];
        for (NSDictionary* traces in [json objectForKey:@"Traces"]) {
            [expressTraces insertObject:traces atIndex:0];
        }
        NSString* shipperCode = [json objectForKey:@"ShipperCode"];
        NSString* logisticCode = [json objectForKey:@"LogisticCode"];
        NSString* expressForUser = @"快递查询";
        
        ExpressInfo* express = [[ExpressInfo alloc]initWitfShipperCode:shipperCode andlogisticCode:logisticCode
                                                     andexpressForUser:expressForUser andexpressTraces:expressTraces];
        //4. 传递数据给ExpresstracesViewController
        ExpressTracesViewController* expressTracesVC = [[ExpressTracesViewController alloc]init];
        expressTracesVC.express = express;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:expressTracesVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error.description);
    }];
}

#pragma mark 关闭键盘
-(void) hiddenKeyboard{
//    [self.expressForUser resignFirstResponder];
//    [self.expressNum resignFirstResponder];
//    [self.expressCompany resignFirstResponder];
    
}
- (IBAction)chooseExpressCompany:(id)sender {
    ChooseExpressViewController* vc = [[ChooseExpressViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
//    [self.expressCompany resignFirstResponder];
}
@end
