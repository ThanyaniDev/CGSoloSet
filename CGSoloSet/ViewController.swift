//
//  ViewController.swift
//  CGSoloSet
//
//  Created by Thanyani on 2020/08/18.
//  Copyright © 2020 Thanyani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private var cgGame = CGGame()
  

  

  @IBOutlet weak var dealMoreButton: UIButton!

  @IBOutlet weak var CGCardViews: CGCardViews!
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    cgGame.dealCards(forAmount: 12)
    CGCardViews.addCardButtons(byAmount: 12)
    assignTargetAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    displayCards()
  }
  

  
  private func assignTargetAction() {
    for button in CGCardViews!.buttons {
      button.addTarget(self, action: #selector(didTapCard(_:)), for: .touchUpInside)
    }
  }

  private func displayCards() {
    if CGCardViews!.buttons.count > cgGame.tableCards.count {
        CGCardViews!.removeCardButtons(byAmount: (CGCardViews?.buttons.count)! - cgGame.tableCards.count)
    }
    
    for (index, cardButton) in CGCardViews!.buttons.enumerated() {
      let currentCard = cgGame.tableCards[index]

      switch currentCard.sequence.color {
      case .green:
        cardButton.color = .green
      case .purple:
        cardButton.color = .purple
      case .red:
        cardButton.color = .red
      default:
        break
      }
   
      switch currentCard.sequence.number {
      case .one:
        cardButton.numberOfSymbols = 1
      case .two:
        cardButton.numberOfSymbols = 2
      case .three:
        cardButton.numberOfSymbols = 3
      default:
        break
      }
 
      switch currentCard.sequence.symbol {
      case .diamond:
        cardButton.symbolShape = .diamond
      case .squiggle:
        cardButton.symbolShape = .squiggle
      case .oval:
        cardButton.symbolShape = .oval
      default:
        break
      }
      
      // Shading feature:
      switch currentCard.sequence.shading {
      case .outlined:
        cardButton.symbolShading = .outlined
      case .solid:
        cardButton.symbolShading = .solid
      case .striped:
        cardButton.symbolShading = .striped
      default:
        break
      }

      if cgGame.selectedCards.contains(currentCard) ||
         cgGame.matchedCards.contains(currentCard) {
        cardButton.layer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
      } else {
        cardButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.849352542)
      }

    }
    
    handleDealMoreButton()
  }

  private func handleDealMoreButton() {
    dealMoreButton.isEnabled = cgGame.deck.count > 3
  }


  @objc func didTapCard(_ sender: UIButton) {
    let index = CGCardViews!.buttons.firstIndex(of: sender as! CGCardButton)!
    cgGame.selectCard(at: index)
    displayCards()
  }
  

  @IBAction func didTapDealMore(_ sender: UIButton) {
    if cgGame.matchedCards.count > 0 {
      cgGame.replaceMatchedCards()
    }
    
    cgGame.dealCards()
    CGCardViews!.addCardButtons()
    assignTargetAction()
    displayCards()
  }
  
  /// Restarts the current game.
  @IBAction func didTapNewGame(_ sender: UIButton) {
    cgGame.reset()
    cgGame.dealCards(forAmount: 12)
    CGCardViews!.clearCardContainer()
    CGCardViews!.addCardButtons(byAmount: 12)
    assignTargetAction()
    displayCards()
  }
}
