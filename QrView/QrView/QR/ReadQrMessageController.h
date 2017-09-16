//
//  ReadQrMessageController.h
//  YouxiniFood
//
//  Created by youxin on 2017/8/3.
//  Copyright © 2017年 YST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol readQRmessageDelegate <NSObject>

- (void)readQRMessage:(NSString*)messageString;

@end

@interface ReadQrMessageController : UIViewController

@property(nonatomic,weak) id<readQRmessageDelegate>readQRdelegate;

//@property(nonatomic,strong)NSString  *title;

@end
