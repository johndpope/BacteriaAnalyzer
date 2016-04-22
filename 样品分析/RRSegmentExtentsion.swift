//
//  RRSegmentExtentsion.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/21.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

extension ResultRepresentViewController {
    func segmentIndexTapped() {
        
        switch choosePattern.selectedSegmentIndex {
        case 0:
            let (a, b) = anaylzer!.computeWith(0.15219, factor2: 0.15339)
            setValue(rbRatio: a, calculationResult: b)
        case 1:
            let (a, b) = anaylzer!.computeWith(0.14605, factor2: 0.16254)
            setValue(rbRatio: a, calculationResult: b)
        case 2:
            let (a, b) = anaylzer!.computeWith(0.13723, factor2: 0.1683)
            setValue(rbRatio: a, calculationResult: b)

        case 3:
            let (a, b) = anaylzer!.computeWith(0.14126, factor2: 0.15591)
            setValue(rbRatio: a, calculationResult: b)

        default:
            let (a, b) = anaylzer!.computeWith(0.15219, factor2: 0.15339)
            setValue(rbRatio: a, calculationResult: b)
            print("Error happend when tried to analyze")
        }
        resultTable.reloadData()
    }
    func setValue(rbRatio rbRatio: CGFloat, calculationResult: CGFloat) {
        self.rbRatio = rbRatio
        self.calculationResult = calculationResult
    }
}
