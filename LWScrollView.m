//
//  LWScrollView.m
//  Created by Levi on 2016/11/9.
//

#import "LWScrollView.h"

@interface LWScrollView ()

@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, strong) UIView *sideView;

@property (nonatomic,strong) UIImageView *sideImageView;

@property (nonatomic, strong) UIImageView *middleImageView;

@property (nonatomic, assign) CGFloat windowWidth;

@property (nonatomic, assign) CGFloat windowHeight;

@property (nonatomic, assign) BOOL toLeft;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) NSInteger imageIndex;

@end

@implementation LWScrollView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _windowWidth = frame.size.width;
        _windowHeight = frame.size.height;
        
        _images = images;
        _imageIndex = 0;
        
        [self initViews];
        [self setupViews];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_middleView addGestureRecognizer:pan];
    }
    return self;
}

- (void)initViews
{
    _middleView = [[UIView alloc] init];
    _middleView.clipsToBounds = YES;
    
    _sideView = [[UIView alloc] init];
    _sideView.clipsToBounds = YES;
    
    _middleImageView = [[UIImageView alloc] init];
    _sideImageView = [[UIImageView alloc] init];
    
    [_middleView addSubview:_middleImageView];
    [_sideView addSubview:_sideImageView];
    
    [self addSubview:_middleView];
    [self addSubview:_sideView];
}

- (void)setupViews
{
    _middleView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
    _sideView.frame = CGRectMake(0, 0, 0, _windowHeight);
    
    _middleImageView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
    _sideImageView.frame = CGRectMake(-_windowWidth / 2, 0, _windowWidth, _windowHeight);
    
    _middleImageView.image = [UIImage imageNamed:_images[_imageIndex]];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self];
        
        if (translation.x > 0) {
            if (_toLeft) {
                _sideView.frame = CGRectMake(0, 0, 0, _windowHeight);
            }
            _toLeft = NO;
            
            NSInteger index = _imageIndex - 1;
            if (index < 0) {
                index += _images.count;
            }
            _sideImageView.image = [UIImage imageNamed:_images[index]];
            
            _middleView.frame = CGRectMake(translation.x, 0, _windowWidth - translation.x, _windowHeight);
            _middleImageView.frame = CGRectMake(-translation.x / 2, 0, _windowWidth, _windowHeight);
            _sideView.frame = CGRectMake(0, 0, translation.x, _windowHeight);
            _sideImageView.frame = CGRectMake(-_windowWidth / 2 + translation.x / 2, 0, _windowWidth, _windowHeight);
        }
        else {
            if (!_toLeft) {
                _sideView.frame = CGRectMake(_windowWidth, 0, 0, _windowHeight);
            }
            _toLeft = YES;
            
            NSInteger index = _imageIndex + 1;
            if (index >= _images.count) {
                index -= _images.count;
            }
            _sideImageView.image = [UIImage imageNamed:_images[index]];
            
            _middleView.frame = CGRectMake(0, 0, _windowWidth + translation.x, _windowHeight);
            _middleImageView.frame = CGRectMake(translation.x / 2, 0, _windowWidth, _windowHeight);
            _sideView.frame = CGRectMake(_windowWidth + translation.x, 0, -translation.x, _windowHeight);
            _sideImageView.frame = CGRectMake(-_windowWidth / 2 - translation.x / 2, 0, _windowWidth, _windowHeight);
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (_toLeft && _sideView.frame.size.width > 50) {
            [UIView animateWithDuration:.4 animations:^{
                _middleView.frame = CGRectMake(0, 0, 0, _windowHeight);
                _middleImageView.frame = CGRectMake(-_windowWidth / 2, 0, _windowWidth, _windowHeight);
                _sideView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _sideImageView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                
            } completion:^(BOOL finished) {
                _imageIndex++;
                if (_imageIndex >= _images.count) {
                    _imageIndex -= _images.count;
                }
                [self setupViews];
            }];
        }
        else if (_toLeft && _sideView.frame.size.width <= 50) {
            [UIView animateWithDuration:.3 animations:^{
                _middleView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _middleImageView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _sideView.frame = CGRectMake(_windowWidth, 0, 0, _windowHeight);
                _sideImageView.frame = CGRectMake(-_windowWidth / 2, 0, _windowWidth, _windowHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
        else if (!_toLeft && _sideView.frame.size.width > 50) {
            [UIView animateWithDuration:.4 animations:^{
                _middleView.frame = CGRectMake(_windowWidth, 0, 0, _windowHeight);
                _middleImageView.frame = CGRectMake(-_windowWidth / 2, 0, _windowWidth, _windowHeight);
                _sideView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _sideImageView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
            } completion:^(BOOL finished) {
                _imageIndex--;
                if (_imageIndex < 0) {
                    _imageIndex += _images.count;
                }
                [self setupViews];
            }];
        }
        else if (!_toLeft && _sideView.frame.size.width <= 50) {
            [UIView animateWithDuration:.3 animations:^{
                _middleView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _middleImageView.frame = CGRectMake(0, 0, _windowWidth, _windowHeight);
                _sideView.frame = CGRectMake(0, 0, 0, _windowHeight);
                _sideImageView.frame = CGRectMake(-_windowWidth / 2, 0, _windowWidth, _windowHeight);
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

@end
