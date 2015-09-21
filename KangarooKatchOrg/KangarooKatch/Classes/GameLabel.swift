//
//  GameLabel.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class GameLabel: SKLabelNode {
    
    let font: String = "Soup of Justice"
    let label: SKLabelNode
    let labelS: SKLabelNode
    var m_Text: String?
    var m_zPosition: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, size: CGFloat,
        horAlignMode: SKLabelHorizontalAlignmentMode, vertAlignMode: SKLabelVerticalAlignmentMode,
        color: UIColor, shadowColor: UIColor, pos: CGPoint, zPosition: CGFloat) {
            
            m_Text = text
            m_zPosition = zPosition
            
            label = SKLabelNode(fontNamed: font)
            label.text = m_Text!
            label.fontSize = size
            label.horizontalAlignmentMode = horAlignMode
            label.verticalAlignmentMode = vertAlignMode
            label.fontColor = color
            label.position = pos
            label.zPosition = zPosition + 1
            
            labelS = SKLabelNode(fontNamed: font)
            labelS.text = m_Text!
            labelS.fontSize = size
            labelS.horizontalAlignmentMode = horAlignMode
            labelS.verticalAlignmentMode = vertAlignMode
            labelS.fontColor = shadowColor
            labelS.position = CGPoint(x: pos.x+2, y: pos.y-2)
            labelS.zPosition = zPosition
            
            super.init()
            
            addChild(label)
            addChild(labelS)
    }
    
    override var text: String {
        get { return m_Text! }
        set {
            m_Text = newValue
            label.text = m_Text!
            labelS.text = m_Text!
        }
    }
    
    override var zPosition: CGFloat {
        get { return m_zPosition! }
        set {
            m_zPosition = newValue
            label.zPosition = m_zPosition! + 1
            labelS.zPosition = m_zPosition!
        }
    }
    
    func changePositionX(posX: CGFloat) {
        var adjustX: CGFloat = 0
        if GS.CurrScore >= 10 { adjustX = 10 }
        if GS.CurrScore >= 100 { adjustX = 20 }
        
        label.position.x = posX - adjustX
        labelS.position.x = posX + 2 - adjustX
    }
    
    override func runAction(action: SKAction!) {
        label.runAction(action)
        labelS.runAction(action)
    }
    
}
