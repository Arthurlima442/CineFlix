# ✅ PARTE 4 CONCLUÍDA - CÉLULAS DE UI PARA SÉRIES

## PARTE 4: CELLS ✅

### Arquivos Criados/Validados:
1. **SeriesTableViewCell.swift** - Card de série individual
2. **EmptySeriesTableViewCell.swift** - Mensagem quando nenhuma série
3. **ErrorSeriesTableViewCell.swift** - Mensagem de erro

---

## 📋 SERIESSTABLEVIEWCELL - DETALHADO

### Propósito:
Exibir UMA série individual na TableView com:
- Imagem de poster
- Nome da série
- Data de estreia
- Gêneros

### UI Layout:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ┌──────────┐  Nome Série                          │
│  │          │  Data Estreia                        │
│  │  POSTER  │  Gênero 1, Gênero 2                  │
│  │ 140x160  │                                      │
│  │          │                                      │
│  └──────────┘                                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Componentes:

#### seriesImageView
- UIImageView com tamanho fixo 140x160pt
- `contentMode = .scaleToFill` (preenche o espaço)
- `cornerRadius = 15` (bordas arredondadas)
- `clipsToBounds = true` (respeita o radius)
- Imagem carregada via AsyncImageLoader (reutilizado)

#### nameSeriesLabel
- Título da série
- Font: 19pt semibold
- Color: white
- Max 2 linhas (se nome muito longo, quebra)

#### firstAirDateLabel
- Data de estreia formatada via Util.formatReleaseDate()
- Font: 17pt semibold
- Color: white
- 1 linha

#### genreSeriesLabel
- Lista de gêneros separados por ", "
- Font: 17pt semibold
- Color: white
- Max 2 linhas

### Constraints (Layout):

```
seriesImageView:
  - top: contentView.top + 14pt
  - leading: contentView.leading + 10pt
  - width: 140pt
  - height: 160pt
  - bottom: contentView.bottom

nameSeriesLabel:
  - top: seriesImageView.top + 10pt
  - leading: seriesImageView.trailing + 10pt
  - trailing: contentView.trailing - 5pt

firstAirDateLabel:
  - top: nameSeriesLabel.bottom + 10pt
  - leading: seriesImageView.trailing + 10pt
  - trailing: contentView.trailing - 5pt

genreSeriesLabel:
  - top: firstAirDateLabel.bottom + 10pt
  - leading: seriesImageView.trailing + 10pt
  - trailing: contentView.trailing - 5pt
```

### setupCell(seriesData:)

```swift
func setupCell(seriesData: SeriesSummary) {
    // 1. URL da imagem
    guard let url = URL(string: "https://image.tmdb.org/t/p/w200\(seriesData.posterPath ?? "")") else { return }
    
    // 2. Carrega imagem com placeholder
    seriesImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "hourglass"))
    
    // 3. Popula nome
    nameSeriesLabel.text = seriesData.name
    
    // 4. Formata e popula data
    firstAirDateLabel.text = Util.formatReleaseDate(seriesData.firstAirDate)
    
    // 5. Mapeia IDs de gênero para nomes
    let genreMap = Dictionary(uniqueKeysWithValues: SeriesGenre.allCases.map { ($0.rawValue, $0.displayName) })
    
    // 6. Converte array de IDs para nomes e junta com ", "
    genreSeriesLabel.text = seriesData.genreIds
        .compactMap { genreMap[$0] }
        .joined(separator: ", ")
}
```

### Fluxo de Reutilização:

1. **Primeira exibição:**
   - SeriesViewController desqua célula
   - setupCell() é chamado
   - Constraints aplicadas
   - Imagem começa a carregar

2. **Scroll para fora:**
   - Célula é reutilizada (não recria)
   - prepareForReuse() é chamado (se implementado)

3. **Scroll de volta:**
   - Nova série é exibida
   - setupCell() atualiza dados
   - Imagem pode estar em cache ou carrega novamente

### Cache de Imagem:

- `AsyncImageLoader.loadImageFromURL()` reutiliza `ImageCache.shared`
- Primeira vez: baixa da API e salva em cache
- Segunda vez mesma série: carrega do cache instantaneamente
- Seguro: cache usa URL como chave, não colide entre filmes/séries

---

## 📋 EMPTYSERIESTAWLEVIEWCELL - DETALHADO

### Propósito:
Mostrar mensagem amigável quando nenhuma série é encontrada

### UI Layout:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│              Nenhuma série encontrada               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Componentes:

#### emptyLabel
- UILabel com mensagem
- Font: 20pt semibold
- Color: white
- Text alignment: center
- Max linhas: ilimitado (para mensagens longas)

### Constraints:

```
emptyLabel:
  - top: contentView.top + 20pt
  - leading: contentView.leading + 20pt
  - trailing: contentView.trailing - 20pt
  - bottom: contentView.bottom - 20pt
  - height: 100pt (mínimo)
```

### setupCell(with:)

```swift
func setupCell(with message: String = "No series found") {
    emptyLabel.text = message
}
```

### Quando é Usada:

No `SeriesViewController`:
```swift
if viewModel.isNamesEmpty {
    cell = EmptySeriesTableViewCell()
    cell.setupCell(with: "Nenhuma série encontrada para sua busca")
}
```

---

## 📋 ERRORSERIESTAWLEVIEWCELL - DETALHADO

### Propósito:
Mostrar mensagem de erro quando API falha

### UI Layout:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│      Infelizmente tivemos um erro, tente            │
│      novamente mais tarde                           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Componentes:

#### errorLabel
- UILabel com mensagem de erro
- Font: 20pt semibold
- Color: white
- Text alignment: center
- Max linhas: ilimitado (quebra automaticamente)

### Constraints:

```
errorLabel:
  - top: contentView.top + 20pt
  - leading: contentView.leading + 20pt
  - trailing: contentView.trailing - 20pt
  - bottom: contentView.bottom - 20pt
```

### setupCell(message:)

```swift
func setupCell(message: String) {
    errorLabel.text = message
}
```

### Quando é Usada:

No `SeriesViewController`:
```swift
if viewModel.isError {
    cell = ErrorSeriesTableViewCell()
    cell.setupCell(message: "Infelizmente tivemos um erro, tente novamente mais tarde")
}
```

---

## 🔄 FLUXO DE TABLEVIEW NO SERIESVIEWCONTROLLER

### numberOfRowsInSection:

```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfNames() // Retorna 1 se error/empty, ou count de séries
}
```

### cellForRowAt:

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.isError {
        // Mostra ErrorSeriesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: ErrorSeriesTableViewCell.identifier, for: indexPath) as? ErrorSeriesTableViewCell
        cell?.setupCell(message: "Infelizmente tivemos um erro, tente novamente mais tarde")
        return cell ?? UITableViewCell()
    } else if viewModel.isNamesEmpty {
        // Mostra EmptySeriesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptySeriesTableViewCell.identifier, for: indexPath) as? EmptySeriesTableViewCell
        cell?.setupCell(with: "Nenhuma série encontrada")
        return cell ?? UITableViewCell()
    } else {
        // Mostra SeriesTableViewCell com dados
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath) as? SeriesTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(seriesData: viewModel.loadCurrentSeriesSection(indexPath: indexPath))
        return cell
    }
}
```

### didSelectRowAt:

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let series = viewModel.loadCurrentSeriesSection(indexPath: indexPath)
    navigationController?.pushViewController(SeriesDetailViewController(idSeries: series.id), animated: true)
    navigationItem.backButtonTitle = "Voltar"
}
```

---

## ✅ CHECKLIST PARTE 4

- ✅ SeriesTableViewCell criada com layout correto
- ✅ Imagem 140x160pt com cornerRadius 15
- ✅ Constraints firmes (Auto Layout)
- ✅ Usa AsyncImageLoader para carregar imagem
- ✅ Usa ImageCache.shared (reutilizado)
- ✅ Mapeia IDs de gênero para displayName
- ✅ EmptySeriesTableViewCell criada
- ✅ ErrorSeriesTableViewCell criada
- ✅ Todas compilam sem erros
- ✅ Prontas para serem registradas na TableView do SeriesViewController

---

## 🚨 DETALHES IMPORTANTES

### Sobre ImageView:
- `contentMode = .scaleToFill` preenche o espaço (pode cortar imagem)
- `clipsToBounds = true` respeita o cornerRadius
- Placeholder: UIImage(systemName: "hourglass") - ícone enquanto carrega
- URL formato: `https://image.tmdb.org/t/p/w200` + posterPath

### Sobre Gêneros:
- `SeriesGenre.allCases` retorna todos os casos do enum
- `map { ($0.rawValue, $0.displayName) }` cria dicionário [Int: String]
- `Dictionary(uniqueKeysWithValues:)` converte para dicionário
- `compactMap` ignora IDs que não existem
- `joined(separator: ", ")` junta em string

### Sobre Constraints:
- Leading/Trailing: 10pt e 5pt (espaçamento lateral)
- Top: 14pt para imagem (um pouco de espaço)
- Labels alinhadas com topo da imagem
- Sem height mínima para célula (usa componentes)

### Sobre Cache:
- ImageCache.shared é global (compartilhado entre filmes e séries)
- Cache seguro porque usa URL como chave (única por poster)
- Série A poster = séries/1.jpg, Filme A poster = movies/1.jpg (URLs diferentes)
- Não há conflito entre filmes e séries

---

## 🔗 DEPENDÊNCIAS

- ✅ AsyncImageLoader (reutilizado)
- ✅ ImageCache (reutilizado)
- ✅ SeriesSummary (criado PARTE 1)
- ✅ SeriesGenre (criado PARTE 1)
- ✅ Util.formatReleaseDate() (reutilizado)

---

## 📝 PRÓXIMAS ETAPAS

**PARTE 5:** Criar SeriesScreen (layout da tela principal)

Screen precisa:
- UIView base
- SafeAreaTopBackground
- SearchBar
- MenuButton (para gêneros)
- TableView registrada com as 3 células

