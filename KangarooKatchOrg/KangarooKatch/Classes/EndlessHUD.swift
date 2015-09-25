//
//  EndlessHUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

weak var TheEndlessHUD: EndlessHUD?
var scoreLabel: GameLabel?

class EndlessHUD: SKNode {
    
    var joeyLifeStartX: CGFloat
    var boomerangLifeStartX: CGFloat
    
    var dropsLeft: Int = 10
    var livesLeft: Int = 3
    let scoreLabelX: CGFloat = oneThirdX - 70
    let scoreLabelY: CGFloat = 962
    let livesDropsX: CGFloat = twoThirdX - 25
    let livesLabelY: CGFloat = 982
    let dropsLabelY: CGFloat = 942
    
    var livesLabel: GameLabel?
    var dropsLabel: GameLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        joeyLifeStartX = GameSize!.width/2 + 93
        boomerangLifeStartX = GameSize!.width/2 + 115
        
        super.init()
        
        TheEndlessHUD = self
        
        self.name = "EndlessHUD"
        self.zPosition = 200
        
        CreateScoreLabel()
        CreateLivesLabel()
        CreateDropsLabel()
        CreateLives()
        
    }
    
    func update(currentTime: CFTimeInterval) {
        /*
        if endlessScoreChange {
            updateScore()
            endlessScoreChange = false
        }
        */
    }
    
    private func CreateScoreLabel() {
        scoreLabel = GameLabel(text: "Score: \(GS.CurrScore)", size: 50,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: scoreLabelX, y: scoreLabelY), zPosition: self.zPosition + 1)
        if let sl = scoreLabel {
            sl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            self.addChild(sl)
        }
    }
    
    private func CreateLivesLabel() {
        livesLabel = GameLabel(text: "Lives: ", size: 35,
            horAlignMode: .Right, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: livesDropsX, y: livesLabelY), zPosition: self.zPosition + 1)
        if let ll = livesLabel {
            ll.runAction(SKAction.scaleYTo(1.2, duration: 0.0))
            self.addChild(ll)
        }
    }
    
    private func CreateDropsLabel() {
        dropsLabel = GameLabel(text: "Drops: ", size: 35,
            horAlignMode: .Right, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: livesDropsX, y: dropsLabelY), zPosition: self.zPosition + 1)
        if let dl = dropsLabel {
            dl.runAction(SKAction.scaleYTo(1.2, duration: 0.0))
            self.addChild(dl)
        }
    }
    
    func CreateLives() {
        
        for i in 0...9 {
            let node = SKSpriteNode(imageNamed: "Egg")
            let nodeS = SKSpriteNode(imageNamed: "Egg")
            
            node.position.x = joeyLifeStartX + CGFloat(i)*20
            node.position.y = dropsLabelY
            node.setScale(0.04)
            node.zPosition = self.zPosition + 2
            node.name = "drop\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.04)
            nodeS.zPosition = self.zPosition + 1
            nodeS.alpha = 0.5
            
            addChild(node)
            addChild(nodeS)
        }
        
        for i in 0...2 {
            let node = SKSpriteNode(imageNamed: "Boomerang")
            let nodeS = SKSpriteNode(imageNamed: "Boomerang")
            
            node.position.x = boomerangLifeStartX + CGFloat(i)*60
            node.position.y = livesLabelY
            node.setScale(0.10)
            node.zPosition = 5
            node.name = "life\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.10)
            nodeS.zPosition = 4
            nodeS.alpha = 0.5
            
            addChild(node)
            addChild(nodeS)
        }
        
    }
    
    func removeLife(child: String) {
        childNodeWithName(child)?.removeFromParent()
    }
    
    func updateScore() {
        if let sl = scoreLabel {
            sl.text = "Score: \(GS.CurrScore)"
        
            let grow = SKAction.scaleBy(1.05, duration: 0.15)
            let adjust = SKAction.runBlock({
                sl.changePositionX(self.scoreLabelX)
            })
            let shrink = grow.reversedAction()
            let scoreAction = SKAction.sequence([grow, adjust, shrink])
            
            sl.runAction(scoreAction)
        }
    }

}
