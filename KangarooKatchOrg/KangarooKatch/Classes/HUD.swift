//
//  HUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

let HUDheight: CGFloat = 120

class HUD: SKNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        self.name = "HUD"
        self.zPosition = 100
        
        let size = TheGameScene?.size
        
        let HUDrect = CGRect(x: 0, y: size!.height - HUDheight, width: size!.width, height: HUDheight)
        var HUDshape = drawRectangle(HUDrect, SKColor.blackColor(), 1.0)
        HUDshape.fillColor = SKColor.blackColor()
        HUDshape.zPosition = 101
        addChild(HUDshape)
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }
    
}
