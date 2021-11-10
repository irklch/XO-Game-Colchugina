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
    var isMachineGame = false
    private var counter = 0

    lazy var referee = Referee(gameboard: self.gameboard)
    private var gameboard = Gameboard()
    var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    private let turnInvoker = StepsInvoker.shared
    var gameSteps: StepsCount!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch gameSteps {
        case .oneByOne: self.goToFirstState()
        case .fiveByOne: self.goToFiveCountStepState()
        case .none: break
        }
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
        switch gameSteps {
        case .oneByOne: self.goToFirstState()
        case .fiveByOne: self.goToFiveCountStepState()
        case .none: break
        }
        self.counter = 0
        Game.steps.removeAll()
        recordEvent(.restartGame)
    }

    // MARK: - State Machine

    private func goToFirstState() {
        let player = Player.first
        if isMachineGame {
            self.currentState = MachineGameState(
                player: player,
                markPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView
            )
            self.secondPlayerTurnLabel.text = "Computer"
        }
        else {
            
            self.currentState = PlayerInputState(
                player: player,
                markPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView
            )
        }
    }

    private func goToNextState() {
        switch gameSteps {
        case .oneByOne:
            if let winner = self.referee.determineWinner() {
                self.gameboard.clear()
                self.gameboardView.clear()
                self.turnInvoker.work()
                self.currentState = WinnerState(winnerPlayer: winner, gameViewController: self, isMachinaGame: false)
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
        case .fiveByOne:
            if counter <= 3 {
                if (self.currentState as? FiveStepsCountGameState) != nil {
                    let nextPlayer = Player.first
                    self.currentState = FiveStepsCountGameState(
                        player: nextPlayer,
                        gameViewController: self,
                        gameboard: self.gameboard,
                        gameboardView: self.gameboardView,
                        markPrototype: nextPlayer.markViewPrototype
                    )
                    counter += 1
                }
            } else if counter >= 3 {
                if counter == 4 {
                    self.gameboard.clear()
                    self.gameboardView.clear()
                }
                if (self.currentState as? FiveStepsCountGameState) != nil {
                    let nextPlayer = Player.second
                    self.currentState = FiveStepsCountGameState(
                        player: nextPlayer,
                        gameViewController: self,
                        gameboard: self.gameboard,
                        gameboardView: self.gameboardView,
                        markPrototype: nextPlayer.markViewPrototype
                    )
                    counter += 1
                    if counter == 10 {
                        self.gameboard.clear()
                        self.gameboardView.clear()
                        self.showFiveStepsForXView()
                    }
                }
            }
        case .none:
            break
        }
    }

        private func goToFiveCountStepState() {
            let player = Player.first

            self.currentState = FiveStepsCountGameState(
                player: player,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView,
                markPrototype: player.markViewPrototype
            )
        }


        func showFiveStepsForXView() {
            self.currentState = FiveStepsGameRunningStateForXView(
                player: Player.first,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView,
                markPrototype: Player.first.markViewPrototype
            )
        }

        func showFiveStepsForOView() {
            self.currentState = FiveStepsGameRunningStateForOView(
                player: Player.second,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView,
                markPrototype: Player.second.markViewPrototype
            )
        }

    }

