//
//  World.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var leftRect: CGRect?
var rightRect: CGRect?

class World: SKNode {
    
    var Kang: Kangaroo?
    var Droplets: DropletLayer?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        self.name = "world"
        self.zPosition = 0
        
        let size = TheGameScene?.size
        
        leftRect = CGRect(x: 0, y: 0,
            width: size!.width/2,
            height: size!.height)
        rightRect = CGRect(x: size!.width/2, y: 0,
            width: size!.width/2,
            height: size!.height)
        
        //oneThirdX = playableMargin + (playableWidth/3)
        //twoThirdX = playableMargin + (playableWidth*(2/3))
        
        TheGameScene?.backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "Background.jpg")
        background.position = CGPoint(x: size!.width/2, y: size!.height/2)
        background.zPosition = 1
        addChild(background)
        
        CreateKangaroo()
        CreateDropletLayer()
        
    }
    
    func update(currentTime: CFTimeInterval) {
        Kang!.update(currentTime)
    }
    
    private func CreateKangaroo() {
        Kang = Kangaroo()
        if let kangaroo = Kang {
            self.addChild(kangaroo)
        }
    }
    
    private func CreateDropletLayer() {
        Droplets = DropletLayer()
        if let drops = Droplets {
            self.addChild(drops)
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if GS.GameState == .GameRunning {
            Kang!.sceneTouched(touchLocation)
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        if GS.GameState == .GameRunning {
            Kang!.sceneUntouched(touchLocation)
        }
    }
    
    func trackThumb(touchLocation:CGPoint) {
        if GS.GameState == .GameRunning {
            Kang!.trackThumb(touchLocation)
        }
    }
    
    
  
    
    
    
    
    
    
}
