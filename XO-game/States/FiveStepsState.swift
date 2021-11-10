//
//  FiveStepsState.swift
//  XO-game
//
//  Created by Ирина Кольчугина on 10.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class FiveStepsCountGameState: GameState {
    
    var isCompleted: Bool = false
    
    let player: Player
    private unowned let gameViewController: GameViewController
    private let gameboard: Gameboard
    private let gameboardView: GameboardView
    private let markPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markPrototype = markPrototype
    }
    
    func begin() {
        let isFirstPlayer = self.player == .first
        self.gameViewController.firstPlayerTurnLabel.isHidden = !isFirstPlayer
        self.gameViewController.secondPlayerTurnLabel.isHidden = isFirstPlayer
        self.gameViewController.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        
        guard self.gameboardView.canPlaceMarkView(at: position) else { return }
        recordEvent(.playerInput(player: self.player, position: position))
        self.gameboard.setPlayer(self.player, at: position)
        self.gameboardView.placeMarkView(self.markPrototype.copy(), at: position)
        Game.steps.append(position)
        self.isCompleted = true
    }
}

class FiveStepsGameRunningStateForXView: GameState {
    
    var isCompleted: Bool = false
    
    let player: Player
    private unowned let gameViewController: GameViewController
    private let gameboard: Gameboard
    private let gameboardView: GameboardView
    private let markPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markPrototype = markPrototype
    }
    
    func begin() {
        let isFirstPlayer = self.player == .first
        self.gameViewController.firstPlayerTurnLabel.isHidden = !isFirstPlayer
        self.gameViewController.secondPlayerTurnLabel.isHidden = isFirstPlayer
        self.gameViewController.winnerLabel.isHidden = true
    }
    
    private func checkPositions(steps: GameboardPosition) {
        guard self.gameboardView.canPlaceMarkView(at: steps) else { return }
        recordEvent(.playerInput(player: self.player, position: steps))
        self.gameboard.setPlayer(self.player, at: steps)
        self.gameboardView.placeMarkView(self.markPrototype.copy(), at: steps)
    }
    
    func addMark(at position: GameboardPosition) {
        let steps = Game.steps
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                self.checkPositions(steps: steps[0])
                self.checkPositions(steps: steps[1])
                self.checkPositions(steps: steps[2])
                self.checkPositions(steps: steps[3])
                self.checkPositions(steps: steps[4])
            },
            completion: { _ in
                self.gameViewController.showFiveStepsForOView()
            })
        self.isCompleted = true
    }

}

class FiveStepsGameRunningStateForOView: GameState {
    
    var isCompleted: Bool = false
    
    let player: Player
    private unowned let gameViewController: GameViewController
    private let gameboard: Gameboard
    private let gameboardView: GameboardView
    private let markPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markPrototype = markPrototype
    }
    
    func begin() {
        
        let isFirstPlayer = self.player == .first
        self.gameViewController.firstPlayerTurnLabel.isHidden = !isFirstPlayer
        self.gameViewController.secondPlayerTurnLabel.isHidden = isFirstPlayer
        
        self.gameViewController.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        
        let steps = Game.steps
        
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                self.checkPositions(steps: steps[5])
                self.checkPositions(steps: steps[6])
                self.checkPositions(steps: steps[7])
                self.checkPositions(steps: steps[8])
                self.checkPositions(steps: steps[9])
            }, completion: {_ in
                if let winner = self.gameViewController.referee.determineWinner() {
                    self.gameViewController.currentState = WinnerState(winnerPlayer: winner, gameViewController: self.gameViewController, isMachinaGame: false)
                    return
                }
            })
        self.isCompleted = true
    }
    
    private func checkPositions(steps: GameboardPosition) {
        if self.gameboard.contains(player: self.player.next, at: steps) {
            self.gameboardView.removeMarkView(at: steps)
            self.gameboard.setPlayer(self.player, at: steps)
            self.gameboardView.placeMarkView(self.markPrototype.copy(), at: steps)
        } else {
            guard self.gameboardView.canPlaceMarkView(at: steps) else { return }
            recordEvent(.playerInput(player: self.player, position: steps))
            self.gameboard.setPlayer(self.player, at: steps)
            self.gameboardView.placeMarkView(self.markPrototype.copy(), at: steps)
        }
    }
    
}
