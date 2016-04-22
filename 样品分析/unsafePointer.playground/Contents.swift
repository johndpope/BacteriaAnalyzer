//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"
//var array = [1,2,3]
//var arrayPtr = UnsafeMutableBufferPointer<Int>(start: &array, count: array.count)
//var basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<Int>
//basePtr.memory
//basePtr.successor().memory
//basePtr.successor().successor().memory
//basePtr.successor().successor().successor().memory
let image = UIImage(named: "1.bmp")
let imageRef: CGImageRef = (image?.CGImage!)!
manipulateImagePixelData(imageRef)

func manipulateImagePixelData(inImage: CGImageRef) {
    let cgctx = createARGBBitmapContext(inImage)
    let w = CGImageGetWidth(inImage)
    let h = CGImageGetHeight(inImage)
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: w, height: h))
    
    CGContextDrawImage(cgctx, rect, inImage)
    let data = CGBitmapContextGetData(cgctx)
    
    
    if data != nil {
        // do stuff with data here
        print(data)
    } else {
        print("data is nil")
    }
}

func createARGBBitmapContext(inImage: CGImageRef) -> CGContextRef {
    var context: CGContextRef!
    var colorSpace: CGColorSpaceRef!
    var bitmapData: UnsafeMutablePointer<Void>
    var bitmapByteCount: Int!
    var bitmapBytePerRow: Int!
    
    let pixelsWide = CGImageGetWidth(inImage)
    let pixelsHigh = CGImageGetHeight(inImage)
    
    bitmapBytePerRow = pixelsWide * 4
    bitmapByteCount = pixelsWide * pixelsHigh
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
    
    if (colorSpace == nil) {
        print("Color is nil")
    }
    
    bitmapData = UnsafeMutablePointer.alloc(bitmapByteCount)
    if bitmapData == nil {
        print("Bitmap data is nil")
    }
    context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytePerRow, colorSpace, 1)

    return context
}
