//
//  KeyboardDucking.swift
//  KeyboardDucking
//
//  Created by Levente Dimény on 2019. 05. 31..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import UIKit

public protocol KeyboardDucking where Self: UIViewController {
    func startDuckingKeyboard()
    func stopDuckingKeyboard()
}

extension KeyboardDucking {

    // MARK: - Internal properties

    internal var textFields: [UITextField] {
        return view.nestedSubviews.compactMap { $0 as? UITextField }
    }

    internal var activeTextField: UITextField? {
        return textFields.first(where: { $0.isFirstResponder })
    }

    // MARK: - Public methods

    public func startDuckingKeyboard() {
        guard !textFields.isEmpty else { return }

        var keyboardNotification = Notification(name: UIResponder.keyboardWillShowNotification)

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            keyboardNotification = notification
            self?.adaptViewFrameToKeyboardNotification(keyboardNotification)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            keyboardNotification = notification
            self?.adaptViewFrameToKeyboardNotification(keyboardNotification)
        }

        NotificationCenter.default.addObserver(forName: UITextField.textDidBeginEditingNotification, object: nil, queue: .main) { [weak self] _ in
            self?.adaptViewFrameToKeyboardNotification(keyboardNotification)
        }
    }

    public func stopDuckingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: self)
    }

    // MARK: - Internal methods

    internal func adaptViewFrameToKeyboardNotification(_ keyboardNotification: Notification) {
        guard let userInfo = keyboardNotification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue,
            let activeTextField = activeTextField else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        let animationOptions = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)

        if view.frame.origin.y == 0 {
            guard keyboardFrame.minY < activeTextField.frame.maxY else { return }
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: animationOptions, animations: { [weak self] in
                self?.view.frame.origin.y -= keyboardHeight
                self?.view.layoutIfNeeded()
            })
        } else {
            guard keyboardFrame.minY > (activeTextField.frame.maxX + keyboardHeight) else { return }
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: animationOptions, animations: { [weak self] in
                self?.view.frame.origin.y = 0
                self?.view.layoutIfNeeded()
            })
        }
    }
}
