//
//  View + Ex.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 1.03.22.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
