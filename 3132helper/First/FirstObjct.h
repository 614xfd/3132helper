//
//  FirstObjct.h
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstObjct : NSObject

@property(nonatomic,strong)NSString *dataJson;              //相片本地路径数组
@property(nonatomic,strong)NSString *photoAlbumName;        //相册名称
@property(nonatomic,strong)NSString *cover;                 //相册封面图片路径
@property(nonatomic,assign)int number;                      //图片数量
@property(nonatomic,strong)NSString *key;                   //key，统一为“photoAlbum”
@property(nonatomic,assign)int ID;

@end
