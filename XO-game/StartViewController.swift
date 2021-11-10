//
//  StartViewController.swift
//  XO-game
//
//  Created by Ирина Кольчугина on 07.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet private var humanGameButton: UIButton!
    @IBOutlet private var machineGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        humanGameButton.addTarget(self, action: #selector(startHumanGame), for: .touchUpInside)
        machineGameButton.addTarget(self, action: #selector(startMachineGame), for: .touchUpInside)
    }
    
    @objc
    private func startHumanGame() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        showAlert { result in
            switch result {
            case .oneByOne:
                vc.gameSteps = .oneByOne
                vc.isMachineGame = false
                self.present(vc, animated: true, completion: nil)
            case .fiveByOne:
                vc.gameSteps = .fiveByOne
                vc.isMachineGame = false
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc
    private func startMachineGame() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.gameSteps = .oneByOne
        vc.isMachineGame = true
        present(vc, animated: true, completion: nil)
    }
    
    private func showAlert(completion: @escaping(StepsCount) -> Void) {
        let alert = UIAlertController(title: "Выберите вариант игры", message: "Один игрок может делать 1 или 5 шагов за один раз", preferredStyle: .alert)
        let oneStepAction = UIAlertAction(title: "1 шаг", style: .cancel) { _ in completion(.oneByOne)}
        let fiveStepAction = UIAlertAction(title: "5 шагов", style: .default) { _ in completion(.fiveByOne)}
        alert.addAction(oneStepAction)
        alert.addAction(fiveStepAction)
        present(alert, animated: true, completion: nil)
    }
    
}
