//
//  DropitBehavior.swift
//  Dropit
//
//  Created by 20161104612 on 2018/11/29.
//  Copyright © 2018 20161104612. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
    
    let gravity = UIGravityBehavior()  //创建一个重力场，使方块可以下落
    
    lazy var collider:UICollisionBehavior = {//碰撞属性
        let lazilyCreatedCollider = UICollisionBehavior()  //没有调用构造器是想要d调用某些属性
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true //将屏幕边界变为边界（referenceview将会变为边界），在collider中的物体会在边界弹起
        return lazilyCreatedCollider
    }()
    
    lazy var dropBehavior:UIDynamicItemBehavior = {
       let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = false //设置是否旋转
        lazilyCreatedDropBehavior.elasticity = 0.75  //设置弹起高度，1.0为完全失重
        return lazilyCreatedDropBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }//重写UIdynamicbehavior的init方法 ,是UIdynamicbehavior的子类
    
    func addDrop(drop: UIView) {
        dynamicAnimator?.referenceView?.addSubview(drop) //将drop添加到引用视图，调用dropbehavior的adddrop时，添加到behaviors里
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop:UIView) { //功能相反的类
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
}
