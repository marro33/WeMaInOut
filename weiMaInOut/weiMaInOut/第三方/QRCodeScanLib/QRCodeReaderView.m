

#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>

#define DeviceMaxHeight  self.frame.size.height
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define ScanWidth 150
#define contentTitleColorStr @"666666" //正文颜色较深

@interface QRCodeReaderView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    
    NSTimer *countTime;
    
    NSMutableArray *array;
}
@property (nonatomic, strong) CAShapeLayer *overlay;


@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        array = [[NSMutableArray alloc] init];
        [self instanceDevice];
        
       
  }
  
  return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"scan_bg"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
//    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
//    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    
    
    
    //添加一个背景图片
    CGRect mImagerect = CGRectMake((DeviceMaxWidth-ScanWidth)/2.0, 80 ,ScanWidth, ScanWidth);
    [scanZomeBack setFrame:mImagerect];
    
    
    CGRect scanCrop =[self getScanCrop:mImagerect readerViewBounds:self.frame];
    [self addSubview:scanZomeBack];
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:self];
    
    //开始捕获
    [session startRunning];
}


- (void)setOverlayPickerView:(QRCodeReaderView *)reader
{
    
    CGFloat wid = (DeviceMaxWidth-ScanWidth)/2.0;
//    CGFloat heih = (DeviceMaxHeight-ScanWidth)/2.0;
    
    //最上部view
    CGFloat alpha = 0.6;
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 80)];
    _upView.alpha = alpha;
    _upView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.frame=CGRectMake(0,20, DeviceMaxWidth,20);
    labIntroudction.font = Font_Bold_16;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor blackColor];
    labIntroudction.text=@"对准二维码/条形码到框内即可扫描";
    [reader insertSubview:labIntroudction aboveSubview:_upView];
    
    _scanNumLab= [[UILabel alloc] init];
    _scanNumLab.backgroundColor = [UIColor clearColor];
    _scanNumLab.frame=CGRectMake(0,labIntroudction.bottom+10, DeviceMaxWidth,20);
    _scanNumLab.font = Font_Bold_16;
//    _scanNumLab.text = @"111";
    _scanNumLab.textAlignment = NSTextAlignmentCenter;
    _scanNumLab.textColor=[UIColor whiteColor];
    [reader insertSubview:_scanNumLab aboveSubview:_upView];

    
    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, _upView.bottom, wid, ScanWidth)];
    cLeftView.alpha = alpha;
    cLeftView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-wid, _upView.bottom, wid,ScanWidth)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:rightView];
    
    //底部view
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, _upView.height+ScanWidth, DeviceMaxWidth, DeviceMaxHeight - _upView.height -ScanWidth)];
    _downView.alpha = alpha;
    _downView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_downView];
    
    
    CGFloat kMagin = (DeviceMaxWidth-120-40)/2.0;
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20,_upView.height+cLeftView.height+ 5,40, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.cornerRadius = 20;
    backBtn.titleLabel.font = Font_Sys_14;
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor blackColor]];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [reader insertSubview:backBtn aboveSubview:_downView];
    
    
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(kMagin+40+20,_upView.height+cLeftView.height+ 5,40, 40);
    [openBtn setTitle:@"开灯" forState:UIControlStateNormal];
    [openBtn setTitle:@"关灯" forState:UIControlStateSelected];
    openBtn.layer.masksToBounds = YES;
    openBtn.layer.cornerRadius = 20;
    openBtn.titleLabel.font = Font_Sys_14;
    [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openBtn setBackgroundColor:[UIColor blackColor]];
    [openBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [reader insertSubview:openBtn aboveSubview:openBtn];
    
    
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pictureBtn.frame = CGRectMake(kMagin*2+40*2+20,_upView.height+cLeftView.height+ 5,40, 40);
    [pictureBtn setTitle:@"确定" forState:UIControlStateNormal];
    pictureBtn.layer.masksToBounds = YES;
    pictureBtn.layer.cornerRadius = 20;
    pictureBtn.titleLabel.font = Font_Sys_14;
    [pictureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pictureBtn setBackgroundColor:[UIColor blackColor]];
    [pictureBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [reader insertSubview:pictureBtn aboveSubview:openBtn];
    
    
}

- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    x = 80/CGRectGetHeight(readerViewBounds);
    y = 80/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

- (void)start
{
    [session startRunning];
}

- (void)stop
{
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
//        NSLog(@"%@",metadataObject.stringValue);
                if(![array containsObject: metadataObject.stringValue]) {
            [array addObject:metadataObject.stringValue];
        }
        
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}


-(void)backAction{
    
    _scanNumLab.text = @"";
    [array removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(backVCAction)]) {
        [self.delegate backVCAction];
    }
}

-(void)nextAction{
    _scanNumLab.text = @"";
    [array removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextVCAction)]) {
        [self.delegate nextVCAction];
    }
}



#pragma mark - 颜色
//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


@end
