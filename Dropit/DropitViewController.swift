//
//  DropitViewController.swift
//  Dropit
//
//  Created by 20161104612 on 2018/11/29.
//  Copyright © 2018 20161104612. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController,UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {  //不会初始化，一旦被应用，闭包就会执行（闭包没有参数），闭包返回一个uidynamicanimator
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView:self.gameView) //因为为一个构造函数，所以在函数没有完整构造出来时，不能引用属性和方法（发生错误）
        lazilyCreatedDynamicAnimator.delegate = self
        return lazilyCreatedDynamicAnimator
    }() //使用闭包
    //最好别在设置好之前调用它，应为它的引用试图为nil，不会工作（引用animator之前），所以在viewdidload之前不会引用，outlet已经被设置好
    //使用lazy的正当理由（1，在构造期有一些东西不能引用 2，构造完毕后设置一些它的属性）
    
    var dropitBehavior = DropitBehavior()  //为了取代animator和分开的gravity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropitBehavior)  //将重力场添加到animator中，animator发挥特性
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) { //发生停滞时执行以下
        removeCompletedRow()
    }
    
    var dropsPerRow = 10 //表示在顶部可以有多少块方块，可设置任意整数
    
    //可调整的ui界面
    var dropSize: CGSize{  //用于计算方块的尺寸，需要用到计算属性
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow) //基于dropsperRow
        return CGSize(width: size, height: size)  //返回一个CGSize,包含相同的长与宽
    }
    
    //添加一个单击手势，在视图中放入方块
    
    @IBAction func drop(_ sender: UITapGestureRecognizer) {
        drop()   //需要计算drop的位置
    }
    
    func drop() {   //不知可以通过手势还可以通过代码来向下掉落
        var frame = CGRect(origin: CGPoint.zero, size: dropSize) //弄清方块的位置，创建他的frame,参数为0，0
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width  //随机生成一个0-dropsperrow-1间的数字
        let dropView = UIView(frame: frame)//创建UIVIEW使用frame构造器
        dropView.backgroundColor = UIColor.random  //将背景颜色设为随机的，调用下方的uicolory函数
        
       /* gameView.addSubview(dropView)  //通过addsubview来添加砖块，试图之类的试图
        gravity.addItem(dropView)  //指明哪个物体将会搜到影响
        collider.addItem(dropView) */ //方块实行碰撞行为
        
        dropitBehavior.addDrop(drop: dropView)
    }
    
    func removeCompletedRow()  //当填满一行后被移除
    {
        var dropsToRemove = [UIView]()
        var dropFrance = CGRect(x: 0,y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat{
            dropFrance.origin.y -= dropSize.height
            dropFrance.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow{
                if let hitView = gameView.hitTest(CGPoint(x: dropFrance.midX, y:dropFrance.midY), with: nil) {
                    if hitView.superview == gameView{
                        dropsFound.append(hitView)
                    }else{
                        rowIsComplete = false
                    }
                }
                dropFrance.origin.x += dropSize.width
            }
            if rowIsComplete{
                dropsToRemove += dropsFound
            }
        }while dropsToRemove.count == 0 && dropFrance.origin.y > 0
        
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop: drop)
        }
    }
}

private extension CGFloat {  //extension可以很好的控制公私有性
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random:UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.green
        case 1: return UIColor.blue
        case 2: return UIColor.orange
        case 3: return UIColor.red
        case 4: return UIColor.purple
        default: return UIColor.black
        }
    }
}
