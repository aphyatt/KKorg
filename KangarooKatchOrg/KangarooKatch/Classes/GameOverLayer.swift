//
//  GameOverLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/20/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class GameOverLayer: SKNode {
    
    let fullRect: CGRect
    
    var restartTap: Bool = false
    var restartTapWait: Bool = false
    var startGameOver: Bool = false
    
    var gameOverLabel: GameLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        
        super.init()
        
        self.name = "GameOver"
        self.zPosition = 300
        
    }
    
    func update(currentTime: CFTimeInterval) {
        endGame()
    }
    
    
    var endGameCalls: Int = 0
    func endGame() {
        endGameCalls++
        if(endGameCalls == 1) {
            var gameOver: SKAction
            if GS.GameMode == .Endless {
                gameOver = SKAction.runBlock({self.endlessGameOver()})
            }
            else { //if GS.GameMode == .Classic {
                gameOver = SKAction.runBlock({self.classicGameOver()})
            }
            let wait2 = SKAction.waitForDuration(NSTimeInterval(5))
            let setBool = SKAction.runBlock({self.restartTapWait = true})
            runAction(SKAction.sequence([gameOver, wait2, setBool]))
        }
        else {
            if restartTap {
                restartTap = false
                restartTapWait = false
                endGameCalls = 0
                restartGame()
            }
        }
    }
    
    private func CreateGameOverLabel() {
        gameOverLabel = GameLabel(text: "GAME OVER", size: 70,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 780), zPosition: self.zPosition + 1)
        if let gol = gameOverLabel {
            gol.alpha = 0.0
            self.addChild(gol)
        }
    }
    
    func restartGame() {
        //remove all nodes
        removeAllActions()
        removeAllChildren()
        //add background and kangaroo
        GS.CurrScore = 0
        GS.DiffLevel = V_EASY
        TheGameScene!.restart()
        //set difficulty, speeds, ect.
        GS.timeBetweenLines = 0.5
        GS.totalLinesDropped = 0
        GS.currLinesToDrop = 0
        GS.lineCountBeforeDrops = 0
        GS.eggPercentage = 100
        GS.groupWaitTimeMin = 2.0
        GS.groupWaitTimeMax = 3.0
        GS.groupAmtMin = 2
        GS.groupAmtMax = 3
        GS.CurrJoeyLives = 10
        GS.CurrBoomerangLives = 3
        //kangPos = 2
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -7.8)
        //change gameState
        GS.GameState = .GameRunning
    }
    
    func endlessGameOver() {
        TheDropletLayer?.freezeDroplets()
        let shade = drawRectangle(fullRect, SKColor.grayColor(), 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = self.zPosition
        addChild(shade)
        
        CreateGameOverLabel()
        
        //fade in GAME OVER
        let wait = SKAction.waitForDuration(0.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let gameOverAction = SKAction.sequence([wait, fadeIn])
        gameOverLabel!.runAction(gameOverAction)
     
        //have score move and grow under GAME OVER
        let wait2 = SKAction.waitForDuration(3.0)
        let bringToFront = SKAction.runBlock({scoreLabel?.zPosition = self.zPosition + 1})
        let moveIntoPos = SKAction.moveTo(CGPoint(x: GameSize!.width/2, y: 722), duration: 1.0)
        let grow = SKAction.scaleBy(1.3, duration: 1.0)
        let adjust = SKAction.runBlock({
            scoreLabel?.labelS.position.x += 2
            scoreLabel?.labelS.position.y -= 2
        })
        let scoreAction = SKAction.sequence([wait2, bringToFront, SKAction.group([moveIntoPos, grow]), adjust])
        scoreLabel!.runAction(scoreAction)
        
        /*
        //tap anywhere to restart
        let tapRestart = createShadowLabel(font: "Soup of Justice", text: "TAP ANYWHERE TO RESTART",
            fontSize: 20,
            horAlignMode: horAlignModeDefault, vertAlignMode: .Baseline,
            labelColor: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            name: "tapRestartLabel",
            positon: CGPoint(x: GameSize!.width/2, y: 650),
            shadowZPos: 7, shadowOffset: 2)
        tapRestart[0].alpha = 0.0
        tapRestart[1].alpha = 0.0
        addChild(tapRestart[0])
        addChild(tapRestart[1])
        
        let wait3 = SKAction.waitForDuration(5.0)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 0.8)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.8)
        let blink = SKAction.sequence([fadeIn2, fadeOut])
        let tapAction = SKAction.sequence([wait3, SKAction.repeatActionForever(blink)])
        tapRestart[0].runAction(tapAction)
        tapRestart[1].runAction(tapAction)
        */
        
    }
    
    func classicGameOver() {
        /*
        freezeDroplets()
        let shade = drawRectangle(fullRect, SKColor.grayColor(), 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = 6
        addChild(shade)
        
        var scoreTmp: Int = 0
        let scoreLabelA: [SKLabelNode] = createShadowLabel(font: "Soup of Justice", text: "Score: \(scoreTmp)",
            fontSize: 60,
            horAlignMode: .Left, vertAlignMode: .Center,
            labelColor: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            name: "scoreLabel",
            positon: CGPoint(x: GameSize!.width/2, y: 780),
            shadowZPos: 7, shadowOffset: 4)
        scoreLabelA[0].runAction(SKAction.scaleYTo(1.3, duration: 0.0))
        scoreLabelA[1].runAction(SKAction.scaleYTo(1.3, duration: 0.0))
        scoreLabelA[0].alpha = 0.0
        scoreLabelA[1].alpha = 0.0
        addChild(scoreLabelA[0])
        addChild(scoreLabelA[1])
        
        //fade in score
        let wait = SKAction.waitForDuration(0.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let scoreAction = SKAction.sequence([wait, fadeIn])
        let Sgroup = SKAction.group([SKAction.runBlock({scoreLabelA[0].runAction(scoreAction)}),
            SKAction.runBlock({scoreLabelA[1].runAction(scoreAction)})])
        runAction(Sgroup)
        
        while scoreTmp < GS.CurrScore {
            scoreLabelA[0].text = "Score: \(score)"
            scoreLabelA[1].text = "Score: \(score)"
            
            var adjustX: CGFloat = 0
            if scoreTmp >= 10 { adjustX = 10 }
            if scoreTmp >= 100 { adjustX = 20 }
            let grow = SKAction.scaleBy(1.05, duration: 0.15)
            let adjust = SKAction.runBlock({
                scoreLabelA[0].position.x = self.size.width/2 - adjustX
                scoreLabelA[1].position.x = self.size.width/2 + 2 - adjustX
            })
            let shrink = grow.reversedAction()
            let scoreAction = SKAction.sequence([grow, adjust, shrink])
            
            let groupScore = SKAction.group([SKAction.runBlock({scoreLabelA[0].runAction(scoreAction)}),
                SKAction.runBlock({scoreLabelA[1].runAction(scoreAction)})])
            SKAction.sequence([groupScore, SKAction.waitForDuration(0.2)])
            scoreTmp++
        }
        
        //tap anywhere to restart
        let tapRestart = createShadowLabel(font: "Soup of Justice", text: "TAP ANYWHERE TO RESTART",
            fontSize: 20,
            horAlignMode: horAlignModeDefault, vertAlignMode: .Baseline,
            labelColor: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            name: "tapRestartLabel",
            positon: CGPoint(x: size.width/2, y: 650),
            shadowZPos: 7, shadowOffset: 2)
        tapRestart[0].alpha = 0.0
        tapRestart[1].alpha = 0.0
        addChild(tapRestart[0])
        addChild(tapRestart[1])
        
        let wait3 = SKAction.waitForDuration(5.0)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 0.8)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.8)
        let blink = SKAction.sequence([fadeIn2, fadeOut])
        let tapAction = SKAction.sequence([wait3, SKAction.repeatActionForever(blink)])
        tapRestart[0].runAction(tapAction)
        tapRestart[1].runAction(tapAction)


        */
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if (restartTapWait) {
            restartTap = true
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }

    
}