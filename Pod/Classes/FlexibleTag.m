//
//  flexibleTag.m
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import "FlexibleTag.h"

@interface FlexibleTag()

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UIButton *cleanBtn;

@end

@implementation FlexibleTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 1, 0.5f });
        self.layer.borderColor = borderColorRef;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 4.5;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-frame.size.height, frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        _titleLabel.userInteractionEnabled = YES;
        
        _cleanBtn = [[UIButton alloc]initWithFrame:CGRectMake((frame.size.width - frame.size.height), 0, frame.size.height, frame.size.height)];
        [_cleanBtn setImage:[UIImage imageNamed:@"alBox2.png"] forState:UIControlStateNormal];
        [_cleanBtn addTarget:self action:@selector(clearBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleLabel];
        [self addSubview:_cleanBtn];
    }
    return self;
}

- (void)setTagString:(NSString *)tagString {
    if (_tagString != tagString) {
        _tagString = tagString;
        
        if (self.autoResize) {
            [self resizeTag:tagString];
        }
        self.titleLabel.text = tagString;
    }
}


#pragma mark - Auto Resize tag width

-(void)resizeTag:(NSString *)name{
    CGFloat nameWidth = [self getTextWidth:name];
    if(nameWidth>self.frame.size.width-self.frame.size.height){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, nameWidth+self.frame.size.height, self.frame.size.height)];
        [self.titleLabel setFrame:CGRectMake(0, 0, nameWidth, self.frame.size.height)];
        [self.cleanBtn setFrame:CGRectMake(nameWidth, 0, self.frame.size.height, self.frame.size.height)];
    }
    self.titleLabel.text = name;
}

-(CGFloat)getTextWidth:(NSString*)name{
    CGSize textSize;
    if([name respondsToSelector:@selector(sizeWithFont:)]){
        textSize = [name sizeWithFont:self.titleLabel.font];
    }if([name respondsToSelector:@selector(sizeWithAttributes:)]){
        textSize = [name sizeWithAttributes: @{NSFontAttributeName: self.titleLabel.font}];
    }
    return textSize.width;
}

#pragma mark - Customer Interaction

-(void)clearBtnTaped:(id)sender{
    if ([self.delegate respondsToSelector:@selector(touchUpInDeleteBtnAtIndex:)]) {
        [self.delegate touchUpInDeleteBtnAtIndex:self.index];
    }
}

-(void)moveUp:(CGFloat)metric{
    [UIView animateKeyframesWithDuration:0.3f delay:0.1f options:UIViewKeyframeAnimationOptionBeginFromCurrentState  animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-metric, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished){
        self.hidden= YES;
    }];
}

-(void)moveLeft:(CGFloat)metric{
    [UIView animateKeyframesWithDuration:0.3f delay:0.1f options:UIViewKeyframeAnimationOptionBeginFromCurrentState  animations:^{
        self.frame = CGRectMake(self.frame.origin.x-metric, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }completion:nil];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
