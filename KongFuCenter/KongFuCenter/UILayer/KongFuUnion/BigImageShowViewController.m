//
//  BigImageShowViewController.m
//  KongFuCenter
//
//  Created by Rain on 16/2/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BigImageShowViewController.h"
#import "XHPicView.h"

@interface BigImageShowViewController (){
    UIImageView *showImgView;
}

@end

@implementation BigImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"图片详情"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)initView{
    NSArray *itemArray =[[NSArray alloc] initWithObjects:_imgUrl, nil];
    XHPicView *picView = [[XHPicView alloc]initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height) withImgs:itemArray withImgUrl:nil];
    picView.eventBlock = ^(NSString *event){
        NSLog(@"触发事件%@",event);
    };
    [self.view addSubview:picView];
    
    
    
//    showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
//    [showImgView setMultipleTouchEnabled:YES];
//    [showImgView setUserInteractionEnabled:YES];
//    showImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_imgUrl]];
//    oldFrame = showImgView.frame;
//    largeFrame = CGRectMake(0 - SCREEN_WIDTH, 0 - SCREEN_HEIGHT, 3 * oldFrame.size.width, 3 * oldFrame.size.height);
//    [self addGestureRecognizerToView:showImgView];
//    [self.view addSubview:showImgView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRightButton:(UIButton *)sender{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"saveImage" object:nil];
    UIImageWriteToSavedPhotosAlbum(showImgView.image, self, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功~" maskType:SVProgressHUDMaskTypeBlack];
}

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    //[view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (showImgView.frame.size.width < oldFrame.size.width) {
            showImgView.frame = oldFrame;
            //让图片无法缩得比原图小
        }
        if (showImgView.frame.size.width > 3 * oldFrame.size.width) {
            showImgView.frame = largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
