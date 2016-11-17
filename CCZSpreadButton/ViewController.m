//
//  ViewController.m
//  CCZSpreadButton
//
//  Created by 金峰 on 2016/11/10.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "ViewController.h"
#import "CCZSpreadButton.h"

@interface ViewController ()<CCZSpreadButtonDelegate>
@property (nonatomic, strong) CCZSpreadButton *com;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCZSpreadButton *com  = [[CCZSpreadButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    com.itemsNum = 7;
    [self.view addSubview:com];
    self.com = com;
    com.normalImage = [UIImage imageNamed:@"plus_L"];
    com.selImage = [UIImage imageNamed:@"plus_F"];
    com.images = @[@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F"];
    [com spreadButtonDidClickItemAtIndex:^(NSUInteger index) {
        NSLog(@"%ld",index);
    }];
}

- (IBAction)openVisouse:(UISwitch *)sender {
    self.com.spreadButtonOpenViscousity = sender.on;
}
- (IBAction)openClickTemp:(UISwitch *)sender {
    self.com.canClickTempOn = sender.on;
}
- (IBAction)openAutoFit:(UISwitch *)sender {
    self.com.autoAdjustToFitSubItemsPosition = sender.on;
}
- (IBAction)changeSlider:(UISlider *)sender {
    self.com.spreadDis = sender.value;
}
- (IBAction)didChange:(UISegmentedControl *)sender {
    self.com.style = sender.selectedSegmentIndex;
}

@end
