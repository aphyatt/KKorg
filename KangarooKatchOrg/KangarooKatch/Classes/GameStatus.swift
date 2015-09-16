//
//  GameStatus.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

var TheGameStatus = GameStatus()

class GameStatus {
    //endless
    let MaxJoeyLives = 10
    let MaxBoomerangLives = 3
    var CurrJoeyLives = 10
    var CurrBoomerangeLives = 3
    
    //classic
    var JoeysLeft = 100
    
    var CurrScore = 0
    var HiScore = 0
    
    var CurrGameControls: Control = .Thumb
    var CurrGameMode: GameMode = .Classic
    
}
