//
//  CWViewController.m
//  CWTag
//
//  Created by Millionaryearl on 08/18/2014.
//  Copyright (c) 2014 Millionaryearl. All rights reserved.
//

#import "CWViewController.h"

@interface CWViewController ()

@property (nonatomic, strong)NSMutableArray *nameArr;

@property (nonatomic, strong)TagContainer *tagViewContainer;
@property (nonatomic, strong)IBOutlet UITextView *originalTextResult;
@property (nonatomic, strong)IBOutlet UITextView *modifiedTextResult;
@property (nonatomic, strong)IBOutlet UISwitch *switcher;


@property (nonatomic, strong)TagContainer *tagViewContainer4Fixed;
@property (nonatomic, strong)IBOutlet UITextView *originalTextResult4Fixed;
@property (nonatomic, strong)IBOutlet UITextView *modifiedTextResult4Fixed;
@property (nonatomic, strong)IBOutlet UISwitch *switcher4Fixed;
@property (nonatomic, strong)IBOutlet UILabel *hintLabel;


@end

@implementation CWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initNameArr];
    [self configTagViewContainer];
}


- (void)configTagViewContainer {
    CGRect frame = CGRectMake(0, 300, 1024, 41);
    self.tagViewContainer = [[TagContainer alloc] initWithFrame:frame];
    self.tagViewContainer.containerDataSource = self;
    self.tagViewContainer.containerDelegate = self;
    self.tagViewContainer.contentInset = UIEdgeInsetsMake(2, 4, 2, 4);
    self.tagViewContainer.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.tagViewContainer];
    
    CGRect frame2 = CGRectMake(0, 250, 1024, 41);
    self.tagViewContainer4Fixed = [[TagContainer alloc] initWithFrame:frame2];
    self.tagViewContainer4Fixed.containerDataSource = self;
    self.tagViewContainer4Fixed.containerDelegate = self;
    self.tagViewContainer4Fixed.contentInset = UIEdgeInsetsMake(2, 4, 2, 4);
    self.tagViewContainer4Fixed.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tagViewContainer4Fixed];
    
    
    
}

-(void)initNameArr{
    if (_nameArr) {
        [_nameArr removeAllObjects];
        
        int num = rand()%20;
        for (int i=0; i<num; i++) {
            [_nameArr addObject:[NSString stringWithFormat:@"Tag%d",i]];
        }
        
    }else{
        _nameArr = [[NSMutableArray alloc]init];
    }
    _originalTextResult.text = [NSString stringWithFormat:@"Flexiable Tag -Init version: \r number: %d \r content: %@",[_nameArr count], _nameArr];
    _originalTextResult4Fixed.text = [NSString stringWithFormat:@"Fixed Tag -Init version: \r number: %d \r content: %@",[_nameArr count], _nameArr];
    
}


-(IBAction)doSwitch:(id)sender{
    [self resetTagParams:_switcher.on];
    [_tagViewContainer reloadData:FlexibleTypeTag];
}
-(IBAction)doSwitch4Fixed:(id)sender{
    [self resetTagParams4Fixed:_switcher4Fixed.on];
    [_tagViewContainer4Fixed reloadData:FixedTypeTag];
}

-(void)resetTagParams:(BOOL)defaultSize{
    if(defaultSize){
        _tagViewContainer.tagSize = CGSizeMake(137, 37);
    }else{
        _tagViewContainer.tagSize = CGSizeMake(237, 37);
    }
    
}

-(void)resetTagParams4Fixed:(BOOL)defaultSize{
    if(defaultSize){
        _tagViewContainer4Fixed.tagSize = CGSizeMake(137, 37);
    }else{
        _tagViewContainer4Fixed.tagSize = CGSizeMake(237, 37);
    }
    
}


#pragma mark - Tags dataSource and delegate

- (NSInteger)numberOfTags:(TagContainer *)container {
    return [self.nameArr count];
    
}

- (NSString *)container:(TagContainer *)container tagAtIndex:(NSInteger)index {
    return _nameArr[index];
}

//- (BOOL)container:(TagContainer *)container shouldDeleteTagAtIndex:(NSInteger)index {
//
//
//    return YES;
//}

- (void)container:(TagContainer *)container tagAtIndexDidRemoved:(NSInteger)index {
    [_nameArr removeObjectAtIndex:index];
    _modifiedTextResult.text = [NSString stringWithFormat:@"Flexiable Tag -Current version: \r number: %d \r content: %@",[_nameArr count], _nameArr];
}

-(IBAction)reloadFlexibleTagDate :(id)sender{
    
    [self initNameArr];
    [_tagViewContainer reloadData: FlexibleTypeTag];
    _modifiedTextResult.text = @"";
    
}

-(IBAction)reloadFixedTagDate:(id)sender{
    [self initNameArr];
    [_tagViewContainer4Fixed reloadData: FixedTypeTag];
    _modifiedTextResult4Fixed.text = @"";
    
}

-(void)refreshDate{
    _hintLabel.text = @"Continuous Interaction finished";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _hintLabel.text = @"";
    });
//    [UIView animateWithDuration:1.0f animations:nil completion:^(BOOL finished) {
//        _hintLabel.text = @"";
//    }];
}

-(void)container:(TagContainer *)container fixedTagPressed:(NSInteger)index{
    _modifiedTextResult4Fixed.text = [NSString stringWithFormat:@"Fixed Tag \r the: %d tag pressed\r content: %@",index, _nameArr[index]];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
