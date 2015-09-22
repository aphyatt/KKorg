//
//  ClassicHUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var TheClassicHUD: ClassicHUD?

class ClassicHUD: SKNode {
    
    var joeyCountLabel: GameLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        TheClassicHUD = self
        
        self.name = "ClassicHUD"
        self.zPosition = 200
        
        CreateJoeyCountLabel()
        
        
    }
    
    func update(currentTime: CFTimeInterval) {
        
    }
    
    private func CreateJoeyCountLabel() {
        joeyCountLabel = GameLabel(text: "Joeys: \(GS.JoeysLeft)", size: 57,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 959), zPosition: self.zPosition + 1)
        if let jc = joeyCountLabel {
            jc.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            self.addChild(jc)
        }
    }
    
    func subtractJoeyCount() {
        GS.JoeysLeft--
        joeyCountLabel!.text = "Joeys: \(GS.JoeysLeft)"
        
        let grow = SKAction.scaleBy(1.05, duration: 0.15)
        let center = SKAction.moveToX(GameSize!.width/2, duration: 0)
        let adjust = SKAction.runBlock({
            self.joeyCountLabel!.labelS.position.x += 2
            self.joeyCountLabel!.labelS.position.y -= 2
        })
        let shrink = grow.reversedAction()
        let scoreAction = SKAction.sequence([grow, center, adjust, shrink])
        joeyCountLabel!.runAction(scoreAction)
        
        if (GS.JoeysLeft == 0) { GS.GameState = .GameOver }
        
    }
    
    
    
}
