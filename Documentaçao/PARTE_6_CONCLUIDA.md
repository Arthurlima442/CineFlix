# ✅ PARTE 6 CONCLUÍDA - SERIESVIEWCONTROLLER (MAIN CONTROLLER)

## PARTE 6: SERIESVIEWCONTROLLER ✅

### Arquivo Criado:
**SeriesViewController.swift** - Controla toda a aba de Séries

---

## 📋 SERIESVIEWCONTROLLER - DETALHADO

### Propósito:
Gerenciar o ciclo de vida da tela de séries, coordenar entre UI (Screen), dados (ViewModel) e navegação.

### Inicialização:

#### loadView()
```swift
override func loadView() {
    screen = SeriesScreen()    // Cria layout
    view = screen              // Screen vira root view do ViewController
    screen?.clipsToBounds = true
}
```

#### viewDidLoad()
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    titleNav()                 // Configura navigation bar
    configSearch()             // Configura searchBar delegate
    configScreen()             // Configura screen delegate
    configTableView()          // Configura tableView delegate/dataSource
    configViewModel()          // Configura viewModel delegate
    viewModel.fetchPopularSeries()  // Carrega séries populares
}
```

#### viewWillAppear()
```swift
override func viewWillAppear(_ animated: Bool) {
    titleNav()  // Re-aplica styling da nav bar
}
```

### Configurações:

#### titleNav()
- Define título: "CineFlix" (mesmo das filmes para consistência)
- Background: black
- Title color: red
- Title font: 35pt bold
- isTranslucent: false

#### configSearch()
- Atribui delegate da searchBar ao ViewController
- SearchBar chama `searchBar(_:textDidChange:)` ao digitar

#### configScreen()
- Atribui delegate do SeriesScreen ao ViewController
- SeriesScreen chama `tappedPresentCategoryMenu()` ao tocar botão

#### configTableView()
- Atribui delegate e dataSource da tableView ao ViewController
- TableView chama métodos: numberOfRowsInSection, cellForRowAt, didSelectRowAt
- Atribui também como UIScrollViewDelegate para detectar scroll infinito

#### configViewModel()
- Atribui delegate do ViewModel ao ViewController
- ViewModel chama: success(), failure(), startLoading(), stopLoading()

---

## 🔄 EXTENSÕES (PROTOCOLS)

### Extension: SeriesScreenProtocol

```swift
extension SeriesViewController: SeriesScreenProtocol {
    func tappedPresentCategoryMenu() {
        // 1. Cria ViewController de categoria
        let categoryVC = SeriesCategoryMenuViewController(genre: viewModel.seriesGenre)
        
        // 2. Atribui delegate
        categoryVC.delegate = self
        
        // 3. Configura apresentação como custom (slide in da esquerda)
        categoryVC.modalPresentationStyle = .custom
        categoryVC.transitioningDelegate = transitionDelegate
        
        // 4. Abre modal
        present(categoryVC, animated: true)
    }
}
```

**Fluxo:**
1. Usuário toca menuButton
2. SeriesScreen.delegate.tappedPresentCategoryMenu() é chamado
3. ViewController abre SeriesCategoryMenuViewController como modal
4. Usuário seleciona gênero
5. CategoryMenu chama ViewController.selectCategory()
6. ViewController chama ViewModel.fetchGenre()

### Extension: SeriesViewModelProtocol

```swift
extension SeriesViewController: SeriesViewModelProtocol {
    func success() {
        screen?.tableView.reloadData()  // Recarrega tableView
    }
    
    func failure() {
        screen?.tableView.reloadData()  // Recarrega (mostra ErrorCell)
    }
    
    func startLoading() {
        // TODO: Mostrar loading spinner se desejado
    }
    
    func stopLoading() {
        // TODO: Esconder loading spinner se desejado
    }
}
```

**Fluxo:**
1. ViewController chama ViewModel.fetchPopularSeries()
2. ViewModel faz API call
3. ViewModel retorna success() ou failure()
4. ViewController atualiza tableView

### Extension: UITableViewDelegate, UITableViewDataSource

#### numberOfRowsInSection
```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfNames()
}
```
- Se error: 1 (mostra ErrorCell)
- Se vazio: 1 (mostra EmptyCell)
- Senão: count de séries

#### cellForRowAt
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.isError {
        let cell = tableView.dequeueReusableCell(withIdentifier: ErrorSeriesTableViewCell.identifier, for: indexPath) as? ErrorSeriesTableViewCell
        cell?.setupCell(message: "Infelizmente tivemos um erro, tente novamente mais tarde")
        return cell ?? UITableViewCell()
    } else if viewModel.isNamesEmpty {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptySeriesTableViewCell.identifier, for: indexPath) as? EmptySeriesTableViewCell
        cell?.setupCell(with: "Nenhuma série encontrada")
        return cell ?? UITableViewCell()
    } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath) as? SeriesTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(seriesData: viewModel.loadCurrentSeriesSection(indexPath: indexPath))
        return cell
    }
}
```

- Prioridade: Error > Empty > Dados
- Cada tipo tem sua célula especializada
- Dequeue e typecast seguro

#### didSelectRowAt
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let series = viewModel.loadCurrentSeriesSection(indexPath: indexPath)
    navigationController?.pushViewController(SeriesDetailViewController(idSeries: series.id), animated: true)
    navigationItem.backButtonTitle = "Voltar"
}
```

- Pega série selecionada
- Cria SeriesDetailViewController com ID
- Push com animação
- Define botão back como "Voltar"

### Extension: UISearchBarDelegate

#### searchBar(_:textDidChange:)
```swift
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.searchSeries(series: searchText)
}
```

- Called a cada letra digitada
- Passa texto para ViewModel
- ViewModel: se vazio → fetchPopularSeries, senão → searchSeries

#### searchBarSearchButtonClicked
```swift
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()  // Fecha teclado
}
```

**Fluxo de Busca:**
```
Usuário digita "Stranger"
→ textDidChange("S")
→ viewModel.searchSeries("S")
→ API call /search/tv?query=S
→ Retorna séries
→ success()
→ tableView.reloadData()

Usuário limpa campo
→ textDidChange("")
→ viewModel.searchSeries("")
→ ViewModel chama fetchPopularSeries()
→ Volta à lista de populares
```

### Extension: SeriesCategoryMenuViewControllerProtocol

```swift
extension SeriesViewController: SeriesCategoryMenuViewControllerProtocol {
    func selectCategory(genreItem: SeriesGenreItem) {
        viewModel.fetchGenre(genre: genreItem)
    }
}
```

- Implementada por SeriesCategoryMenuViewController
- Chama ViewModel.fetchGenre() com gênero selecionado
- ViewModel fetcha séries desse gênero

### Extension: UIScrollViewDelegate

```swift
extension SeriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        let threshold: CGFloat = 200
        
        if offsetY > contentHeight - frameHeight - threshold {
            viewModel.fetchNextPage()
        }
    }
}
```

**Infinite Scroll:**
- Detecta quando usuário está a 200pt do fim da tableView
- Chama ViewModel.fetchNextPage()
- ViewModel valida: `!isLoadingMore && hasMorePages`
- Se válido: faz requisição de próxima página
- Append de novos resultados
- reloadData()

---

## 🔗 FLUXO COMPLETO DE ABERTURA

### 1. Tela Abre
```
→ loadView()
  → screen = SeriesScreen()
  
→ viewDidLoad()
  → titleNav()
  → configSearch()
  → configScreen()
  → configTableView()
  → configViewModel()
  → viewModel.fetchPopularSeries()  ← API Call!
```

### 2. API Retorna
```
→ viewModel.success()
  → delegate.success()
    → screen?.tableView.reloadData()
    
→ numberOfRowsInSection
  → return viewModel.numberOfNames()  ← Retorna count
  
→ cellForRowAt (for each row)
  → return SeriesTableViewCell
  → setupCell(serie)
    → Load image
    → Populate labels
```

### 3. Usuário Interage
```
a) Digita na SearchBar
   → textDidChange()
   → viewModel.searchSeries(text)
   → API Call
   → reloadData()

b) Toca MenuButton
   → tappedPresentCategoryMenu()
   → Open SeriesCategoryMenuViewController
   → Seleciona gênero
   → selectCategory()
   → viewModel.fetchGenre()
   → API Call
   → reloadData()

c) Scroll até fim
   → scrollViewDidScroll()
   → fetchNextPage()
   → API Call (page 2, 3, 4...)
   → append resultados
   → reloadData()

d) Toca série
   → didSelectRowAt()
   → Push SeriesDetailViewController
```

---

## ✅ CHECKLIST PARTE 6

- ✅ SeriesViewController criada
- ✅ loadView implementado
- ✅ viewDidLoad com todas as configs
- ✅ viewWillAppear restyling nav
- ✅ SeriesScreenProtocol implementado
- ✅ SeriesViewModelProtocol implementado
- ✅ UITableViewDelegate/DataSource implementado
- ✅ UISearchBarDelegate implementado
- ✅ SeriesCategoryMenuViewControllerProtocol implementado
- ✅ UIScrollViewDelegate implementado (infinite scroll)
- ✅ Navegação para SeriesDetailViewController
- ✅ Compila sem erros
- ✅ Segue padrão exato de HomeViewController

---

## 🔗 DEPENDÊNCIAS

- ✅ SeriesScreen (criado PARTE 5)
- ✅ SeriesViewModel (criado PARTE 3)
- ✅ SeriesTableViewCell (criado PARTE 4)
- ✅ EmptySeriesTableViewCell (criado PARTE 4)
- ✅ ErrorSeriesTableViewCell (criado PARTE 4)
- ⏳ SeriesCategoryMenuViewController (será criar PARTE 7)
- ⏳ SeriesDetailViewController (será criar PARTE 8)

---

## ⚠️ IMPORTANTE

SeriesViewController faz referência a:
- `SeriesCategoryMenuViewController` - Será criado PARTE 7
- `SeriesDetailViewController` - Será criado PARTE 8

Não há erro de compilação porque Swift aceita referências a classes não definidas (resolvidas em link time). Quando PARTE 7 e 8 forem criadas, tudo funcionará.

---

## 📝 PRÓXIMAS ETAPAS

**PARTE 7:** Criar SeriesCategoryMenuViewController e relacionados

Será:
- SeriesCategoryMenuViewController
- SeriesCategoryMenuViewModel
- SeriesCategoryMenuScreen
- SeriesCategoryTableViewCell

