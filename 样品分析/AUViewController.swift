//
//  ViewController.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/17.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var logo1: UIImageView!
    @IBOutlet weak var logo2: UIImageView!
    @IBOutlet weak var pickSampleButton: UIButton!
    @IBOutlet weak var analysisButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TabBar
        self.tabBarController?.tabBar.tintColor = blueGrey.s500.colorRGB // 整个TabBar
        
        for item in (tabBarController?.tabBar.items)! {
            item.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Times new roman", size: 11)!], forState: .Normal)
        }
        
        // Navigation Controller
        
        self.navigationController?.navigationBar.barTintColor = blueGrey.s500.colorRGB
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Times new roman", size: 20)!]
        
        //        navigatiddonController?.navigationBar.translucent = false
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.backgroundColor = blueGrey.s500.colorRGB
        
        // Button Initialization
        pickSampleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        pickSampleButton.backgroundColor = UIColorFrom(hex: 0x26c6da)
        analysisButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        analysisButton.backgroundColor = UIColorFrom(hex: 0x26c6da)
        analysisButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // Others
        subtitle.adjustsFontSizeToFitWidth = true
        
        view.backgroundColor = grey.s200.colorRGB
    }
    
    func UIColorFrom(hex hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toSAView(sender: AnyObject) {
        
        self.tabBarController?.selectedIndex = 1
//        let viewController = self.tabBarController?.childViewControllers[1] as! UINavigationController
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.window?.rootViewController = self.tabBarController?.selectedViewController
//        let rootViewController = viewController.popToRootViewControllerAnimated(true)

//        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func toRRView(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
}

