
//
//  ViewController.swift
//  QRScan
//
//  Created by Nimble Chapps on 8/10/17.
//  Copyright © 2017 nimblechapps. All rights reserved.
//

import UIKit
import AVFoundation

//DELEGATE: AVCaptureMetaDataOutputBelegate

class ScanViewController: UIViewController,  AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureMetadataOutputObjectsDelegate{

    //    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var lblString: UILabel!
    //    @IBOutlet weak var btnStartStop: UIButton!
    @IBOutlet weak var sw: UISwitch!
    //    @IBOutlet weak var scanButton: UIButton!


    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false

    var scanRect: CGRect!
    var scanView: UIImageView!
    var dataModel: DataModel!

    var res = ""
    var scanMode = "隐形码"
    var message = "可选择二维码或隐形码进行扫描"


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.basicUIinit()
        captureSession = nil;
        //        btnStartStop.setTitle("点击开始扫描", for: .normal)
        //        btnStartStop.layer.cornerRadius = 20
        lblString.text = message;
        self.startReading()
        isReading = true
    }



    func basicUIinit(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "微码稽查"
        self.view.backgroundColor = UIColor.gray

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "历史记录", style: .plain, target: self, action: #selector(ScanViewController.historyList(_:)))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(ScanViewController.cancel(_:)))

        // 扫描框范围定义
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let scanRectWidth = width - 150
        let scanRectHeight = scanRectWidth
        let scanRectX = (width - scanRectWidth) / 2
        let scanRectY = (height - scanRectHeight) / 2 - 50
        scanRect = CGRect.init(x: scanRectX, y: scanRectY, width: scanRectWidth, height: scanRectHeight)

    }



    // MARK: - IBAction Method

    @IBAction func cancel(_ sender: Any) {
        print("stop")
        self.stopReading()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func historyList(_ sender: Any) {
        self.stopReading()
        print("stop")
//        self.performSegue(withIdentifier: "historyList", sender: nil)
//
        let vc = HistoryListTableViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }





    // MARK: - Custom Method
    func startReading() -> Bool {


        isReading = true

        lblString.text = "正在扫描" + scanMode + "..."
        // scanningUI init
        //不透明外框
        //        let scanMaskLeft = CGRect.init(x: 0, y: 0, width: 100/2, height: UIScreen.main.bounds.size.height)
        //        let scanMaskView = UIView.init(frame: scanMaskLeft)
        //        scanMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        //        //        scanMaskView.backgroundColor?.withAlphaComponent(0.6)
        //
        //        self.view.addSubview(scanMaskView)

        //        scanView.removeFromSuperview()


        //        let maskview = UIView.init(frame: self.view.bounds)
        //        maskview.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        //        self.view.addSubview(maskview)
        //        self.view.sendSubview(toBack: maskview)
        //        let imageView = UIImageView.init(image: UIImage.init(named: "ic_scanBg.png"))
        //        imageView.frame = scanRect
        //        self.view.addSubview(imageView)


        //扫描动画
        //        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        //        animation.duration = 0.25
        //        animation.fromValue = 0
        //        animation.toValue = 1
        //        animation.delegate = self as! CAAnimationDelegate
        //        imageView.layer.add(animation, forKey: nil)
        //扫描显示层

        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // Do the rest of your work...
        } catch let error as NSError {
            // Handle any errors
            print(error)
            return false
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(videoPreviewLayer, at: 0)


        if(scanMode == "二维码"){
            scanView = UIImageView.init(image: UIImage.init(named: "qr.png"))
            scanView.frame = scanRect
            scanView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            self.view.addSubview(scanView)

            /* Check for metadata */
            print(">>>>>>>>>>>>QRMode")
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            print(captureMetadataOutput.availableMetadataObjectTypes)

            //set delegate

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureSession?.startRunning()
        }else{

            scanView = UIImageView.init(image: UIImage.init(named: "iv.png"))
            scanView.frame = scanRect
            scanView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            self.view.addSubview(scanView)

            print(">>>>>>>>>>>IVMode")
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]

            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            let queue = DispatchQueue(label: "vedioDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: queue)
            captureSession?.addOutput(videoDataOutput)
            captureSession?.startRunning()
        }
        return true
    }

    func stopReading() {
        scanView.removeFromSuperview()
        isReading = false
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer.removeFromSuperlayer()
    }


    // 隐形码解码
    func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){

        print("get image")
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)

        //        let width = UIScreen.main.bounds.size.width
        //        let height = UIScreen.main.bounds.size.height
        //        print(width, height)
        // 6 plus (414, 736)

        let interestrect = videoPreviewLayer.metadataOutputRectOfInterest(for: scanRect)
        print(scanRect.size)
        print(scanRect.origin)
        print(interestrect.size.height, interestrect.size.width)

        if let result = ImageBufferHandler.handleTheBuffer(imageBuffer, interestrect){

//            if(result.hasPrefix("result: ")){
//                self.stopReading()
//                print(result);
//            }
            self.process(result)
        }
    }


    // 二维码解码
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//
//        for data in metadataObjects {
//            let metaData = data as! AVMetadataObject
//            print(metaData.description)
//
//            //解码接口
//            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
//            if let unwraped = transformed {
//                print("unwraped:" + unwraped.stringValue)
//                //                lblString.text = unwraped.stringValue
//                //                btnStartStop.setTitle("开始扫描", for: .normal)
//                self.performSelector(onMainThread: #selector(stopReading), with: nil, waitUntilDone: false)
//                isReading = false;
//                self.performSegue(withIdentifier: "qr", sender:  unwraped.stringValue)
//            }
//        }
//    }


    func process(_ result: String){
        if(result.hasPrefix("result: ")){
            self.stopReading()
            isReading = false

            //Handle the dataModel TUDO
            dataModel = DataModel.init()
            let index = result.index(result.startIndex, offsetBy: 8)
            res = result.substring(from: index)

            //            lblString.text = res
            //            btnStartStop.setTitle("继续扫描", for: .normal)

            let date = Date()
            let dateFormat = DateFormatter.init()
            dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let time = dateFormat.string(from: date)
            print(time)

            dataModel.append(list: HistoryList.init(result: res, time: time))


            let alert = UIAlertController(title: "产品追溯码", message: res, preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default, handler: {
                (alerts: UIAlertAction) -> Void in

//                let mainStoryboard = UIStoryboard(name:"Scan", bundle:nil)
//                let vc = mainStoryboard.instantiateViewController(withIdentifier: "detail") as! HistoryDetailViewController1
//                vc.result = self.res
                //方法1
                let vc = HistoryDetailViewController()
                vc.result = self.res
                self.navigationController?.pushViewController(vc, animated: false)
                //方法2
                //                self.performSegue(withIdentifier: "toResult", sender: nil)

                //方法3
                //                self.present()
            })
            alert.addAction(action)
            present(alert,animated: true,completion: nil)
        }
    }

    //    @objc func toResult(){
    //
    //    }

    //    func convert(cmage:CIImage) -> UIImage
    //    {
    //        let context:CIContext = CIContext.init(options: nil)
    //        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
    //        let image:UIImage = UIImage.init(cgImage: cgImage)
    //        return image
    //    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "qr"){
//            let vc = segue.destination as! WebViewController
//            vc.url = URL(string: sender as! String)
//        }
//    }


}

