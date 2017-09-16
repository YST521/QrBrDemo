//
//  QrBarClickAnimalView.m
//  YouxiniFood
//
//  Created by youxin on 2017/9/1.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "QrBarClickAnimalView.h"

#define SCALE 1.0
#define GLOBALHEIGHT  SceneHeight
#define GLOBALWIDTH    SceneWidth

// 获取物理屏幕的宽度
#define SceneWidth             [[UIScreen mainScreen] bounds].size.width
#define SceneHeight            [[UIScreen mainScreen] bounds].size.height

@implementation QrBarClickAnimalView{
    
}

//原始尺寸
static CGRect oldframe;

/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview code:(NSString*)qrCode type:(NSString *) strType{
    
   
    
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];

    //strType = @"二维码";
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    //    UILabel*codeLa =[[UILabel alloc]init];
    //
    //    codeLa.textColor =[UIColor blackColor];
    //    codeLa.font =[UIFont systemFontOfSize:16];
    //    codeLa.textAlignment = NSTextAlignmentCenter;
    //    [window addSubview:codeLa];
    //
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        //        CGFloat y,width,height;
        //        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //        //宽度为屏幕宽度
        //        width = [UIScreen mainScreen].bounds.size.width;
        //        //高度 根据图片宽高比设置
        //        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, 0, oldframe.size.width * 1.3, oldframe.size.height *1.3)];
        
        //        codeLa.frame = CGRectMake(0, 0, (imageView.width+100)*1.3, 20);
        //        codeLa.text = qrCode;
        
        imageView.center =backgroundView.center;
  
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{

    
    // isEqual(strType, @"二维码")
    //    if ([strType isEqualToString:@"二维码"]) {
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setBounds:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
    
    //    }else{
    //        UIView *backgroundView = tap.view;
    //        //原始imageview
    //        UIImageView *imageView = [tap.view viewWithTag:1];
    //        //恢复
    //        [UIView animateWithDuration:0.4 animations:^{
    //            [imageView setBounds:oldframe];
    //            [backgroundView setAlpha:0];
    //        } completion:^(BOOL finished) {
    //            //完成后操作->将背景视图删掉
    //            [backgroundView removeFromSuperview];
    //        }];
    //    }
}


+(void)scanBarCodeImageWithImageView:(UIImageView *)currentImageview barcode:(NSString *)barcode type:(NSString *) strType{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    strType = @"条形码";
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBarImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        // 旋转图片
        imageView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
        CGFloat y,width,height;
//        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
//        //宽度为屏幕宽度
//        width = [UIScreen mainScreen].bounds.size.width;
//        //高度 根据图片宽高比设置
//        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        //        [imageView setFrame:CGRectMake(50*SCALE, 50*SCALE,150*SCALE , GLOBALHEIGHT - 100*SCALE)];
        
        [imageView setFrame:CGRectMake(50*SCALE, 50*SCALE,150*SCALE , SceneHeight - 100*SCALE)];
        
        
        
        imageView.center =backgroundView.center;
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
        
        UILabel *label = [[UILabel alloc] init];

        label.text = barcode;
   
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:25]];
        label.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        [backgroundView addSubview:label];
        [label setFrame:CGRectMake(60*SCALE, 50*SCALE,20*SCALE , GLOBALHEIGHT - 100*SCALE)];
        
        UILabel *warringlabel = [[UILabel alloc] init];
        warringlabel.text = @"付款码数字仅用于支付时向收银员展示，请勿泄露以防诈骗";
        warringlabel.textAlignment = NSTextAlignmentCenter;
        [warringlabel setFont:[UIFont systemFontOfSize:15]];
        warringlabel.textColor =[UIColor colorWithRed:250 green:218 blue:141 alpha:1.0];
        warringlabel.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        [backgroundView addSubview:warringlabel];
        //        [warringlabel setFrame:CGRectMake((GLOBALWIDTH - 400)/2, 50*SCALE,20*SCALE , 400)];
        [warringlabel setFrame:CGRectMake(GLOBALWIDTH - 60*SCALE, (GLOBALHEIGHT - 400)/2,15 , 400)];
        
        
        UIImageView *alartImageView = [[UIImageView alloc] init];
        alartImageView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        alartImageView.image = [UIImage imageNamed:@"pay_cok_image"];
        [backgroundView addSubview:alartImageView];
        
        [alartImageView setFrame:CGRectMake(GLOBALWIDTH - 60*SCALE, 60*SCALE,20*SCALE , 20*SCALE)];
        [alartImageView setFrame:CGRectMake(GLOBALWIDTH - 60*SCALE, ((GLOBALHEIGHT - 400)/2) - 15,15 , 15)];
        
        
        
    }];
    
}

//条形码隐藏
+(void)hideBarImageView:(UITapGestureRecognizer *)tap{

    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setBounds:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
    //}
}





@end
