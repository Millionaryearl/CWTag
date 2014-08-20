//
//  TagContainer.m
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import "TagContainer.h"

@interface TagContainer (){
    NSTimer *timer;
    int timeLeft;
}

@property (strong, nonatomic) NSMutableArray *tagViews;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

@end


@implementation TagContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self variableInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self variableInit];
    }
    return self;
}

- (void)variableInit {
    self.tagSize = CGSizeMake(137, 37);
    self.autoresizesSubviews = YES;
    self.tagViews = [[NSMutableArray alloc] init];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(responseToSwipe:)];
    [self.swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:self.swipeGesture];
    
    self.clipsToBounds = NO;
}

- (void)reloadData :(NSInteger)tagType {
    //    [self layoutIfNeeded];
    [self cleanSubviews];
    
    NSInteger tags = [self.containerDataSource numberOfTags:self];
    CGFloat offset = self.contentInset.left + 1;
    switch (tagType){
        case FlexibleTypeTag:{
            for (int i=0; i<tags; i++) {
                FlexibleTag *mytag = [[FlexibleTag alloc]initWithFrame:CGRectMake(offset,
                                                                                  0,
                                                                                  self.tagSize.width,
                                                                                  self.tagSize.height)];
                mytag.autoResize = self.autoresizesSubviews;
                mytag.tagString = [self.containerDataSource container:self
                                                           tagAtIndex:i];
                mytag.index = i;
                mytag.delegate =self;
                
                [self.tagViews addObject:mytag];
                [self addSubview:mytag];
                
                offset += mytag.frame.size.width;
                offset += 1;
            }
            break;
        }
        case FixedTypeTag:{
            
            for (int i=0; i<tags; i++) {
                FixedTag *mytag = [[FixedTag alloc]initWithFrame:CGRectMake(offset,
                                                                                  0,
                                                                                  self.tagSize.width,
                                                                                  self.tagSize.height)];
                mytag.autoResize = self.autoresizesSubviews;
                mytag.tagString = [self.containerDataSource container:self
                                                           tagAtIndex:i];
                mytag.index = i;
                mytag.delegate =self;
                
                [self.tagViews addObject:mytag];
                [self addSubview:mytag];
                
                offset += mytag.frame.size.width;
                offset += 1;
            }
            [self removeGestureRecognizer:self.swipeGesture];
            
            break;
        }
    }
    
    self.contentSize = CGSizeMake(offset, self.tagSize.height);
    
    [self setNeedsLayout];
}

- (void)cleanSubviews {
    for (UIView *view in self.tagViews) {
        [view removeFromSuperview];
    }
    
    [self.tagViews removeAllObjects];
}

#pragma mark - Flexible Tag Delegate CallBack method

- (void)touchUpInDeleteBtnAtIndex:(NSInteger)index {
    BOOL delete = YES;
    if ([self.containerDelegate respondsToSelector:@selector(container:shouldDeleteTagAtIndex:)])
    {
        delete = [self.containerDelegate container:self shouldDeleteTagAtIndex:index];
    }
    
    if (delete) {
        [self removeTagAtIndex:index];
    }
}

#pragma mark - Fixed Tag Delegate CallBack method

-(void)touchUpInsideBtnAtIndex:(NSInteger)index{
    if([self.containerDelegate respondsToSelector:@selector(container:fixedTagPressed:)]){
        [self.containerDelegate container:self fixedTagPressed:index];
    }
}

- (FlexibleTag *)FlexibleTagViewAtIndex:(NSInteger)index {
    assert(self.tagViews.count > index);
    return self.tagViews[index];
}

- (void)removeTagAtIndex:(NSInteger)index {
    FlexibleTag *view = [self FlexibleTagViewAtIndex:index];
    CGFloat offset = view.frame.size.width + 1;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.clipsToBounds = YES;
                         CGRect frame = view.frame;
                         frame.size.width = 0.0;
                         view.frame = frame;
                         
                         for (int i=index+1; i<self.tagViews.count; i++) {
                             FlexibleTag *tagView = [self FlexibleTagViewAtIndex:i];
                             tagView.index--;
                             CGRect frame = tagView.frame;
                             frame.origin.x -= offset;
                             tagView.frame = frame;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.tagViews removeObject:view];
                             [view removeFromSuperview];
                             CGSize size = self.contentSize;
                             size.width -= offset;
                             self.contentSize = size;
                             
                             if ([self.containerDelegate respondsToSelector:@selector(container:tagAtIndexDidRemoved:)]) {
                                 [self countDownTimer];
                                 [self.containerDelegate container:self tagAtIndexDidRemoved:index];
                             }
                         }
                     }];
}

#pragma mark -

- (void)responseToSwipe:(UISwipeGestureRecognizer *)gesture {
    FlexibleTag *tag = nil;
    NSInteger index = -1;
    NSInteger i = 0;
    for (FlexibleTag *view in self.tagViews) {
        CGPoint point = [gesture locationInView:view];
        if ([view pointInside:point withEvent:nil]) {
            tag = view;
            index = i;
            break;
        }
        
        i++;
    }
    
    if (index != -1) {
        BOOL delete = YES;
        if ([self.containerDelegate respondsToSelector:@selector(container:shouldDeleteTagAtIndex:)]) {
            delete = [self.containerDelegate container:self
                                shouldDeleteTagAtIndex:index];
        }
        
        if (delete) {
            [self removeTagWithSwipeAtIndex:index withDirection:gesture.direction];
        }
    }
    
}

- (void)removeTagWithSwipeAtIndex:(NSInteger)index
                    withDirection:(UISwipeGestureRecognizerDirection)direction
{
    FlexibleTag *view = [self FlexibleTagViewAtIndex:index];
    CGFloat offset = view.frame.size.width + 1;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -44);
                         view.transform = transform;
                         view.alpha = 0.0;
                         
                         for (int i=index+1; i<self.tagViews.count; i++) {
                             FlexibleTag *tagView = [self FlexibleTagViewAtIndex:i];
                             tagView.index--;
                             CGRect frame = tagView.frame;
                             frame.origin.x -= offset;
                             tagView.frame = frame;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.tagViews removeObject:view];
                             [view removeFromSuperview];
                             CGSize size = self.contentSize;
                             size.width -= offset;
                             self.contentSize = size;
                             
                             if ([self.containerDelegate respondsToSelector:@selector(container:tagAtIndexDidRemoved:)]) {
                                 [self countDownTimer];
                                 [self.containerDelegate container:self tagAtIndexDidRemoved:index];
                             }
                         }
                     }];
}

#pragma mark - User Action Timer

-(void)countDownTimer{
    if(!timer){
        timer = [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
    timeLeft=2;
}
- (void)updateCounter:(NSTimer *)theTimer {
    if(timeLeft > 0 ){
        timeLeft--;
        NSLog(@"%d",timeLeft);
    }
    else{
        //trigger update
        if ([self.containerDelegate respondsToSelector:@selector(refreshDate)]) {
            [self.containerDelegate refreshDate];
        }
        [timer invalidate];
        timer = nil;
    }
}

@end
