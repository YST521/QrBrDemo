//
//  QrBarClickAnimalView.h
//  YouxiniFood
//
//  Created by youxin on 2017/9/1.
//  Copyright © 2017年 YST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QrBarClickAnimalView : NSObject

/**
 *  浏览大图
 *
 //   图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview code:(NSString*)qrCode type:(NSString *) strType;

+(void)scanBarCodeImageWithImageView:(UIImageView *)currentImageview barcode:(NSString *)barcode type:(NSString *) strType;


@end
