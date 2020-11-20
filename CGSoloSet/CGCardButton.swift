//
//  CGCardButton.swift
//  CGSoloSet
//
//  Created by Thanyani on 2020/08/27.
//  Copyright © 2020 Thanyani. All rights reserved.
//

import UIKit



class CGCardButton: UIButton {

  
  enum CardSymbolShape {
    case squiggle
    case diamond
    case oval
  }
  
  enum CardColor {
    case red
    case green
    case purple
    
 
    func get() -> UIColor {
      switch self {
      case .red:
        return #colorLiteral(red: 0.5819329619, green: 0.1857426763, blue: 0.1775132418, alpha: 1)
      case .green:
        return #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
      case .purple:
        return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
      }
    }

  }
  
  enum CardSymbolShading {
    case solid
    case striped
    case outlined
  }
  

  var symbolShape: CardSymbolShape? {
    didSet {
      setNeedsDisplay()
    }
  }

  var numberOfSymbols = 0 {
    didSet {
      setNeedsDisplay()
    }
  }

  var color: CardColor? {
    didSet {
      setNeedsDisplay()
    }
  }

  var symbolShading: CardSymbolShading? {
    didSet {
      setNeedsDisplay()
    }
  }

  var path: UIBezierPath?

  private var drawableRect: CGRect {
    let drawableWidth = frame.size.width * 0.80
    let drawableHeight = frame.size.height * 0.90
    
    return CGRect(x: frame.size.width * 0.1,
                  y: frame.size.height * 0.05,
                  width: drawableWidth,
                  height: drawableHeight)
  }
  
  private var shapeHorizontalMargin: CGFloat {
    return drawableRect.width * 0.05
  }
  
  private var shapeVerticalMargin: CGFloat {
    return drawableRect.height * 0.05 + drawableRect.origin.y
  }
  
  private var shapeWidth: CGFloat {
    return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3
  }
  
  private var shapeHeight: CGFloat {
    return drawableRect.size.height * 0.9
  }
  
  private var drawableCenter: CGPoint {
    return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
  }

  
  override func draw(_ rect: CGRect) {
    guard let shape = symbolShape else { return }
    guard let color = color?.get() else { return }
    guard let shading = symbolShading else { return }
    guard numberOfSymbols <= 3 || numberOfSymbols > 0 else { return }
    
    switch shape {
    case .squiggle:
      drawSquiggles(byAmount: numberOfSymbols)
      
    case .diamond:
      drawTriangle(byAmount: numberOfSymbols)
      
    case .oval:
      drawOvals(byAmount: numberOfSymbols)
    }
    
    path!.lineCapStyle = .round
    
    switch shading {
    case .solid:
      color.setFill()
      path!.fill()
      
    case .outlined:
      color.setStroke()
      path!.lineWidth = 1 // TODO: Calculate the line width
      path!.stroke()
      
    case .striped:
      path!.lineWidth = 0.01 * frame.size.width
      color.setStroke()
      path!.stroke()
      path!.addClip()
      
      var currentX: CGFloat = 0
      
      let stripedPath = UIBezierPath()
      stripedPath.lineWidth = 0.005 * frame.size.width
      
      while currentX < frame.size.width {
        stripedPath.move(to: CGPoint(x: currentX, y: 0))
        stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
        currentX += 0.03 * frame.size.width
      }
      
      color.setStroke()
      stripedPath.stroke()
      
      break
    }
  }

 
  private func drawSquiggles(byAmount amount: Int) {
    let path = UIBezierPath()
    let allSquigglesWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allSquigglesWidth) / 2
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
      let currentShapeY = shapeVerticalMargin
      let curveXOffset = shapeWidth * 0.35
      
      path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))

//      path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
//                    controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
//                    controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
      
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
      
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY))
                   
      
     path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
    }
    
    self.path = path
  }
  
 
  private func drawOvals(byAmount amount: Int) {
    let allOvalsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allOvalsWidth) / 2
    path = UIBezierPath()
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)

      path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX ,
                                                    y: shapeVerticalMargin,
                                                    width: shapeWidth,
                                                    height: shapeHeight),
                                cornerRadius: 0))
    }
  }
  
 
  private func drawTriangle(byAmount amount: Int) {
    let allDiamondsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allDiamondsWidth) / 2
    let path = UIBezierPath()
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
      
path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
      path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
    path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
    }
    
    self.path = path
  }

}
