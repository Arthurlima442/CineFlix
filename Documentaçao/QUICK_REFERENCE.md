# 🔧 CINEFLIX SERIES - QUICK REFERENCE GUIDE

**Version:** 2.0  
**Date:** 23 de Junho de 2026  
**Status:** Production Ready ✅

---

## 📍 File Locations

### Core Series Files
```
/Feature/Series/
├── SeriesViewController.swift                    [Main list controller]
├── Model/
│   ├── SeriesGenre.swift                        [20 genres enum]
│   ├── SeriesSummary.swift                      [List item model]
│   ├── SeriesList.swift                         [Paginated response]
│   ├── SeriesDetail.swift                       [Full details]
│   └── SeriesGenreItem.swift                    [Genre + isSelected]
├── Service/
│   └── SeriesService.swift                      [API methods]
├── ViewModel/
│   └── SeriesViewModel.swift                    [State + pagination]
├── Screen/
│   └── SeriesScreen.swift                       [UI layout]
├── Cell/
│   ├── SeriesTableViewCell.swift                [List cell]
│   ├── EmptySeriesTableViewCell.swift           [No results]
│   └── ErrorSeriesTableViewCell.swift           [Error message]
├── CategoryMenu/
│   ├── SeriesCategoryMenuViewController.swift   [Genre modal]
│   ├── SeriesCategoryMenuViewModel.swift        [Genre logic]
│   ├── Screen/
│   │   └── SeriesCategoryMenuScreen.swift       [Menu layout]
│   └── Cell/
│       └── SeriesCategoryTableViewCell.swift    [Genre cell]
└── Detail/
    ├── SeriesDetailViewController.swift         [Detail view]
    ├── ViewModel/
    │   └── SeriesDetailViewModel.swift          [Detail logic]
    ├── Screen/
    │   └── SeriesDetailScreen.swift             [Detail layout]
    └── Cell/
        ├── SeriesImageTableViewCell.swift       [Poster cell]
        └── SeriesInformationTableViewCell.swift [Info cell]
```

---

## 🔗 Quick Navigation

### To Add a New Series Source
1. Add method to `SeriesService.swift` (copy from existing)
2. Add button/option in `SeriesViewController`
3. Call new service method in ViewModel
4. Wire up in UI

### To Add a New Series Field
1. Update `SeriesDetail.swift` model with new property
2. Update `CodingKeys` enum in model
3. Add UILabel in `SeriesInformationTableViewCell`
4. Add constraint in `configConstraints()`
5. Populate in `setupCell(series:)`

### To Fix a Bug
1. Check error in Xcode (red line, build log)
2. Find affected file(s)
3. Review logic
4. Test on simulator
5. Verify no regressions

### To Improve Performance
1. Profile with Instruments
2. Check image loading (AsyncImageLoader)
3. Verify pagination (no duplicate requests)
4. Test memory (weak delegates)
5. Profile scrolling FPS

---

## 🎨 Common Customizations

### Change Series Tab Icon
**File:** `Feature/TabBar/TabBarController.swift`
```swift
let series = createNavController(
    viewController: SeriesViewController(),
    title: "Series",
    imageName: "tv",              // ← Change icon
    selectedImage: "tv.fill"      // ← Change selected icon
)
```

### Change Search Placeholder
**File:** `Feature/Series/Screen/SeriesScreen.swift`
```swift
searchBar.placeholder = "Buscar série"  // ← Change text
```

### Change Number of Genres
**File:** `Feature/Series/Model/SeriesGenre.swift`
```swift
enum SeriesGenre: Int, CaseIterable {
    // Add/remove cases here
}
```

### Change Page Size (pagination)
**File:** `Feature/Series/Service/SeriesService.swift`
```swift
// Find API calls and change "page=\(page)" parameter
```

---

## 🧪 Testing Quick Checklist

- [ ] Series tab appears in TabBar
- [ ] Popular series load on first open
- [ ] Search filters results
- [ ] Genre filter works
- [ ] Infinite scroll loads more
- [ ] Detail view opens and shows data
- [ ] Back button returns to list
- [ ] Home tab still works
- [ ] No crashes
- [ ] No memory leaks

---

## 🐛 Common Issues & Solutions

### Issue: Series tab not showing
**Solution:** Verify `TabBarController.swift` has Series in `viewControllers` array

### Issue: Images not loading
**Solution:** Check URL format and AsyncImageLoader in `Feature/ImageDownload/`

### Issue: Search not working
**Solution:** Verify `searchBar(_:textDidChange:)` calls `SeriesViewModel.searchSeries()`

### Issue: Pagination not working
**Solution:** Check `scrollViewDidEndDragging()` logic and page increments

### Issue: Detail view crashes
**Solution:** Verify Series ID is valid and SeriesService returns proper data

### Issue: Memory leak
**Solution:** Check delegates are weak, use `[weak self]` in closures

---

## 📱 User Flows

### Browse Popular Series
1. Launch app
2. Tap "Series" tab
3. View loads popular series
4. Scroll to load more
5. Done

### Search Series
1. Open Series tab
2. Tap search bar
3. Type series name
4. Results filter automatically
5. Tap series for details
6. Done

### Filter by Genre
1. Open Series tab
2. Tap menu (⋮) button
3. Select genre from list
4. Modal closes
5. Series filter by genre
6. Done

### View Series Details
1. Browse or search series
2. Tap on series row
3. Detail view opens
4. View poster and info
5. Tap back to return
6. Done

---

## 🔌 API Integration

### Endpoints Used
```swift
// Popular series
GET /tv/popular?language=pt-BR&api_key={key}&page={page}

// Top rated
GET /tv/top_rated?language=pt-BR&api_key={key}&page={page}

// On the air
GET /tv/on_the_air?language=pt-BR&api_key={key}&page={page}

// Search
GET /search/tv?query={query}&language=pt-BR&api_key={key}&page={page}

// By genre
GET /discover/tv?with_genres={genreId}&language=pt-BR&api_key={key}&page={page}

// Detail
GET /tv/{id}?language=pt-BR&api_key={key}
```

### API Key
**Location:** `Feature/Service/HomeService.swift`
```swift
private let apiKey = "YOUR_API_KEY"  // Reused in SeriesService
```

---

## 📊 Data Models

### SeriesGenre
```swift
enum SeriesGenre: Int {
    case action = 10759
    case animation = 16
    // ... 18 more
}
```

### SeriesSummary
```swift
struct SeriesSummary: Codable {
    let id: Int
    let name: String
    let firstAirDate: String
    let posterPath: String?
    let genreIds: [Int]
}
```

### SeriesDetail
```swift
struct SeriesDetail: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let firstAirDate: String
    let lastAirDate: String?
    let genres: [Genre]
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let status: String
    let networks: [Network]
}
```

---

## 🎬 Architecture Overview

```
┌─────────────────────────────────────┐
│         AppDelegate                 │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│       TabBarController              │
│  [Home] [Series] [Config]           │
└────────────┬────────────────────────┘
             │ SeriesViewController
┌────────────▼────────────────────────┐
│   SeriesViewController              │
│  ┌──────────────────────────────┐   │
│  │    SeriesScreen             │   │
│  │  ┌─────────────────────────┐ │   │
│  │  │ SearchBar + MenuButton  │ │   │
│  │  ├─────────────────────────┤ │   │
│  │  │ TableView (Series List) │ │   │
│  │  │ ┌───────────────────────┤ │   │
│  │  │ │ SeriesTableViewCell   │ │   │
│  │  │ ├───────────────────────┤ │   │
│  │  │ │ SeriesTableViewCell   │ │   │
│  │  │ └───────────────────────┘ │   │
│  │  └─────────────────────────┘ │   │
│  └──────────────────────────────┘   │
└─┬────────────┬──────────────────────┘
  │            │
  │            └─ SeriesCategoryMenuViewController (modal)
  │               (Genre filter)
  │
  └─ SeriesDetailViewController (push)
     (View series details)
```

---

## 🚀 Performance Tips

1. **Image Loading**
   - AsyncImageLoader handles async + caching
   - Images shown immediately from cache
   - Placeholder while loading

2. **Pagination**
   - Loads 20 items per page
   - Append to existing array (no reload)
   - Guards prevent duplicate requests

3. **Search**
   - Real-time filtering (no debounce)
   - Resets pagination on search
   - Clear to return to popular

4. **Memory**
   - Weak delegates prevent cycles
   - `[weak self]` in closures
   - Proper ViewController cleanup

---

## 📚 Code Examples

### Fetch Series
```swift
viewModel.fetchPopularSeries()
```

### Search Series
```swift
viewModel.searchSeries("Breaking Bad")
```

### Filter by Genre
```swift
viewModel.fetchGenre(.drama)
```

### Load More (Pagination)
```swift
viewModel.fetchNextPage()
```

### View Details
```swift
let detailVC = SeriesDetailViewController(idSeries: seriesId)
navigationController?.pushViewController(detailVC, animated: true)
```

---

## ✅ Code Standards

### Naming Conventions
- Controllers: `*ViewController`
- ViewModels: `*ViewModel`
- Services: `*Service`
- Models: `*` (no suffix)
- Cells: `*TableViewCell` or `*CollectionViewCell`
- Protocols: `*Protocol`

### File Organization
- One class/struct per file (unless nested)
- Protocols in same file or separate
- Extensions at bottom of file
- MARK comments for sections

### Safety
- Use `guard let` for optionals
- Weak references for delegates
- `[weak self]` in closures
- No force unwrap (!)

---

## 🔄 Workflow

### Adding a Feature
1. Plan (architecture, wireframes)
2. Create Models
3. Create Service
4. Create ViewModel
5. Create Screen
6. Create Cells
7. Create ViewController
8. Wire up protocols
9. Test
10. Document

### Debugging
1. Add breakpoint
2. Step through code
3. Check variables
4. Review console
5. Fix issue
6. Test again

### Performance
1. Profile with Instruments
2. Check memory graph
3. Monitor CPU
4. Test on device
5. Optimize if needed

---

## 📞 Support & Maintenance

### Regular Tasks
- [ ] Monitor API limits
- [ ] Update dependencies
- [ ] Review error logs
- [ ] Check performance metrics
- [ ] Test on latest iOS

### When Issues Arise
- Check error messages
- Review recent changes
- Check git history
- Test on different devices
- Use Instruments to profile

### Documentation
- Keep README updated
- Document new features
- Update architecture docs
- Add code comments
- Maintain changelog

---

## 🎯 Future Roadmap

### Phase 1 (Easy)
- [ ] Add more sorting options
- [ ] Add year/rating filters
- [ ] Add watchlist feature

### Phase 2 (Medium)
- [ ] Season/Episode details
- [ ] User reviews integration
- [ ] Share functionality

### Phase 3 (Complex)
- [ ] Local database persistence
- [ ] Offline viewing
- [ ] Recommendation engine
- [ ] Advanced analytics

---

## 📝 Notes

- SeriesViewController mirrors HomeViewController pattern
- SeriesDetailViewController mirrors MovieDetailViewController
- All series data from TMDB API
- Pagination works for all list views
- Images cached for better performance
- Dark theme consistent throughout
- Error handling graceful (show message, not crash)

---

**Quick Reference Version 2.0**  
**Last Updated:** 23 de Junho de 2026  
**Status:** ✅ Production Ready  

For detailed information, see `FINAL_STATUS_COMPLETE.md`
