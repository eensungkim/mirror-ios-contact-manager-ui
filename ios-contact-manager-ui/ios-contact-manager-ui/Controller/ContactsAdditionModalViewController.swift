//
//  ContactsAdditionModalViewController.swift
//  ios-contact-manager-ui
//
//  Created by Kim EenSung on 1/9/24.
//

import UIKit

final class ContactsAdditionModalViewController: UIViewController {
    weak var delegate: ContactsManageable?
    private var regexByTextField: Dictionary<UITextField, String>
    private var invalidationByTextField: Dictionary<UITextField, InvalidationInput>
    private let contactsAdditionModalView: ContactsAddtionModalView
    private var sortedTextField: Array<UITextField>
    var reloadData: (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        regexByTextField = [:]
        invalidationByTextField = [:]
        sortedTextField = []
        contactsAdditionModalView = ContactsAddtionModalView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setSortedTextField()
        setRegexByTextField()
        setInvalidationByTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = contactsAdditionModalView
    }
}

extension ContactsAdditionModalViewController {
    private func setRegexByTextField() {
        regexByTextField = [
            contactsAdditionModalView.nameTextField: #"^[^\s]+$"#,
            contactsAdditionModalView.ageTextField: #"^\d{1,3}$"#,
            contactsAdditionModalView.phoneNumberTextField: #"^\d{2,}-\d{3,}-\d{4,}$"#
        ]
    }
    
    private func setInvalidationByTextField() {
        invalidationByTextField = [
            contactsAdditionModalView.nameTextField: .name,
            contactsAdditionModalView.ageTextField: .age,
            contactsAdditionModalView.phoneNumberTextField: .phoneNumber
        ]
    }
    
    private func setSortedTextField() {
        sortedTextField = [
            contactsAdditionModalView.nameTextField,
            contactsAdditionModalView.ageTextField,
            contactsAdditionModalView.phoneNumberTextField,
        ]
    }
}

extension ContactsAdditionModalViewController {
    @objc func dismissContactsAdditionModalView() {
        makeCancelAlert(message: "정말로 취소하시겠습니까?", destructiveAction: { _ in self.dismiss(animated: true) })
    }
    
    @objc func saveButtonDidTapped() {
        if let invalidationInput = validateTextFields() {
            makeAlert(message: invalidationInput.message, confirmAction: nil)
            return
        }
        guard let contact = newContact() else {
            return
        }
        delegate?.create(contact)
        reloadData?()
        self.dismiss(animated: true)
    }
    
    private func newContact() -> Contact? {
        guard let name = contactsAdditionModalView.nameTextField.text,
              let ageString = contactsAdditionModalView.ageTextField.text,
              let age = Int(ageString),
              let phoneNumber = contactsAdditionModalView.phoneNumberTextField.text else {
            return nil
        }
        return Contact(name: name, contact: phoneNumber, age: age)
    }
}

extension ContactsAdditionModalViewController {
    private func validateTextFields() -> InvalidationInput? {
        var invalidationInput: InvalidationInput? = nil
        sortedTextField.forEach { uiTextField in
            invalidationInput = invalidationInput == nil ? validate(regex: regexByTextField[uiTextField], input: uiTextField) : invalidationInput
        }
        return invalidationInput
    }
    
    private func validate(regex: String?, input: UITextField) -> InvalidationInput? {
        guard let inputText = input.text, let regexString: String = regex else {
            return invalidationByTextField[input]
        }
        
        let regexTest = NSPredicate(format: "SELF MATCHES %@", regexString)
        return regexTest.evaluate(with: inputText) ? nil : invalidationByTextField[input]
    }
}
