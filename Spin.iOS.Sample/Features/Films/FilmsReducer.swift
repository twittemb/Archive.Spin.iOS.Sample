//
//  FilmsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Films {
    static func reducer(state: Films.State, action: Films.Action) -> Films.State {
        switch action {
        case .startLoad:
            return .loading
        case .succeedLoad(let films, let previousPage, let nextPage):
            return .loaded(data: films, previousPage: previousPage, nextPage: nextPage)
        case .failLoad:
            return .failed
        }
    }
}
