//
//  ViewController.m
//  test+collectionView
//
//  Created by fanqi on 2018/9/26.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "ViewController.h"
#import "FQImagePreviewVc.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    FQImagePreviewVc *vc = [[FQImagePreviewVc alloc]init];
    
//    UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:vc];
//    
//    [self presentViewController:navigationVC animated:YES completion:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
