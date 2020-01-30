//
//  ExtensionUIView.swift
//  29HWUITableViewStaticCellSwift
//
//  Created by Сергей on 25.01.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
