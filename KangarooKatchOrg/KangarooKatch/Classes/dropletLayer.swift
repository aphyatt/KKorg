//
//  dropletLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

//Difficulty variables
var changeDiff: Bool = false
let V_EASY = 0
let EASY = 1
let MED = 2
let HARD = 3
let V_HARD = 4
let EXTREME = 5

//Droplet types and arrays
let SPACE = 0
let JOEY = 1
let BOOMERANG = 2

var dropLines: Bool = false
var TheDropletLayer: DropletLayer?

class DropletLayer: SKNode {
    
    var catchZoneRect: CGRect = CGRectNull
    var fadeZoneRect: CGRect = CGRectNull
    
    //Variables affecting speed / frequency of droplet lines
    var timeBetweenLines: NSTimeInterval = 0.5
    var totalLinesDropped: Int = 0
    var totalGroupsDropped: Int = 0
    var currLinesToDrop: Int = 0
    var lineCountBeforeDrops: Int = 0
    var eggPercentage: Int = 100
    var groupWaitTimeMin: CGFloat = 2.0
    var groupWaitTimeMax: CGFloat = 3.0
    var groupAmtMin: Int = 2
    var groupAmtMax: Int = 3
    var checkDiffCalls: Int = 1
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        TheDropletLayer = self
        
        self.name = "droplets"
        self.zPosition = 50
      
        catchZoneRect = CGRect(x: playableMargin, y: dropletCatchBoundaryY - 5,
            width: playableWidth,
            height: 10)
        fadeZoneRect = CGRect(x: playableMargin, y: dropletFadeBoundaryY - 5,
            width: playableWidth,
            height: 10)
        
        switch GS.GameMode {
        case .Endless:
            GS.DiffLevel = V_EASY
            break
        case .Classic:
            setDifficulty(GS.DiffLevel)
        }
        
        dropLines = true
        
    }
    
    func update(currentTime: CFTimeInterval) {
        switch GS.GameMode {
        case .Endless:
            switch GS.GameState {
            case .GameRunning:
                if (changeDiff) {
                    changeDifficulty()
                }
                
                if (totalLinesDropped - lineCountBeforeDrops) == currLinesToDrop {
                    dropNewGroup()
                }
                break
            case .Paused:
                break
            case .GameOver:
                break
            }
        case .Classic:
            switch GS.GameState {
            case .GameRunning:
                if (changeDiff) {
                    changeDifficulty()
                }
                
                if (totalLinesDropped - lineCountBeforeDrops) == currLinesToDrop {
                    dropNewGroup()
                }
                break
            case .Paused:
                break
            case .GameOver:
                break
            }
            
            
        }
     
    }
    
    //Set Difficulty once for Classic
    func setDifficulty(diff: Int) {
        switch diff {
        case V_EASY:
            timeBetweenLines = 0.5
            scene?.physicsWorld.gravity.dy = -7.8
            groupWaitTimeMax = 3
            groupWaitTimeMin = 2
            eggPercentage = 100
            break
        case EASY:
            timeBetweenLines = 0.46
            scene?.physicsWorld.gravity.dy = -9.0
            groupWaitTimeMax = 2.8
            groupWaitTimeMin = 1.8
            eggPercentage = 70
            break
        case MED:
            timeBetweenLines = 0.42
            scene?.physicsWorld.gravity.dy = -10.2
            groupWaitTimeMax = 2.6
            groupWaitTimeMin = 1.6
            eggPercentage = 70
            break
        case HARD:
            timeBetweenLines = 0.38
            scene?.physicsWorld.gravity.dy = -11.4
            groupWaitTimeMax = 2.4
            groupWaitTimeMin = 1.4
            eggPercentage = 75
            break
        case V_HARD:
            timeBetweenLines = 0.34
            scene?.physicsWorld.gravity.dy = -12.6
            groupWaitTimeMax = 2.2
            groupWaitTimeMin = 1.2
            eggPercentage = 90
            break
        default:
            timeBetweenLines = 0.3
            scene?.physicsWorld.gravity.dy = -13.8
            groupWaitTimeMax = 2
            groupWaitTimeMin = 1
            eggPercentage = 90
            break
        }
    }
    
    //Update Group Amount for Classic
    func updateGroupAmount() {
        let t = totalGroupsDropped
        if t == 10 || t == 20 || t == 30 || t == 37 || t >= 42 {
            groupAmtMin = (groupAmtMin*2 - 1)
            groupAmtMax = (groupAmtMin*2 - 1)
        }
        
    }
    
    //Change Difficulty for Endless
    func changeDifficulty() {
        if GS.DiffLevel < EXTREME {
            timeBetweenLines -= 0.04
            scene?.physicsWorld.gravity.dy -= 1.2
            groupWaitTimeMax -= 0.2
            groupWaitTimeMin -= 0.2
            groupAmtMin = (groupAmtMin*2 - 1)
            groupAmtMax = (groupAmtMin*2 - 1)
            GS.DiffLevel++
        }
        else {
            groupAmtMin = (groupAmtMin*2 - 1)
            groupAmtMax = (groupAmtMin*2 - 1)
        }
        
        switch GS.DiffLevel {
        case V_EASY: eggPercentage = 100
            break
        case EASY: eggPercentage = 70
            break
        case MED: eggPercentage = 70
            break
        case HARD: eggPercentage = 75
            break
        case V_HARD: eggPercentage = 90
            break
        default: eggPercentage = 90
            break
        }
        
        println("Diff Changed to \(GS.DiffLevel)")
        changeDiff = false
    }
    
    //Update Difficulty for Endless
    func updateDifficulty() {
        var repeat: Int?
        switch GS.DiffLevel {
        case V_EASY:
            repeat = 10
            break
        case EASY:
            repeat = 10
            break
        case MED:
            repeat = 10
            break
        case HARD:
            repeat = 7
            break
        case V_HARD:
            repeat = 5
            break
        default:
            repeat = 1
        }
        
        println("repeat = \(repeat)")
        if checkDiffCalls >= repeat {
            checkDiffCalls = 1
            changeDiff = true
        }
        else {
            checkDiffCalls++
        }
    }
    
    /******************************************************************************
    * DROP NEW GROUP
    * Function drops new group, calls:
    * dropRandomLine: gets random line and drops
    * then groups a determined amount of these into one action
    *******************************************************************************/
    func dropNewGroup() {
        //if true, drop a new group of lines
        switch GS.GameMode {
        case .Endless:
            updateDifficulty()
            break
        case .Classic:
            updateGroupAmount()
            break
        }
        
        let linesToDrop: Int?
        let waitBeforeGroup: NSTimeInterval?
        if totalLinesDropped == 0 {
            linesToDrop = 1
            waitBeforeGroup = 0.0
        }
        else {
            linesToDrop = randomInt(groupAmtMin, groupAmtMax)
            waitBeforeGroup = NSTimeInterval(CGFloat.random(min: groupWaitTimeMin, max: groupWaitTimeMax))
        }
        
        let groupSequence = SKAction.sequence([SKAction.runBlock({self.dropRandomLine()}), SKAction.waitForDuration(timeBetweenLines)])
        let groupAction = SKAction.repeatAction(groupSequence, count: linesToDrop!)
        let finalAction = SKAction.sequence([SKAction.waitForDuration(waitBeforeGroup!), groupAction])
        
        //save variables to check when you can drop another group
        currLinesToDrop = linesToDrop!
        lineCountBeforeDrops = totalLinesDropped
        totalGroupsDropped++
        
        //println("Droping group size: \(linesToDrop), waitBeforeGroup: \(waitBeforeGroup)")
        runAction(finalAction)
    }
    
    /*********************** Drop Group Helper Functions ******************************/
    
    /*
    * Drops random line chosen from pickRandomLine() by making
    * three simultaneous calls to spawnDroplet
    */
    func dropRandomLine() {
        if(dropLines) {
            let chosenLine = pickRandomLine()
        
            let dropLeft = SKAction.runBlock({self.spawnDroplet(1, type: chosenLine[0])})
            let dropMiddle = SKAction.runBlock({self.spawnDroplet(2, type: chosenLine[1])})
            let dropRight = SKAction.runBlock({self.spawnDroplet(3, type: chosenLine[2])})
        
            let dropLine = SKAction.group([dropLeft, dropMiddle, dropRight])
            runAction(dropLine)
            //runAction(dropLineSound) whistle down
        
            totalLinesDropped++;
        }
    }
    
    /*
    * Fetches all possible lines based on diffLevel and
    * uses eggPercentage algorithm to return one of them
    */
    var lastIndexPicked: Int = 0
    func pickRandomLine() -> [Int] {
        let percentage: Int = randomInt(1, 100)
        let linesForDifficulty: [[Int]]
        if percentage <= eggPercentage { linesForDifficulty = difficultyArraysG[GS.DiffLevel] }
        else { linesForDifficulty = difficultyArraysB[GS.DiffLevel] }
        
        var randomIndex: Int = Int(arc4random_uniform(UInt32(linesForDifficulty.endIndex)))
        
        if GS.DiffLevel > EASY {
            if randomIndex == lastIndexPicked {
                if randomIndex == 0 { randomIndex++ }
                else { randomIndex-- }
            }
        }
        lastIndexPicked = randomIndex
        return linesForDifficulty[randomIndex]
    }
    
    /*
    * Adds child with physics body of individual droplet
    * to the top of the screen
    */
    
    func spawnDroplet(col: Int, type: Int) {
        var droplet: SKSpriteNode!
        var somethingDropped = true
        switch type {
        case JOEY:
            droplet = SKSpriteNode(imageNamed: "Egg")
            droplet.name = "joey"
            droplet.setScale(0.1)
            break
        case BOOMERANG:
            droplet = SKSpriteNode(imageNamed: "Boomerang")
            droplet.name = "boomerang"
            droplet.setScale(0.2)
            break
        default:
            somethingDropped = false
        }
        
        if somethingDropped {
            droplet.zPosition = 3
            var dropletPosX: CGFloat = rightColX
            if(col == 1) {
                dropletPosX = leftColX
            }
            else if(col == 2) {
                dropletPosX = midColX
            }
            droplet.position = CGPoint(
                x: dropletPosX,
                y: GameSize!.height + droplet.size.height/2)
            
            if(type == JOEY) {
                //Joey animation here
                droplet.zRotation = -π / 8.0
                let leftWiggle = SKAction.rotateByAngle(π/4.0, duration: 0.25)
                let rightWiggle = leftWiggle.reversedAction()
                let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle, leftWiggle, rightWiggle])
                let scaleUp = SKAction.scaleBy(1.1, duration: 0.25)
                let scaleDown = scaleUp.reversedAction()
                let fullScale = SKAction.sequence(
                    [scaleUp, scaleDown, scaleUp, scaleDown])
                let group = SKAction.group([fullScale, fullWiggle])
                droplet.runAction(SKAction.repeatActionForever(group))
                if GS.GameMode == .Classic {
                    TheClassicHUD?.subtractJoeyCount()
                }
            }
            if(type == BOOMERANG) {
                let halfSpin = SKAction.rotateByAngle(π, duration: 0.5)
                let fullSpin = SKAction.sequence([halfSpin, halfSpin])
                droplet.runAction(SKAction.repeatActionForever(fullSpin))
            }
            
            droplet.physicsBody = SKPhysicsBody(circleOfRadius: droplet.size.width/2)
            addChild(droplet)
            
        }
    }
    
    /*********************************************************************************************************
    * CHECK COLLISIONS
    * Function for determining collisions between Kangaroo and droplets
    *********************************************************************************************************/
    func checkCollisions() {
        
        var caughtJoeys: [SKSpriteNode] = []
        var missedJoeys: [SKSpriteNode] = []
        enumerateChildNodesWithName("joey") { node, _ in
            let joey = node as! SKSpriteNode
            if (Int(joey.position.x) == Int(kangPosX)) {
                if CGRectIntersectsRect(CGRectInset(joey.frame, 5, 5), self.catchZoneRect) {
                    caughtJoeys.append(joey)
                    joey.name = "caught"
                }
                else if joey.position.y < dropletCatchBoundaryY {
                    missedJoeys.append(joey)
                    joey.name = "missedJoey"
                }
            }
            else {
                if joey.position.y < dropletCatchBoundaryY {
                    missedJoeys.append(joey)
                    joey.name = "missedJoey"
                }
            }
        }
        for joey in caughtJoeys {
            kangarooCaughtJoey(joey)
        }
        for joey in missedJoeys {
            kangarooMissedJoey(joey)
        }
        
        var fadeJoeys: [SKSpriteNode] = []
        enumerateChildNodesWithName("missedJoey") { node, _ in
            let joey = node as! SKSpriteNode
            if CGRectIntersectsRect(CGRectInset(joey.frame, 5, 5), self.fadeZoneRect) {
                fadeJoeys.append(joey)
                joey.name = "faded"
            }
        }
        for joey in fadeJoeys {
            stopAndFadeJoey(joey)
        }
        
        var caughtBoomers: [SKSpriteNode] = []
        var missedBoomers: [SKSpriteNode] = []
        enumerateChildNodesWithName("boomerang") { node, _ in
            let boomer = node as! SKSpriteNode
            if (Int(boomer.position.x) == Int(kangPosX)) {
                if CGRectIntersectsRect(CGRectInset(boomer.frame, 5, 5), self.catchZoneRect) {
                    caughtBoomers.append(boomer)
                    boomer.name = "caught"
                }
                else if boomer.position.y < dropletCatchBoundaryY {
                    missedBoomers.append(boomer)
                    boomer.name = "missedBoomer"
                }
            }
            else {
                if boomer.position.y < dropletCatchBoundaryY {
                    missedBoomers.append(boomer)
                    boomer.name = "missedBoomer"
                }
            }
        }
        for boomer in caughtBoomers {
            kangarooCaughtBoomer(boomer)
        }
        for boomer in missedBoomers {
            kangarooMissedBoomer(boomer)
        }
        
    }
    
    //Can use pouch idea where joey falls behind pouch and detection is near entrance
    func kangarooCaughtJoey(joey: SKSpriteNode) {
        //runAction(caughtJoeySound)
        //println("joeyCaught")
        
        let jumpUp = SKAction.moveByX(0.0, y: 10.0, duration: 0.1)
        let jumpDown = jumpUp.reversedAction()
        let catch = SKAction.sequence([jumpUp, jumpDown])
        TheKangaroo!.runAction(catch)
        
        joey.removeAllActions()
        joey.runAction(SKAction.removeFromParent())
        
        GS.CurrScore++
        scoreChange = true
        
    }
    
    func kangarooMissedJoey(joey: SKSpriteNode) {
        //runAction(missedJoeySound) aaahh
        
        //make fade rect like catchzone, in checkcollision if missed hits fadezone, then stop and fade
        let fade = SKAction.fadeAlphaTo(0.3, duration: 0.1)
        joey.runAction(fade)
        
    }
    
    func stopAndFadeJoey(joey: SKSpriteNode) {
        joey.removeFromParent()
        joey.removeAllActions()
        joey.physicsBody = nil
        joey.zRotation = 0
        joey.alpha = 0.3
        joey.position.y = dropletFadeBoundaryY
        //change joey to have frown?
        addChild(joey)
        
        if GS.GameMode == .Endless {
            TheEndlessHUD?.removeLife("drop\(GS.CurrJoeyLives)")
            GS.CurrJoeyLives--
    
            if(GS.CurrJoeyLives == 0) {
                GS.GameState = .GameOver
            }
        }
        
    }
    
    func kangarooCaughtBoomer(boomer: SKSpriteNode) {
        
        //runAction(enemyCollisionSound) ouch!
        // make kangaroo frown
        
        let shakeLeft = SKAction.moveByX(-10.0, y: 0.0, duration: 0.05)
        let shakeRight = SKAction.moveByX(20.0, y: 0.0, duration: 0.1)
        let shakeOff = SKAction.sequence([shakeLeft, shakeRight, shakeLeft])
        //turn shake off into screen shake
        TheKangaroo!.runAction(shakeOff)
        println("shake")
        
        boomer.removeAllActions()
        boomer.runAction(SKAction.removeFromParent())
        
        if GS.GameMode == .Endless {
            println("life\(GS.CurrBoomerangLives)")
            TheEndlessHUD?.removeLife("life\(GS.CurrBoomerangLives)")
            GS.CurrBoomerangLives--
            
            if(GS.CurrBoomerangLives == 0) {
                GS.GameState = .GameOver
            }
        }
        
    }
    
    func kangarooMissedBoomer(boomer: SKSpriteNode) {
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.18)
        let remove = SKAction.removeFromParent()
        boomer.runAction(SKAction.sequence([fade, remove]))
        
    }
    
    internal func freezeDroplets() {
        removeAllActions()
        enumerateChildNodesWithName("*") { node, _ in
            if node.name == "joey" || node.name == "missedJoey" ||
                node.name == "boomerang" || node.name == "missedBoomer" {
                    println("node found")
                    let node = node as! SKSpriteNode
                    node.removeAllActions()
                    node.physicsBody = nil
            }
        }
    }
    
    internal func unfreezeDroplets() {
        enumerateChildNodesWithName("*") { node, _ in
            if node.name == "joey" || node.name == "missedJoey" {
                let node = node as! SKSpriteNode
                node.zRotation = -π / 8.0
                let leftWiggle = SKAction.rotateByAngle(π/4.0, duration: 0.25)
                let rightWiggle = leftWiggle.reversedAction()
                let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle, leftWiggle, rightWiggle])
                let scaleUp = SKAction.scaleBy(1.1, duration: 0.25)
                let scaleDown = scaleUp.reversedAction()
                let fullScale = SKAction.sequence(
                    [scaleUp, scaleDown, scaleUp, scaleDown])
                let group = SKAction.group([fullScale, fullWiggle])
                node.runAction(SKAction.repeatActionForever(group))
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
            }
            if node.name == "boomerang" || node.name == "missedBoomer" {
                let node = node as! SKSpriteNode
                let halfSpin = SKAction.rotateByAngle(π, duration: 0.5)
                let fullSpin = SKAction.sequence([halfSpin, halfSpin])
                node.runAction(SKAction.repeatActionForever(fullSpin))
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
            }
        }
    }



}
