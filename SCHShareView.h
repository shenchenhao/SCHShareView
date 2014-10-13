//
//  SCHShareView.h
//  微信分享
//
//  Created by 沈 晨豪 on 14-5-27.
//  Copyright (c) 2014年 sch. All rights reserved.
//
// 里面的cell 就是一个 button  计数 从 左到右 从下往上  开始

#import <UIKit/UIKit.h>


@class SCHShareView;

@protocol  SCHShareViewDataSource<NSObject>

@required
/**
 *  返回有多少行 放置 cell 的 view (一行可以放很多个按钮) (一行分 左右2个view)
 *
 *  @param share_view 本身
 *
 *  @return NSInteger 行数
 */
- (NSInteger)numberOfRowViewInSCHShareView: (SCHShareView *) share_view;

/**
 *  返回有 多少个cell 在 SCHShareView 上面
 *
 *  @param share_view 本身
 *
 *  @return NSInteger cell 的个数
 */
- (NSInteger)numberOfCellInSCHShareView: (SCHShareView *) share_view;

/**
 *  返回在一个行 view 有一半的块上有 几个cell （一行分 左右2个view）
 *
 *  @param share_view
 *
 *  @return NSInteger cell 个数
 */
- (NSInteger)numberOfCellInHalfOfRowView:(SCHShareView *)share_view;


@optional
/**
 *  返回每一行的view 的size (一行分 左右2个view)
 *
 *  @param share_view  本身
 *  @param index       没一行的view
 *
 *  @return   CGSize   一个rowview 有多大
 */
- (CGSize)sizeOfRowViewInSCHShareView: (SCHShareView *) share_view rowAtIndex: (NSInteger) index;

/**
 *  返回底部view的尺寸
 *
 *  @param share_view 本身
 *
 *  @return CGSize
 */
- (CGSize)sizeOfBottomViewInSCHShareView: (SCHShareView *) share_view;

/**
 *  返回顶部view的尺寸
 *
 *  @param share_view 本身
 *
 *  @return CGSize
 */
- (CGSize)sizeOfTopViewInSCHShareView: (SCHShareView *) share_view;



/**
 *  返回自定义的cell cell其实是一个button （如果实现了该 方法 则  对于cell 的定义的所有信息都将被屏蔽）
 *
 *  @param share_view 本身
 *  @param index      cell索引
 *
 *  @return UIButton *
 */
- (UIButton *)cellInSCHShareRowView: (SCHShareView *) share_view cellAtIndex: (NSInteger) index;


/**
 * cell的大小
 *
 *  @param share_view 本身
 *  @param index      cell索引
 *
 *  @return CGSize
 */
- (CGSize)sizeOfCellInSCHShareRowView: (SCHShareView *) share_view cellAtIndex: (NSInteger) index;

/**
 *  返回cell正常图片
 *
 *  @param share_vew 本身
 *  @param index     cell的索引
 *
 *  @return  UIImage *
 */
- (UIImage *)normalImageForCell: (SCHShareView *) share_vew cellAtIndex: (NSInteger) index;

/**
 *  返回cell被点击的图片
 *
 *  @param share_vew 本身
 *  @param index     cell的索引
 *
 *  @return  UIImage *
 */
- (UIImage *)highlightedImageForCell: (SCHShareView *) share_view cellAtIndex: (NSInteger) index;

/**
 *  返回cell失效的图片
 *
 *  @param share_vew 本身
 *  @param index     cell的索引
 *
 *  @return  UIImage *
 */
- (UIImage *)disabledImageForCell: (SCHShareView *) share_view cellAtIndex: (NSInteger) index;

/**
 *  返回cell被选中的图片
 *
 *  @param share_vew 本身
 *  @param index     cell的索引
 *
 *  @return  UIImage *
 */
- (UIImage *)selectedImageForCell: (SCHShareView *) share_view cellAtIndex: (NSInteger) index;



@end


@protocol SCHShareViewDelegate <NSObject>

/**
 *  指定 cell 被点下
 *
 *  @param share_view  本身
 *  @param index       cell 的index
 */
- (void)shareView: (SCHShareView *) share_view didSelectCellAtIndex: (NSInteger) index;

/**
 *  按下底部button的按钮
 *
 *  @param share_view 本身
 */
- (void)shareViewDidActionBottomView:(SCHShareView *)share_view;

@end

@interface SCHShareView : UIView
{
    struct
    {
        unsigned int numberOfRowViewInSCHShareViewDataSource  : 1;
        unsigned int numberOfCellInSCHShareViewDataSource     : 1;
        unsigned int sizeOfBottomViewInSCHShareViewDataSource : 1;
        unsigned int sizeOfTopViewInSCHShareViewDataSource    : 1;
        unsigned int sizeOfCellInSCHShareRowViewDataSource    : 1;
        unsigned int numberOfCellInHalfOfRowViewDataSource    : 1;
        unsigned int sizeOfRowViewInSCHShareViewDataSource    : 1;
        unsigned int normalImageForCellDataSource             : 1;
        unsigned int highlightedImageForCellDataSource        : 1;
        unsigned int disabledImageForCellDataSource           : 1;
        unsigned int selectedImageForCellDataSource           : 1;
        unsigned int cellInSCHShareRowViewDataSource          : 1;
        
    } _data_source_flags;
    
    struct
    {
        unsigned int didSelectCellDelegate      : 1;
        unsigned int bottomButtonActionDelegate : 1;
        
    }_delegate_flags;
}

@property (nonatomic,weak) id<SCHShareViewDataSource> data_source;
@property (nonatomic,weak) id<SCHShareViewDelegate>   delegate;


/**
 *  显示分享的view
 *
 *  @param view 被添加上去的view
 */
- (void)showShareView: (UIView *) view;

/**
 *  隐藏分享的view
 */
- (void)hiddenShareView;


/**
 *  加载view
 */
- (void)reload;


@end
