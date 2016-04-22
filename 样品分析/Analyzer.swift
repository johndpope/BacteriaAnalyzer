//
//  Analyzer.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/21.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

struct Analyzer {
    
    
    var numerator: CGFloat? // default is R
    var denomintor: CGFloat? // default is B
    var factor1: CGFloat?
    var factor2: CGFloat?
    
    init (wtihRGBColor numerator: Int, denomintor: Int) {
        self.numerator = CGFloat(numerator)
        
        self.denomintor = CGFloat(denomintor == 0 ? 1 : denomintor)
        
    }
    
    func computeWith(factor1: CGFloat, factor2: CGFloat, baseNumber: CGFloat = 10) -> (CGFloat, CGFloat) {
        let rbRatio = CGFloat(numerator! / denomintor!)
        let temp = CGFloat(rbRatio + factor1)
        let index = CGFloat(temp / factor2)
        let result  = pow(baseNumber , index)
        
        return (rbRatio, result)
    }
}