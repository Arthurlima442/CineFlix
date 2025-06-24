import UIKit

class CategoryMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let categoryScreen = CategoryMenuScreen()
    
    
    override func loadView() {
        view = categoryScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryScreen.tableView.delegate = self
        categoryScreen.tableView.dataSource = self
        categoryScreen.closeButton.addTarget(self, action: #selector(closeModal), for:.touchUpInside)
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryScreen.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categoryScreen.categories[indexPath.row]
        cell.textLabel?.text = category
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return cell
    }
}
