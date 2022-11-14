//  Copyright © 2018 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit

final class ViewController: UIViewController {
    private let heart = UIImageView(image: UIImage(named: "Heart"))
    private let star = UIImageView(image: UIImage(named: "Star"))
    private let diamond = UIImageView(image: UIImage(named: "Diamond"))

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heart, star, diamond])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView(for: traitCollection)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass !=
            traitCollection.verticalSizeClass {
            configureView(for: traitCollection)
        }
    }

    private func setupView() {
        view.addSubview(stackView)
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20.0, leading: 20.0, bottom: 20.0, trailing: 20.0)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: margins.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        ])
    }

    private func configureView(for traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
}

extension ViewController {
    private enum AnimationMetrics {
        static let duration: TimeInterval = 0.3
        static let transformScale: CGFloat = 1.25
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if traitCollection.verticalSizeClass != newCollection.verticalSizeClass {
            animateStack(with: coordinator)
        }
    }

    private func animateStack(with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.stackView.transform = CGAffineTransform(scaleX: AnimationMetrics.transformScale, y: AnimationMetrics.transformScale)
        }, completion: { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationMetrics.duration, delay: 0, options: [], animations: {
                self.stackView.transform = .identity
            })
        })
    }
}
