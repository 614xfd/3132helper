//
//  FirstViewController.m
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstObjct.h"
#import "TDCache.h"
#import "FirstInfoViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Photos/Photos.h>


@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong)UITableView *tabView;
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSString *filePath;

@property(nonatomic, strong) UIImagePickerController *imagePicker;


@property(nonatomic, strong)UIView *dustView;
@property(nonatomic, strong)UIView *delectImageView;


@property(nonatomic, strong)NSURL *delPath;
@property(nonatomic, strong)NSString *addImagePath;                 //添加的图片本地路径
@property(nonatomic, strong)UIImage *addImage;                      //添加的图片


@property (nonatomic, strong)UISwitch *swith;


@property(nonatomic, assign)BOOL isAddImage;


@property(nonatomic, strong)TDOperator *operator;
@end

@implementation FirstViewController

- (void)creatNavItem{
    //    self.navigationController.navigationBar
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 60, 40);
//    [rightBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    lab.text = @"密码保护";
    lab.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:lab];
    
    self.swith = [[UISwitch alloc]initWithFrame:CGRectMake(70, 7, 50, 30)];
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if ([[userinfo objectForKey:@"isOpenPassWord"] isEqualToString:@"1"]) {
        [self.swith setOn:YES];
    }
    
    [rightView addSubview:self.swith];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (BOOL)prefersStatusBarHidden{
    
    return NO;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
    
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    LAContext *context = [[LAContext alloc] init];
    /// @brief 使用canEvaluatePolicy方法判断当前用户手机是否支持指纹验证

    if (@available(iOS 9.0, *)) {
        if ([[userinfo objectForKey:@"isOpenPassWord"] isEqualToString:@"1"] && !self.operator) {
            BOOL isSupport = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil];
            
            if (!isSupport) {
                NSLog(@"不支持");
                return;
            }
            else
            {
                /// @brief 使用evaluatePolicy方法进行指纹验证
                
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按手指" reply:^(BOOL success, NSError * _Nullable error) {
                    
                    if (success) {
                        
                        NSLog(@"指纹正确");
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        self.filePath = [paths objectAtIndex:0];
                        
                        //创建sqlite模型类
                        FirstObjct *cacheModel = [[FirstObjct alloc]init];
                        //通过模型生产操作者
                        self.operator = [TDOperator instanceWhithModel:cacheModel];
                        
                        
                        self.dataList = [[self.operator findOneWithValue:@"photoAlbum" forKey:@"key"] mutableCopy];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.tabView reloadData];
                        });
                        
                        
                    }
                    
                    else
                        
                    {
                        
                        NSLog(@"指纹错误");
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }];
                
            }
        }else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            self.filePath = [paths objectAtIndex:0];
            
            //创建sqlite模型类
            FirstObjct *cacheModel = [[FirstObjct alloc]init];
            //通过模型生产操作者
            self.operator = [TDOperator instanceWhithModel:cacheModel];
            
            
            self.dataList = [[self.operator findOneWithValue:@"photoAlbum" forKey:@"key"] mutableCopy];
            [self.tabView reloadData];
        }
        
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.filePath = [paths objectAtIndex:0];
        
        //创建sqlite模型类
        FirstObjct *cacheModel = [[FirstObjct alloc]init];
        //通过模型生产操作者
        self.operator = [TDOperator instanceWhithModel:cacheModel];
        
        
        self.dataList = [[self.operator findOneWithValue:@"photoAlbum" forKey:@"key"] mutableCopy];
        [self.tabView reloadData];
    }
    
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *value = self.swith.isOn?@"1":@"0";
    [userinfo setObject:value forKey:@"isOpenPassWord"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全相册";
//    self.filePath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    
    
    
    [self creatNavItem];
    [self creatMainView];
}
- (void)creatMainView{
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = [UIView new];
    self.tabView.backgroundColor = [[UIColor alloc]initWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [self.view addSubview:self.tabView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake((self.view.frame.size.width - 60) / 2.0 , self.view.frame.size.height - 80 - 64, 60, 60);
    [addBtn setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addBtnClick:(UIButton *)addBtn{
    if (self.isAddImage) {
        return;
    }
    
    UIAlertController* ui=[UIAlertController alertControllerWithTitle:@"选择倒入方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil
                           
                           ];
    UIAlertAction* other=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self pickerImage:2];
    }];
    
    
    UIAlertAction* other1=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
         [self pickerImage:1];
    }];
    
    
//    UIAlertAction* reset=[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:nil];
    
    //[ui addAction:reset];
    
    [ui addAction:cancel];
    
    [ui addAction:other];
    
    [ui addAction:other1];
    
    [self presentViewController:ui animated:YES completion:nil];
}

- (void)pickerImage:(int)type{
    NSUInteger sourceType = 0;
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.delegate = self; //设置代理
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType; //图片来源
        if (type == 0) {
            return;
        }else if (type == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }else if (type == 2){
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}





#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
//    image = [UIImage imageNamed:@"delImage"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.filePath,[self getNowTimeTimestamp]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
//    image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    
    self.addImagePath = filePath;
    
    
    self.addImage = image;
    
    if (@available(iOS 11.0, *)) {
        self.delPath = [info objectForKey:UIImagePickerControllerReferenceURL];

        self.isAddImage = YES;
        
        [self.tabView reloadData];
    }
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isAddImage) {
        return self.dataList.count + 1;
    }
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    }
    for (UIView *v in cell.contentView.subviews) {
        if (v.tag == 100) {
            [v removeFromSuperview];
        }
    }
    
    
    if (indexPath.row == self.dataList.count) {
        UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, self.view.frame.size.width - 5 * 2, 100)];
        bView.backgroundColor = [UIColor whiteColor];
        bView.layer.cornerRadius = 4.0;
        bView.tag = 100;
        [cell.contentView addSubview:bView];
        
        
        UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile:self.addImagePath]];
        UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
        imgV.frame = CGRectMake(20, 10, 80, 80);
        [bView addSubview:imgV];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.frame.size.width + imgV.frame.origin.x + 30, 35, 200, 30)];
        titleLab.text = @"创建新相册";
        [bView addSubview:titleLab];
    }else{
        FirstObjct *obj = self.dataList[indexPath.row];
        
        
        UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, self.view.frame.size.width - 5 * 2, 140)];
        bView.backgroundColor = [UIColor whiteColor];
        bView.layer.cornerRadius = 4.0;
        bView.tag = 100;
        bView.clipsToBounds = YES;
        [cell.contentView addSubview:bView];
        
        UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile:obj.cover]];
        UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
        imgV.frame = CGRectMake(0, 0, 140, 140);
        imgV.contentMode = UIViewContentModeScaleToFill;
        [bView addSubview:imgV];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.frame.size.width + imgV.frame.origin.x + 30, 35, 200, 30)];
        titleLab.text = obj.photoAlbumName;
        [bView addSubview:titleLab];
        
        UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height + 20, 30, 30)];
        numberLab.text = [NSString stringWithFormat:@"%d",obj.number];
        [bView addSubview:numberLab];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"photoAlbum"]];
        imgView.frame = CGRectMake(numberLab.frame.origin.x + numberLab.frame.size.width, numberLab.frame.origin.y + 3, 30, 24);
        [bView addSubview:imgView];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if  (indexPath.row == self.dataList.count){
        return 120;
    }else{
        if  (indexPath.row == self.dataList.count - 1){
            return 160;
        }
    }
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataList.count) {//新建相册
        [self showDelectImageViewWithtype:2];
    }else if (self.isAddImage){//将图片添加进指定相册
        FirstObjct *obj = self.dataList[indexPath.row];
        obj.number += 1;
        NSMutableArray *data = [[self stringToJSON:obj.dataJson] mutableCopy];
        [data addObject:self.addImagePath];
        obj.dataJson = [self getJson:data];

        [self.operator deleteWithPrimary:obj.ID];
        [self.operator insertWithModel:obj];
        
        self.isAddImage = NO;
        [self showDelectImageViewWithtype:1];
        [self.tabView reloadData];
    }else{//进入相册
        FirstObjct *obj = self.dataList[indexPath.row];
        FirstInfoViewController *infoVC = [[FirstInfoViewController alloc]init];
        infoVC.cacheID = obj.ID;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataList.count == 0 && !self.isAddImage) {
        return self.view.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    imgV.frame = CGRectMake((self.view.frame.size.width - 80) / 2.0, 200, 80, 80);
    [headerView addSubview:imgV];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(50, 290, self.view.frame.size.width - 50 * 2, 30)];
    lab.text = @"没有相册数据";
    lab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lab];
    
    return headerView;
}




-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

- (void)showDelectImageViewWithtype:(int)type{
    if (!self.dustView) {
        //delectImageView
        
        self.dustView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 66)];
        self.dustView.backgroundColor = [UIColor blackColor];
        self.dustView.alpha = 0.4;
        
        
        self.delectImageView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 280) / 2.0, (self.view.frame.size.height - 320) / 2.0 + 32, 280, 320)];
        self.delectImageView.backgroundColor = [UIColor whiteColor];
        self.delectImageView.layer.cornerRadius = 10.0;
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.delectImageView.frame.size.width, 40)];
        titleLab.tag = 1001;
        titleLab.font = [UIFont systemFontOfSize:13.0];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self.delectImageView addSubview:titleLab];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.delectImageView.frame.size.width, 0.5)];
        lineView1.backgroundColor = [[UIColor alloc]initWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [self.delectImageView addSubview:lineView1];
        
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 50, self.delectImageView.frame.size.width - 30 * 2, 40)];
        textField.placeholder = @"请输入相册名称";
        textField.tag = 1002;
        textField.hidden = YES;
        [self.delectImageView addSubview:textField];
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:self.addImage];
        imgV.frame = CGRectMake(0, 50, self.delectImageView.frame.size.width, 230);
        imgV.tag = 1003;
        textField.hidden = YES;
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.delectImageView addSubview:imgV];
        
        
        UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.delectImageView.frame.size.height - 45, self.delectImageView.frame.size.width, 45)];
        downView.backgroundColor = [UIColor clearColor];
        downView.tag = 1004;
        [self.delectImageView addSubview:downView];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.delectImageView.frame.size.width, 0.5)];
        lineView2.backgroundColor = [[UIColor alloc]initWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [downView addSubview:lineView2];
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 5, self.delectImageView.frame.size.width / 2.0 - 0.5, 45);
        cancelBtn.tag = 1005;
        [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:cancelBtn];
        
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(self.delectImageView.frame.size.width / 2.0, 0, 0.5, 45)];
        lineView3.backgroundColor = [[UIColor alloc]initWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [downView addSubview:lineView3];
        
        UIButton *delectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delectBtn.frame = CGRectMake(self.delectImageView.frame.size.width / 2.0 + 0.5, 5, self.delectImageView.frame.size.width / 2.0 - 0.5, 40);
        delectBtn.tag = 1006;
        [delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:delectBtn];
    }
    UILabel *titleLab = [self.delectImageView viewWithTag:1001];
    UITextField *tf = [self.delectImageView viewWithTag:1002];
    UIImageView *imgV = [self.delectImageView viewWithTag:1003];
    UIView *downView = [self.delectImageView viewWithTag:1004];
    UIButton *cancelBtn = [downView viewWithTag:1005];
    UIButton *delectBtn = [downView viewWithTag:1006];

    if (type == 1) {
        titleLab.text = @"允许“3132助手”从系统相册中删除这张图片";
//        [tf removeFromSuperview];
        tf.hidden = YES;
        imgV.image = self.addImage;
//        [self.delectImageView addSubview:imgV];
        imgV.hidden = NO;
        
        self.delectImageView.frame = CGRectMake((self.view.frame.size.width - 280) / 2.0, (self.view.frame.size.height - 320) / 2.0 + 32, 280, 320);
        downView.frame = CGRectMake(0, self.delectImageView.frame.size.height - 45, self.delectImageView.frame.size.width, 45);
        
        [cancelBtn setTitle:@"不允许" forState:UIControlStateNormal];
        [delectBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }else if (type == 2){
//        [self.delectImageView addSubview:tf];
        titleLab.text = @"请输入新的相册名称";
        tf.hidden = NO;
        imgV.hidden = YES;
//        [imgV removeFromSuperview];
        self.delectImageView.frame = CGRectMake((self.view.frame.size.width - 280) / 2.0, (self.view.frame.size.height - 320) / 2.0 + 32, 280, 150);

         downView.frame = CGRectMake(0, self.delectImageView.frame.size.height - 45, self.delectImageView.frame.size.width, 45);

        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [delectBtn setTitle:@"保存" forState:UIControlStateNormal];
        [delectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    
    
    
    
    [self performSelector:@selector(showView) withObject:nil afterDelay:0.5];
}
- (void)showView{
    if ([NSThread isMainThread]){
        UIView *v = [UIApplication sharedApplication].keyWindow;
        [v addSubview:self.dustView];
        [v addSubview:self.delectImageView];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIView *v = [UIApplication sharedApplication].keyWindow;
            [v addSubview:self.dustView];
            [v addSubview:self.delectImageView];
        });
    }
}
- (void)hideDelectImageView{
    
        
    [self.dustView removeFromSuperview];
    [self.delectImageView removeFromSuperview];
}


- (void)cancelBtnClick:(UIButton *)btn{
    self.delPath = nil;
    [self hideDelectImageView];
    self.isAddImage = NO;
}
- (void)delectBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"保存"]) {
        self.isAddImage = NO;
        UITextField *tf = [self.delectImageView viewWithTag:1002];

        FirstObjct *obj = [[FirstObjct alloc]init];
        
        obj.dataJson = [self getJson:@[self.addImagePath]];
        if (tf.text.length >= 1) {
            obj.photoAlbumName = tf.text;
        }else{
            obj.photoAlbumName = @"未命名文件夹";
        }
        obj.cover = self.addImagePath;
        obj.number = 1;
        obj.key = @"photoAlbum";

        [self.operator insertWithModel:obj];

        [self.dataList addObject:obj];
        [self hideDelectImageView];
        [self showDelectImageViewWithtype:1];
        [self.tabView reloadData];
    }else if ([btn.titleLabel.text isEqualToString:@"删除"]){
        
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[self.delPath] options:nil];
        PHAsset *asset = [result lastObject];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [self hideDelectImageView];
    }
}


@end
