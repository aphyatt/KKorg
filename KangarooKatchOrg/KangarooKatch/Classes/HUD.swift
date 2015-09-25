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

var TheHUD: HUD?

class HUD: SKNode {
    
    var classicHUD: ClassicHUD?
    var endlessHUD: EndlessHUD?
    var pauseButton: SKSpriteNode?
    var pauseButtonS: SKSpriteNode?
    var pauseLabel: GameLabel?
    var mainMenuLabel: GameLabel?
    var unpauseGame: Bool = false
    var pauseMenuArray: [SKNode]
    let fullRect: CGRect
    let pauseRect: CGRect
    let pauseX: CGFloat = 585
    let pauseY: CGFloat = GameSize!.height - 80
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        pauseRect = CGRect(x: pauseX, y: pauseY, width: 60, height: 60)
        
        pauseMenuArray = []
        
        super.init()
        
        TheHUD = self
        
        self.name = "HUD"
        self.zPosition = 100
        
        CreatePauseButton()
        
        if GS.GameMode == .Classic {
            CreateClassicHUD()
        }
        if GS.GameMode == .Endless {
            CreateEndlessHUD()
        }
        
    }
    
    func update(currentTime: CFTimeInterval) {
        if GS.GameState == .Paused {
            pauseGame()
        }
    }
    
    private func CreatePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "PauseButtonWhite")
        pauseButtonS = SKSpriteNode(imageNamed: "PauseButtonGray")
        if let pb = pauseButton {
            pb.position = CGPoint(x: pauseX+30, y: pauseY+30)
            pb.setScale(1.5)
            pb.zPosition = 301
            pb.setScale(0.45)
            pb.color = SKColor.whiteColor()
            addChild(pb)
        }
        if let pbS = pauseButtonS {
            pbS.position = CGPoint(x: pauseX+32, y: pauseY+28)
            pbS.setScale(1.5)
            pbS.zPosition = 300
            pbS.setScale(0.45)
            pbS.color = SKColor.grayColor()
            addChild(pbS)
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
    
    private func CreatePauseLabel() {
        pauseLabel = GameLabel(text: "GAME PAUSED", size: 50,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 780), zPosition: 300)
        if let p = pauseLabel {
            self.addChild(p)
        }
    }
    
    private func CreateMMLabel() {
        mainMenuLabel = GameLabel(text: "MAIN MENU", size: 20,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: oneThirdX, y: 500), zPosition: 300)
        if let mm = mainMenuLabel {
            self.addChild(mm)
        }
    }
    
    let mmLabel = createShadowLabel(font: "Soup of Justice", text: "MAIN MENU",
        fontSize: 20,
        horAlignMode: horAlignModeDefault, vertAlignMode: .Baseline,
        labelColor: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
        name: "mainMenu",
        positon: CGPoint(x: oneThirdX, y: 500),
        shadowZPos: 8, shadowOffset: 2)
    
    func updateScore() {
        if GS.GameMode == .Endless {
            endlessHUD!.updateScore()
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        switch GS.GameState {
        case .GameRunning:
            if (pauseRect.contains(touchLocation)) {
                GS.GameState = .Paused
            }
            break
        case .Paused:
            unpauseGame = true
            break
        case .GameOver:
            break
        }
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }
    
    var pauseGameCalls: Int = 0
    func pauseGame() {
        pauseGameCalls++
        if(pauseGameCalls == 1) {
            TheDropletLayer!.freezeDroplets()
            showPauseMenu()
        }
        else {
            if unpauseGame {
                unpauseGame = false
                pauseGameCalls = 0
                removePauseMenu()
                //countdown / wait
                TheDropletLayer!.unfreezeDroplets()
                GS.lineCountBeforeDrops = GS.totalLinesDropped
                GS.currLinesToDrop = 0
                dropLines = true
                GS.GameState = .GameRunning
            }
        }
    }
    
    func removePauseMenu() {
        removeChildrenInArray(pauseMenuArray)
        mainMenuLabel?.removeFromParent()
        pauseLabel?.removeFromParent()
    }
    
    func showPauseMenu() {
        let shade = drawRectangle(fullRect, SKColor.grayColor(), 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = 6
        shade.name = "shade"
        addChild(shade)
        
        let mmRect = CGRect(x: oneThirdX-70, y: GameSize!.height/2-300,
            width: GameSize!.width-(2*(oneThirdX-70)), height: 600)
        let mainMenu = getRoundedRectShape(rect: mmRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        mainMenu.fillColor = SKColor.blackColor()
        mainMenu.zPosition = 7
        addChild(mainMenu)
        
        CreatePauseLabel()
        CreateMMLabel()
        
        pauseMenuArray = [shade, mainMenu]
    }
    
}
