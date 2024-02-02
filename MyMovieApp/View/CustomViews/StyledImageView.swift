//
//  StyledImageView.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 02.02.2024.
//

import UIKit

class StyledImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
