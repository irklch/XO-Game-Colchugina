//
//  StepsInvoker.swift
//  XO-game
//
//  Created by Ирина Кольчугина on 10.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

class StepsInvoker {

    static let shared = StepsInvoker()

    private init() {}

    private var gameboard: Gameboard = Gameboard()
    private var gameboardView: GameboardView = GameboardView()
    var commands: [Command] = []
    private let xViewPlayerTurn = XViewPlayerTurn()
    private let oViewPlayerTurn = OViewPlayerTurn()

    func work() {
        self.commands.forEach({ $0.execute() })
    }

    func appendCommandX(position: GameboardPosition) {
        let turn = XViewPlayerTurn()
        turn.gameboard = self.gameboard
        turn.gameboardView = self.gameboardView
        turn.position = position
        commands.append(turn)
    }
    func appendCommandO(position: GameboardPosition) {
        let turn = OViewPlayerTurn()
        turn.gameboard = self.gameboard
        turn.gameboardView = self.gameboardView
        turn.position = position
        commands.append(turn)
    }
}
