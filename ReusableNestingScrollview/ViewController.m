//
//  ViewController.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "ViewController.h"
#import "RNSHandler.h"
#import <objc/runtime.h>
#import "RNSComponentViewPool.h"

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,readwrite,strong) UIScrollView *containerView;
@property(nonatomic,readwrite,strong) RNSHandler *handler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        self.containerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.containerView.backgroundColor = [UIColor lightGrayColor];
        self.containerView.scrollEnabled = YES;
        self.containerView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 10);
        self.containerView;
    })];
    
    [self configRNS];
}

-(void)configRNS{
    
    _handler = [[RNSHandler alloc]initWithScrollView:self.containerView externalScrollViewDelegate:self scrollWorkRange:200 componentViewStateChangeBlock:^(RNSComponentViewState state, RNSComponentItem *componentItem, __kindof UIView *componentView) {
        
        if (state == kRNSComponentViewWillPreparedComponentView) {
            
            NSDictionary *dequeueViews = [[RNSComponentViewPool shareInstance] getDequeueViewsDic];
            NSDictionary *enqueueViews = [[RNSComponentViewPool shareInstance] getEnqueueViewsDic];
            
            NSMutableString *logStr = @"".mutableCopy;
            
            for (NSString *classStr in dequeueViews.allKeys) {
                NSSet *viewSet = [dequeueViews objectForKey:classStr];
                [logStr appendFormat:@"\n dequeueViews------class:%@ -- count:%@",classStr,@(viewSet.count)];
            }
            
            for (NSString *classStr in enqueueViews.allKeys) {
                NSSet *viewSet = [enqueueViews objectForKey:classStr];
                [logStr appendFormat:@"\n enqueueViews-------class:%@ -- count:%@",classStr,@(viewSet.count)];
            }
            
            NSLog(@"%@",logStr);
        }
        
        if (state == kRNSComponentViewWillDisplayComponentView) {
            componentView.backgroundColor = [UIColor blackColor];
            NSLog(@"ViewController will display index:%@",componentItem.uniqueId);
        }
        
        if (state == kRNSComponentViewEndDisplayComponentView) {
            NSLog(@"ViewController will display index:%@",componentItem.uniqueId);
        }
    }];
    
    [_handler reloadComponentViewsWithProcessBlock:^(NSMutableDictionary<NSString *,RNSComponentItem *> *componentItemDic) {
        CGFloat offsetY = 0.f;
        NSArray * viewClassArray = @[@"UIView",@"UIImageView",@"UILabel"];
        
        for (int i = 0 ;i < 20; i++) {
            CGFloat height = (arc4random_uniform(5) + 1) * 25;
            [componentItemDic setObject:[[RNSComponentItem alloc]initWithUniqueId:@(i).stringValue
                                                                   componentFrame:CGRectMake(0, offsetY, [[UIScreen mainScreen] bounds].size.width, height)
                                                               componentViewClass:NSClassFromString([viewClassArray objectAtIndex:arc4random_uniform(3)]) contextBuilder:^__kindof RNSComponentContext *{
                                                                   return [[RNSComponentContext alloc] init];
                                                               }] forKey:@(i).stringValue];
            offsetY += height + 20;
        }
    }];
}

#pragma mark

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"ViewController scrollview did scroll");
}

@end
