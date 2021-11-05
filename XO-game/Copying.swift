//
//  Copying.swift
//  XO-game
//
//  Created by v.prusakov on 11/4/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        // Monster.init(self)
        return type(of: self).init(self)
    }
}
