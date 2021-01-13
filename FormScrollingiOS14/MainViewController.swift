//
//  MainViewController.swift
//  FormScrollingiOS14
//
//  Created by AT on 10/13/20.
//
//   https://stackoverflow.com/questions/19036228/uiscrollview-scrollable-content-size-ambiguity
//

import Combine
import UIKit

class MainViewController: UIViewController {
    
    private var tasks = Set<AnyCancellable>()
    private var activeTextField: UITextField?
    private var builder: DoubleViewBuilder
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(builder: DoubleViewBuilder) {
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
        
        listenForKeyboardEvents()
        scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        constructView()
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fieldStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.setTitle("Save", for: .normal)
        view.addTarget(self, action: #selector(onSave(_:)), for: .touchUpInside)
        view.accessibilityIdentifier = "AccountApp.MockSignedOutButton"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func constructView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [fieldStack, saveButton].forEach(contentView.addSubview(_:))
        
        var fields = [UITextField]()
        for n in 1...35 {
            fields.append(createTextField(placeholder: "Field \(n)"))
        }
        fields.forEach(fieldStack.addArrangedSubview(_:))
        
        constraintScrollView()
        constraintFieldStack()
        constrainSaveButton()
    }
    
   
    func constraintScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
    
        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])
    }
    
    func constraintFieldStack() {
        let fieldStackHeight = fieldStack.heightAnchor.constraint(equalToConstant: 0)
        fieldStackHeight.priority = .defaultLow
        
        let fieldStackBottom = fieldStack.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                                                  constant: -16)
        fieldStackBottom.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            fieldStack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 16),
            fieldStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16),
            fieldStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -16),
            fieldStackHeight,
            fieldStackBottom
        ])
    }
    
    func constrainSaveButton() {
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -16),
            
            saveButton.heightAnchor.constraint(equalToConstant: Dimensions.saveButtonHeight)
        ])
    }

    @objc
    private func onSave(_ sender: Any) {
        print("onSave")
        let viewController = builder.make(alertType: .hello, presentingViewController: self)
        present(viewController, animated: true)
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let view =  UITextField()
        view.placeholder = placeholder
        view.font = UIFont.systemFont(ofSize: 15)
        view.borderStyle = UITextField.BorderStyle.roundedRect
        view.autocorrectionType = UITextAutocorrectionType.no
        view.keyboardType = UIKeyboardType.default
        view.returnKeyType = UIReturnKeyType.done
        view.clearButtonMode = UITextField.ViewMode.whileEditing
        view.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.doneAccessory = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollIfNeeded(to: activeTextField)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

private extension MainViewController {

    enum Dimensions {
        static let saveButtonHeight: CGFloat = 40
    }
}

private extension MainViewController {
    func listenForKeyboardEvents() {

        let notificationCenter = NotificationCenter.default

        notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink(receiveValue: { [weak self] in self?.adjustForKeyboard(notification: $0) })
            .store(in: &tasks)

        notificationCenter.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .sink(receiveValue: { [weak self] in self?.adjustForKeyboard(notification: $0) })
            .store(in: &tasks)
    }

    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardWillHide()
        } else {
            let height = keyboardViewEndFrame.height
            keyboardWillShow(height: height)
        }
    }
    
    func keyboardWillShow(height: CGFloat) {
        let adjustment = height + view.safeAreaInsets.bottom
        
        scrollView.contentInset = .init(top: 0, left: 0, bottom: adjustment, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    func scrollIfNeeded(to textField: UITextField?) {
        guard let textField = textField else { return }
        // auto-scrolling is broken (at least on iOS 14)
        // So we need to adjust it
        let adjustedHeight = scrollView.frame.size.height - scrollView.contentInset.bottom
        let visibleSize = CGSize(width: scrollView.frame.size.width, height: adjustedHeight)
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: visibleSize)
        if !textField.frame.intersects(visibleRect) {
            let point = scrollView.convert(textField.frame.origin, from: scrollView)
            let contentY = max(point.y - (visibleSize.height / 2), 0)
            scrollView.setContentOffset(CGPoint(x: 0, y: contentY), animated: false)
        }
    }
}

#if DEBUG
extension MainViewController {
    struct DebugPanel {
        let sut: MainViewController
        
        func tapOnSave() {
            sut.onSave(self)
        }
    }
    
    var debugPanel: DebugPanel {
        .init(sut: self)
    }
}
#endif
