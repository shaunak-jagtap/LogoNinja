//
//  Points.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import Foundation

class Points {
    
    let totalTime = 60
    let correctAnswerPoints = 10
    
    func calculatePoints(level : Int, time : Int) -> Int {
        let pointsByTime = (totalTime - time) > 0 ? (totalTime - time) : 0
        return pointsByTime + correctAnswerPoints * level
        
    }
    
    
}
