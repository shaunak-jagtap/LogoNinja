//
//  GameLevelService.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import Foundation

class GameLevelService {
    
    
    func getDataForLevel(level : Int) -> Any? {
        
        guard let filePath = Bundle.main.url(forResource: "logo", withExtension: "txt") else { return nil }

        //TODO : Error Handling
        if let data = try? Data.init(contentsOf: filePath) {
        let model = try? JSONDecoder().decode(Welcome.self, from: data)
        return model
        
        }
        
        return nil
    }
    
    
    
}
