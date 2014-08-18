//
//  FixedTag.h
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FixedTagDelegate <NSObject>

@optional
- (void)touchUpInsideBtnAtIndex:(NSInteger)index;

@end


@interface FixedTag : UIView

@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *tagString;
@property (nonatomic) BOOL autoResize;

@property(nonatomic,weak)id<FixedTagDelegate> delegate;


@end
