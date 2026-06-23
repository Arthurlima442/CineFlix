# ANÁLISE DETALHADA E PLANO DE IMPLEMENTAÇÃO - SÉRIES

## 📋 ANÁLISE DO CÓDIGO ATUAL (FILMES)

### 1. ESTRUTURA DE PASTAS FILMES
```
Feature/
├── Home/                          (Tela Principal de Filmes)
│   ├── HomeViewController.swift
│   ├── Cell/
│   │   ├── MovieTableViewCell.swift        (Card individual)
│   │   ├── ErrorTableViewCell.swift
│   │   └── EmptyTableViewCell.swift
│   ├── Screen/
│   │   └── HomeMovieScreen.swift           (Layout/UI)
│   └── ViewModel/
│       └── HomeViewModel.swift
├── MovieDetail/                   (Detalhes do Filme)
│   ├── MovieDetailViewController.swift
│   ├── Cell/
│   │   ├── MovieImageTableViewCell.swift
│   │   └── MovieInformationTableViewCell.swift
│   ├── Screen/
│   │   └── MovieDetailScreen.swift
│   ├── Service/
│   │   └── MovieDetailService.swift
│   ├── ViewModel/
│   │   └── MovieDetailViewModel.swift
│   └── Model/
│       └── MovieDetail.swift
├── CategoryHome/                  (Menu de Gêneros)
│   ├── CategoryMenuViewController.swift
│   ├── CategoryMenuViewModel.swift
│   ├── Cell/
│   │   └── CategoryTableViewCell.swift
│   ├── Screen/
│   │   └── CategoryMenuScreen.swift
│   └── Transition/
│       ├── LeftSideTransitioningDelegate.swift
│       ├── LeftSidePresentationController.swift
│       └── SlideInTransition.swift
├── Service/
│   ├── HomeService.swift           (API calls)
│   └── NetworkService.swift        (Generic HTTP)
├── Modal/
│   ├── MovieGenre.swift
│   ├── MovieList.swift
│   └── GenreItem.swift
├── ImageDownload/
│   ├── AsyncImageLoader.swift      (Extension UIImageView)
│   └── ImageCache.swift
└── Util/
    ├── AppTransition.swift
    ├── ValidationHelper.swift
    └── Util.swift
```

### 2. FLUXO ATUAL DE FILMES - Resumo Executivo

**HomeViewController:**
- Cria HomeMovieScreen (UI)
- Cria HomeViewModel (lógica)
- Configura TableView com 3 tipos de célula: MovieTableViewCell, ErrorTableViewCell, EmptyTableViewCell
- Implementa UIScrollViewDelegate para infinite scroll
- Chama viewModel.fetchPopularMovie() no viewDidLoad
- Busca próxima página quando scroll está a 200pt do final
- Permite filtro por gênero via CategoryMenuViewController
- Permite busca via SearchBar

**HomeViewModel:**
- Usa callbacks (completion handlers) com Result<T, Error>
- Propriedades de paginação: currentPage, totalPages, isLoadingMore, hasMorePages
- Métodos: fetchPopularMovie(), fetchGenre(), fetchNextPage(), searchMovie()
- Segue pattern: currentPage=1 ao resetar, depois currentPage += 1
- Valida hasMorePages && !isLoadingMore antes de fetchNextPage
- Usa append(contentsOf:) para adicionar novos resultados

**HomeService:**
- Usa NetworkService.request() genérico
- Métodos: fetchPopularMovies(page:), fetchMoviesByGenre(genre:, page:), searchMovies(query:, page:)
- Retorna Result<MovieList, Error>
- MovieList contém: page, results, totalPages, totalResults

**MovieTableViewCell:**
- Imagem esquerda (140x160pt, cornerRadius 15)
- Título, data de lançamento e gênero à direita
- loadImageFromURL reutiliza cache
- URL format: "https://image.tmdb.org/t/p/w200{posterPath}"

**MovieDetailViewController/ViewModel/Service:**
- Recebe ID do filme no construtor
- Service: apenas 1 chamada GET /movie/{id}
- ViewModel: fetchDetail() com delegate callbacks
- ViewController: startLoading/stopLoading (vazios, sem UI de spinner)

**CategoryMenuViewController:**
- Modal com slide in transition (esquerda)
- TableView com gêneros
- Ao selecionar, chama delegate selectCategory
- HomeViewController observa e chama viewModel.fetchGenre()

**Navegação entre telas:**
- HomeViewController → MovieDetailViewController via pushViewController
- navigationItem.backButtonTitle = "Voltar"

### 3. COMPONENTES DE REUTILIZAÇÃO IDENTIFICADOS

#### ✅ Reutilizáveis para Séries:
1. **AsyncImageLoader.swift** - Funciona com qualquer URL
2. **ImageCache.swift** - Cache genérico de imagens
3. **NetworkService.swift** - HTTP genérico com Result
4. **AppTransition.swift** - Mudança de root VC
5. **ValidationHelper.swift** - Validação de email/senha
6. **Util.swift** - Funções auxiliares
7. **LeftSideTransitioningDelegate** - Animação de menu
8. **Layout pattern** - TableView com cells à esquerda/direita

#### ⚠️ Padrões a Adaptar:
1. **MovieGenre enum** → Criar **SeriesGenre enum** (IDs diferentes!)
2. **MovieTableViewCell** → Criar **SeriesTableViewCell**
3. **CategoryMenuViewController** → Criar **SeriesCategoryMenuViewController**
4. **MovieDetail models** → Criar **SeriesDetail models**

#### ❌ NÃO Reutilizar:
1. Não alterar HomeViewController
2. Não alterar MovieTableViewCell
3. Não alterar CategoryMenuViewController
4. Não alterar MovieDetailViewController
5. Não alterar HomeService

---

## 🎬 PLANO DE IMPLEMENTAÇÃO SERIES

### PHASE 1: MODELS (Series)

#### Arquivos a Criar:
```
Feature/Series/Model/
├── SeriesGenre.swift          (Enum com IDs de gêneros de séries)
├── SeriesSummary.swift        (Struct da resposta /tv/popular, /tv/top_rated, etc)
├── SeriesList.swift           (Wrapper: page, results, totalPages, totalResults)
├── SeriesDetail.swift         (Struct detalhes completos /tv/{id})
└── SeriesItem.swift           (Struct helper para categoria menu)
```

**Considerações Importantes:**

SeriesSummary vs MovieSummary:
- Movie: title, original_title, release_date
- Series: name, original_name, first_air_date
- Series adicionais: number_of_seasons, number_of_episodes, status, networks

SeriesGenre IDs (DIFERENTES de MovieGenre!):
- TMDB usa IDs diferentes para séries vs filmes
- Example: Ficção Científica = 878 (filme) vs 10765 (série)
- Listar todos os 16+ gêneros com IDs corretos

### PHASE 2: SERVICE LAYER (Series)

#### Arquivos a Criar:
```
Feature/Series/Service/
└── SeriesService.swift         (Chamadas API /tv/*)
```

**Métodos:**
```swift
func fetchPopularSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void)
func fetchTopRatedSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void)
func fetchOnTheAirSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void)
func searchSeries(query: String, page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void)
func fetchSeriesByGenre(_ genre: SeriesGenre, page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void)
func fetchSeriesDetail(by id: Int, completion: @escaping (Result<SeriesDetail, Error>) -> Void)
```

**Endpoints:**
- Popular: `/tv/popular?page=X`
- Top Rated: `/tv/top_rated?page=X`
- On The Air: `/tv/on_the_air?page=X`
- Search: `/search/tv?query=X&page=Y`
- By Genre: `/discover/tv?with_genres=X&page=Y`
- Detail: `/tv/{id}`

Usar apiKey existente (ea1bfb9a0f4886c39967baaab322b1d8)
Usar language=pt-BR

### PHASE 3: VIEWMODEL (Series)

#### Arquivos a Criar:
```
Feature/Series/ViewModel/
└── SeriesViewModel.swift
```

**Exatamente igual HomeViewModel mas com:**
- SeriesSummary ao invés de MovieSummary
- SeriesList ao invés de MovieList
- SeriesGenre ao invés de MovieGenre
- fetchPopularSeries() ao invés de fetchPopularMovie()
- Métodos: fetchTopRatedSeries(), fetchOnTheAirSeries() (variações de Home)
- Mesmos callbacks: success(), failure(), startLoading(), stopLoading()
- Mesma lógica de paginação

### PHASE 4: UI CELLS (Series)

#### Arquivos a Criar:
```
Feature/Series/Cell/
├── SeriesTableViewCell.swift        (Cópia de MovieTableViewCell adaptada)
├── SeriesImageTableViewCell.swift   (Para detalhe - cópia de MovieImageTableViewCell)
├── SeriesInformationTableViewCell.swift (Para detalhe)
├── EmptySeriesTableViewCell.swift
└── ErrorSeriesTableViewCell.swift
```

**Detalhes Críticos:**

SeriesTableViewCell:
- Mesmo layout de MovieTableViewCell (imagem esquerda, info à direita)
- Mesmo tamanho: 140x160pt
- seriesImageView com cornerRadius 15, scaleToFill
- nameSeriesLabel, firstAirDateLabel, genreSeriesLabel
- URL: "https://image.tmdb.org/t/p/w200{posterPath}"
- Usar loadImageFromURL (AsyncImageLoader reutilizado)
- NO prepareForReuse: cancelar downloads pendentes (se houver pattern no código)

### PHASE 5: UI SCREENS (Series)

#### Arquivos a Criar:
```
Feature/Series/Screen/
└── SeriesScreen.swift           (Cópia de HomeMovieScreen adaptada)
```

**Detalhes:**
- Mesmo layout: safeAreaTopBackground, searchBar, menuButton, tableView
- Registrar SeriesTableViewCell, EmptySeriesTableViewCell, ErrorSeriesTableViewCell
- Mesmas constraints do HomeMovieScreen
- Protocol SeriesScreenProtocol com tappedPresentCategoryMenu()

### PHASE 6: VIEWCONTROLLER (Series)

#### Arquivos a Criar:
```
Feature/Series/
└── SeriesViewController.swift      (Cópia de HomeViewController adaptada)
```

**Detalhes:**
- Mesmo estrutura: loadView, viewDidLoad, titleNav, etc
- Mudar título de navegação para "Séries" (ou manter CineFlix?)
- SeriesViewController → SeriesScreen → SeriesViewModel
- Mesmo pattern de configuração: configScreen, configTableView, configViewModel, configSearch
- Mesmas extensões: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CategoryMenuViewControllerProtocol, UIScrollViewDelegate
- Mesmo threshold de 200pt no scrollViewDidScroll
- Mesmo padrão de navegação: pushViewController para SeriesDetailViewController

**Questão Visual:** Manter título "CineFlix" ou mudar para "Séries"? Vou assumir que manter "CineFlix" é mais limpo.

### PHASE 7: CATEGORY MENU PARA SÉRIES

#### Arquivos a Criar:
```
Feature/Series/CategoryMenu/
├── SeriesCategoryMenuViewController.swift    (Cópia adaptada)
├── SeriesCategoryMenuViewModel.swift
├── Cell/
│   └── SeriesCategoryTableViewCell.swift
└── Screen/
    └── SeriesCategoryMenuScreen.swift
```

**Ou Reutilizar?**

Questão: CategoryMenuViewController pode ser genérico?
- Atualmente usa MovieGenre hardcoded
- Solução A: Criar versão específica para séries (SEGURO, não mexe em filmes)
- Solução B: Tornar genérico (RISCO, pode quebrar filmes)

**Recomendação:** Criar SeriesCategoryMenuViewController separado. Seguro, mantém filmes intactos.

### PHASE 8: DETAIL VIEW PARA SÉRIES

#### Arquivos a Criar:
```
Feature/Series/Detail/
├── SeriesDetailViewController.swift       (Similar MovieDetailViewController)
├── SeriesDetailViewModel.swift
├── SeriesDetailService.swift
├── Cell/
│   ├── SeriesImageTableViewCell.swift
│   └── SeriesInformationTableViewCell.swift
└── Screen/
    └── SeriesDetailScreen.swift
```

**Diferenças vs Movie Detail:**
- Mostrar: number_of_seasons, number_of_episodes, status
- Mostrar: networks (emissoras) além de gêneros
- Data: first_air_date (não release_date)
- Adaptar campos do InfoCell

### PHASE 9: INTEGRATION WITH TABBAR

#### Arquivos a Modificar:
```
Feature/TabBar/TabBarController.swift    (ÚNICO arquivo a modificar!)
```

**Mudança mínima:**
- Adicionar 1 linha no setupTabBar():
```swift
let series = createNavController(viewController: SeriesViewController(), title: "Séries", imageName: "tv", selectedImage: "tv.fill")
```
- Mudar viewControllers array de 2 para 3 items

### PHASE 10: MODELS DETAIL

#### Arquivos a Criar:
```
Feature/Series/Model/
└── SeriesDetail.swift          (Contém nested structs Genre, Network)
```

**Estrutura:**
```swift
struct SeriesDetail: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    let firstAirDate: String
    let lastAirDate: String?
    let genres: [Genre]           // Array de objetos!
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let status: String            // "Ended", "Returning Series", etc
    let networks: [Network]       // Emissoras
    
    struct Genre: Codable { id: Int, name: String }
    struct Network: Codable { id: Int, name: String, logoPath: String? }
}
```

---

## ⚠️ RISCOS IDENTIFICADOS

### Risco 1: IDs de Gênero Diferentes
**Problema:** MovieGenre e SeriesGenre usam IDs diferentes para mesmos gêneros
**Solução:** Criar enum SeriesGenre separado com IDs corretos
**Teste:** Verificar que Ficção Científica (878) não conflita

### Risco 2: Campos Ausentes em Séries
**Problema:** SeriesSummary não tem `title`, só `name`
**Solução:** Criar SeriesSummary separada, não reutilizar MovieSummary
**Teste:** Verificar que nome da série apareça corretamente

### Risco 3: Infinite Scroll Duplicado
**Problema:** ScrollViewDelegate implementado igual em Home e Series
**Solução:** Copiar código, não está bom para extrair em classe genérica
**Teste:** Testar scroll ao final em ambas as abas

### Risco 4: Cache de Imagem Compartilhado
**Problema:** ImageCache.shared é global, série pode mostrar imagem de filme
**Solução:** URLs são diferentes (posterPath), cache por URL é seguro
**Teste:** Trocar entre abas rapidamente, imagens devem estar corretas

### Risco 5: Navegação Back não Resetar ViewModel
**Problema:** Voltar de Detail para Series, ViewModel mantém estado anterior
**Solução:** Estrutura atual não faz reset ao voltar (igual filmes), OK
**Teste:** Voltar de detail, dados devem estar visíveis

### Risco 6: API Key Duplicada
**Problema:** API key hardcoded em HomeService, SeriesService, MovieDetailService
**Solução:** Está OK por enquanto, seria refactor futuro extrair para Config
**Teste:** Verificar que séries usam mesma key

### Risco 7: SearchBar em Series Pode Misturar com Popular
**Problema:** Se buscar, depois voltar, pode não resetar para popular
**Solução:** searchMovie(movie: "") chama fetchPopularMovie(), mesmo pattern
**Teste:** Buscar, limpar texto, deve volta aos populares

### Risco 8: CategoryMenu Transition Quebrar
**Problema:** LeftSideTransitioningDelegate reutilizado para séries
**Solução:** Transition é genérico, funciona com qualquer ViewController
**Teste:** Abrir menu de gêneros em ambas as abas

### Risco 9: TableView Height Inconsistent
**Problema:** MovieTableViewCell usa altura fixa com bottomAnchor
**Solução:** Copiar exatamente o mesmo layout para SeriesTableViewCell
**Teste:** Verificar que altura é consistente

### Risco 10: Multiple Page Loads Simultaneously
**Problema:** Rápido scroll pode chamar fetchNextPage múltiplas vezes
**Solução:** isLoadingMore flag previne, mesmo pattern
**Teste:** Scroll rápido até fim, verificar que não duplica requests

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### FASE 1: MODELS
- [ ] SeriesGenre.swift - Todos os 16+ gêneros com IDs corretos
- [ ] SeriesSummary.swift - name, first_air_date, posterPath, genreIds
- [ ] SeriesList.swift - page, results, totalPages, totalResults
- [ ] SeriesDetail.swift - Complete com Genre nested, Network nested
- [ ] SeriesItem.swift (optional) - Se usar em categoria menu

### FASE 2: SERVICE
- [ ] SeriesService.swift - 6 métodos (popular, toprated, onair, search, bygenre, detail)
- [ ] Testar endpoints manualmente com cURL ou Postman
- [ ] Verificar respostas JSON vs models (ajustar CodingKeys se necessário)
- [ ] Verificar erros de decode

### FASE 3: VIEWMODEL
- [ ] SeriesViewModel.swift - Exatamente igual HomeViewModel
- [ ] Testar paginação com delegate callbacks
- [ ] Testar search (query vazio retorna popular)
- [ ] Testar filtro por gênero

### FASE 4: CELLS
- [ ] SeriesTableViewCell.swift - Layout exato de MovieTableViewCell
- [ ] EmptySeriesTableViewCell.swift
- [ ] ErrorSeriesTableViewCell.swift
- [ ] Testar constraints em simulator (iPhone 12, 14, SE)
- [ ] Testar imagen loading com cache

### FASE 5: SCREENS
- [ ] SeriesScreen.swift - Mesmo layout de HomeMovieScreen
- [ ] Testar safe area, searchbar, button, tableview positioning
- [ ] Testar em landscape mode (se app suporta)

### FASE 6: VIEWCONTROLLER
- [ ] SeriesViewController.swift - Cópia de Home adaptada
- [ ] Testar tapbar navigation (click em "Séries", click em "Home")
- [ ] Testar título da nav bar
- [ ] Testar busca (searchBar)
- [ ] Testar scroll infinito (chegar ao fim, deve carregar mais)
- [ ] Testar erro na API (deve mostrar ErrorSeriesTableViewCell)
- [ ] Testar lista vazia (deve mostrar EmptySeriesTableViewCell)

### FASE 7: CATEGORY MENU
- [ ] SeriesCategoryMenuViewController.swift
- [ ] SeriesCategoryMenuViewModel.swift
- [ ] SeriesCategoryMenuScreen.swift
- [ ] SeriesCategoryTableViewCell.swift (pode reutilizar?)
- [ ] Testar abrir menu, selecionar gênero, filtrar séries
- [ ] Testar que filmes continuam funcionando (categoria de filmes não afeta séries)

### FASE 8: DETAIL VIEW
- [ ] SeriesDetailViewController.swift
- [ ] SeriesDetailViewModel.swift
- [ ] SeriesDetailService.swift
- [ ] SeriesImageTableViewCell.swift
- [ ] SeriesInformationTableViewCell.swift
- [ ] SeriesDetailScreen.swift
- [ ] Testar navegar series → detail
- [ ] Testar back button
- [ ] Testar loading durante fetch de detalhes
- [ ] Testar erro ao carregar detalhe

### FASE 9: INTEGRATION
- [ ] Modificar TabBarController.swift - Adicionar Series tab
- [ ] Testar tab switching (Home ↔ Series ↔ Config)
- [ ] Testar que Home continua funcionando (não quebrou)
- [ ] Testar que Config continua funcionando
- [ ] Testar cores/estilos da tabbar consistente

### FASE 10: REGRESSION TESTING
- [ ] Home (filmes) - Popular, top-rated, on-air, search, gêneros, detail, scroll infinito
- [ ] Series - Popular, top-rated, on-air, search, gêneros, detail, scroll infinito
- [ ] TabBar - Navigation entre 3 abas
- [ ] Imagens - Cache compartilhado não mostra imagens erradas
- [ ] Navigação - Back button volta corretamente
- [ ] Erro - API error tratado corretamente em ambas
- [ ] Vazio - Lista vazia mostra mensagem em ambas
- [ ] Loading - Transição suave durante carregamento

---

## 📂 ESTRUTURA FINAL ESPERADA

```
Feature/
├── Home/                          ✅ UNCHANGED
├── MovieDetail/                   ✅ UNCHANGED
├── CategoryHome/                  ✅ UNCHANGED
├── Series/                        🆕 NOVO
│   ├── SeriesViewController.swift
│   ├── Cell/
│   │   ├── SeriesTableViewCell.swift
│   │   ├── EmptySeriesTableViewCell.swift
│   │   └── ErrorSeriesTableViewCell.swift
│   ├── Screen/
│   │   └── SeriesScreen.swift
│   ├── ViewModel/
│   │   └── SeriesViewModel.swift
│   ├── Service/
│   │   └── SeriesService.swift
│   ├── Model/
│   │   ├── SeriesGenre.swift
│   │   ├── SeriesSummary.swift
│   │   ├── SeriesList.swift
│   │   ├── SeriesDetail.swift
│   │   └── SeriesItem.swift
│   ├── Detail/
│   │   ├── SeriesDetailViewController.swift
│   │   ├── SeriesDetailViewModel.swift
│   │   ├── SeriesDetailService.swift
│   │   ├── Cell/
│   │   │   ├── SeriesImageTableViewCell.swift
│   │   │   └── SeriesInformationTableViewCell.swift
│   │   └── Screen/
│   │       └── SeriesDetailScreen.swift
│   └── CategoryMenu/
│       ├── SeriesCategoryMenuViewController.swift
│       ├── SeriesCategoryMenuViewModel.swift
│       ├── Cell/
│       │   └── SeriesCategoryTableViewCell.swift
│       └── Screen/
│           └── SeriesCategoryMenuScreen.swift
├── Service/                       ✅ Adicionar métodos a NetworkService se necessário
├── Modal/                         ✅ Sem mudanças (MovieGenre, etc)
├── ImageDownload/                 ✅ Reutilizado
├── Util/                          ✅ Reutilizado
└── TabBar/
    └── TabBarController.swift     🔧 MODIFICAR (adicionar Series tab)
```

---

## 🎯 PRÓXIMOS PASSOS APÓS APROVAÇÃO

1. **Validar este plano** - Você concorda com a estrutura?
2. **Criar models Series** - Começar pela PHASE 1
3. **Implementar passo a passo** - Seguir order exato
4. **Testar cada fase** - Não pular para próxima sem testar
5. **Review final** - Antes de subir para App Store

---

## 📌 PONTOS-CHAVE PARA LEMBRAR

✅ **REUTILIZAÇÃO SEGURA:**
- AsyncImageLoader.swift → Funciona com qualquer URL
- ImageCache.shared → Global, funciona para séries
- NetworkService.request() → Genérico
- Transition animations → Genéricos
- Util.formatReleaseDate() → Função genérica

❌ **NÃO ALTERAR:**
- HomeViewController, HomeMovieScreen, HomeViewModel, HomeService
- MovieTableViewCell, MovieDetailViewController
- CategoryMenuViewController (criar version para séries)
- Nenhum arquivo de Login/Register/Settings

✅ **COPIAR E ADAPTAR:**
- HomeViewController → SeriesViewController (mudar tipos, manter estrutura)
- HomeMovieScreen → SeriesScreen (mudar tipos, manter layout)
- HomeViewModel → SeriesViewModel (mudar tipos, manter lógica)
- MovieTableViewCell → SeriesTableViewCell (mudar labels, manter constraints)

⚠️ **CRIAR NOVOS:**
- SeriesGenre (IDs diferentes!)
- SeriesSummary, SeriesList, SeriesDetail (campos diferentes)
- SeriesService (endpoints /tv/*)
- SeriesCategoryMenu (versão para séries)
- SeriesDetailView (estrutura similar a movies)

---

## 🚀 QUALIDADE PARA APP STORE

Ao implementar, garantir:

✅ Código limpo sem duplicação (OK copiar HomeViewController, adaptar nomes)
✅ Error handling completo (catch all errors, mostrar ao user)
✅ Loading states (startLoading/stopLoading vazios, mas estrutura pronta)
✅ Empty states (mostrar mensagem quando nenhuma série encontrada)
✅ Infinite scroll funcionando (scroll até fim, carrega mais)
✅ Image caching (não fazer novo request da mesma imagem)
✅ No memory leaks (weak self em closures)
✅ Thread-safe (DispatchQueue.main.async para UI updates)
✅ Constraint bem defini (Auto Layout, funciona em todos os iPhones)
✅ Naming conventions (Series não Seria, métodos em inglês)
✅ Documentation (comentários em métodos complexos)
✅ No hardcoded strings (nomes de séries etc vêm da API)

---

**Questões para você esclarecer antes de começar:**

1. **Título da aba Series:** "Séries" ou "TV Shows" ou outro?
2. **Ordem das abas:** Home → Séries → Config ou outra ordem?
3. **Ícone da aba Series:** "tv" vs "play.tv" vs outro?
4. **Reordenar TabBar:** Manter atual ou mudar posição?
5. **Menu Category:** Reutilizar CategoryMenuViewController genérico ou criar versão para séries?
6. **Detail Screen:** Mostrar poster grande como filmes ou poster pequeno?

