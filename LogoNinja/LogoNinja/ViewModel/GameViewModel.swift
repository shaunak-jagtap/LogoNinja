//
//  GameViewModel.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import Foundation
import UIKit

protocol LogoDelegate : AnyObject {
    
    func shouldDisplayNext()
    func didGameEnd(score : Int)
}

class GameViewModel {
    
    weak var logoDelegate : LogoDelegate?
    var logoArray = [Logo]()
    var currentLogo = -1
    var startDate = Date()
    var time = 0
    let gameLevel : Int
    
    init(gameLevel: Int) {
        self.gameLevel = gameLevel
        let notificationCenter = NotificationCenter.default
           notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
           
           notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func appMovedToBackground() {
        print("app enters background")
    }

    @objc func appCameToForeground() {
        print("app enters foreground")
    }
    
    func clearGameData() {
        currentLogo = -1
        logoArray.removeAll()
        time = 0
    }
    
    func getData() {
        if let array = GameLevelService().getDataForLevel(level : gameLevel) as? [Logo] {
            logoArray.append(contentsOf: array)
        }
        //TODO : Error Handling
    }
    
    func getLogo() -> Logo?  {

        currentLogo += 1
        if currentLogo < logoArray.count {
            return logoArray[currentLogo]
        }
        return nil
    }
    
    func startTimer() {
        startDate = Date()
        print("Started Counting time : \(startDate)")
    }
    
    func stopTimer() {

        time += Date().seconds(from: startDate)
        print("Stopped time : \(time)")
    }
    
    func getLetters() -> [Character] {
        
        let logo = logoArray[currentLogo]
        var letters = [Character]()
        letters.append(contentsOf: logo.name)
        return letters
    }
        
    func verifyIfLogoIdentified( string : String) {
        
        if currentLogo >= logoArray.count {
            logoDelegate?.didGameEnd(score: Score.shared.getScore())
            return
        }
        
        let logo = logoArray[currentLogo]
        if logo.name.uppercased() == string.uppercased() {
            stopTimer()
            Score.shared.updatScore(score : Points().calculatePoints(level : 1, time : time))
            print("total score : \(Score.shared.getScore())")
            if currentLogo == ( logoArray.count - 1 ) {
                logoDelegate?.didGameEnd(score: Score.shared.getScore())
            } else if currentLogo < logoArray.count {
                self.logoDelegate?.shouldDisplayNext()
            }
        }
    }
}
