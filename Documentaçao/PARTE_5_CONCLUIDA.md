# ✅ PARTE 5 CONCLUÍDA - SERIESSCREEN (LAYOUT)

## PARTE 5: SERIESSCREEN ✅

### Arquivo Criado:
**SeriesScreen.swift** - Layout da tela principal de séries

---

## 📋 SERIESSCREEN - DETALHADO

### Propósito:
Encapsular toda a UI (views, constraints, layout) de forma limpa e separada do ViewController.

Padrão UIView que contém:
- SafeAreaTopBackground
- SearchBar
- MenuButton
- TableView

### Arquitetura:

```
SeriesScreen (UIView)
├── safeAreaTopBackground (UIView - fundo preto)
├── searchBar (UISearchBar)
├── menuButton (UIButton)
└── tableView (UITableView)
```

### Componentes:

#### safeAreaTopBackground
- **Propósito:** Preencher espaço acima da safe area (onde fica notch/status bar)
- **Color:** black
- **Constraints:** top a top, leading/trailing full width, bottom na safeAreaLayoutGuide.top

#### searchBar
- **Placeholder:** "Buscar série"
- **Style:** minimal (sem background padrão)
- **Custom TextField:** dark gray background, borderRadius 10
- **Placeholder color:** white com 80% alpha
- **Constraints:** abaixo do menuButton, com 5pt de espaçamento

#### menuButton
- **Image:** "line.3.horizontal" (3 linhas - hambúrguer icon)
- **Color:** white
- **Background:** black
- **Border radius:** 8pt
- **Constraints:** top da safeArea + 20pt padding, leading 10pt
- **Action:** tappedPresentCategoryMenu() ao tocar

#### tableView
- **Células Registradas:**
  - SeriesTableViewCell
  - ErrorSeriesTableViewCell
  - EmptySeriesTableViewCell
- **Style:** plain (sem grouped)
- **Separator:** none
- **Bounces:** false
- **ContentInsetAdjustmentBehavior:** never (importante!)
- **Constraints:** full width, do fim da searchBar até bottom

### Layout Visual:

```
┌─────────────────────────────────────────┐
│ [safeAreaTopBackground]                 │ ← Acima da safe area
├─────────────────────────────────────────┤
│ ☰ [Search Box........................]   │ ← menuButton + searchBar
├─────────────────────────────────────────┤
│                                         │
│ [TableView com células de séries]       │
│                                         │
│ ┌────┐ Nome Série                      │
│ │ P │ Data Estreia                     │
│ │ O │ Gênero 1, Gênero 2               │
│ │ S │                                  │
│ │ T │                                  │
│ │ E │                                  │
│ │ R │                                  │
│ └────┘                                 │
│                                         │
└─────────────────────────────────────────┘
```

### Protocol: SeriesScreenProtocol

```swift
protocol SeriesScreenProtocol: AnyObject {
    func tappedPresentCategoryMenu()
}
```

- Define callback quando usuário toca menuButton
- Implementado por SeriesViewController
- Abre SeriesCategoryMenuViewController

### Métodos Públicos:

#### init()
- Cria view com background preto
- Adiciona todos os componentes
- Aplica constraints
- Define clipsToBounds = true

#### addElements()
- Adiciona todos os views ao rootView
- Ordem: safeAreaTopBackground, tableView, searchBar, menuButton

#### configConstraints()
- Define todas as constraints do layout
- Important: contentInsetAdjustmentBehavior = .never previne problemas com safe area na tableView

#### configTableViewProtocols(delegate:, dataSource:)
- Atribui delegate e dataSource da tableView
- Chamado pelo SeriesViewController

### Questões de Design:

**Por que separar em Screen?**
- ViewController fica focado em lógica
- Screen fica focado em UI
- Reutilização: poderia reutilizar SeriesScreen em outro ViewController se necessário
- Testabilidade: Screen pode ser testada isoladamente

**Por que clipsToBounds = true?**
- Garante que componentes não vazem para fora da view
- Essencial quando há transformações ou animações

**Por que contentInsetAdjustmentBehavior = .never?**
- Tableview não ajusta automaticamente com safe area
- Deixa a responsabilidade para as constraints
- Funciona melhor em layouts com SearchBar

---

## ✅ CHECKLIST PARTE 5

- ✅ SeriesScreen criada herdando de UIView
- ✅ Protocol SeriesScreenProtocol definido
- ✅ safeAreaTopBackground com cor correta
- ✅ SearchBar com placeholder e styling
- ✅ MenuButton com imagem e action
- ✅ TableView registrada com 3 tipos de célula
- ✅ Constraints aplicadas corretamente
- ✅ Layout responsivo (Auto Layout)
- ✅ Método configTableViewProtocols implementado
- ✅ Compila sem erros
- ✅ Segue padrão exato de HomeMovieScreen

---

## 🔗 DEPENDÊNCIAS

- ✅ SeriesTableViewCell (criado PARTE 4)
- ✅ EmptySeriesTableViewCell (criado PARTE 4)
- ✅ ErrorSeriesTableViewCell (criado PARTE 4)

---

## 🔄 RELAÇÃO COM SERIESVIEWCONTROLLER

SeriesViewController fará:

```swift
override func loadView() {
    screen = SeriesScreen()
    view = screen
}

func configScreen() {
    screen?.delegate = self
}

func configTableView() {
    screen?.configTableViewProtocols(delegate: self, dataSource: self)
}
```

---

## 📝 PRÓXIMAS ETAPAS

**PARTE 6:** Criar SeriesViewController (controla tudo)

ViewController precisa:
- Criar SeriesScreen no loadView
- Configurar delegates (Screen, TableView, SearchBar, ViewModel)
- Implementar UITableViewDelegate/DataSource
- Implementar UISearchBarDelegate
- Implementar SeriesScreenProtocol
- Implementar SeriesViewModelProtocol
- Implementar UIScrollViewDelegate (para infinite scroll)
- Inicializar busca ao abrir

