//
//  BaseLabel.m
//  newHNW
//
//  Created by hnwlbh on 16/10/31.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

- (void) setMYFont:(CGFloat)x
{
    self.font = [UIFont fontWithName:@"MicrosoftYaHei" size:x];
//    self.font = [UIFont fontWithName:@"ArialMT" size:x];

}

+ (UIFont*)returnFont:(CGFloat)x
{
    return [UIFont fontWithName:@"MicrosoftYaHei" size:x];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
