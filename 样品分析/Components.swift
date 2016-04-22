//
//  Components.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/17.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit



public class ALertMessageBox{
    
    /**
     获取UIAlertController对象
     
     :param: title      标题提示内容
     :param: contentMsg 主要信息内容
     :param: boxStyle   窗口样式：Alert或者ActionSheet
     
     :returns: 警示框
     */
    
    
    public class func boxController(title:String, contentMsg:String,boxStyle: UIAlertControllerStyle)->UIAlertController{
        return UIAlertController(title: title, message: contentMsg, preferredStyle: boxStyle)
    }
    
    /**
     获取指定的UIAlertAction对象
     
     :param: buttonString   按钮文本内容
     :param: boxActionStyle 按钮类型
     :param: blockHandler   点击按钮后的事件回调方法
     
     :returns: <#return value description#>
     */
    public class func boxAction(buttonString:String,boxActionStyle:UIAlertActionStyle,blockHandler:((UIAlertAction!) -> Void)!) -> UIAlertAction{
        return UIAlertAction(title: buttonString, style: boxActionStyle, handler: blockHandler)
    }
    
    /**
     快速显示一个Alert弹窗
     
     :param: viewControl  需要显示的页面（常用Self表示当前viewControl）
     :param: title        弹窗的标题文本内容
     :param: contentMsg   弹窗的主要内容
     :param: buttonString 按钮的文本内容
     :param: blockHandler 按钮点击事件的回调方法
     */
    public class func show(viewControl:UIViewController,title:String,contentMsg:String,buttonString:String,blockHandler:((UIAlertAction!) -> Void)!){
        let control = self.boxController(title, contentMsg: contentMsg, boxStyle: UIAlertControllerStyle.Alert)
        let action  = self.boxAction(buttonString, boxActionStyle: UIAlertActionStyle.Default, blockHandler: blockHandler)
        control.addAction(action)
        viewControl.presentViewController(control, animated: true, completion: nil)
    }
}
