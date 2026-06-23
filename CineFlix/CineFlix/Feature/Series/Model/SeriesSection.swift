import Foundation

// MARK: - SeriesSection

struct SeriesSection {
    enum SectionType {
        case popular
        case topRated
        case onTheAir
        case genre
    }
    
    let title: String
    let type: SectionType
    let genre: SeriesGenre?
    
    var series: [SeriesSummary] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoadingMore: Bool = false
    var error: Error?
    
    init(title: String, type: SectionType, genre: SeriesGenre? = nil) {
        self.title = title
        self.type = type
        self.genre = genre
    }
}
