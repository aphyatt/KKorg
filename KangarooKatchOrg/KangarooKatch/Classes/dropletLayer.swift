//
//  dropletLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var dropletRect: CGRect = CGRectNull
var catchZoneRect: CGRect = CGRectNull
var fadeZoneRect: CGRect = CGRectNull

class dropletLayer: SKNode {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        self.name = "droplets"
        self.zPosition = 50
        
        let size = TheGameScene?.size
        
        dropletRect = CGRect(x: playableMargin, y: dropletCatchBoundaryY,
            width: playableWidth,
            height: size!.height - dropletCatchBoundaryY)
        catchZoneRect = CGRect(x: playableMargin, y: dropletCatchBoundaryY - 5,
            width: playableWidth,
            height: 10)
        fadeZoneRect = CGRect(x: playableMargin, y: dropletFadeBoundaryY - 5,
            width: playableWidth,
            height: 10)
        
        
        
    }
}
