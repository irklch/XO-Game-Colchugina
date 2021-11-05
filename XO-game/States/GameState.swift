//
//  GameState.swift
//  XO-game
//
//  Created by v.prusakov on 11/4/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol GameState {
    var isCompleted: Bool { get }
    
    func begin()
    
    func addMark(at position: GameboardPosition)
}
