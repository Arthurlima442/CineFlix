import UIKit

protocol CategoryMenuViewControllerProtocol: AnyObject {
    func selectCategory(genreItem: GenreItem)
}

class CategoryMenuViewController: UIViewController {
    
    weak var delegate: CategoryMenuViewControllerProtocol?
    
    var screen: CategoryMenuScreen?
    private let viewModel = CategoryMenuViewModel(genre: .all)
    #warning(arrumar")
    
    override func loadView() {
        screen = CategoryMenuScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configScreen()
        configViewModel()
    }
    
    func configScreen() {
        screen?.delegate = self
    }
    
    func configViewModel() {
        viewModel.delegate = self
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension CategoryMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGenre()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(genre: viewModel.loadCurrentGenre(at: indexPath.item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genreItem = viewModel.loadCurrentGenre(at: indexPath.row)
        delegate?.selectCategory(genreItem: genreItem)
        dismiss(animated: true)
    }
}

extension CategoryMenuViewController: CategoryMenuScreenProtocol {
    func tappedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension CategoryMenuViewController: CategoryMenuViewModelProtocol {
    func startLoading() {
        //start
    }
    
    func stopLoading() {
        //stop
    }
    
    func successCategory() {
        screen?.tableView.reloadData()
    }
    
    func failure(message: String) {
        // alert
    }
}

