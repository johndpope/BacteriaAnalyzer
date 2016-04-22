//
//  SAAssetExtension.swift
//  Bacteria Analyzer
//
//  Created by 王俊硕 on 16/4/17.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit
import AssetsLibrary

extension SampleAnalsisViewController {
    func importImageFormLibrary(){
        var count = 0
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: {
            (group: ALAssetsGroup!, stop) in
            if group != nil {
                let assetBlock: ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!,  index: Int, stop) in
                    if result != nil && count <= 1
                    {
                        self.assets.append(result)
                        count++
                    }
                }
                
                
                group.enumerateAssetsUsingBlock(assetBlock)
            }
            }, failureBlock: {
                (fail) in
                print(fail)
        })
    }
    
    func getImageFromAsset(asset: ALAsset) -> UIImage{
        let representation = asset.defaultRepresentation()
        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
        let bufferSize = representation.getBytes(imageBuffer, fromOffset: 0, length: Int(representation.size()), error: nil)
        let data = NSData(bytesNoCopy: imageBuffer, length: bufferSize, freeWhenDone: true)
        let image = UIImage(data: data)
        return image!
        
    }
}
