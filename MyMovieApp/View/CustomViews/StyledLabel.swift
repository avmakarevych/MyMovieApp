//
//  StyledLabel.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 02.02.2024.
//

import UIKit

class StyledLabel: UILabel {
    init() {
        super.init(frame: .zero)
        textColor = .gray
        font = UIFont.systemFont(ofSize: 16)
        textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
