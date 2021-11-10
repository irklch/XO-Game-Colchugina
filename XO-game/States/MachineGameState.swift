//
//  MachineGameState.swift
//  XO-game
//
//  Created by Ирина Кольчугина on 07.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

final class MachineGameState: GameState {
    var isCompleted: Bool = false

    let player: Player
    private let markPrototype: MarkView
    private weak var gameViewController: GameViewController?
    private weak var gameboard: Gameboard?
    private weak var gameboardView: GameboardView?


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
        if self.player == .second {

            guard let gameboard = self.gameboard else {return}
            let machineReferee = Referee(gameboard: gameboard)
            var machinePositions = (machineReferee.winningCombinations.randomElement()?.randomElement())!
            guard let view = gameboardView else {return}
            while !view.canPlaceMarkView(at: machinePositions) {
                machinePositions = (machineReferee.winningCombinations.randomElement()?.randomElement())!
            }

            recordEvent(.playerInput(player: self.player, position: machinePositions))

            self.gameboard?.setPlayer(self.player, at: machinePositions)
            view.placeMarkView(self.markPrototype.copy(), at: machinePositions)
            
            self.isCompleted = true


        } else {
            guard let view = gameboardView, view.canPlaceMarkView(at: position) else { return }

            recordEvent(.playerInput(player: self.player, position: position))

            self.gameboard?.setPlayer(self.player, at: position)
            view.placeMarkView(self.markPrototype.copy(), at: position)

            self.isCompleted = true
        }
    }

}
