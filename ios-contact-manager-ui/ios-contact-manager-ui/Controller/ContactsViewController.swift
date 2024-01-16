//
//  ContactListViewController.swift
//  ios-contact-manager-ui
//
//  Created by Kim EenSung on 1/4/24.
//

import UIKit

final class ContactsViewController: UIViewController {

    private let contactsTableView: ContactsView
    var dataSource: ContactsApproachable?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        contactsTableView = ContactsView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = contactsTableView
        contactsTableView.tableView.dataSource = self
    }
}

extension ContactsViewController {
    @objc func presentContactsAdditionModalView() {
        let contactsAdditionModalViewController = ContactsAdditionModalViewController()
        contactsAdditionModalViewController.delegate = dataSource as? any ContactsManageable
        contactsAdditionModalViewController.reloadData = { [weak self] in
            self?.contactsTableView.tableView.reloadData()
        }
        present(contactsAdditionModalViewController, animated: true)
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.sorted().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        guard let contact: Contact = dataSource?.sorted()[indexPath.row] else {
            return cell
        }
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(contact.name)(\(contact.age))"
        content.secondaryText = contact.phoneNumber
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension ContactsViewController {
    private func setupContactsTableViewConstraints() {
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            contactsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])
    }
}
