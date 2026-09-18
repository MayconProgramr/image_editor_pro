# Contexto — Redesign visual do ImageEditorPro (screen Pintar/Texto/Emoji/Limpar)

## Onde estamos

Este repo (`image_editor_pro`, package Flutter — plugin com canal nativo
Android/iOS) é consumido como dependência git por outro projeto irmão,
`app-vistoria` (`~/Desktop/Apps/App_Sami_Vistoria/app-vistoria`), via
`pubspec.yaml`:

```yaml
image_editor_pro:
  git:
    url: git@github.com:MayconProgramr/EditorImagem.git
    ref: v6.4
```

O app-vistoria está no meio de um redesign visual completo ("SAMI Design
System", branch `feat/new-layout`) — todas as telas principais já migradas
pra um visual novo: chrome claro (AppBar branca), paleta azul institucional
(`AppColors.primary` = `#1A4592`), tipografia Inter (texto) + JetBrains Mono
(labels/overlines em uppercase), ícones via pacote `heroicons` (Heroicons v2
outline, SVG) — não mais `Icons.*`/`FontAwesomeIcons` do Material.

A ÚNICA tela do fluxo de fotos que ainda ficou pra trás nesse redesign é
esta aqui: o editor de imagem (Pintar/Texto/Emoji/Limpar) que abre quando o
usuário toca em "Editar" numa foto — porque ela vive NESTE repo separado,
não no app-vistoria.

## O que existe hoje (`lib/image_editor_pro.dart`)

- `ImageEditorPro` (StatefulWidget) — construtor recebe `appBarColor`,
  `bottomBarColor`, `defaultImage`, `pathSave`, `nameSave`,
  `backgroundScaffold`. **Esse contrato público não pode mudar** — é assim
  que o app-vistoria chama (`lib/pages/fotosComodo.dart`/`fotosItem.dart`,
  função `getimageditor()`), e o retorno via `Navigator.pop(context, file)`
  (um `File` do JPG salvo) também precisa continuar igual.
- `AppBar`: leading seta voltar (`Icons.arrow_back`), sem título, action
  único `TextButton("Salvar", branco)` que faz `screenshotController.capture()`
  do canvas e salva o arquivo.
- Corpo: canvas (imagem + assinatura/desenho via `Signature` + emojis/textos
  arrastáveis sobrepostos).
- `bottomNavigationBar`: `Container` altura 80, cor `bottomBarColor`,
  `OverflowBar` com 4 `TextButton` (ícone+label em `Column`, tudo branco):
  - **Pintar** (`FontAwesomeIcons.brush`) — abre `AlertDialog` padrão
    (`FontSizePickerDialog`) com `ColorPicker` + slider de espessura.
  - **Texto** (`Icons.text_fields`) — abre `TextEditor` (outra tela
    full-screen, `modules/text.dart`).
  - **Emoji** (`FontAwesomeIcons.faceSmile`) — abre `showModalBottomSheet`
    com grid de emojis (`modules/emoji.dart`, `modules/all_emojies.dart`).
  - **Limpar** (`FontAwesomeIcons.eraser`) — limpa tudo (desenho/texto/emoji).

Cores hoje são só as passadas via `appBarColor`/`bottomBarColor` — o resto
(ícones brancos fixos, `TextButton` sem estilo, `AlertDialog` padrão do
Material pro seletor de cor/tamanho) está todo hardcoded, sem seguir
nenhum design system.

## Referência de paleta/tipografia (app-vistoria)

Não dá pra importar direto (`image_editor_pro` é um package standalone, não
depende do app-vistoria) — mas os valores-fonte, pra manter os dois visuais
consistentes, estão em:

- `~/Desktop/Apps/App_Sami_Vistoria/app-vistoria/lib/theme/app_colors.dart`
  (primary500 `#1A4592`, neutral0-800, danger/warning/success 50-700 etc.)
- `~/Desktop/Apps/App_Sami_Vistoria/app-vistoria/lib/theme/app_typography.dart`
  (`AppFonts.inter`/`AppFonts.mono`, helpers `AppText.mono()`/`.overline()`)

Pacote `heroicons: ^0.11.0` (mesma versão do app-vistoria) pode ser
adicionado como dependência aqui sem problema — está no pub.dev, não é fork.

## O que fazer

Modernizar a casca visual desta tela (AppBar + bottom toolbar + diálogos de
cor/tamanho/emoji) pra bater com a linguagem visual do app-vistoria — SEM
mexer na lógica de desenho/texto/emoji/salvar (isso já funciona, é só
reembalar).

Sugestões de direção (não é obrigatório seguir à risca — ajustar conforme
fizer sentido olhando o resultado):

- Trocar `FontAwesomeIcons`/`Icons.*` por `HeroIcon` (outline) nos 4 botões
  da toolbar e no botão salvar/voltar.
- Botão "Salvar" da AppBar como botão preenchido (pill/rounded) em vez de
  `TextButton` cru — mesmo padrão de affordance que o app-vistoria usa
  (`AppModalFilledButton`, mas esse widget É do app-vistoria, não dá pra
  importar aqui — replicar o ESTILO visual, não o widget).
- Manter as cores vindo de `appBarColor`/`bottomBarColor` (não hardcodar o
  azul institucional aqui dentro — o pacote é usado por mais de um app; ver
  `app-vistoria/CLAUDE.md`: SAMI Leitura é um app irmão que também consome
  este fork).
- `FontSizePickerDialog` (seletor cor/espessura do pincel) e o bottom sheet
  de emoji podem ganhar cantos arredondados/tipografia consistente, mas são
  telas do Material padrão hoje — dá pra deixar mais "fino" sem reescrever
  a lógica de `ColorPicker`/slider.
- Ícones/labels da toolbar: tamanho, espaçamento, tap target — hoje é só
  `TextButton` com `Column` solta, sem preocupação de acessibilidade/toque.

## Não existe mockup específico desta tela ainda

Diferente das outras telas do redesign (que tiveram print de referência
antes de cada implementação), esta aqui NÃO tem mockup pronto. Se precisar
de uma referência visual antes de implementar, é melhor perguntar ao usuário
por um print/spec em vez de inventar do zero — ele tem mockups de outras
telas internas do app-vistoria que podem servir de inspiração de tom (cores
sóbrias, ícones outline, radius 8-12px, sem sombra pesada).

## Validação

`flutter analyze` (0 problemas hoje) e testar via `example/` do próprio
pacote antes de publicar uma tag nova. Depois de pronto, o app-vistoria
precisa apontar `pubspec.yaml` pra nova tag/ref (mesmo fluxo já usado nas
migrações anteriores — ver `app-vistoria/ai-memory/decisions.md`, entradas
`[2026-08-18]`/`[2026-09-16]` sobre esse fork).
