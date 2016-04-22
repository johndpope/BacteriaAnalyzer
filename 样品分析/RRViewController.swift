//
//  ResultRepresentView.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/20.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

class ResultRepresentViewController: UIViewController {
    
   
    var image: UIImage?
    var partialImage: UIImage?
    var anaylzer: Analyzer?
    var warnLabel: UILabel?
    var numerator: String?
    var denominator: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePattern: UISegmentedControl!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var partialImageView: UIImageView!
   
    @IBOutlet weak var choosePattherTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var dataArray: [Int] = []
    var backgroundColor: UIColor?
    var calculationResult: CGFloat?
    var rbRatio: CGFloat?
    
    var selectedNumerator: Int?
    var selectedDonominator: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Controller Initialization
        self.navigationController?.navigationBar.barTintColor = blueGrey.s500.colorRGB
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        //        navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Times new roman", size: 20)!]
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.backgroundColor = blueGrey.s500.colorRGB
        
        
    
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        image = appDelegate.image
        
        partialImage = appDelegate.partialImage
        dataArray = appDelegate.dataToPass
        numerator = appDelegate.numerator
        denominator = appDelegate.denominator
        
        backgroundColor = grey.s50.colorRGB
        view.backgroundColor = backgroundColor
        

        
    }
    
    func averageOfdata(Array data: [[Int]] ) -> Int{
        var resultInTotal: Int = 0
        var count: Int = 0
        
        for valueArray in data {
            count += 1
            for value in valueArray {
                count += 1
                resultInTotal += value
            }
        }
        return Int(resultInTotal / count)
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        image = appDelegate.image
        partialImage = appDelegate.partialImage
        dataArray = appDelegate.dataToPass
        numerator = appDelegate.numerator
        denominator = appDelegate.denominator
        
        warnLabel?.removeFromSuperview()
        
        
        if image != nil {
            
            imageView.image = image
            imageView.contentMode = .ScaleAspectFill
            partialImageView.image = partialImage
            imageViewHeight = NSLayoutConstraint(item: imageView!, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.5, constant: 0)
            
        } else {
            dataArray.append(255)
            dataArray.append(255)
            dataArray.append(255)
            
            warnLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: imageView.frame.height / 2), size: CGSize(width: view.frame.width, height: 20)))
            warnLabel?.textAlignment = .Center
            
            warnLabel!.text = "Try Analyze First"
            view.addSubview(warnLabel!)
            print(warnLabel!.description)
            
            // 前面没有选择分析数据
            print("there is no image in imageView, image descrition: \(image?.description)")
        }
        setSegmentControll()
        tableViewInitial()
        anaylzerInitial()
        
        segmentIndexTapped() // 刷新原值
    }
    override func viewDidDisappear(animated: Bool) {
        warnLabel?.removeFromSuperview()
        print("viwe did disappear")
        dataArray = []
        imageView.image = nil
        
        
    }
    func anaylzerInitial() {
        
        var numeratorValue: Int
        var denominatorValue: Int
        if numerator != nil {
        switch self.numerator! {
        case "R":
            numeratorValue = dataArray[0]
        case "G":
            numeratorValue = dataArray[1]
        case "B":
            numeratorValue = dataArray[2]
        default:
            numeratorValue = 255
            }
        } else {
            numeratorValue = 255
        }
        
        if  denominator != nil {
            switch self.denominator! {
            case "R":
                denominatorValue = dataArray[0]
            case "G":
                denominatorValue = dataArray[1]
            case "B":
                denominatorValue = dataArray[2]
            default:
                denominatorValue = 255
            }
        } else {
            denominatorValue = 255
        }
       
        
        anaylzer = Analyzer(wtihRGBColor: numeratorValue, denomintor: denominatorValue)
        let (rbRatio, methodAResult) = anaylzer!.computeWith(0.15219, factor2: 0.15339)
        calculationResult = methodAResult
        self.rbRatio = rbRatio

    }
    func tableViewInitial() {
        // Table View Initial
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.bounces = false
        resultTable.scrollEnabled = false
        resultTable.backgroundColor = backgroundColor // 在section之间添加背景图片做效果
        resultTable.separatorStyle = .None
        

    }
    func setSegmentControll() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let patternTitle = ["B.subtilis","E.coli","P.aeruginosa","S.aureus"]
        
        choosePattern.selectedSegmentIndex = 0
        choosePattern.setBackgroundImage(imageOfColorWithRGB(blueGrey.s500.colorRGB, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))), forState: UIControlState.Highlighted, barMetrics: UIBarMetrics.Default)
        choosePattern.selectedSegmentIndex = 0
        choosePattern.addTarget(self, action: #selector(ResultRepresentViewController.segmentIndexTapped), forControlEvents: .ValueChanged)
        choosePattern.tintColor = blueGrey.s500.colorRGB
        for (index, title) in patternTitle.enumerate() {
            choosePattern.setTitle(title, forSegmentAtIndex: index)
            choosePattern.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Times new roman", size: 15)!], forState: .Normal)
            choosePattern.titleForSegmentAtIndex(index)
            switch index {
            case 1:
                choosePattern.setWidth(0.2 * screenWidth, forSegmentAtIndex: index)
            case 2:
                choosePattern.setWidth(0.25 * screenWidth, forSegmentAtIndex: index)
            default:
                choosePattern.setWidth(0.215 * screenWidth, forSegmentAtIndex: index)
            }
           
        }
        


    }
    
    func imageOfColorWithRGB(color: UIColor, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        print("iamge color frame \(frame)")
        return image
        
    }
    
}


























