//
//  SampleAnalsisViewController.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/17.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class SampleAnalsisViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var dashedBorderView: DashedBorderView!
    @IBOutlet weak var scanButton: UIButton!
    //    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dashedViewX: NSLayoutConstraint!
    @IBOutlet weak var dashedViewY: NSLayoutConstraint!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    var imagePickerController: UIImagePickerController!
    var imageView: UIImageView?
    var partialImage: UIImage!
    var dataToPass: [Int] = [255,255,255]
    var backgroundColor: UIColor?
    
    //    var numerator: Int?
    //    var denominator: Int?
    var currentCell: Int?
    
    var rowIndex = 0 // 0表示 分子 1 表示 分母
    var selectedRowIndex = [Int: Int]()
    var contentOffsetTemp: CGPoint?
    var dashViewFrame: CGRect?
    
    var touchPointCache: CGPoint?
    
    // 2.28添加 tableviewdidselected
    var selectedNumerator: Int?
    var selectedDenominator: Int?
    var selectedTableView: UITableView?
    // 4.17
    let assetsLibrary = ALAssetsLibrary()
    var assets = [ALAsset]()

    // 2.29
    var numeratorString: String {
        get {
            if selectedNumerator == nil {
                return "B"
            } else {
                switch selectedNumerator! {
                case 0: return "R"
                case 1: return "G"
                case 2: return "B"
                default: return "Others"
                }
            }
        }
    }
    var denominaotrString: String {
        get {
            if selectedDenominator == nil {
                return "R"
            } else {
                switch selectedDenominator! {
                case 0: return "R"
                case 1: return "G"
                case 2: return "B"
                default: return "Others"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tab Bar Controller
        
        
        //        tabBarController?.tabBarItem.titleTextAttributesForState(<#T##state: UIControlState##UIControlState#>)
        
        backgroundColor = blueGrey.s50.colorRGB
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SampleAnalsisViewController.handlePanGesture(_:)))
        dashedBorderView.addGestureRecognizer(panGesture)
        //        dashedBorderView.textOnLabel = Int(128 / imageScrollView.zoomScale).description
        
        // Navigation Controller
        self.navigationController?.navigationBar.barTintColor = blueGrey.s500.colorRGB
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        //        navigatiddonController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Times new roman", size: 20)!]
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.backgroundColor = blueGrey.s500.colorRGB
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 1
        paragraphStyle.alignment = .Right
        // Button Initialization
        
        
        analyzeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        analyzeButton.backgroundColor = blueGrey.s500.colorRGB
        //        analyzeButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 19)
        analyzeButton.setAttributedTitle(NSAttributedString(string: "Color Info", attributes: [NSFontAttributeName: UIFont(name: "Times new roman", size: 19)!, NSParagraphStyleAttributeName:  paragraphStyle]), forState: .Normal)
        //        analyzeButton.disabl
        //       NSKernAttributeName: NSNumber(float: 5) 字符间距 比如 5的意思就是COLOR 各个字母间距变成5
        
        scanButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        scanButton.backgroundColor = blueGrey.s500.colorRGB
        //        scanButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 15)
        scanButton.setAttributedTitle(NSAttributedString(string: "Scan", attributes: [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: UIFont(name: "Times new roman", size: 19)!]), forState: .Normal)
        
        albumButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Times new roman", size: 17)!], forState: .Normal)
        
        // TableView Initializaiton
        infoTable.dataSource = self
        infoTable.delegate = self
        infoTable.bounces = false
        infoTable.scrollEnabled = false
        infoTable.backgroundColor = backgroundColor // 在section之间添加背景图片做效果
        infoTable.separatorStyle = .None
        
        
        imageScrollView.bounces = false
        imageScrollView.delegate = self
        imagePickerController = UIImagePickerController()
        
        
        loadImageOn(imageScrollView, image: UIImage(named: "22.png")!)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if let offset = contentOffsetTemp {
            imageScrollView.contentOffset = offset
            //            print("image scroll view content offset: \(offset)")
        } else {
            print("offset is nil")
        }
        if let frame = dashViewFrame {
            //            print("dash view frame: \(frame)")
            dashedBorderView.frame = frame
        } else {
            print("frame is nil")
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if contentOffsetTemp == nil {
            //            print("sdasds")
            imageScrollView.contentOffset = CGPoint(x: 0, y: 0)
            //            imageView!.frame = CGRect(origin: CGPoint(x: 0, y: -64), size: imageView!.image!.size)
            //            imageScrollView.bounds = CGRect(origin: CGPoint(x: -4, y: 0), size: imageScrollView.frame.size)
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        contentOffsetTemp = imageScrollView.contentOffset
        dashViewFrame = dashedBorderView.frame
        
        
        
    }
    func imagePickerControllerInit(sourceType: UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let mediaTypeArr: NSArray = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
            // 判断是否可以使用 摄像 和 拍照
            if mediaTypeArr.containsObject(kUTTypeMovie) && mediaTypeArr.containsObject(kUTTypeImage){
                
                // 设置类型
                imagePickerController.sourceType = sourceType
                // 设置可用媒体类型
                imagePickerController.mediaTypes = [(mediaTypeArr as! [String])[0]]
                // 设置 Delegate
                imagePickerController.delegate = self
                
                //可选，视频最长的录制时间，这里是10秒，默认为10分钟（600秒）
                imagePickerController.videoMaximumDuration = 10
                //可选，设置视频的质量，默认就是TypeMedium
                imagePickerController.videoQuality = UIImagePickerControllerQualityType.TypeMedium
                //设置视频或者图片拍摄好后，是否能编辑，默认为false不能编辑
                imagePickerController.allowsEditing = false
                
                // 显示
                self.modalPresentationStyle = .CurrentContext // 要不然会报错
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        } else{
            ALertMessageBox.show(self, title: "Warnning", contentMsg: "Camera is Not Supported", buttonString: "Ok", blockHandler: nil)
        }
    }
    
    @IBAction func selectFromLib(sender: AnyObject) {
        imagePickerControllerInit(.PhotoLibrary)
    }
    
    
    @IBAction func takeAPhoto(sender: AnyObject) {
        imagePickerControllerInit(.Camera)
        
        
    }
    
    func imageOfColorWithRGB(r r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(red: r, green: g, blue: b, alpha: alpha).CGColor)
        CGContextFillRect(context, frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("iamge color frame \(frame)")
        return image
        
    }
    func imageOfColorWithRGB(color: UIColor, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // reset scroll view
        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
        
        UIGraphicsBeginImageContext(image.size);
        image.drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        let w = CGImageGetWidth(image.CGImage)
        let h = CGImageGetHeight(image.CGImage)
        print("w: \(w) h: \(h)")
        
        let wN = CGImageGetWidth(newImage.CGImage)
        let hN = CGImageGetHeight(newImage.CGImage)
        print("w: \(wN) h: \(hN)")
        
        
        
        
        loadImageOn(imageScrollView, image: newImage)
        if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
        } else {
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        //        getRGBColorsInImage(image, startX: 0, endX: 0, startY: 750, endY: 750)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        print("User cancelled")
    }
    @IBAction func showPhotoAlbums(sender: AnyObject) {
    }
    @IBAction func requestForAnalyzing(sender: AnyObject) {
        
        prepareForAnalyzing()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.image = imageView?.image
        appDelegate.partialImage = partialImage
        appDelegate.dataToPass = dataToPass
        
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func requestForScan(sender: AnyObject) {
        
        prepareForAnalyzing()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.image = imageView?.image
        appDelegate.partialImage = partialImage
        appDelegate.dataToPass = dataToPass
        appDelegate.numerator = numeratorString
        appDelegate.denominator = denominaotrString
        
        infoTable.reloadData()
        
    }
    /**
     完成partialImage 和 dataToPass
     */
    func prepareForAnalyzing() {
        
        let scrolleViewFrame = imageScrollView.frame
        
        // 注意scroll View frame != 0
        let startX = dashedBorderView.frame.origin.x + imageScrollView.contentOffset.x - scrolleViewFrame.origin.x
        print("startX: \(startX)")
        let startY = dashedBorderView.frame.origin.y + imageScrollView.contentOffset.y - scrolleViewFrame.origin.y
        print("startY: \(startY)")
        
        let width = zoom(atValue: dashedBorderView.frame.width)
        let height = zoom(atValue: dashedBorderView.frame.height)
        let originX = zoom(atValue: startX)
        let originY = zoom(atValue: startY)
        let frame = CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: width, height: height))// 已经zoom过
        
        print("dashboederview frame: \(dashedBorderView.frame)")
        print("content offset: \(imageScrollView.contentOffset)")
        print("calculation in frame: \(frame)")
        
        if imageView!.image == nil {
            print("imageVIew has no image")
        } else {
            partialImage = imageView!.image?.getPartialImage(withImageFrame: frame)
            print("Got partial image")
            
        }
        
        partialImage.dumpIamge()
        if partialImage.CGImage != nil {
            imageView?.image
            
            let (rs, gs, bs) = manipulateImagePixelData(inImage: partialImage.CGImage!)
            //        let (rs, bs) = getRGBColorsInImage(imageView.image!, startX: zoom(atPoint: startX.x), endX: zoom(atPoint: startX.x + width), startY: zoom(atPoint: startX.y), endY: zoom(atPoint: startX.y + height))
            
            let averageR = averageOfdata(Array: rs)
            let averageG = averageOfdata(Array: gs)
            let averageB = averageOfdata(Array: bs)
            
            print("get rs: \(averageR), gs: \(averageG), bs: \(averageB)")
            
            
            dataToPass = [averageR]
            dataToPass.append(averageG)
            dataToPass.append(averageB)
            
        } else {
            print("Partial image has no CGImage")
        }
        
        

        
    }
    
    /**
     -discuss: 将在UIScrollView上放大的点变换会原来图片上的坐标点 要不然在读取像素点的时候会超出边界
     */
    func zoom(atValue x: CGFloat ) -> Int {
        let currentZoomScale = imageScrollView.zoomScale
        return Int(x / currentZoomScale)
        
    }
    func averageOfdata(Array data: [[Int]] ) -> Int{
        var resultInTotal: Int = 0
        var count: Int = 0
        
        for valueArray in data {
            for value in valueArray {
                count += 1
                resultInTotal += value
            }
        }
        return Int(resultInTotal / count)
    }
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch (gesture.state) {
        case UIGestureRecognizerState.Began:
            print("Moving bega")
            touchPointCache = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Changed:
            //            print("Touch point changed")
            let touchPoint = gesture.locationInView(self.view)
            let deltaX = (touchPointCache?.x)! - touchPoint.x
            let deltaY = (touchPointCache?.y)! - touchPoint.y
            dashedViewX.constant -= deltaX
            dashedViewY.constant -= deltaY
            touchPointCache = touchPoint
        //            print(touchPoint)
        case UIGestureRecognizerState.Ended:
            print("User has ended the touch")
            print("x :  \(dashedViewX) y: \(dashedViewY)")
            touchPointCache = nil
        default:
            print("What's happend")
        }
        print("dashedBoard frmae: \(dashedBorderView)")
        
    }
    
}















