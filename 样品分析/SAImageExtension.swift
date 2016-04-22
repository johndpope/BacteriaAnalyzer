//
//  SAExtension.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/18.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

extension SampleAnalsisViewController {
    
    
    func loadImageOn(scrollView: UIScrollView, image: UIImage) {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        if imageView != nil {
            imageView!.removeFromSuperview()
        }
        imageView = UIImageView(image: image)
        imageView!.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        
        print("the original size of image is \(image.size)")
        
        scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: screenHeight / 2))
        //        scrollView.bounds = CGRect(origin: CGPoint(x: 0,y: 0), size: scrollView.frame.size)
        // 2设置scrollView的内容大小 这个区域也是指可滚动的区域
        //        scrollView.contentSize = CGSize(width: imageView!.frame.width, height: imageView!.frame.height - 128)
        scrollView.contentSize = imageView!.frame.size
        
        // 4 此图比scrollView
        let scrollViewFrame = scrollView.frame//scrollView本身在屏幕上占的空间 应该是在storyboard中设置过的那个大小
        print("scrollView frame: \(scrollViewFrame)")
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width //scrollView对比其内容(image)宽度倍数
        let scaleHeight = screenHeight / scrollView.contentSize.height //高度倍数
        let minScale = min(scaleWidth, scaleHeight);//宽度与高度倍数里面最小的成为放大倍数最小值 这样图片过宽过高都能显示到当前画面中
        let maxMinScale = max(scaleWidth, scaleHeight) // 宽度与高度里较大的成为最小放大倍数 这样图片是可以填满屏幕的
        scrollView.minimumZoomScale = minScale;//将此倍数设为最小倍数 即不允许再缩小了
        
        // 5 这里有一个问题 用constrain 把scrollView 的大小改变了 但是这里初始化读取到的fram是还没有 constrain的frame
        print("sacled width: \(image.size.width * minScale), height: \(image.size.height * minScale)")
        scrollView.minimumZoomScale = minScale
        print("minScale: \(minScale)")
        //        imageView?.frame.width /
        if minScale > 0.25 {
            scrollView.maximumZoomScale = 1
        } else {
            scrollView.maximumZoomScale = 0.25// 放大至原图的大小
        }
        print("screen.width \(screenWidth) / image.width \(imageView?.frame.width) /  :\(screenWidth / (imageView?.frame.width)!)")
        scrollView.zoomScale = minScale;//当前的缩放比例
        
        // 6
        //        centerScrollViewContents(imageView, scrollView: scrollView)//因为缩小时图片会显示在最左上角，这个函数可以使图片回到视图中心
        scrollView.addSubview(imageView!)
        
    }
    
    func centerScrollViewContents(imageView: UIImageView, scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    
    func addDashedFrame(inView view: UIView, withFrame frame: CGRect)  {
        
        let border = CAShapeLayer();
        
        border.strokeColor = UIColor.whiteColor().CGColor;
        border.fillColor = nil;
        border.lineDashPattern = [4, 4];
        view.layer.addSublayer(border);
        border.path = UIBezierPath(roundedRect: frame, cornerRadius:8).CGPath;
        border.frame = frame
        
        
    }
    func prosessImageData(data: UnsafeMutablePointer<UInt8>, imageSize: CGSize) -> (reds: [[Int]], greens: [[Int]], blues: [[Int]]) {
        
       
        var rs: [[Int]] = []
        var gs: [[Int]] = []
        var bs: [[Int]] = []
        var alphs: [[Int]] = []
        
        let width = imageSize.width.toInt()
        let height = imageSize.height.toInt()
     
        for indexY in 0..<height {
            var tempR: [Int] = []
            var tempG: [Int] = []
            var tempB: [Int] = []
            var tempA: [Int] = []
            for indexX in 0..<width {
                let offSet = 4 * (indexX * width + indexY)
                let r = Int(data[1 + offSet])
                let g = Int(data[2 + offSet])
                let b = Int(data[3 + offSet])
                let a = Int(data[offSet])
                tempR.append(r)
                tempG.append(g)
                tempB.append(b)
                tempA.append(a)
            }
            rs.append(tempR)
            gs.append(tempG)
            bs.append(tempB)
            alphs.append(tempA)
        }
        return (rs, gs, bs)
    }
    
    /**
     从Apple开发者文档中获取的方法: 处理图片中的像素颜色值
     
     - parameter imageRef: 图片的CGImage
     
     - returns: RGB颜色值
     */

    func manipulateImagePixelData(inImage imageRef: CGImage) -> (reds: [[Int]], greens: [[Int]], blues: [[Int]]) {
        // Create the bitmap context
        let cgctx = createARGBBitmapContext(inImage: imageRef)
        // Get image width, height. We'll use the entire image.
        let w = CGImageGetWidth(imageRef)
        let h = CGImageGetHeight(imageRef)
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: w, height: h))
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(cgctx, frame, imageRef)
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        let data = CGBitmapContextGetData(cgctx)
        if data != nil {
            // Got the ARGB Data
            return prosessImageData(UnsafeMutablePointer<UInt8>(data), imageSize: CGSize(width: w, height: h))
        } else {
            return ([[]], [[]], [[]])
        }
    }
    
    /**
     从Apple开发者文档QA中获取的方法: 创建ARGB位图环境
     
     - parameter imageRef: 图片的CGImage属性
     
     - returns: 位图环境
     */

    func createARGBBitmapContext(inImage imageRef: CGImage) -> CGContextRef {
        
        let context:CGContextRef?
        var colorSpace: CGColorSpace?
        var bitmapData: UnsafeMutablePointer<Void>?
        var bitmapByteCount: Int
        var bitmapBytesPerRow: Int
        
        // Get image width, height. We'll use the entire image.
        let pixelsWide = CGImageGetWidth(imageRef)
        let pixelsHigh = CGImageGetHeight(imageRef)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = (pixelsWide * 4)
        bitmapByteCount = (bitmapBytesPerRow * pixelsHigh)
        
         // Use the generic RGB color space.
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
        if colorSpace == nil {
            print("error allocating color spacing")
//            return context!
        }
        
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        bitmapData = malloc(bitmapByteCount)
        if bitmapData == nil {
            print("memory not allocated")
//            return context!
        }
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
//        CGImageAlphaInfo.First
        context = CGBitmapContextCreate(bitmapData!, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace,  CGImageAlphaInfo.PremultipliedFirst.rawValue)
        if context == nil {
            print("failed to create bitmap context")
            return context!
        }
        return context!
    }
    
    
}


extension UIImage{
    
    
    /**
     
     - parameter frame: 新图片的 frame 适用到原图片bounds
     - returns : 原图片指定的一部分
     
     */
    
    func getPartialImage(withImageFrame frame: CGRect) -> UIImage{
        
//        let partialImage = CGImageCreateWithImageInRect(self.CGImage, frame)!
//        
//        let bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGImageGetWidth(partialImage), height: CGImageGetHeight(partialImage)))
//        print("Partial Image Info w: \( CGImageGetWidth(partialImage)) h: \( CGImageGetHeight(partialImage)) frame: \(frame)")
//        UIGraphicsBeginImageContext(bounds.size)
//        let context = UIGraphicsGetCurrentContext()
//        CGContextDrawImage(context, bounds, partialImage) // 这个函数在考虑原图片的大小的时候用的是原图片的bounds
//        let image = UIImage(CGImage: partialImage)
//        
//        
//        //        let image = UIImage(CGImage: partialImage, scale: 1, orientation: UIImageOrientation.Right) // 这里如果没有加的话图片会逆时针90度
//        //        (CGImage: partialImage)
//        UIGraphicsEndImageContext()
//        image.dumpIamge()
////
//        
        let partialCGImage = CGImageCreateWithImageInRect(CGImage, frame)
        let partialImage = UIImage(CGImage: partialCGImage!)

        return partialImage
    }
    func redrawImage() -> UIImage {
        let width = CGImageGetWidth(CGImage)
        let height = CGImageGetHeight(CGImage)
        let bpc = CGImageGetBitsPerComponent(CGImage)
        let bpp = CGImageGetBitsPerPixel(CGImage)
        let bpr = CGImageGetBytesPerRow(CGImage)
        let colorSpace = CGImageGetColorSpace(CGImage)
        let bitmapInfo = CGImageGetBitmapInfo(CGImage)
        let provider = CGImageGetDataProvider(CGImage)
        let intent = CGImageGetRenderingIntent(CGImage)
 
        let newCGImage = CGImageCreate(width, height, bpc, bpp, bpr, colorSpace, bitmapInfo, provider, nil, false, intent)
//        if letnewCGImage
        return UIImage(CGImage: newCGImage!)
    }
    
    func dumpIamge() {
        let pixelData=CGDataProviderCopyData(CGImageGetDataProvider(CGImage))
        let tmpa = CGImageGetWidth(CGImage)
        let tmpb = CGImageGetHeight(CGImage)
        let tmpc = CGImageGetBytesPerRow(CGImage)
        let tmpd = CGImageGetBitsPerComponent(CGImage)
        let tmpe: CGColorSpaceRef = CGImageGetColorSpace(CGImage)!
        let tmpf = CGImageIsMask(CGImage)
        let tmpg = CGImageGetBitmapInfo(CGImage)
        let tmph = CGImageGetBitsPerPixel(CGImage)
//        let tmpi = CGImageGetUTType(CGImage)
        let tmpj = CGImageGetShouldInterpolate(CGImage)
        let tmpk = CGImageGetRenderingIntent(CGImage)
        
        print("image width: \(tmpa)")
        print("image height: \(tmpb)")
        print("image has \(tmpc) bytes per row" )
        print("image has \(tmpd) bits per component" )
        print("image color space: \(tmpe)")
        print("image is mask: \(tmpf)")
        print("image bitmap info: \(tmpg)")
        print("image has \(tmph) bits per pixel")
//        print("image utt type: \(tmpi)")
        print("image should interpolate: \(tmpj)")
        print("image  rendering intent: \(tmpk)")
        
        print("Bitamp Info: ------")
        print("Alpha info mask: \((tmpg.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue)  != 0 ? "Ture" : "False")")
        print("Float components: \((tmpg.rawValue & CGBitmapInfo.FloatComponents.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte oder mask: \((tmpg.rawValue & CGBitmapInfo.ByteOrderMask.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte order default: \((tmpg.rawValue & CGBitmapInfo.ByteOrderDefault.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte order 16 little: \((tmpg.rawValue & CGBitmapInfo.ByteOrder16Little.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte order 32 little: \((tmpg.rawValue & CGBitmapInfo.ByteOrder32Little.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte order 16 big: \((tmpg.rawValue & CGBitmapInfo.ByteOrder16Big.rawValue)  != 0 ? "Ture" : "False")")
        print("Byte order 32 big: \((tmpg.rawValue & CGBitmapInfo.ByteOrder32Big.rawValue)  != 0 ? "Ture" : "False")")
        print("Image Info ended---------------")
    }
    
    
}