//
//  CGGame.swift
//  CGSoloSet
//
//  Created by Thanyani on 2020/08/27.
//  Copyright © 2020 Thanyani. All rights reserved.
//

import Foundation


typealias CGDeck = [CGCard]
typealias CGTrio = [CGCard]


class CGGame {

  private(set) var deck = CGDeck()
  
 
  private(set) var matchedDeck = [CGTrio]()
 
  private(set) var tableCards = [CGCard]()
  

  private(set) var selectedCards = [CGCard]()
  
 
  private(set) var matchedCards = [CGCard]() {
    didSet {
      if matchedCards.count == 3 {
        matchedDeck.append(matchedCards)
      }
    }
  }

  private(set) var score = 0 {
    didSet {
      if score < 0 {
        score = 0
      }
    }
  }
  

  
  init() {
    deck = makeDeck()
  }
  
 
  func selectCard(at index: Int) {
    let card = tableCards[index]
    
    guard !matchedCards.contains(card) else { return }
   

    if matchedCards.count > 0 {
      replaceMatchedCards()
    }
    
   
    if selectedCards.count == 3 {
   
      guard !selectedCards.contains(card) else { return }
      
      score -= 2
      selectedCards = []
    }
    
    
    if let index = selectedCards.firstIndex(of: card) {
      selectedCards.remove(at: index)
    } else {
      selectedCards.append(card)
    }
 
    if selectedCards.count == 3, currentSelectionMatches() {
      matchedCards = selectedCards
      selectedCards = []
      score += 4
    }
  }
  

  func replaceMatchedCards() {
    guard matchedCards.count == 3 else { return }
    dealCards()
    matchedCards = []
  }
  

  private func currentSelectionMatches() -> Bool {
    guard selectedCards.count == 3 else { return false }
    return matches(selectedCards)
  }

  private func matches(_ cards: CGTrio) -> Bool {
    let first = cards[0]
    let second = cards[1]
    let third = cards[2]
    
   
    let numbersFeatures = Set([first.sequence.number, second.sequence.number, third.sequence.number])
    let colorsFeatures = Set([first.sequence.color, second.sequence.color, third.sequence.color])
    let symbolsFeatures = Set([first.sequence.symbol, second.sequence.symbol, third.sequence.symbol])
    let shadingsFeatures = Set([first.sequence.shading, second.sequence.shading, third.sequence.shading])
    
 
    return (numbersFeatures.count == 1 || numbersFeatures.count == 3) &&
           (colorsFeatures.count == 1 || colorsFeatures.count == 3) &&
           (symbolsFeatures.count == 1 || symbolsFeatures.count == 3) &&
           (shadingsFeatures.count == 1 || shadingsFeatures.count == 3)
  }
  

  func dealCards(forAmount amount: Int = 3) {
    guard amount > 0 else { return }
    guard deck.count >= amount else {
      
      for card in matchedCards {
        let index = tableCards.firstIndex(of: card)!
        tableCards.remove(at: index)
      }
      
      return
    }
    
    var cardsToDeal = [CGCard]()
    
    for _ in 0..<amount {
      cardsToDeal.append(deck.removeFirst())
    }
    
    for (index, card) in tableCards.enumerated() {
      if matchedCards.contains(card) {
        tableCards[index] = cardsToDeal.removeFirst()
      }
    }
    
    if !cardsToDeal.isEmpty {
      tableCards += cardsToDeal
    }
  }

  func shuffleTableCards() {
    tableCards = tableCards.shuffled()
  }
  
  /// Finishes the current running game and starts a fresh new one.
  func reset() {
    deck = makeDeck()
    matchedCards = []
    selectedCards = []
    matchedDeck = []
    tableCards = []
    score = 0
  }

  private func makeDeck(features: [Attribute] = Number.values,
                        currentCombination: AttributeSequence = AttributeSequence(),
                        deck: CGDeck = CGDeck()) -> CGDeck {
    var deck = deck
    var currentCombination = currentCombination

    let nextFeatures = type(of: features[0]).getNextAttribute()
    
    for feature in features {
      currentCombination.add(feature: feature)
      
      if let nextFeatures = nextFeatures {
     
        deck = makeDeck(features: nextFeatures, currentCombination: currentCombination, deck: deck)
      } else {
      
        deck.append(CGCard(sequence: currentCombination))
      }
    }
    
    return deck.shuffled()
  }
}

import GameKit

extension Array {
  func shuffled() -> [Element] {
    return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self) as! [Element]
  }
}
