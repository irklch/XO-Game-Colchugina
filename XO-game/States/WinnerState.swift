//
//  WinnerState.swift
//  XO-game
//
//  Created by v.prusakov on 11/4/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

class WinnerState: GameState {
    var isCompleted: Bool = false
    
    let winnerPlayer: Player?
    private weak var gameViewController: GameViewController?
    
    init(
        winnerPlayer: Player?,
        gameViewController: GameViewController?
    ) {
        self.winnerPlayer = winnerPlayer
        self.gameViewController = gameViewController
    }
    
    func begin() {
        self.gameViewController?.winnerLabel.isHidden = false
        
        recordEvent(.gameFinished(winner: self.winnerPlayer))
        
        if let winner = self.winnerPlayer {
            self.gameViewController?.winnerLabel.text = self.winnerName(winner) + " win"
        } else {
            self.gameViewController?.winnerLabel.text = "No winner"
        }
        
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) { }
    
    private func winnerName(_ winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2nd player"
        }
    }
}
