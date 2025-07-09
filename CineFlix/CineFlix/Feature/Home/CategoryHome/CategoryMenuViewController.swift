import UIKit

class CategoryMenuViewController: UIViewController {
    
    private let categoryScreen = CategoryMenuScreen()
    private let viewModel = CategoryMenuViewModel()
    
    override func loadView() {
        view = categoryScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
        configTableView()
    }
    
    private func configScreen() {
        categoryScreen.closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }
    
    private func configTableView() {
        categoryScreen.configTableViewProtocols(delegate: self, dataSource: self)
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}

extension CategoryMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        let category = viewModel.categories[indexPath.row]
        cell.setup(title: category)
        return cell
    }
}
