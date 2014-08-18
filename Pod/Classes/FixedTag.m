//
//  FixedTag.m
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import "FixedTag.h"

@interface FixedTag()

@property(nonatomic,retain)UIButton *mainBtn;

@end

@implementation FixedTag

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
        
//        _mainBtn = [[UIButton alloc]initWithFrame:frame];
        _mainBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _mainBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        [_mainBtn setImage:[UIImage imageNamed:@"alBox2.png"] forState:UIControlStateNormal];
        [_mainBtn addTarget:self action:@selector(mainBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _mainBtn.backgroundColor = [UIColor blueColor];
        
        [self addSubview:_mainBtn];
    }
    return self;
}

- (void)setTagString:(NSString *)tagString {
    if (_tagString != tagString) {
        _tagString = tagString;
        
        if (self.autoResize) {
            [self resizeTag:tagString];
        }
//        self.titleLabel.text = tagString;
        [self.mainBtn setTitle:tagString forState:UIControlStateNormal];
        
    }
}

#pragma mark - Auto Resize tag width

-(void)resizeTag:(NSString *)name{
    CGFloat nameWidth = [self getTextWidth:name];
    if(nameWidth>self.frame.size.width-self.frame.size.height){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, nameWidth+self.frame.size.height, self.frame.size.height)];
        [self.mainBtn setFrame:CGRectMake(0, 0, nameWidth+self.frame.size.height, self.frame.size.height)];
    }
    [self.mainBtn setTitle:name forState:UIControlStateNormal];
}

-(CGFloat)getTextWidth:(NSString*)name{
    CGSize textSize;
    if([name respondsToSelector:@selector(sizeWithFont:)]){
        textSize = [name sizeWithFont:self.mainBtn.titleLabel.font];
    }if([name respondsToSelector:@selector(sizeWithAttributes:)]){
        textSize = [name sizeWithAttributes: @{NSFontAttributeName: self.mainBtn.titleLabel.font}];
    }
    return textSize.width;
}


#pragma mark - Customer Interaction

- (void)mainBtnTaped: (id)sender{
    if([self.delegate respondsToSelector:@selector(touchUpInsideBtnAtIndex:)]){
        [self.delegate touchUpInsideBtnAtIndex:self.index];
    }
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
