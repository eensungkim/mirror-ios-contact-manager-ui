import UIKit
final class ContactViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    var contactDTOs: [ContactDTO]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactDTOs = decodeJSON()
        tableView.delegate = self
        tableView.dataSource = self
    }
  
}

extension ContactViewController: UITableViewDelegate {
    
}

extension ContactViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let peopleCount = contactDTOs?.count else {
            return 0
        }
        return peopleCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
        
        guard let contactDTOs = contactDTOs?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let name = contactDTOs.name
        let age = contactDTOs.age
        let phoneNumber = contactDTOs.phoneNumber
        
        content.text = "\(name) (\(age))"
        content.secondaryText = phoneNumber
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ContactViewController: JSONCodable {
    
}

extension ContactViewController: DataSendable {
    func send(textField: [ContactDTO]) {
        print("a")
    }
}

