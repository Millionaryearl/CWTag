//
//  flexibleTag.h
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlexiableTagDelegate <NSObject>

@optional
- (void)touchUpInDeleteBtnAtIndex:(NSInteger)index;

@end


@interface FlexibleTag : UIView

-(void)moveLeft:(CGFloat)metric;
-(void)moveUp:(CGFloat)metric;
//-(void)resizeTag:(NSString*)name;

@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *tagString;
@property (nonatomic) BOOL autoResize;

@property(nonatomic,weak)id<FlexiableTagDelegate> delegate;

@end
