//
//  RNSHandler.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNSComponentItem.h"

typedef NS_ENUM(NSInteger, RNSComponentViewState) {
    kRNSComponentViewWillPreparedComponentView,
    kRNSComponentViewWillDisplayComponentView,
    kRNSComponentViewEndDisplayComponentView,
    kRNSComponentViewEndPreparedComponentView,
};

typedef void (^RNSComponentViewStateChangeBlock)(RNSComponentViewState state ,RNSComponentItem *componentItem ,__kindof UIView * componentView);

typedef void (^RNSComponentProcessItemBlock)(NSMutableDictionary<NSString *,RNSComponentItem *> * componentItemDic);


@interface RNSHandler : NSObject

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView
        externalScrollViewDelegate:(__weak NSObject <UIScrollViewDelegate>*)externalDelegate
                   scrollWorkRange:(CGFloat)scrollWorkRange
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock;

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock;

- (RNSComponentItem *)getComponentItemByUniqueId:(NSString *)uniqueId;
- (__kindof UIView *)getComponentViewByItem:(RNSComponentItem *)item;
- (NSArray <RNSComponentItem *>*)getAllComponentItems;

@end
