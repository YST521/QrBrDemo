//
//  ReadQrMessageController.m
//  YouxiniFood
//
//  Created by youxin on 2017/8/3.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "ReadQrMessageController.h"

#import <AVFoundation/AVFoundation.h>

/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

//#define TOP (SCREEN_HEIGHT-220)/2
#define TOP 150
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface ReadQrMessageController ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIImageView * line;

@property(nonatomic,strong)UILabel                 *naTitle;
@property(nonatomic,strong)UILabel                 *naSubTitle;

@end

@implementation ReadQrMessageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setCropRect:kScanRect];
    
//    self.title = @"扫一扫";
//    [self setTitle:@"扫一扫"];
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.01];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"扫一扫"];
    
    //黑色背景 去掉则为透明背景
    self.view.backgroundColor =[UIColor blackColor];
    
    [self creatNav];
    [self configView];
  
}

- (void)creatNav{
    
    UIView *la = [[UIView alloc]init];
    la.frame = CGRectMake(0, 20,[UIScreen mainScreen].bounds.size.width, 44);
    
    self.naTitle = [[UILabel alloc]init];
    self.naTitle.frame = CGRectMake(la.frame.size.width*0.25,(44-23)/2, 60, 23.0f);
  
    self.naTitle.textColor =[UIColor whiteColor];
    self.naTitle.textAlignment = NSTextAlignmentCenter;
    self.naTitle.font = [UIFont systemFontOfSize:17];
    [la addSubview: self.naTitle];
    self.naTitle.text  = @"扫一扫";
    self.naTitle.textColor =[UIColor greenColor];
//  //    self.naSubTitle = [[UILabel alloc]init];
//    self.naSubTitle.frame = CGRectMake(0, 24,SceneWidth-150.0f, 17.0f);
//    self.naSubTitle.textColor =[UIColor whiteColor];
//    self.naSubTitle.textAlignment = NSTextAlignmentCenter;
//    self.naSubTitle.font =[UIFont systemFontOfSize:14];
//    [la addSubview:   self.naSubTitle];
//    self.naSubTitle.text  =[self currentTimeYYMM];
//    la.backgroundColor =[UIColor redColor];
    self.navigationItem.titleView = la;
}


-(void)configView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}


-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    
     //Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //二维码
   // [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    //二维码 +条形码
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        //代理传出扫描结果
        if ( stringValue.length > 0  && [self.readQRdelegate respondsToSelector:@selector(readQRMessage:)]) {
            
             [self.readQRdelegate readQRMessage:stringValue];
        }
     
        
        NSArray *arry = metadataObject.corners;
        for (id temp in arry) {
            NSLog(@"%@",temp);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_session != nil && timer != nil) {
                [_session startRunning];
                [timer setFireDate:[NSDate date]];
            }
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
