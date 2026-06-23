# 📋 PARTE 7: CATEGORYMENU PARA SÉRIES (Próxima Etapa)

## O QUE VOU FAZER NA PARTE 7

Vou criar o menu de gêneros de séries (exatamente como existe para filmes), mas totalmente separado e dentro de Feature/Series.

---

## 🎯 ESTRUTURA PARA CRIAR

```
Feature/Series/CategoryMenu/
├── SeriesCategoryMenuViewController.swift   (NEW)
├── SeriesCategoryMenuViewModel.swift        (NEW)
├── Cell/
│   └── SeriesCategoryTableViewCell.swift    (NEW)
└── Screen/
    └── SeriesCategoryMenuScreen.swift       (NEW)
```

---

## 📝 ARQUIVOS QUE VOU COPIAR COMO BASE

### 1. De CategoryHome/CategoryMenuViewController.swift
→ Para Series/CategoryMenu/SeriesCategoryMenuViewController.swift

Mudanças:
- Classe: CategoryMenuViewController → SeriesCategoryMenuViewController
- Protocol: CategoryMenuViewControllerProtocol → SeriesCategoryMenuViewControllerProtocol
- Init: género: MovieGenre → género: SeriesGenre
- ViewModel: CategoryMenuViewModel → SeriesCategoryMenuViewModel

### 2. De CategoryHome/CategoryMenuViewModel.swift
→ Para Series/CategoryMenu/SeriesCategoryMenuViewModel.swift

Mudanças:
- Classe: CategoryMenuViewModel → SeriesCategoryMenuViewModel
- Protocol: CategoryMenuViewModelProtocol → SeriesCategoryMenuViewModelProtocol
- Genre: MovieGenre → SeriesGenre
- Array: MovieGenre.allCases → SeriesGenre.allCases
- GenreItem: GenreItem(genre: MovieGenre) → SeriesGenreItem(genre: SeriesGenre)

### 3. De CategoryHome/Screen/CategoryMenuScreen.swift
→ Para Series/CategoryMenu/Screen/SeriesCategoryMenuScreen.swift

Mudanças:
- Classe: CategoryMenuScreen → SeriesCategoryMenuScreen
- Protocol: CategoryMenuScreenProtocol → SeriesCategoryMenuScreenProtocol
- CellID: CategoryTableViewCell → SeriesCategoryTableViewCell
- Register: CategoryTableViewCell → SeriesCategoryTableViewCell

### 4. De CategoryHome/Cell/CategoryTableViewCell.swift
→ Para Series/CategoryMenu/Cell/SeriesCategoryTableViewCell.swift

Mudanças:
- Classe: CategoryTableViewCell → SeriesCategoryTableViewCell
- Setup: GenreItem → SeriesGenreItem
- DisplayName: genre.rawValue → genre.displayName

---

## ⚠️ DIFERENÇAS IMPORTANTES

### IDs de Gênero:
- **MovieGenre:** Ficção Científica = 878
- **SeriesGenre:** Ficção Científica = 10765

Não há conflito porque cada um está em seu próprio enum!

### Nomes de Gênero:
- **MovieGenre:** Usa `rawValue` para nomes (ex: "Ficção Científica")
- **SeriesGenre:** Usa `displayName` para nomes (ex: "Ficção Científica")

Função setupCell em SeriesCategoryTableViewCell:
```swift
func setupCell(genre: SeriesGenreItem) {
    genreLabel.text = genre.genre.displayName  // ← Usar displayName!
    checkmark.isHidden = !genre.isSelected
}
```

---

## 🔄 FLUXO DE USUÁRIO

```
1. Usuário toca MenuButton na SeriesScreen
   ↓
2. SeriesViewController.tappedPresentCategoryMenu() chamado
   ↓
3. SeriesCategoryMenuViewController criada e apresentada como modal
   ↓
4. Modal escorrega da esquerda (LeftSideTransitioningDelegate)
   ↓
5. Usuário vê lista de 20 gêneros
   ↓
6. Usuário toca um gênero (ex: Drama)
   ↓
7. SeriesCategoryMenuViewController.didSelectRowAt() chamado
   ↓
8. delegate?.selectCategory(genreItem:) chamado
   ↓
9. SeriesViewController.selectCategory() chamado
   ↓
10. viewModel.fetchGenre(genre:) chamado
    ↓
11. SeriesService.fetchSeriesByGenre(genre:, page: 1) chamado
    ↓
12. API: GET /discover/tv?with_genres=18
    ↓
13. Retorna séries do gênero Drama
    ↓
14. Modal fecha automaticamente
    ↓
15. SeriesViewController.tableView.reloadData()
    ↓
16. User vê séries de Drama
```

---

## ✅ CHECKLIST PARTE 7

Quando criada, verificar:

- [ ] SeriesCategoryMenuViewController compila
- [ ] SeriesCategoryMenuViewModel compila
- [ ] SeriesCategoryMenuScreen compila
- [ ] SeriesCategoryTableViewCell compila
- [ ] Tocar MenuButton abre modal
- [ ] Modal escorrega da esquerda
- [ ] Lista mostra todos os 20 gêneros
- [ ] Tocar gênero filtra séries
- [ ] Modal fecha automaticamente
- [ ] Voltar: lista retorna ao original (não aplica select)
- [ ] Selecionar mesmo gênero 2x: não faz duplicate request
- [ ] Gêneros têm nomes em português

---

## 🎯 RESULTADO ESPERADO

Após PARTE 7:
- ✅ Tela de séries totalmente funcional
- ✅ Menu de gêneros funcionando
- ✅ Busca funcionando
- ✅ Scroll infinito funcionando
- ❌ Detalhes de série ainda não (PARTE 8)
- ❌ TabBar ainda não mostra Séries (PARTE 9)

---

## 📝 COMO PROCEDER

Quando você quiser prosseguir com PARTE 7, avise e farei:

1. Criar SeriesCategoryMenuViewController
2. Criar SeriesCategoryMenuViewModel
3. Criar SeriesCategoryMenuScreen
4. Criar SeriesCategoryTableViewCell
5. Testar fluxo completo
6. Documentar resultados

Cada arquivo será criado com explicações detalhadas!

