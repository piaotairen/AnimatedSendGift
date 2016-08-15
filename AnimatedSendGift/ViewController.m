//
//  ViewController.m
//  AnimatedSendGift
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "ViewController.h"
#import "LSGiftDisplayView.h"
#import "LSGiftFIFOManager.h"
#import "YYText.h"

@interface ViewController ()

@property (nonatomic,strong) LSGiftDisplayView *giftView;

@property (nonatomic,readwrite,strong) YYLabel *giftComboLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftView = [[LSGiftDisplayView alloc]initWithFrame:CGRectMake(20, 200, 250, 100)];
    self.giftView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.giftView];
    
    
    self.giftComboLabel = ({
        _giftComboLabel = [[YYLabel alloc]initWithFrame:CGRectMake(20, 100, 70, 30)];
        _giftComboLabel.backgroundColor = [UIColor clearColor];
        _giftComboLabel.textAlignment = NSTextAlignmentCenter;
        _giftComboLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _giftComboLabel.numberOfLines = 1;
        _giftComboLabel;
    });//发送礼物combo连击数
    [self.view addSubview:self.giftComboLabel];
    
    
    NSMutableAttributedString *comboNumber = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ⅹ %d",12]];
    comboNumber.yy_font = [UIFont boldSystemFontOfSize:35];
    comboNumber.yy_color = [UIColor greenColor];
    YYTextShadow *shadow = [YYTextShadow new];
    shadow.color = [UIColor yellowColor];
    shadow.offset = CGSizeMake(0, 0);
    shadow.radius = 10;
    comboNumber.yy_textShadow = shadow;
    self.giftComboLabel.attributedText = comboNumber;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendGift:(id)sender {
    [[LSGiftFIFOManager manager] saveGiftMessage:@"safjdla"];
}

- (IBAction)showGift:(id)sender {
    
    [self.giftView animatedShowFromLeft];
}
- (IBAction)oneTEST:(id)sender {
    [[LSGiftFIFOManager manager] popFirstMessageWithCompletion:^(LSGiftDisplayInfo *info){
        NSLog(@"info IS %p",info);
    }];
}
- (IBAction)twoTEST:(id)sender {
    [[LSGiftFIFOManager manager] popFirstTwoMessgesWithCompletion:^(NSArray *info){
        NSLog(@"info IS %@",info);
    }];
}

@end
