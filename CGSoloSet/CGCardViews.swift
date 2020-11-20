//
//  CGCardViews.swift
//  CGSoloSet
//
//  Created by Thanyani on 2020/08/27.
//  Copyright © 2020 Thanyani. All rights reserved.
//

import UIKit


class CGCardViews: UIView {
    
    
    private(set) var buttons = [CGCardButton]()
    
 
    private(set) var grid = CGBoard(layout: CGBoard.Layout.aspectRatio(3/2))
   
    private var centeredRect: CGRect {
        get {
            return CGRect(x: bounds.size.width * 0.025,
                          y: bounds.size.height * 0.025,
                          width: bounds.size.width * 0.95,
                          height: bounds.size.height * 0.95)
        }
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        
        for (i, button) in buttons.enumerated() {
            if let frame = grid[i] {
                button.frame = frame
                button.layer.cornerRadius = 10
                button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                button.layer.borderWidth = 0.5
            }
        }
    }
   
    func addCardButtons(byAmount numberOfButtons: Int = 3) {
        let cardButtons = (0..<numberOfButtons).map { _ in CGCardButton() }
        
        for button in cardButtons {
            addSubview(button)
        }
        
        buttons += cardButtons
        
        grid.cellCount = buttons.count
        
        setNeedsLayout()
    }
   
    func removeCardButtons(byAmount numberOfCards: Int) {
        guard buttons.count >= numberOfCards else { return }
        
        for index in 0..<numberOfCards {
            let button = buttons[index]
            button.removeFromSuperview()
        }
        
        buttons.removeSubrange(0..<numberOfCards)
        grid.cellCount = buttons.count
        
        setNeedsLayout()
    }

    func clearCardContainer() {
        buttons = []
        grid.cellCount = 0
        removeAllSubviews()
        setNeedsLayout()
    }
    
}

extension UIView {
    

    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
}
