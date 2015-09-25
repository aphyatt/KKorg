//
//  GameScene.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 7/8/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

weak var TheGameScene: GameScene?
var GameSize: CGSize?

var numFingers: Int = 0
var playableMargin: CGFloat = 0
var playableWidth: CGFloat = 0

let leftColX: CGFloat = 219.43
let midColX: CGFloat = 384.0
let rightColX: CGFloat = 548.57
let oneThirdX: CGFloat = 288.0
let twoThirdX: CGFloat = 480.0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let fullRect: CGRect
    let sceneRect: CGRect
    let worldRect: CGRect
    let hudRect: CGRect
    
    var GameWorld: World?
    var HUDdisplay: HUD?
    var Drops: DropletLayer?
    var GameOver: GameOverLayer?
    
    /************************************ Init/Update Functions ***************************************/
    
    override func didMoveToView(view: SKView) {
        TheGameScene = self
        GameSize = TheGameScene?.size
        super.didMoveToView(view)
        
        CreateWorld()
        CreateHUD()
        CreateDropletLayer()
        CreateGameOver()
        
        debugDrawPlayableArea()
    }
    
    func restart() {
        removeAllActions()
        removeAllChildren()
        CreateWorld()
        CreateHUD()
        CreateDropletLayer()
        CreateGameOver()
    }
    
    private func CreateWorld() {
        GameWorld = World()
        if let world = GameWorld {
            self.addChild(world)
        }
    }
    
    private func CreateHUD() {
        HUDdisplay = HUD()
        if let hud = HUDdisplay {
            self.addChild(hud)
        }
    }
    
    private func CreateDropletLayer() {
        Drops = DropletLayer()
        if let dl = Drops {
            self.addChild(dl)
        }
    }
    
    private func CreateGameOver() {
        GameOver = GameOverLayer()
        if let go = GameOver {
            self.addChild(go)
        }
    }
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        playableWidth = size.height / maxAspectRatio
        playableMargin = (size.width-playableWidth)/2.0
        fullRect = CGRect(x: 0, y: 0,
            width: size.width,
            height: size.height)
        worldRect = CGRect(x: 0, y: 0,
            width: size.width,
            height: size.height - HUDheight)
        hudRect = CGRect(x: 0, y: size.height - HUDheight,
            width: size.width,
            height: HUDheight)
        sceneRect = CGRect(x: playableMargin, y: 0,
            width: playableWidth,
            height: size.height)
  
        GS.GameState = .GameRunning
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*********************************************************************************************************
    * UPDATE
    * Function is called incredibly frequently, main game loop is here
    *********************************************************************************************************/
    override func update(currentTime: CFTimeInterval) {
    
        switch GS.GameState {
        case .GameRunning:
            GameWorld!.update(currentTime)
            HUDdisplay!.update(currentTime)
            Drops!.update(currentTime)
            break
        case .Paused:
            dropLines = false
            HUDdisplay!.update(currentTime)
            break
        case .GameOver:
            dropLines = false
            GameOver!.update(currentTime)
            break
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        numFingers += touches.count
        
        switch GS.GameState {
        case .GameRunning:
            if worldRect.contains(touchLocation) {
                GameWorld!.sceneTouched(touchLocation)
            }
            if hudRect.contains(touchLocation) {
                HUDdisplay!.sceneTouched(touchLocation)
            }
            break
        case .Paused:
            HUDdisplay!.sceneTouched(touchLocation)
            break
        case .GameOver:
            GameOver!.sceneTouched(touchLocation)
            break
        }
       
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        if GS.GameControls == .Thumb {
            GameWorld!.trackThumb(touchLocation)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        numFingers -= touches.count
        
        switch GS.GameState {
        case .GameRunning:
            if worldRect.contains(touchLocation) {
                GameWorld!.sceneUntouched(touchLocation)
            }
            if hudRect.contains(touchLocation) {
                HUDdisplay!.sceneUntouched(touchLocation)
            }
            break
        case .Paused:
            HUDdisplay!.sceneUntouched(touchLocation)
            break
        case .GameOver:
            GameOver!.sceneUntouched(touchLocation)
            break
        }
    }
    
    override func didEvaluateActions()  {
        Drops!.checkCollisions()
    }
    
    
    /****************************** Other Functions ***********************************/
    
    func debugDrawPlayableArea() {
        
        //let sceneArea = drawRectangle(sceneRect, SKColor.redColor(), 4.0)
        //addChild(sceneArea)
        
        //let dropletArea = drawRectangle(dropletRect, SKColor.yellowColor(), 6.0)
        //addChild(dropletArea)
        
        //let leftSide = drawRectangle(leftRect, SKColor.greenColor(), 10.0)
        //addChild(leftSide)
        
        //let rightSide = drawRectangle(rightRect, SKColor.redColor(), 10.0)
        //addChild(rightSide)
        
        /*
        let catchZone = drawRectangle(catchZoneRect, SKColor.blueColor(), 6.0)
        catchZone.zPosition = 2
        addChild(catchZone)
        
        let fadeZone = drawRectangle(fadeZoneRect, SKColor.whiteColor(), 6.0)
        fadeZone.zPosition = 2
        addChild(fadeZone)
        
        let testRect = CGRect(x: 300, y: 300, width: 300, height: 300)
        let test = getRoundedRectShape(rect: testRect, cornerRadius: 16, color: SKColor.blackColor(), lineWidth: 5)
        test.zPosition = 10
        addChild(test)
        
        let worldOutline = drawRectangle(worldRect, SKColor.greenColor(), 20.0)
        worldOutline.zPosition = 500
        addChild(worldOutline)
        
        let hudOutline = drawRectangle(hudRect, SKColor.blueColor(), 20.0)
        hudOutline.zPosition = 500
        addChild(hudOutline)
            */
        let pauseRect = drawRectangle(CGRect(x: 585, y: GameSize!.height - 80, width: 60, height: 60), SKColor.blackColor(), 6.0)
        pauseRect.zPosition = 3
        addChild(pauseRect)
        
    }
    
}
