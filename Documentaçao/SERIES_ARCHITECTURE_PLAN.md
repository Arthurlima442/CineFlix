# 📺 PLANO DE ARQUITETURA - SÉRIE TV

## 1. FLUXO DE NAVEGAÇÃO

```
┌─────────────────────────────────────────────┐
│            TabBarController                 │
│  ┌──────────────────────────────────────┐   │
│  │ [Filmes 🏠]  [Séries 📺]  [Config ⚙️]  │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
        ↓                      ↓
    HomeViewController    SeriesViewController
    (Filme Atual)         (NOVO)
```

**Comportamento:**
- Clica em "Filmes" → HomeViewController (mantém tudo igual)
- Clica em "Séries" → SeriesViewController (nova tela)
- Clica em "Config" → SettingsViewController (mantém tudo igual)

---

## 2. LAYOUT VISUAL DA TELA DE SÉRIES

### **Estrutura Geral:**

```
┌─────────────────────────────────────────┐
│  CINEFLIX                      [☰]      │ ← Navigation Bar
├─────────────────────────────────────────┤
│ ┌────────────────────────────────────┐  │
│ │  🔍 Pesquisar série...             │  │ ← SearchBar
│ └────────────────────────────────────┘  │
├─────────────────────────────────────────┤
│ SÉRIES POPULARES                        │ ← Section Title
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │ ← Horizontal Scroll
│ │  [1]  │ │  [2]  │ │  [3]  │        │
│ │ GOT   │ │ TBBT  │ │ Breaking│      │
│ │ ⭐9.2 │ │ ⭐8.4 │ │ ⭐9.5  │       │
│ └──────┘ └──────┘ └──────┘            │
├─────────────────────────────────────────┤
│ MAIS BEM AVALIADAS                      │ ← Section Title
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │
│ │  [1]  │ │  [2]  │ │  [3]  │        │
│ │ Série │ │ Série │ │ Série │        │
│ │ ⭐9.5 │ │ ⭐9.3 │ │ ⭐9.2 │       │
│ └──────┘ └──────┘ └──────┘            │
├─────────────────────────────────────────┤
│ EM ALTA                                 │ ← Section Title
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │
│ │  [1]  │ │  [2]  │ │  [3]  │        │
│ │ Série │ │ Série │ │ Série │        │
│ │ ⭐8.9 │ │ ⭐8.7 │ │ ⭐8.5 │       │
│ └──────┘ └──────┘ └──────┘            │
├─────────────────────────────────────────┤
│ DRAMA                                   │ ← Section Title (por gênero)
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │
│ └──────┘ └──────┘ └──────┘            │
├─────────────────────────────────────────┤
│ COMÉDIA                                 │
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │
│ └──────┘ └──────┘ └──────┘            │
├─────────────────────────────────────────┤
│ AÇÃO E AVENTURA                         │
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │ Poster│ │Poster│ │Poster│ ► ...    │
│ └──────┘ └──────┘ └──────┘            │
└─────────────────────────────────────────┘
```

---

## 3. COMPONENTES DO LAYOUT

### **Topo da Tela (Navigation Bar)**
- **Título:** "SÉRIES" (em vermelho, como em "FILMES")
- **Botão direita:** Menu de gêneros (☰ hambúrguer)
- **Cor fundo:** Preto (igual)
- **Font:** Sistema Bold 35pt (igual)

### **SearchBar**
- Igual à SearchBar dos filmes
- Placeholder: "Pesquisar série"
- Background: Cinza escuro
- Debounce para não fazer muitas chamadas

### **Seções da TableView**
```swift
Categorias Automáticas (sempre mostram):
1. Séries Populares    (endpoint: /tv/popular)
2. Mais Bem Avaliadas  (endpoint: /tv/top_rated)
3. Em Alta             (endpoint: /tv/on_the_air)

Categorias por Gênero (carregam conforme seleção):
4. Drama               (endpoint: /discover/tv?with_genres=18)
5. Comédia             (endpoint: /discover/tv?with_genres=35)
6. Ação e Aventura     (endpoint: /discover/tv?with_genres=10759)
7. Animação            (endpoint: /discover/tv?with_genres=16)
...
```

### **Cada Card de Série**
```
┌──────────┐
│          │
│  Poster  │ 200x300px
│  Image   │
│          │
├──────────┤
│ Nome     │ Max 2 linhas
│ da Série │
├──────────┤
│ ⭐ 8.5   │ Vote average
└──────────┘
```

### **Comportamento de Scroll**

**Scroll Principal (Vertical):**
- Scroll para **baixo** = navega pelas categorias
- Quando chega perto do final, carrega mais dados (paginação)

**Scroll Secundário (Horizontal):**
- Dentro de cada categoria, cards rolam para **direita**
- Cada categoria é uma CollectionView horizontal
- Threshold: 200pt do final (como em filmes)

---

## 4. INTERAÇÕES DO USUÁRIO

### **Clique no Botão de Menu (☰)**
```
Usuario clica ☰
    ↓
Abre CategoryMenuForSeriesViewController
    ↓
Mostra lista de gêneros de séries
    ↓
Usuario seleciona "Drama"
    ↓
SeriesViewController filtra por gênero
    ↓
Mostra apenas séries de Drama
```

### **Clique em uma Série**
```
Usuario clica em poster de série
    ↓
Abre SeriesDetailViewController
    ↓
Mostra: Título, Descrição, Número de Temporadas, Status
    ↓
Usuario pode: Voltar, Ver mais detalhes, etc
```

### **Busca**
```
Usuario digita "Game of Thrones"
    ↓
ViewModell chama /search/tv
    ↓
Filtra resultado em tempo real
    ↓
Mostra séries que correspondem
    ↓
Implementa scroll infinito na busca
```

---

## 5. ESTRUTURA DE ARQUIVOS

### **Arquivos NOVOS a Criar:**

```
Feature/Series/
├── SeriesViewController.swift          ← Controller principal
├── Screen/
│   └── SeriesScreen.swift              ← Layout da tela
├── ViewModel/
│   └── SeriesViewModel.swift           ← Lógica de séries
├── Service/
│   └── SeriesService.swift             ← Chamadas de API
├── Cell/
│   ├── SeriesTableViewCell.swift       ← Célula com CollectionView
│   ├── SeriesCollectionViewCell.swift  ← Card individual de série
│   ├── ErrorTableViewCell.swift        ← Pode reusar? SIM
│   └── EmptyTableViewCell.swift        ← Pode reusar? SIM
├── Model/
│   ├── SeriesList.swift                ← Response da API
│   ├── SeriesSummary.swift             ← Série resumida
│   ├── SeriesDetail.swift              ← Série detalhada
│   └── SeriesGenre.swift               ← Enum de gêneros
├── CategoryMenu/
│   ├── SeriesCategoryMenuViewController.swift  ← Menu de gêneros
│   ├── Screen/
│   │   └── SeriesCategoryMenuScreen.swift
│   ├── ViewModel/
│   │   └── SeriesCategoryMenuViewModel.swift
│   └── Cell/
│       └── SeriesCategoryTableViewCell.swift
└── SeriesDetail/
    ├── SeriesDetailViewController.swift   ← Tela de detalhes
    ├── Screen/
    │   └── SeriesDetailScreen.swift
    ├── ViewModel/
    │   └── SeriesDetailViewModel.swift
    ├── Service/
    │   └── SeriesDetailService.swift
    └── Cell/
        ├── SeriesImageTableViewCell.swift
        └── SeriesInfoTableViewCell.swift
```

### **Arquivos a MODIFICAR:**

```
Feature/TabBar/
├── TabBarController.swift              ← Adicionar aba de séries
```

### **Arquivos a REUSAR (sem modificar):**

```
✅ NetworkService.swift                 ← Já é genérico
✅ NetworkLogger.swift                  ← Já é genérico
✅ ValidationHelper.swift               ← Pode usar se precisar
✅ AppTransition.swift                  ← Pode usar
✅ ImageCache.swift                     ← Pode reusar
✅ AsyncImageLoader.swift               ← Pode reusar
✅ ErrorTableViewCell.swift             ← Pode reusar
✅ EmptyTableViewCell.swift             ← Pode reusar
```

---

## 6. COMPARAÇÃO: FILMES vs SÉRIES

### **Layout Visual:**
```
FILMES                          SÉRIES
┌────────────────────┐          ┌────────────────────┐
│ FILMES     [☰]     │          │ SÉRIES     [☰]     │
├────────────────────┤          ├────────────────────┤
│ [🔍 Filmes...]     │          │ [🔍 Séries...]     │
├────────────────────┤          ├────────────────────┤
│ POPULARES          │          │ POPULARES          │
│ [P] [P] [P] ►      │          │ [P] [P] [P] ►      │
├────────────────────┤          ├────────────────────┤
│ DRAMA              │          │ TOP RATED          │
│ [P] [P] [P] ►      │          │ [P] [P] [P] ►      │
├────────────────────┤          ├────────────────────┤
│ AÇÃO               │          │ EM ALTA            │
│ [P] [P] [P] ►      │          │ [P] [P] [P] ►      │
└────────────────────┘          └────────────────────┘

✅ VISUALMENTE IDÊNTICO!
```

### **Funcionalidades:**

| Feature | Filmes | Séries | Diferença |
|---------|--------|--------|-----------|
| SearchBar | ✅ | ✅ | Nenhuma |
| Menu Gêneros | ✅ | ✅ | Endpoints diferentes |
| Scroll Infinito | ✅ | ✅ | Lógica igual |
| Cards Poster | ✅ | ✅ | Reutiliza AsyncImageLoader |
| Paginação | ✅ | ✅ | Mesmo padrão |
| Tela Detalhes | ✅ | ✅ | Campos específicos série |

---

## 7. REUTILIZAÇÃO DE COMPONENTES

### **PODE REUSAR (100% seguro):**

✅ `AsyncImageLoader.swift`
- Carrega imagens de forma assíncrona
- Funciona com qualquer URL
- Usa ImageCache genérico

✅ `ImageCache.swift`
- Cache de memória genérico
- Não tem dependência de filmes

✅ `NetworkService.swift`
- Request HTTP genérico
- Funciona com qualquer Decodable

✅ `NetworkLogger.swift`
- Log de requisições genérico

✅ `AppTransition.swift`
- Transição de window genérica

✅ `ErrorTableViewCell.swift`
- Célula de erro reutilizável
- Sem referência a filme específico

✅ `EmptyTableViewCell.swift`
- Célula de lista vazia reutilizável
- Sem referência a filme específico

### **NÃO PODE REUSAR (campos diferentes):**

❌ `MovieTableViewCell.swift`
- ❌ Referencia MovieSummary
- ❌ Hard-coded para filmes
- ✅ Copiar e adaptar para SeriesTableViewCell

❌ `MovieDetail.swift`
- ❌ Campos específicos de filme
- ✅ Criar SeriesDetail.swift novo

❌ `MovieList.swift` + `MovieSummary.swift`
- ❌ Campos como "title", "release_date"
- ✅ Criar SeriesList.swift + SeriesSummary.swift

❌ `CategoryMenuViewController.swift`
- ❌ Usa MovieGenre enum
- ✅ Pode reusar estrutura, mas criar SeriesCategoryMenuViewController

---

## 8. COMO O LAYOUT FICA NA PRÁTICA

### **Estado Inicial - Carregando:**
```
┌─────────────────────────────────────┐
│  SÉRIES                      [☰]    │
├─────────────────────────────────────┤
│ [🔍 Pesquisar série...]             │
├─────────────────────────────────────┤
│                                     │
│  Carregando séries populares...     │
│                                     │
└─────────────────────────────────────┘
```

### **Estado com Dados:**
```
┌─────────────────────────────────────┐
│  SÉRIES                      [☰]    │
├─────────────────────────────────────┤
│ [🔍 Pesquisar série...]             │
├─────────────────────────────────────┤
│ SÉRIES POPULARES                    │
│ [GOT] [TBBT] [Breaking] [Stranger] │ ← CollectionView Horizontal
├─────────────────────────────────────┤
│ MAIS BEM AVALIADAS                  │
│ [Game] [Chernobyl] [The Boys] [...] │
├─────────────────────────────────────┤
│ EM ALTA                             │
│ [Dexter] [Suits] [Fargo] [House]   │
├─────────────────────────────────────┤
│ DRAMA                               │
│ [Série1] [Série2] [Série3] [...]    │
├─────────────────────────────────────┤
│ COMÉDIA                             │
│ [Office] [Parks] [Friends] [...]    │
└─────────────────────────────────────┘
```

### **Com Menu de Gêneros Aberto:**
```
Lado Esquerdo:                 Lado Direito:
┌─────────────────────────┐   ┌────────────────────┐
│ SÉRIES       [☰] ←Clicado  │ GÊNEROS SÉRIES │
├─────────────────────────┤   ├────────────────────┤
│ [🔍 Pesquisar...]       │   │ ☐ Todos            │
├─────────────────────────┤   │ ☐ Drama            │
│ SÉRIES POPULARES        │   │ ☑ Ação e Aventura  │
│ [cards...]              │   │ ☐ Comédia          │
│                         │   │ ☐ Animação         │
│                         │   │ ☐ Suspense         │
│                         │   │ ☐ Crime            │
│                         │   └────────────────────┘
└─────────────────────────┘
```

### **Depois de Selecionar Gênero:**
```
┌─────────────────────────────────────┐
│  SÉRIES - AÇÃO E AVENTURA    [☰]    │
├─────────────────────────────────────┤
│ [🔍 Pesquisar série...]             │
├─────────────────────────────────────┤
│ AÇÃO E AVENTURA - POPULARES         │
│ [Série1] [Série2] [Série3] [...]    │
├─────────────────────────────────────┤
│ AÇÃO E AVENTURA - TOP RATED         │
│ [Série1] [Série2] [Série3] [...]    │
├─────────────────────────────────────┤
│ AÇÃO E AVENTURA - EM ALTA           │
│ [Série1] [Série2] [Série3] [...]    │
└─────────────────────────────────────┘
```

### **Clicando em Uma Série:**
```
┌─────────────────────────────────────┐
│  Game of Thrones                    │
├─────────────────────────────────────┤
│                                     │
│  [Grande imagem/poster]             │
│                                     │
├─────────────────────────────────────┤
│ INFORMAÇÕES                         │
│ Título: Game of Thrones             │
│ Tipo: Série Dramática               │
│ Temporadas: 8                       │
│ Episódios: 73                       │
│ Status: Finalizado                  │
│ Nota: ⭐ 9.2/10                      │
│ Sinopse: Lorem ipsum...             │
│ Rede: HBO                           │
│                                     │
│ [✓ Assistir] [➕ Favoritos]        │
└─────────────────────────────────────┘
```

---

## 9. FLUXO DE DADOS

### **Carregar Séries Populares:**
```
SeriesViewController.viewDidLoad()
    ↓
SeriesViewModel.fetchPopularSeries()
    ↓
SeriesService.fetchPopularSeries(page: 1)
    ↓
NetworkService.request<SeriesList>()
    ↓
API: /tv/popular?page=1
    ↓
Response: { results: [SeriesSummary], totalPages: X }
    ↓
SeriesViewModel.movieDataList += newSeries  ← APPEND!
    ↓
SeriesViewController.success()
    ↓
screen?.tableView.reloadData()
```

### **Carregar Mais Séries (Scroll Infinito):**
```
User scrollView(_ scrollView:, didScroll:)
    ↓
Detecta: offset > contentHeight - threshold
    ↓
SeriesViewModel.fetchNextPage()
    ↓
SeriesService.fetchPopularSeries(page: 2)
    ↓
API: /tv/popular?page=2
    ↓
Response: { results: [SeriesSummary], totalPages: X }
    ↓
SeriesViewModel.movieDataList += newSeries  ← APPEND!
    ↓
SeriesViewController.success()
    ↓
screen?.tableView.reloadData()
```

### **Filtrar por Gênero:**
```
User clica em gênero "Drama"
    ↓
SeriesCategoryMenuViewController.delegate.selectCategory()
    ↓
SeriesViewController.selectCategory(drama)
    ↓
SeriesViewModel.fetchGenre(drama)
    ↓
currentPage = 1  ← RESET!
    ↓
SeriesViewModel.movieDataList = []  ← LIMPAR!
    ↓
SeriesService.fetchSeriesByGenre(18, page: 1)  ← 18 = Drama ID
    ↓
API: /discover/tv?with_genres=18&page=1
    ↓
Response: { results: [SeriesSummary], totalPages: X }
    ↓
SeriesViewModel.movieDataList = newSeries  ← SOBRESCREVER!
    ↓
SeriesViewController.success()
    ↓
screen?.tableView.reloadData()
```

---

## 10. SEGURANÇA E RISCO

### **Risco de Quebrar Filmes: 🟢 ZERO**

```
❌ NÃO vamos alterar:
  - HomeViewController
  - HomeViewModel
  - HomeService
  - MovieTableViewCell
  - MovieDetail
  - TabBarController.viewControllers (só adicionar)

✅ Vamos apenas ADICIONAR:
  - SeriesViewController
  - SeriesViewModel
  - SeriesService
  - SeriesTableViewCell
  - SeriesDetail
  - Modificar TabBarController.setupTabBar()
```

### **Modificação TabBarController (100% Segura):**

```swift
// ANTES
let home = createNavController(...HomeViewController...)
let settings = createNavController(...SettingsViewController...)
viewControllers = [home, settings]

// DEPOIS
let home = createNavController(...HomeViewController...)
let series = createNavController(...SeriesViewController...)  // NOVO!
let settings = createNavController(...SettingsViewController...)
viewControllers = [home, series, settings]  // Só adiciona!
```

**Por que é seguro?**
- Apenas adiciona nova aba
- Não altera lógica existente
- Cada aba é independente
- Nenhuma alteração em NavigationController

---

## 11. RESUMO FINAL

| Aspecto | Descrição |
|--------|-----------|
| **Layout** | Idêntico ao de filmes |
| **TableView** | Sim, com seções horizontais |
| **CollectionView** | Sim, horizontal dentro de cada seção |
| **Scroll Principal** | Vertical (entre categorias) |
| **Scroll Secundário** | Horizontal (entre séries) |
| **Menu Gêneros** | Sim, novo menu para séries |
| **SearchBar** | Sim, igual à de filmes |
| **Paginação** | Sim, scroll infinito |
| **Tela Detalhes** | Sim, nova tela para séries |
| **Risco** | 🟢 ZERO de quebrar filmes |
| **Arquivos Novos** | ~15-20 |
| **Arquivos Modificados** | 1 (TabBar) |
| **Tempo Estimado** | 3-4 horas |

---

## 12. PRÓXIMOS PASSOS

Se você concordar com esse plano, vamos:

1. ✅ Criar models de séries (SeriesList, SeriesSummary, SeriesDetail)
2. ✅ Criar SeriesService com endpoints de séries
3. ✅ Criar SeriesViewModel com lógica de paginação
4. ✅ Criar SeriesScreen com layout
5. ✅ Criar SeriesViewController como controller principal
6. ✅ Criar SeriesTableViewCell e SeriesCollectionViewCell
7. ✅ Criar SeriesCategoryMenuViewController para gêneros
8. ✅ Criar SeriesDetailViewController para tela de detalhes
9. ✅ Modificar TabBarController para adicionar aba
10. ✅ Testar tudo funcionando

**Quer que eu comece? 🚀**
