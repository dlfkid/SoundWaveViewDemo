//
//  UIColor+Ex.h
//  IntelliCom
//
//  Created by weida on 2018/8/28.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ex)

+ (UIColor *)colorWithHexString: (NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIImage *)CreateImageWithColor:(UIColor *)color Size:(CGSize)size;
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha;
+ (UIColor *)uitableViewDefaultBackgroundColor;
+ (UIColor *)tintColor;
+ (UIColor *)backgroundColor;
@end
