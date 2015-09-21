//
//  HUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

let HUDheight: CGFloat = 120
let horAlignModeDefault: SKLabelHorizontalAlignmentMode = .Center
let vertAlignModeDefault: SKLabelVerticalAlignmentMode = .Baseline

class HUD: SKNode {
    
    var classicHUD: ClassicHUD?
    var endlessHUD: EndlessHUD?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        self.name = "HUD"
        self.zPosition = 100
        
        if GS.GameMode == .Classic {
            CreateClassicHUD()
        }
        if GS.GameMode == .Endless {
            CreateEndlessHUD()
        }
        
    }
    
    func update(currentTime: CFTimeInterval) {
        if GS.GameMode == .Endless {
            if let eh = endlessHUD {
                eh.update(currentTime)
            }
        }
        if GS.GameMode == .Classic {
            if let ch = classicHUD {
                ch.update(currentTime)
            }
        }
    }
    
    private func CreateClassicHUD() {
        classicHUD = ClassicHUD()
        if let cHUD = classicHUD {
            self.addChild(cHUD)
        }
    }
    
    private func CreateEndlessHUD() {
        endlessHUD = EndlessHUD()
        if let eHUD = endlessHUD {
            self.addChild(eHUD)
        }
    }
    
    func updateScore() {
        if GS.GameMode == .Endless {
            endlessHUD!.updateScore()
        }
        if GS.GameMode == .Classic {
            classicHUD!.updateScore()
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }
    
}
