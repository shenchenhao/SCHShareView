//
//  SCHShareView.m
//  微信分享
//
//  Created by 沈 晨豪 on 14-5-27.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import "SCHShareView.h"


#define ullchange(a,b) a##b
#define SCH_ROW_HEGIHT 60.0f

#pragma mark -
#pragma mark - SChShareRowView

@interface SCHShareRowView :UIView

@property (nonatomic,assign) CGRect     show_rect;
@property (nonatomic,assign) CGRect     hidden_rect;


@property (nonatomic,strong) UIView    *left_view;
@property (nonatomic,strong) UIView    *rihgt_view;


@property (nonatomic,assign) NSInteger  animation_count;


@property (nonatomic,copy  ) void (^animation_finish_block)();

- (void)startCloseAnimation: (void (^)(void)) finish_block
                      delay:(NSTimeInterval)delay;

- (void)hiddenLeftAndRightView;

@end

@implementation SCHShareRowView

#pragma mark -
#pragma mark - init 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGSize size = CGSizeMake(frame.size.width / 2.0f,
                                 frame.size.height);
        
        self.left_view = [[UIView alloc] initWithFrame:CGRectMake(-size.width / 2.0f,
                                                                  0.0f,
                                                                  size.width,
                                                                  size.height)];
        self.left_view.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
        
        self.rihgt_view = [[UIView alloc] initWithFrame:CGRectMake( size.width * 3.0f / 2.0f,
                                                                   0.0f,
                                                                   size.width,
                                                                   size.height)];
        
        self.rihgt_view.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        
        self.left_view.backgroundColor  = [UIColor whiteColor];
        self.rihgt_view.backgroundColor = [UIColor whiteColor];
//        self.left_view.backgroundColor = [UIColor colorWithRed:random()%255 / 255.0f green:random()%255 / 255.0f blue:random()%255 / 255.0f alpha:1.0f];
//        self.rihgt_view.backgroundColor = [UIColor colorWithRed:random()%255 / 255.0f green:random()%255 / 255.0f blue:random()%255 / 255.0f alpha:1.0f];
        
        self.left_view.hidden           = YES;
        self.rihgt_view.hidden          = YES;
        
        [self addSubview:self.left_view];
        [self addSubview:self.rihgt_view];
    }
    
    return self;
}


CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)startCloseAnimation:(void (^)(void))finish_block
{
    self.animation_finish_block = finish_block;
    
    self.animation_count        = 0;
    
    self.left_view.hidden       = NO;
    self.rihgt_view.hidden       = NO;
    
    /*left view */
    CATransform3D left_view_rotate_start =  CATransform3DMakeRotation(-M_PI /1.01, 0, 1, 0);
    CATransform3D left_view_rotate_end   = CATransform3DMakeRotation(0.0f, 0, 1, 0);
    
    self.left_view.layer.transform = CATransform3DPerspect(left_view_rotate_start, CGPointMake(0, 0), 800);
    
    CABasicAnimation *left_view_transform_animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    left_view_transform_animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DPerspect(left_view_rotate_start, CGPointMake(0, 0), 800)];
    left_view_transform_animation.toValue =  [NSValue valueWithCATransform3D:CATransform3DPerspect(left_view_rotate_end, CGPointMake(0, 0), 800)
                            ];
    left_view_transform_animation.removedOnCompletion = NO;
    left_view_transform_animation.fillMode =kCAFillModeForwards;
    left_view_transform_animation.duration = 0.3;
    left_view_transform_animation.delegate = self;
    
    [left_view_transform_animation setValue:@"left" forKey:@"transform_key"];
    
    [self.left_view.layer addAnimation:left_view_transform_animation forKey:@"left_view_layer_key"];
    
    /*right view*/
    CATransform3D right_view_rotate_start = CATransform3DMakeRotation(M_PI /1.01, 0, 1, 0);
    CATransform3D right_view_rotate_end   = CATransform3DMakeRotation(0.0f, 0, 1, 0);
    
    self.rihgt_view.layer.transform = CATransform3DPerspect(right_view_rotate_start, CGPointMake(0, 0), 800);
    
    CABasicAnimation *right_view_transform_animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    right_view_transform_animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DPerspect(right_view_rotate_start, CGPointMake(0, 0), 800)];
    right_view_transform_animation.toValue =  [NSValue valueWithCATransform3D:CATransform3DPerspect(right_view_rotate_end, CGPointMake(0, 0), 800)
                                    ];
    right_view_transform_animation.removedOnCompletion = NO;
    right_view_transform_animation.fillMode = kCAFillModeForwards;
    right_view_transform_animation.duration = 0.3;
    right_view_transform_animation.delegate = self;
    
    [right_view_transform_animation setValue:@"right" forKey:@"transform_key"];
    
    [self.rihgt_view.layer addAnimation:right_view_transform_animation forKey:@"right_view_layer_key"];
}

/**
 *  开始关闭动画
 *
 *  @param finish_block 完成的block
 *  @param delay        延迟时间
 */
- (void)startCloseAnimation:(void (^)(void))finish_block delay: (NSTimeInterval) delay
{
    //dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ullchange(3, ull) *  NSEC_PER_MSEC)
    [self performSelector:@selector(startCloseAnimation:) withObject:finish_block afterDelay:delay];
}

- (void)hiddenLeftAndRightView
{
    self.left_view.hidden = YES;
    self.rihgt_view.hidden = YES;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    ++self.animation_count;
    
    NSString *value = [anim valueForKey:@"transform_key"];
    
    if ([value isEqualToString:@"right"])
    {
        CATransform3D  right_view_rotate_end  = CATransform3DMakeRotation(0.0f, 0, 1, 0);
        self.rihgt_view.layer.transform = right_view_rotate_end;
        
        [self.rihgt_view.layer removeAllAnimations];
        
    }
    else if([value isEqualToString:@"left"])
    {
        CATransform3D left_view_rotate_end = CATransform3DMakeRotation(0.0f, 0, 1, 0);

        self.left_view.layer.transform = left_view_rotate_end;
        
        [self.left_view.layer removeAllAnimations];
    }

    
    if (2 == self.animation_count)
    {
        self.animation_finish_block();
    }
}


@end


#pragma mark -
#pragma mark - SCHShareView

@interface SCHShareView ()
{
    NSInteger _number_of_row;               //行数
    
    NSInteger _number_of_cell;              //有多少个单元
    
    NSInteger _number_of_cell_in_half_view; //半个的view有多cell
    
    CGFloat   _top_height;                  //顶部view的高度
    
    CGFloat   _bottom_height;               //底部view的高度
    
    CGFloat   _row_height;                  //row的高度
    
    CGFloat   _all_height;                  //总高度
    
    CGRect    _top_show_rect;               //顶部view的显示frame
    
    CGRect    _bottom_show_rect;            //底部view的显示frame
    
    
}
@property (nonatomic,strong) NSMutableArray *cell_array;
@property (nonatomic,strong) NSMutableArray *row_view_array;

@property (nonatomic,strong) UIView         *bottom_view;
@property (nonatomic,strong) UIView         *top_view;
@property (nonatomic,strong) UIView         *shade_view;
@property (nonatomic,assign) BOOL            is_do_animation;  //是否在做动画



@end

@interface  SCHShareView (private)

- (void)bottomButtonAction: (id) sender;

- (void)clean;

- (void)load;

- (void)show;

- (void)cellButtonAction: (id) sender;



@end


@implementation SCHShareView

#pragma mark -
#pragma mark - private

- (void)bottomButtonAction: (id) sender
{
    if (_delegate_flags.bottomButtonActionDelegate)
    {
        [self.delegate shareViewDidActionBottomView:self];
    }
}

- (void)clean
{
    typeof(self) __weak temp_self = self;
    typeof(self)      strong_self = temp_self;
    
    [self.cell_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         
        UIView *cell = (UIView *)obj;
         [cell removeFromSuperview];
        
    }];
    
    [strong_self.cell_array removeAllObjects];
    
    [self.row_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         UIView *cell = (UIView *)obj;
         [cell removeFromSuperview];
     }];
    [strong_self.row_view_array removeAllObjects];

    
    [self.bottom_view removeFromSuperview];
    [self.top_view removeFromSuperview];
    [self.shade_view removeFromSuperview];
    
    self.bottom_view = nil;
    self.top_view    = nil;
    
    _top_height    = 0.0f;
    _bottom_height = 0.0f;
    _row_height    = 0.0f;
    _all_height    = 0.0f;
    
    _number_of_cell              = 0;
    _number_of_row               = 0;
    _number_of_cell_in_half_view = 0;
    
    
}

- (void)load
{
    self.shade_view                 = [[UIView alloc] initWithFrame:self.bounds];
    self.shade_view.backgroundColor = [UIColor blackColor];
    self.shade_view.alpha           = 0.0f;
    
    
    /**
     *  行数
     */
    if (_data_source_flags.numberOfRowViewInSCHShareViewDataSource)
    {
        _number_of_row = [self.data_source numberOfRowViewInSCHShareView:self];
    }
    else
    {
        return;
    }
    
    
    _all_height = 0.0f;
    
    
    
    /**
     *  底部的高度
     */
    if (_data_source_flags.sizeOfBottomViewInSCHShareViewDataSource)
    {
        
        CGSize    size = [self.data_source sizeOfBottomViewInSCHShareView:self];
        _bottom_height = size.height;
        _all_height   += _bottom_height;
        
        self.bottom_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                    self.frame.size.height - _bottom_height,
                                                                    size.width,
                                                                    _bottom_height)];
        self.bottom_view.backgroundColor = [UIColor clearColor];
        
        
    }
    else
    {
        CGSize size = CGSizeMake(self.frame.size.width,
                                 SCH_ROW_HEGIHT);
        _bottom_height = SCH_ROW_HEGIHT;
        _all_height   += _bottom_height;
        
        self.bottom_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                    self.frame.size.height - _bottom_height,
                                                                    size.width,
                                                                    _bottom_height)];
        self.bottom_view.backgroundColor = [UIColor clearColor];
        
    }
    
    _bottom_show_rect = self.bottom_view.frame;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:30.0f / 255.0f green:166.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [button setFrame:self.bottom_view.bounds];
    [self.bottom_view addSubview:button];
    
    CALayer *line_layer = [CALayer layer];
    line_layer.frame    = CGRectMake(15.0f, 5.0f, _bottom_show_rect.size.width - 30.0f, 1.0f);
    line_layer.backgroundColor = [UIColor colorWithRed:30.0f / 255.0f green:166.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f].CGColor;
    [self.bottom_view.layer addSublayer:line_layer];
    
    /**
     *  row的 高度 和宽度
     */
    if (_data_source_flags.sizeOfRowViewInSCHShareViewDataSource)
    {
        _row_height = 0.0f;
        
        for (int i = 0; i < _number_of_row; ++i)
        {

            CGSize size = [_data_source sizeOfRowViewInSCHShareView:self rowAtIndex:i];

            _row_height += size.height;
            _all_height += size.height;
            
            CGRect frame = CGRectMake((CGRectGetWidth(self.frame)  - size.width) / 2.0f,
                                        CGRectGetHeight(self.frame) - _all_height,
                                        size.width,
                                        size.height);
            
            SCHShareRowView *row_view = [[SCHShareRowView alloc] initWithFrame:frame];
            
            row_view.show_rect        = frame;
            row_view.hidden_rect      = CGRectOffset(frame,
                                                     0.0f,
                                                     self.frame.size.height + 200.0f);
            
            [self.row_view_array addObject:row_view];
           
        }
  
    }
    else
    {
        _row_height = 0.0f;
        CGSize size = CGSizeMake(self.frame.size.width,
                                 SCH_ROW_HEGIHT);
        
        for (int i = 0; i < _number_of_row; ++i)
        {
        
            
            _row_height += size.height;
            _all_height += size.height;
            
            CGRect frame = CGRectMake((CGRectGetWidth(self.frame)  - size.width) / 2.0f,
                                      CGRectGetHeight(self.frame) - _all_height,
                                      size.width,
                                      size.height);
            
            SCHShareRowView *row_view = [[SCHShareRowView alloc] initWithFrame:frame];
            
            row_view.show_rect        = frame;
            row_view.hidden_rect      = CGRectOffset(frame,
                                                     0.0f,
                                                     self.frame.size.height + 200.0f);
            
            [self.row_view_array addObject:row_view];
            
        }
    }
    
    /**
     *  顶部的高度
     */
    if (_data_source_flags.sizeOfTopViewInSCHShareViewDataSource)
    {
        CGSize    size = [self.data_source sizeOfTopViewInSCHShareView:self];
        _top_height = size.height;
        _all_height   += _top_height;
        
        self.top_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                 self.frame.size.height - _all_height,
                                                                 size.width,
                                                                 _top_height)];
        self.top_view.backgroundColor = [UIColor blackColor];
    }
    else
    {
        CGSize    size = CGSizeMake(self.frame.size.width,
                                    SCH_ROW_HEGIHT);
        _top_height = size.height;
        _all_height   += _top_height;
        
        self.top_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                 self.frame.size.height - _all_height,
                                                                 size.width,
                                                                 _top_height)];
        self.top_view.backgroundColor = [UIColor clearColor];
    }
    
    _top_show_rect = self.top_view.frame;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.top_view.bounds];
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    label.text = @"分享到";
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.top_view addSubview:label];
    
    
    /**
     *  cell 的内容
     */
    
    if (_data_source_flags.numberOfCellInSCHShareViewDataSource)
    {
        _number_of_cell = [self.data_source numberOfCellInSCHShareView:self];
    }
    else
    {
        /*必须实现*/
    }
    
    if (_data_source_flags.numberOfCellInHalfOfRowViewDataSource)
    {
        _number_of_cell_in_half_view = [self.data_source numberOfCellInHalfOfRowView:self];
    }
    else
    {
        /*必须实现*/
    }
    
#pragma mark -
#pragma mark - cell 
    
    
    /*如果 实现了button 则关于定义 cell的属性 不复*/
    if (_data_source_flags.cellInSCHShareRowViewDataSource)
    {
        for (int i = 0; i < _number_of_cell; ++i)
        {
            UIButton *button = [self.data_source cellInSCHShareRowView:self cellAtIndex:i];
            
            [button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.cell_array addObject:button];
        
        }
        return;
    }
    
    if (_data_source_flags.sizeOfCellInSCHShareRowViewDataSource)
    {
        for (int i = 0; i < _number_of_cell; ++i)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGSize    size   = [self.data_source sizeOfCellInSCHShareRowView:self cellAtIndex:i];
            
            button.frame     = CGRectMake(0.0f,
                                          0.0f,
                                          size.width ,
                                          size.height);
            button.backgroundColor = [UIColor clearColor];
            
            /*正常图片*/
            if (_data_source_flags.normalImageForCellDataSource)
            {
                UIImage *image = [self.data_source normalImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
            }
            
            /*被点击的时候的图片*/
            if (_data_source_flags.highlightedImageForCellDataSource)
            {
                UIImage *image = [self.data_source highlightedImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateHighlighted];

            }
            
            /*被选中的时候的图片*/
            if (_data_source_flags.selectedImageForCellDataSource)
            {
                UIImage *image = [self.data_source selectedImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateSelected];

            }
            
            /*失效的时候的图片*/
            if (_data_source_flags.disabledImageForCellDataSource)
            {
                UIImage *image = [self.data_source disabledImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateDisabled];

            }
            
            [button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.cell_array addObject:button];
        }
    }
    else
    {
        CGSize size;
        
        for (int i = 0; i < _number_of_cell; ++i)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            NSInteger        index      = i / (2 * _number_of_cell_in_half_view);
            
            SCHShareRowView *row_view   = [self.row_view_array objectAtIndex:index];
            size                        = CGSizeMake(row_view.frame.size.width / (2 * _number_of_cell_in_half_view),
                                                     row_view.frame.size.height);
            
            button.frame     = CGRectMake(0.0f,
                                          0.0f,
                                          size.width ,
                                          size.height);
            button.backgroundColor = [UIColor clearColor];
            
            /*正常图片*/
            if (_data_source_flags.normalImageForCellDataSource)
            {
                UIImage *image = [self.data_source normalImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
            }
            
            /*被点击的时候的图片*/
            if (_data_source_flags.highlightedImageForCellDataSource)
            {
                UIImage *image = [self.data_source highlightedImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateHighlighted];
                
            }
            
            /*被选中的时候的图片*/
            if (_data_source_flags.selectedImageForCellDataSource)
            {
                UIImage *image = [self.data_source selectedImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateSelected];
                
            }
            
            /*失效的时候的图片*/
            if (_data_source_flags.disabledImageForCellDataSource)
            {
                UIImage *image = [self.data_source disabledImageForCell:self cellAtIndex:i];
                [button setImage:image forState:UIControlStateDisabled];
                
            }
            
            [button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.cell_array addObject:button];
        }
    }
    
}

- (void)show
{
    [self addSubview:self.shade_view];
    
    self.top_view.frame = CGRectOffset(_top_show_rect,
                                      0.0f,
                                      self.frame.size.height + 200.0f);
    self.bottom_view.frame = CGRectOffset(_bottom_show_rect,
                                          0.0f,
                                          self.frame.size.height);
    
    [self addSubview:self.top_view];
    [self addSubview:self.bottom_view];
    
    typeof(self) __weak temp_self = self;
    
    [self.row_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        SCHShareView    *strong_self  = temp_self;

        SCHShareRowView *row_view     = (SCHShareRowView *)obj;
        
        
        row_view.frame                = row_view.hidden_rect;
        
        [strong_self addSubview:row_view];
    }];
    
    
    __block CGFloat x_offset = 0.0f;
    
    [self.cell_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
       
        SCHShareView *strong_self = temp_self;
        
        UIButton        *button                   = (UIButton*)obj;
        
        NSInteger        index                    =  idx / (2 * _number_of_cell_in_half_view);
        
        SCHShareRowView *row_view                 = [strong_self.row_view_array objectAtIndex:index];
        
        NSInteger        button_index_at_row_view = idx % (2 * _number_of_cell_in_half_view);
        
        CGSize           half_row_size            = CGSizeMake(row_view.frame.size.width / 2.0f,
                                                               row_view.frame.size.height);
        
        /*从第一个开始了*/
        if (0 ==  idx % _number_of_cell_in_half_view)
        {
            x_offset = 0.0f;
        }
        
        button.frame = CGRectMake(x_offset,
                                  (half_row_size.height - button.frame.size.height) / 2.0f,
                                  button.frame.size.width,
                                  button.frame.size.height);
        
        /*右边*/
        if (button_index_at_row_view >= _number_of_cell_in_half_view)
        {
            
            [row_view.rihgt_view addSubview:button];
        }
        /*左边*/
        else
        {
            [row_view.left_view addSubview:button];
        }
        
        x_offset += button.frame.size.width;
    }];
    
}

- (void)cellButtonAction: (id) sender
{
  
    NSInteger index = [self.cell_array indexOfObject:sender];
//    UIAlertView *alter_view = [[UIAlertView alloc] initWithTitle:@"123" message:[NSString stringWithFormat:@"%d",index] delegate:nil cancelButtonTitle:@"23" otherButtonTitles: nil];
//    [alter_view show];
    if (_delegate_flags.didSelectCellDelegate)
    {
        [self.delegate shareView:self didSelectCellAtIndex:index];
    }
}

#pragma mark -
#pragma mark - public

- (void)setData_source:(id<SCHShareViewDataSource>)data_source
{
    _data_source = data_source;
    
    if (nil != _data_source)
    {
        _data_source_flags.numberOfRowViewInSCHShareViewDataSource  = [self.data_source respondsToSelector:@selector(numberOfRowViewInSCHShareView:)];
        _data_source_flags.numberOfCellInSCHShareViewDataSource     = [self.data_source respondsToSelector:@selector(numberOfCellInSCHShareView:)];
        _data_source_flags.numberOfCellInHalfOfRowViewDataSource    = [self.data_source respondsToSelector:@selector(numberOfCellInHalfOfRowView:)];
        _data_source_flags.sizeOfRowViewInSCHShareViewDataSource    = [self.data_source respondsToSelector:@selector(sizeOfRowViewInSCHShareView:rowAtIndex:)];
        _data_source_flags.sizeOfBottomViewInSCHShareViewDataSource = [self.data_source respondsToSelector:@selector(sizeOfBottomViewInSCHShareView:)];
        _data_source_flags.sizeOfTopViewInSCHShareViewDataSource    = [self.data_source respondsToSelector:@selector(sizeOfTopViewInSCHShareView:)];
        _data_source_flags.sizeOfCellInSCHShareRowViewDataSource    = [self.data_source respondsToSelector:@selector(sizeOfCellInSCHShareRowView:cellAtIndex:)];
        _data_source_flags.normalImageForCellDataSource             = [self.data_source respondsToSelector:@selector(normalImageForCell:cellAtIndex:)];
        _data_source_flags.highlightedImageForCellDataSource        = [self.data_source respondsToSelector:@selector(highlightedImageForCell:cellAtIndex:)];
        _data_source_flags.disabledImageForCellDataSource           = [self.data_source respondsToSelector:@selector(disabledImageForCell:cellAtIndex:)];
        _data_source_flags.selectedImageForCellDataSource           = [self.data_source respondsToSelector:@selector(selectedImageForCell:cellAtIndex:)];
        _data_source_flags.cellInSCHShareRowViewDataSource          = [self.data_source respondsToSelector:@selector(cellInSCHShareRowView:cellAtIndex:)];
        
    }
    
}

- (void)setDelegate:(id<SCHShareViewDelegate>)delegate
{
    _delegate = delegate;
    
    if (nil != _delegate)
    {
        _delegate_flags.didSelectCellDelegate = [self.delegate respondsToSelector:@selector(shareView:didSelectCellAtIndex:)];
        _delegate_flags.bottomButtonActionDelegate = [self.delegate respondsToSelector:@selector(shareViewDidActionBottomView:)];
    }
}

- (void)showBottomView
{
    self.is_do_animation = YES;
    
    self.top_view.backgroundColor = [UIColor whiteColor];
    self.bottom_view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         
                         self.shade_view.alpha  = 0.66f;
                         self.bottom_view.frame = _bottom_show_rect;
                         
                     } completion:^(BOOL finished) {
                         
                         [self showRowView];
                     }];
}



- (void)showRowView
{
    static int row_animation_count;
    row_animation_count = 0;
    
    int i = 0;
    
    
    typeof(self) __weak temp_self = self;
    
    for (SCHShareRowView *row_view in self.row_view_array)
    {
        SCHShareView* strong_self  = temp_self;
        
        row_view.frame = row_view.show_rect;
        
        [row_view startCloseAnimation:^{
            
            row_view.frame = row_view.show_rect;
//            row_view.transform = CGAffineTransformIdentity;
            ++row_animation_count;
            
            if (row_animation_count == strong_self.row_view_array.count)
            {
                [strong_self showTopView];
            }
            
        } delay:i * 0.1f];
        
        ++i;
    }
}

- (void)showTopView
{
    self.top_view.hidden    = YES;
    self.top_view.frame     = _top_show_rect;
    self.top_view.transform = CGAffineTransformIdentity;
    self.top_view.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.top_view.hidden    = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.top_view.transform =  CGAffineTransformMakeScale(1.0f, 1.0f);;
    } completion:^(BOOL finished) {
        self.is_do_animation = NO;
    }];
}

- (void)showShareView:(UIView *)view
{
    [view addSubview:self];
    
    [self showBottomView];
}


- (void)hiddenRowViewLeftAndRihgtView
{
    for (SCHShareRowView *row_view in self.row_view_array)
    {
        [row_view hiddenLeftAndRightView];
    }
}

- (void)hiddenShareView
{
    if (self.is_do_animation)
    {
        return;
    }
    
    self.is_do_animation = YES;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.bottom_view.frame = CGRectOffset(_bottom_show_rect,
                                                               0.0f,
                                                               self.frame.size.height + 200.0f);
                         self.shade_view.alpha  = 0.0f;
    } completion:^(BOOL finished) {
        
    }];


    
    __block int i = 0;
        
    for (SCHShareRowView *row_view in self.row_view_array)
    {
        [UIView animateWithDuration:0.5f
                              delay:(i + 1) * 0.05f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             ++i;
                             row_view.frame = row_view.hidden_rect;
                             
                         } completion:^(BOOL finished) {
                             
                             if (i == self.row_view_array.count)
                             {
                                 [self hiddenRowViewLeftAndRihgtView];
                                 [self removeFromSuperview];
                                 
                             }
                             
                         }];
    }
    
    
    [UIView animateWithDuration:0.5f
                          delay:(i + 1) * 0.05f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.top_view.frame = CGRectOffset(_top_show_rect,
                                                            0.0f,
                                                            self.frame.size.height + 200.0f);
                     } completion:^(BOOL finished) {
                         
                         self.is_do_animation = NO;
                     }];
}

- (void)reload
{
    [self clean];
    
    [self load];
    
    [self show];
}


#pragma mark -
#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        self.cell_array      = [[NSMutableArray alloc] init];
        self.row_view_array  = [[NSMutableArray alloc] init];
        
        self.is_do_animation = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark - dealloc 

- (void)dealloc
{
    
}

@end
