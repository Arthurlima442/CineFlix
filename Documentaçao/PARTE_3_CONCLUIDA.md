# ✅ PARTE 3 CONCLUÍDA - SERIESVIEWMODEL

## PARTE 3: SERIESVIEWMODEL ✅

### Arquivo Criado:
1. **SeriesViewModel.swift** - Lógica principal de séries
2. **SeriesGenreItem.swift** - Modelo helper para menu de gêneros

---

## 📋 SERIESVIEWMODEL - DETALHADO

### Padrão Seguido:
✅ **Idêntico a HomeViewModel** - Mesmo pattern, mesmo callbacks
✅ Usa completion handlers (não async/await)
✅ Usa Result<T, Error> para respostas
✅ Implementa paginação corretamente
✅ Não reutiliza @Published (padrão do projeto usa delegates)

### Protocol: SeriesViewModelProtocol

Define a interface entre ViewController e ViewModel:
```swift
protocol SeriesViewModelProtocol: AnyObject {
    func success()      // Dados carregados com sucesso
    func failure()      // Erro ao carregar dados
    func startLoading() // Começar loading
    func stopLoading()  // Parar loading
}
```

### Propriedades Principais:

#### Private:
- `service: SeriesService` - Chamadas API
- `seriesDataList: [SeriesSummary]` - Array de séries carregadas
- `currentPage: Int` - Página atual
- `totalPages: Int` - Total de páginas disponíveis
- `isLoadingMore: Bool` - Flag para evitar múltiplas requisições

#### Public (computed):
- `hasMorePages: Bool` - Se há próxima página
- `isError: Bool` - Se houve erro na última requisição
- `isNamesEmpty: Bool` - Se lista está vazia
- `seriesGenre: SeriesGenre` - Gênero selecionado atualmente

### Métodos Públicos:

#### 1. **fetchPopularSeries()**
```swift
func fetchPopularSeries()
```
- Reseta `currentPage = 1`
- Chama `service.fetchPopularSeries(page: 1)`
- Resultado: Array de séries mais populares
- Uso: Ao abrir SeriesViewController, ao selecionar "Populares"

#### 2. **fetchGenre(genre:)**
```swift
func fetchGenre(genre: SeriesGenreItem)
```
- Recebe item de gênero do menu
- Filtra séries por gênero
- Reseta `currentPage = 1`
- Chama `service.fetchSeriesByGenre()`
- Uso: Quando usuário seleciona gênero no CategoryMenu

#### 3. **searchSeries(series:)**
```swift
func searchSeries(series: String)
```
- Se vazio: chama `fetchPopularSeries()`
- Se não vazio: busca com `service.searchSeries()`
- Reseta `currentPage = 1`
- Uso: Quando usuário digita na SearchBar

#### 4. **fetchNextPage()**
```swift
func fetchNextPage()
```
- Guard: `!isLoadingMore && hasMorePages`
- Incrementa `currentPage += 1`
- Chama service com página seguinte
- Usa `append(contentsOf:)` para adicionar (não replace)
- Usa `DispatchQueue.main.async` para callbacks
- Uso: Infinite scroll quando usuário chega perto do fim

### Métodos Acessores (para ViewController):

#### numberOfNames() -> Int
- Se error: retorna 1 (mostra célula de erro)
- Se vazio: retorna 1 (mostra célula vazia)
- Senão: retorna count de séries

#### isNamesEmpty -> Bool
- Retorna se `seriesDataList.isEmpty`
- Usado pelo ViewController para decidir qual célula mostrar

#### loadCurrentSeriesSection(indexPath:) -> SeriesSummary
- Retorna a série no índice solicitado
- Usado para popular célula da TableView

### Métodos Privados:

#### handleNextPageResult(_:)
- Processa resultado de fetchNextPage()
- Em caso de sucesso: `append(contentsOf:)`
- Em caso de erro: decrementa `currentPage -= 1`
- Usa `DispatchQueue.main.async` para callbacks
- Define `isLoadingMore = false` sempre

---

## 🔄 FLUXO DE DADOS SERIESVIEWMODEL

### 1. Abrir SeriesViewController
```
SeriesViewController.viewDidLoad()
→ viewModel.fetchPopularSeries()
→ SeriesService.fetchPopularSeries(page: 1)
→ NetworkService.request()
→ API: GET /tv/popular?page=1
→ Decodifica SeriesList
→ delegate.success()
→ SeriesViewController.success()
→ tableView.reloadData()
```

### 2. Selecionar Gênero
```
CategoryMenu → selectCategory()
→ viewModel.fetchGenre(genre:)
→ currentPage = 1
→ SeriesService.fetchSeriesByGenre(genre:, page: 1)
→ delegate.success()
→ tableView.reloadData()
```

### 3. Buscar Série
```
SearchBar.textDidChange()
→ viewModel.searchSeries(query:)
→ SeriesService.searchSeries(query:, page: 1)
→ delegate.success()
→ tableView.reloadData()
```

### 4. Scroll Infinito
```
UIScrollViewDelegate.scrollViewDidScroll()
→ Detecta scroll perto do fim
→ viewModel.fetchNextPage()
→ Guard: !isLoadingMore && hasMorePages
→ currentPage += 1
→ SeriesService.fetchSeriesByGenre(page: 2)
→ append(contentsOf: newSeries)
→ delegate.success()
→ tableView.reloadData()
```

---

## 📊 ESTADO DE PAGINAÇÃO

### Página 1 (Inicial):
- `currentPage = 1`
- `totalPages = 10` (exemplo)
- `isLoadingMore = false`
- `hasMorePages = true` (1 < 10)

### Página 2 (Após Scroll):
- `currentPage = 2`
- `totalPages = 10`
- `isLoadingMore = false`
- `hasMorePages = true` (2 < 10)

### Página 10 (Final):
- `currentPage = 10`
- `totalPages = 10`
- `isLoadingMore = false`
- `hasMorePages = false` (10 < 10 = false)
- `fetchNextPage()` não faz nada (guard previne)

### Em Caso de Erro:
- `currentPage -= 1` (volta para página anterior)
- `isError = true`
- `isLoadingMore = false`
- Próxima tentativa tenta a mesma página novamente

---

## 🔧 SERIESGENREITEM

### Struct para Menu de Categorias:
```swift
struct SeriesGenreItem: Hashable {
    let genre: SeriesGenre
    var isSelected: Bool
}
```

- Encapsula `SeriesGenre` + flag de seleção
- Usada em `SeriesCategoryMenuViewModel` (próxima fase)
- Exemplo: `SeriesGenreItem(genre: .drama, isSelected: false)`

---

## ✅ CHECKLIST PARTE 3

- ✅ SeriesViewModel criado sem async/await
- ✅ Segue padrão exatamente de HomeViewModel
- ✅ Usa completion handlers com Result
- ✅ Implementa paginação corretamente
- ✅ Tiene protective guards para evitar múltiplas requisições
- ✅ Usa DispatchQueue.main.async para callbacks
- ✅ SeriesGenreItem criado para uso em CategoryMenu
- ✅ Compila sem erros
- ✅ Pronto para receber chamadas de SeriesViewController

---

## 🎯 COMO TESTAR PARTE 3

### Teste Manual (quando SeriesViewController existir):
1. Abrir aba Séries
2. Deve carregar "Populares" automaticamente
3. ScrollView deve detectar scroll até fim
4. Verificar logs:
   - "❌ Error fetching..." (se erro)
   - Success silencioso (se sucesso)

### Teste Programático (futuro):
```swift
let vm = SeriesViewModel()
vm.delegate = self // test delegate
vm.fetchPopularSeries()
// Esperar callback success() ou failure()
assert(vm.numberOfNames() > 0)
assert(!vm.isError)
```

---

## 🚨 RISCOS MITIGADOS

- ❌ NÃO afeta HomeViewModel
- ❌ NÃO mexe em Movies
- ✅ Padrão idêntico garante consistência
- ✅ Guard previne requisições duplicadas
- ✅ DispatchQueue previne crashes na main thread

---

## 🔗 DEPENDÊNCIAS

- ✅ SeriesService.swift (criado na PARTE 2)
- ✅ SeriesSummary, SeriesList, SeriesGenre (criado na PARTE 1)
- ✅ NetworkService (reutilizado de existente)

---

## 📝 PRÓXIMAS ETAPAS

**PARTE 4:** Criar Células de UI (SeriesTableViewCell, EmptySeriesTableViewCell, ErrorSeriesTableViewCell)

Células precisam de:
- Layout (imagem + dados)
- Constraints
- Reutilização correta
- Carregamento de imagem com cache

