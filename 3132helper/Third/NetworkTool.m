//
//  NetworkTool.h
//  BitCoin
//
//  Created by LBH on 2017/9/22.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (instancetype)sharedTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
    });
    
    return instance;
}

- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                   completed:(CallBackSucceed)completedBlock
                      failed:(CallBlockFailure)failed {
    if ([method isEqualToString:@"GET"]) {
        [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            completedBlock([self changeType:jsonDict], jsonStr);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(error);
        }];
    }
    
    if ([method isEqualToString:@"POST"]) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            completedBlock([self changeType:jsonDict], jsonStr);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(error);
        }];
    }
}

//将NSDictionary中的Null类型的项目转化成@""
-(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
-(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSNumber类型转化NSString
- (NSString *)numberToString : (NSNumber *)number
{
    return [NSString stringWithFormat:@"%@", number];
}

//将NSString类型的原路返回
-(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
-(NSString *)nullToString
{
    return @"";
}

//类型识别:将所有的NSNull类型转化成@""
-(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        if ([myObj isKindOfClass:[NSString class]]) {
            if (([myObj compare:@"null" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) || ([myObj compare:@"nil" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)) {
                return [self nullToString];
            }
        }
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else if([myObj isKindOfClass:[NSNumber class]]){
        return [self numberToString:myObj];
    }
    else
    {
        return myObj;
    }
}

@end
