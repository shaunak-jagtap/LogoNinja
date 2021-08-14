//
//  Score.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import Foundation

final class Score {
    
    private var totalScore = 0
    static let shared = Score()
    private init() {
    
    }
    
    func updatScore(score : Int) {
        totalScore += score
    }
    
    func restartGame() {
        totalScore = 0
    }
    
    func getScore() -> Int {
        totalScore
    }
}
