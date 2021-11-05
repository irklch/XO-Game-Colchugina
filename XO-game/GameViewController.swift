//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    private var gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        self.gameboardView.onSelectPosition = { [unowned self] position in
            self.currentState.addMark(at: position)
            
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        self.gameboard.clear()
        self.gameboardView.clear()
        self.goToFirstState()
        
        recordEvent(.restartGame)
    }
    
    // MARK: - State Machine
    
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(
            player: player,
            markPrototype: player.markViewPrototype,
            gameViewController: self,
            gameboard: self.gameboard,
            gameboardView: self.gameboardView
        )
    }
    
    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
            self.currentState = WinnerState(winnerPlayer: winner, gameViewController: self)
            
            return
        }
        
        if let playerInputState = self.currentState as? PlayerInputState {
            let nextPlayer = playerInputState.player.next
            self.currentState = PlayerInputState(
                player: nextPlayer,
                markPrototype: nextPlayer.markViewPrototype,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView
            )
        }
    }
}

