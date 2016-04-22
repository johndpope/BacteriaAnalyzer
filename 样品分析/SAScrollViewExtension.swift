//
//  SAScrollViewExtension.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/18.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

extension SampleAnalsisViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //这个方法定义在继承的协议中，当zoom事件发生的时候调用，如果返回nil则什么都不发生
        return imageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents(imageView!, scrollView: imageScrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshDashedBorderView(scrollView)
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        refreshDashedBorderView(scrollView)
    }
    func refreshDashedBorderView(scrollView: UIScrollView) {
        dashedBorderView.textOnLabel = Int(64 / scrollView.zoomScale).description
        if scrollView.zoomScale == 0.25 {
            dashedBorderView.border.strokeColor = UIColor.whiteColor().CGColor
        } else {
            dashedBorderView.border.strokeColor = UIColor.grayColor().CGColor
        }
    }
}

