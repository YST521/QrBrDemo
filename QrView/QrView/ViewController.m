//
//  ViewController.m
//  QrView
//
//  Created by youxin on 2017/9/16.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "ViewController.h"
#import "ReadQrMessageController.h"
#import "CreatQrImage.h"
#import "QrBarClickAnimalView.h"



@interface ViewController ()<readQRmessageDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qrimageV;
@property (weak, nonatomic) IBOutlet UIImageView *barImageV;
@property(nonatomic,strong)NSString  *qrString;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.qrString = @"生成扫描二维码条形码";
    
      self.qrimageV.image = [CreatQrImage createQRimageString:self.qrString sizeWidth: self.qrimageV.frame.size.width fillColor:[UIColor whiteColor]];
    
    //条形码
    CIImage *ciImage = [self generateBarCodeImage:@"123456789"];
    UIImage *image = [self resizeCodeImage:ciImage withSize:CGSizeMake((self.view.frame.size.width - 80), 80)];
   self.barImageV.image = image;
    
    self.qrimageV.userInteractionEnabled = YES;
    self.barImageV.userInteractionEnabled = YES;
    
    //点击
    UITapGestureRecognizer *qrTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qrTapAction:)];
    UITapGestureRecognizer *barTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(barTapAction:)];
    
    
    
    [self.qrimageV addGestureRecognizer:qrTap];
    [self.barImageV addGestureRecognizer:barTap];

    
}



-(void)qrTapAction:(UITapGestureRecognizer*)sender{
    
    // [self creatQrPopView];
    [QrBarClickAnimalView scanBigImageWithImageView:self.qrimageV code:self.qrString type:@"二维码"];
    
}

-(void)barTapAction:(UITapGestureRecognizer*)sender{
    
    // [self creatBarView];
    [QrBarClickAnimalView scanBarCodeImageWithImageView:self.barImageV barcode:self.qrString type:@"条形码"];
    
}

- (IBAction)readQRbR:(id)sender {
    
    ReadQrMessageController *readQrVC =[[ReadQrMessageController alloc]init];
    readQrVC.title = @"收付款";
    readQrVC.readQRdelegate = self;
    [self.navigationController pushViewController:readQrVC animated:YES];
    

}
-(void)readQRMessage:(NSString *)messageString{

    NSLog(@"读取结果为%@",messageString);

}


/**
 *  调整生成的图片的大小
 *
 *  @param image CIImage对象
 *  @param size  需要的UIImage的大小
 *
 *  @return size大小的UIImage对象
 */
- (UIImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}

/**
 *  生成条形码
 *
 *  @param source
 *
 *  @return 生成条形码的CIImage对象
 */
- (CIImage *) generateBarCodeImage:(NSString *)source
{
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 注意生成条形码的编码方式
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        // 设置生成的条形码的上，下，左，右的margins的值
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
