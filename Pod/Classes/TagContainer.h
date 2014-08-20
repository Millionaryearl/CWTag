//
//  TagContainer.h
//  ChensTag
//
//  Created by millionaryearl on 14-8-15.
//  Copyright (c) 2014年 Chen Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlexibleTag.h"
#import "FixedTag.h"

typedef NS_ENUM(NSInteger, SearchType)
{
    FlexibleTypeTag = 0,
    FixedTypeTag = 1,
};

@class TagContainer;

@protocol TagContainerDataSource <NSObject>

@required
/*
 * the number of tags in container
 */
- (NSInteger)numberOfTags:(TagContainer *)container;

/*
 * set the name of tag
 */
- (NSString *)container:(TagContainer *)container tagAtIndex:(NSInteger)index;


@end

@protocol TagContainerDelegate <NSObject>

@optional
/*
 * when a tag is about to be deleted, this method should be called to do further management
 */
- (BOOL)container:(TagContainer *)container shouldDeleteTagAtIndex:(NSInteger)index;
/*
 * when a tag has been deleted, this method should be called to do further management.
 * it enable app to be aware of discrete customer interaction.
 */
- (void)container:(TagContainer *)container tagAtIndexDidRemoved:(NSInteger)index;

/*
 * when continuous user action finished, this method should be called to do further management
 */
- (void)refreshDate;

@required
- (void)container:(TagContainer *)container fixedTagPressed:(NSInteger)index;


@end
@interface TagContainer : UIScrollView<FlexiableTagDelegate, FixedTagDelegate>

@property (nonatomic, weak) id<TagContainerDataSource> containerDataSource;
@property (nonatomic, weak) id<TagContainerDelegate> containerDelegate;

/**
 *  mininum Tag size，decide whether auto resize tag size by autoResizeSubviews propterty
 */
@property (nonatomic) CGSize tagSize;
@property (nonatomic) NSInteger tag;

- (void)reloadData: (NSInteger)tagType;


@end
