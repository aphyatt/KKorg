//
//  Kangaroo.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class Kangaroo: SKNode {
    
    let leftColX: CGFloat
    let midColX: CGFloat
    let rightColX: CGFloat
    
    var leftTouch: Bool = false
    var rightTouch: Bool = false
    
    var kangPos: Int = 2
    var kangPosX: CGFloat = 0
    
    let kangaroo = SKSpriteNode(imageNamed: "Kangaroo")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        let size = TheGameScene?.size
        
        leftColX = (size!.width/2) - (dropletRect.width/3.5)
        midColX = size!.width/2
        rightColX = (size!.width/2) + (dropletRect.width/3.5)
        
        super.init()
        
        self.name = "kangaroo"
        self.zPosition = 10
        
        kangaroo.position = CGPoint(x: size!.width/2, y: dropletCatchBoundaryY)
        kangaroo.zPosition = 11
        kangaroo.setScale(0.7)
        addChild(kangaroo)
        
    }
    
    func update(currentTime: CFTimeInterval) {
        var kangSpeed: NSTimeInterval
        /*
        if let cs = controlSettings {
            switch cs {
            case .TwoThumbs:
                kangSpeed = 0.1
            case .Thumb:
                kangSpeed = 0.05
                break
            }
        }
        */
        
        kangSpeed = 0.05
        
        if leftTouch && (kangPos != 1) {
            println("move left")
            self.runAction(SKAction.moveToX(leftColX, duration: kangSpeed))
            kangPos = 1
        }
        if rightTouch && (kangPos != 3) {
            println("move right")
            self.runAction(SKAction.moveToX(rightColX, duration: kangSpeed))
            kangPos = 3
        }
        if ((!leftTouch && !rightTouch) || numFingers == 0) && (kangPos != 2) {
            println("move center")
            self.runAction(SKAction.moveToX(midColX, duration: kangSpeed))
            kangPos = 2
        }
        
        switch kangPos {
        case 1: kangPosX = leftColX
            break
        case 2: kangPosX = midColX
            break
        default: kangPosX = rightColX
        }
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        println("touched")
        if let cs = controlSettings {
            switch cs {
            case .TwoThumbs:
                if leftRect!.contains(touchLocation) {
                    leftTouch = true
                    rightTouch = false
                }
                if rightRect!.contains(touchLocation) {
                    rightTouch = true
                    leftTouch = false
                }
                break
            case .Thumb:
                if touchLocation.x < oneThirdX {
                    println("left touch")
                    leftTouch = true
                    rightTouch = false
                }
                if touchLocation.x > twoThirdX {
                    println("right touch")
                    rightTouch = true
                    leftTouch = false
                }
                break
            }
            
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
        if let cs = controlSettings {
            switch cs {
            case .TwoThumbs:
                let leftEndTouch = leftRect!.contains(touchLocation)
                let rightEndTouch = rightRect!.contains(touchLocation)
                
                if leftEndTouch || (numFingers == 0) {
                    leftTouch = false
                }
                if rightEndTouch || (numFingers == 0) {
                    rightTouch = false
                }
                break
            case .Thumb:
                if numFingers == 0 {
                    leftTouch = false
                    rightTouch = false
                }
                break
            }
        }
    }
    
    func trackThumb(touchLocation:CGPoint) {
        if touchLocation.x < oneThirdX {
            leftTouch = true
            rightTouch = false
        }
        else if touchLocation.x > twoThirdX {
            rightTouch = true
            leftTouch = false
        }
        else {
            leftTouch = false
            rightTouch = false
        }
    }
    
}