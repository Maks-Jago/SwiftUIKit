//
//  DispatchQueue.swift
//  
//
//  Created by Max Kuznetsov on 08.09.2021.
//

import SwiftUI

extension DispatchQueue {
    func asyncWithAnimation(_ animation: Animation = .default, _ block: @escaping () -> Void) {
        self.async {
            withAnimation(animation) {
                block()
            }
        }
    }
}
