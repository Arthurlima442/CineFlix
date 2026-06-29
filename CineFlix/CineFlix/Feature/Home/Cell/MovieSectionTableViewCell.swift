import UIKit

protocol MovieSectionTableViewCellDelegate: AnyObject {
    func movieSectionCell(_ cell: MovieSectionTableViewCell, didSelectMovieAt index: Int, sectionIndex: Int)
    func movieSectionCell(_ cell: MovieSectionTableViewCell, shouldLoadMoreAt index: Int)
}

class MovieSectionTableViewCell: UITableViewCell {
    
    static let identifier = "MovieSectionTableViewCell"
    
    weak var delegate: MovieSectionTableViewCellDelegate?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    
    private var movies: [MovieSummary] = []
    private var sectionIndex: Int = 0
    
    // Preserve horizontal scroll position for each section
    private static var savedHorizontalOffsets: [Int: CGFloat] = [:]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.backgroundColor = .black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // Title Label
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25)
        ])
        
        // CollectionView Setup
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviePosterCollectionViewCell.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 12
        layout?.minimumInteritemSpacing = 0
        layout?.itemSize = CGSize(width: 160, height: 240)
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with section: MovieSection, sectionIndex: Int) {
        self.titleLabel.text = section.title
        let dataMudou = self.movies != section.movies
        self.movies = section.movies
        self.sectionIndex = sectionIndex
        
        if movies.isEmpty {
            // Show empty state
            let emptyLabel = UILabel()
            emptyLabel.text = "Nenhum filme disponível"
            emptyLabel.textColor = .gray
            emptyLabel.font = .systemFont(ofSize: 14)
            emptyLabel.textAlignment = .center
            
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
        
        // Only reload if data actually changed
        if dataMudou {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                
                // Restore saved horizontal scroll position for this section
                if let savedOffset = MovieSectionTableViewCell.savedHorizontalOffsets[sectionIndex] {
                    self.collectionView.setContentOffset(CGPoint(x: savedOffset, y: 0), animated: false)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MovieSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item >= 0, indexPath.item < movies.count else {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath)
            return emptyCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath)
        
        guard let movieCell = cell as? MoviePosterCollectionViewCell else {
            return cell
        }
        
        let movie = movies[indexPath.item]
        movieCell.configure(with: movie)
        
        return movieCell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieSectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieSectionCell(self, didSelectMovieAt: indexPath.item, sectionIndex: sectionIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if should load more
        let threshold = movies.count - 5 // Load when there are 5 items left
        if indexPath.item >= threshold && !movies.isEmpty {
            delegate?.movieSectionCell(self, shouldLoadMoreAt: sectionIndex)
        }
    }
}

// MARK: - UIScrollViewDelegate (Preserve Horizontal Scroll)

extension MovieSectionTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            MovieSectionTableViewCell.savedHorizontalOffsets[sectionIndex] = scrollView.contentOffset.x
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        MovieSectionTableViewCell.savedHorizontalOffsets[sectionIndex] = scrollView.contentOffset.x
    }
}
