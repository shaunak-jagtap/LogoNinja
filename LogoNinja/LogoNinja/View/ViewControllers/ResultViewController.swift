//
//  ResultViewController.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successLabel.text = "Game Over...!!\n Final score : \(Score.shared.getScore())"
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
        Score.shared.restartGame()
        self.navigationController?.popViewController(animated: true)
    }
}
