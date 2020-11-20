//
//  CGCard.swift
//  CGSoloSet
//
//  Created by Thanyani on 2020/08/27.
//  Copyright © 2020 Thanyani. All rights reserved.
//

import Foundation


struct CGCard {
  

  private(set) var sequence: AttributeSequence
  
  init(sequence: AttributeSequence) {
    self.sequence = sequence
  }
}

extension CGCard: Hashable {
  

  var hashValue: Int {
    return Int("\(sequence.number.rawValue)\(sequence.color.rawValue)\(sequence.symbol.rawValue)\(sequence.shading.rawValue)")!
  }
  

  static func ==(lhs: CGCard, rhs: CGCard) -> Bool {
    return lhs.sequence == rhs.sequence
  }
}


struct AttributeSequence {
  

  var number: Number = .none

  var color: Color = .none
 
  var symbol: Symbol = .none

  var shading: Shading = .none

  mutating func add(feature: Attribute) {
    if feature is Number {
      
      number = feature as! Number
      
    } else if feature is Color {
      
      color = feature as! Color
      
    } else if feature is Symbol {
      
      symbol = feature as! Symbol
      
    } else if feature is Shading {
      
      shading = feature as! Shading
    }
  }
}

extension AttributeSequence: Equatable {

  static func ==(lhs: AttributeSequence, rhs: AttributeSequence) -> Bool {
    return lhs.number == rhs.number &&
      lhs.color == rhs.color &&
      lhs.symbol == rhs.symbol &&
      lhs.shading == rhs.shading
  }
}

protocol Attribute {

  static var values: [Attribute] { get }

  static func getNextAttribute() -> [Attribute]?
}

enum Number: Int, Attribute {
  case one
  case two
  case three
  case none
  
  static var values: [Attribute] {
    return [Number.one, Number.two, Number.three]
  }
  
  static func getNextAttribute() -> [Attribute]? {
    return Color.values
  }
}

enum Color: Int, Attribute {
  case red
  case green
  case purple
  case none
  
  static var values: [Attribute] {
    return [Color.red, Color.green, Color.purple]
  }
  
  static func getNextAttribute() -> [Attribute]? {
    return Symbol.values
  }
}


enum Symbol: Int, Attribute {
  case squiggle
  case diamond
  case oval
  case none
  
  static var values: [Attribute] {
    return [Symbol.squiggle, Symbol.diamond, Symbol.oval]
  }
  
  static func getNextAttribute() -> [Attribute]? {
    return Shading.values
  }
}


enum Shading: Int, Attribute {
  case solid
  case striped
  case outlined
  case none
  
  static var values: [Attribute] {
    return [Shading.solid, Shading.striped, Shading.outlined]
  }
  
  static func getNextAttribute() -> [Attribute]? {
    return nil
  }
}
