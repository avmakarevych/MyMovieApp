//
//  Bindable.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 02.02.2024.
//

import Foundation

class Bindable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }

    var observer: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(observer: @escaping (T) -> Void) {
        self.observer = observer
        observer(value)
    }
}
