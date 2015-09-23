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
    var tempScoreLabel: GameLabel?
    
    var scoreTmp: Int = 0
    
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
    
    private func CreateTempScoreLabel() {
        tempScoreLabel = GameLabel(text: "Score: 0", size: 60,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 780), zPosition: self.zPosition + 1)
        if let tsl = tempScoreLabel {
            tsl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            tsl.alpha = 0.0
            self.addChild(tsl)
        }
    }
    
    func restartGame() {
        //remove all nodes
        removeAllActions()
        removeAllChildren()
        //add background and kangaroo
        GS.CurrScore = 0
        GS.JoeysLeft = 100 //CHANGE LATER
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
        TheDropletLayer?.freezeDroplets()
        let shade = drawRectangle(fullRect, SKColor.grayColor(), 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = self.zPosition
        addChild(shade)
        
        CreateTempScoreLabel()
        
        //fade in score
        let wait = SKAction.waitForDuration(0.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let fadeAction = SKAction.sequence([wait, fadeIn])
        tempScoreLabel!.runAction(fadeAction)
        
        let changeScore = SKAction.runBlock({
            //will add twice because of shadow and main label
            self.scoreTmp++
            self.tempScoreLabel!.text = "Score: \(self.scoreTmp/2)"
        })
        let grow = SKAction.scaleBy(1.005, duration: 0.05)
        
        let test = SKAction.runBlock({
            println("hello")
        })
        
        let scoreAction = SKAction.group([changeScore, grow])
        let waitFirstScoreAction = SKAction.waitForDuration(0.5)
        let waitQuickScoreAction = SKAction.waitForDuration(0.01)
        let beginScoreAction = SKAction.sequence([scoreAction, waitFirstScoreAction])
        let endScoreAction2 = SKAction.sequence([SKAction.waitForDuration(0.5), scoreAction])
        var finalScoreAction: SKAction
        var repeatScore: SKAction
        var endScoreAction1: SKAction
        if GS.CurrScore > 4 {
            endScoreAction1 = SKAction.sequence([SKAction.waitForDuration(0.49), scoreAction])
            repeatScore = SKAction.repeatAction(SKAction.sequence([scoreAction, waitQuickScoreAction]), count: GS.CurrScore-4)
            finalScoreAction = SKAction.sequence([beginScoreAction, beginScoreAction, repeatScore, endScoreAction1, endScoreAction2])
        }
        else {
            endScoreAction1 = SKAction.sequence([SKAction.waitForDuration(0.2), scoreAction])
            repeatScore = SKAction.repeatAction(SKAction.sequence([scoreAction, SKAction.waitForDuration(0.3)]), count: GS.CurrScore-1)
            finalScoreAction = SKAction.sequence([repeatScore, endScoreAction1])
        }
        let finalAction = SKAction.sequence([SKAction.waitForDuration(2.5), finalScoreAction])
        tempScoreLabel!.runAction(finalAction)
        
        /*
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
