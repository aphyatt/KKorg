//
//  GameStatus.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit
var GS = GameStatus()

class GameStatus {
    //endless
    let MaxJoeyLives = 10
    let MaxBoomerangLives = 3
    var CurrJoeyLives = 10
    var CurrBoomerangLives = 3
    
    //classic
    var JoeysLeft = 100
    
    var CurrScore = 0
    var HiScore = 0
    var DiffLevel = 0
    
    var GameControls: ControlType = .Thumb
    var GameMode: GameModeType = .Classic
    var GameState: GameStateType = .GameRunning
    
    //Droplet Status
    var timeBetweenLines: NSTimeInterval = 0.5
    var totalGroupsDropped: Int = 0
    var totalLinesDropped: Int = 0
    var currLinesToDrop: Int = 0
    var lineCountBeforeDrops: Int = 0
    var eggPercentage: Int = 100
    var groupWaitTimeMin: CGFloat = 2.0
    var groupWaitTimeMax: CGFloat = 3.0
    var groupAmtMin: Int = 2
    var groupAmtMax: Int = 3
    
}
