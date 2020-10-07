//
//  SheetState.swift
//  PickAnImage
//
//  Created by Jan Hovland on 07/10/2020.
//

import Combine

class SheetState<State>: ObservableObject {
    @Published var isShowing = false
    @Published var state: State? {
        didSet { isShowing = state != nil }
    }
}
