import UIKit

class CategoryMenuViewController: UIViewController {
    
    var screen: CategoryMenuScreen?
    private let viewModel = CategoryMenuViewModel()
    
    override func loadView() {
        screen = CategoryMenuScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configScrenn()
    }
    
    func configScrenn() {
        screen?.delegate = self
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension CategoryMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(title: viewModel.loudCurrentMovieSection(indexPath: indexPath))
        return cell
    }
}

extension CategoryMenuViewController: CategoryMenuScreenProtocol {
    func tappedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
