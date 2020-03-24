//
//  Extensions.swift
//  ToDO
//
//  Created by Alessandro Spedito on 23/03/2020.
//  Copyright © 2020 Alessandro Spedito Photography. All rights reserved.
//

import Foundation

class ExtensionsManager {
    static let shared = ExtensionsManager()
    
    // Print the document path
    func printDocumentsPath() {
        print("DOCUMENTS PATH")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("//////////////")
    }
    
    
}

// Extensions

//MARK - ARRAY
extension Array {
    
    //MANAGE ERRORS
    enum MoveErrors: Error {
        case inicesOutOfRange(message: String)
        case unknowError(message: String = "Unknow Error")
    }
    
    //MOVE AN ITEM OF AN ARRAY FROM ONE INDEX TO ANOTHER AND THROW ERRORS IF THE INDICES ARE OUT OF BOUNDS
    func move(from: Int, to: Int) throws -> [Element] {
        if self.indices.contains(from) && self.indices.contains(to) {
            var newAray = self
            let numberAtIndexFromMove = self[from]
            if from != to {
                newAray.remove(at: from)
                newAray.insert(numberAtIndexFromMove, at: to)
            } else {
                return self
            }
            return newAray
        } else  {
            throw MoveErrors.inicesOutOfRange(message: "the indices you want to move are not part of the Array")
        }
    }
}
