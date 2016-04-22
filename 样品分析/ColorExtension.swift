//
//  ColorExtension.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

enum blueGrey {
    case s50
    case s100
    case s200
    case s300
    case s400
    case s500
    case s600
    case s700
    case s800
    case s900
    case grey50
    
    var colorRGB: UIColor {
        switch self {
        case .s50: return UIColorFrom(hex: 0xe0f7fa)
        case .s100: return UIColorFrom(hex: 0xb2ebf2)
        case .s200: return UIColorFrom(hex: 0x80deea)
        case .s300: return UIColorFrom(hex: 0x4dd0e1)
        case .s400: return UIColorFrom(hex: 0x26c6da)
        case .s500: return UIColorFrom(hex: 0x00bcd4)
        case .s600: return UIColorFrom(hex: 0x00acc1)
        case .s700: return UIColorFrom(hex: 0x0097a7)
        case .s800: return UIColorFrom(hex: 0x00838f)
        case .s900: return UIColorFrom(hex: 0x006064)
        case .grey50: return UIColorFrom(hex: 0xfafafa)
        }
        
    }
    
    func UIColorFrom(hex hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
    
}

enum grey {
    case s50
    case s100
    case s200
    case s300
    case s400
    case s500
    case s600
    case s700
    case s800
    case s900
    case s1000b
    case s1000w
    
    var colorRGB: UIColor {
        switch self {
        case .s50: return UIColorFrom(hex: 0xfafafa)
        case .s100: return UIColorFrom(hex: 0xf5f5f5)
        case .s200: return UIColorFrom(hex: 0xeeeeee)
        case .s300: return UIColorFrom(hex: 0xe0e0e0)
        case .s400: return UIColorFrom(hex: 0xbdbdbd)
        case .s500: return UIColorFrom(hex: 0x9e9e9e)
        case .s600: return UIColorFrom(hex: 0x757575)
        case .s700: return UIColorFrom(hex: 0x616161)
        case .s800: return UIColorFrom(hex: 0x212121)
        case .s900: return UIColorFrom(hex: 0x263238)
        case .s1000b: return UIColorFrom(hex: 0xffffff)
        case .s1000w: return UIColorFrom(hex: 0x000000)
        }
        
    }
    
    func UIColorFrom(hex hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
    
}