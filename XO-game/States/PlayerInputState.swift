//
//  PlayerInputState.swift
//  XO-game
//
//  Created by v.prusakov on 11/4/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerInputState: GameState {
    
    var isCompleted: Bool = false
    
    let player: Player
    private let markPrototype: MarkView
    private weak var gameViewController: GameViewController?
    private weak var gameboard: Gameboard?
    private weak var gameboardView: GameboardView?
    private let turnInvoker = StepsInvoker.shared
    
    init(
        player: Player,
        markPrototype: MarkView,
        gameViewController: GameViewController?,
        gameboard: Gameboard?,
        gameboardView: GameboardView?
    ) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markPrototype = markPrototype
    }
    
    func begin() {
        let isFirstPlayerTurn = self.player == .first
        
        self.gameViewController?.firstPlayerTurnLabel.isHidden = !isFirstPlayerTurn
        self.gameViewController?.secondPlayerTurnLabel.isHidden = isFirstPlayerTurn
        
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        guard let view = gameboardView, view.canPlaceMarkView(at: position) else { return }
        
        recordEvent(.playerInput(player: self.player, position: position))
        
        self.gameboard?.setPlayer(self.player, at: position)
        view.placeMarkView(self.markPrototype.copy(), at: position)
        
        switch player {
        case .first: turnInvoker.appendCommandX(position: position)
        case .second: turnInvoker.appendCommandO(position: position)
        }
        
        self.isCompleted = true
    }
}
