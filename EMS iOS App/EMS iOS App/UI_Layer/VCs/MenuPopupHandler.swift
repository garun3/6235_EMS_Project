//
//  MenuPopupHandler.swift
//  EMS iOS App
//

import UIKit

class MenuPopupHandler: NSObject {

    var containerView = UIView()
    var displayedView: UIView!

    func displayPopup(_ viewToDisplay: UIView, _ height: CGFloat) {

        displayedView = viewToDisplay

        if let window = UIApplication.shared.keyWindow {
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            window.addSubview(containerView)

            window.addSubview(viewToDisplay)

            let y = window.frame.height - height

            viewToDisplay.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            containerView.frame = window.frame
            containerView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.containerView.alpha = 1

                viewToDisplay.frame = CGRect(x: 0, y: y, width: viewToDisplay.frame.width, height: viewToDisplay.frame.height)
            })
        }
    }

    @objc func handleDismiss() {

        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 0;

            if let window = UIApplication.shared.keyWindow {
                self.displayedView.frame = CGRect(x: 0, y: window.frame.height + 50, width: self.displayedView.frame.width, height: self.displayedView.frame.height)
            }
        }
    }

    override init() {
        super.init()
    }
}
