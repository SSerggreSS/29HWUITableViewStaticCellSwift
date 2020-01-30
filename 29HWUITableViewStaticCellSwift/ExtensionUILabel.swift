//
//  ExtensionUILabel.swift
//  29HWUITableViewStaticCellSwift
//
//  Created by Сергей on 25.01.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    self.fadeTransition(characterDelay)
                }
            }
        }
    }
}
