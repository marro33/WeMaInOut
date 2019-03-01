

#import <UIKit/UIKit.h>


@protocol QRCodeReaderViewDelegate <NSObject>

- (void)readerScanResult:(NSString *)result;

/**
 *  返回到上一界面
 */
-(void)backVCAction;
/**
 *  跳转到下一界面
 */
-(void)nextVCAction;



@end

@interface QRCodeReaderView : UIView

@property (nonatomic, weak) id<QRCodeReaderViewDelegate> delegate;

//@property (nonatomic,strong) UIImageView * readLineView;

@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;

@property (nonatomic,strong)UILabel *scanNumLab;

@property (nonatomic,strong)UIView* upView;
@property (nonatomic,strong)UIView * downView;

//开启关闭扫描
- (void)start;
- (void)stop;

//- (void)loopDrawLine;//初始化扫描线

@end
