# Decisões Técnicas

## [2026-09-16] Adotar suporte dual CocoaPods + Swift Package Manager no iOS
- **Decisão:** Reestruturar `ios/Classes` para `ios/image_editor_pro/Sources/image_editor_pro/`, criar `ios/image_editor_pro/Package.swift` e manter `ios/image_editor_pro.podspec` apontando pro mesmo código-fonte.
- **Motivo:** Flutter emitia warning "does not support Swift Package Manager for ios" no build; isso vira erro em versão futura do Flutter. Suporte dual é o caminho recomendado pela documentação oficial do Flutter, sem forçar consumidores a abandonar CocoaPods imediatamente.

## [2026-09-16] Renomear repositório GitHub de EditorImagem para image_editor_pro
- **Decisão:** Renomear o repo no GitHub (`MayconProgramr/EditorImagem` → `MayconProgramr/image_editor_pro`) e atualizar a URL git em `app-vistoria/pubspec.yaml`.
- **Motivo:** SwiftPM deriva a "identity" do pacote a partir do nome do diretório de checkout (que para dependências git é o nome do repositório), não do campo `name:` do `Package.swift`. Com o nome do repo divergente do nome do package Dart, a resolução do Xcode falhava com `unable to override package 'image_editor_pro' because its identity 'editorimagem' doesn't match override's identity...`. Sem o rename, nenhum consumidor via git conseguiria resolver o pacote via SPM.

## [2026-09-16] Remover shim Objective-C e apontar pluginClass do iOS pra classe Swift
- **Decisão:** Excluir `ImageEditorProPlugin.m`/`.h` (shim que só repassava pra `SwiftImageEditorProPlugin`) e mudar `pubspec.yaml` pro formato `flutter.plugin.platforms.ios.pluginClass: SwiftImageEditorProPlugin`. Android manteve o pluginClass antigo via `flutter.plugin.platforms.android`.
- **Motivo:** Xcode/SwiftPM não resolve target com fontes Swift+ObjC misturadas no mesmo target ("mixed language source files; feature not supported"), mesmo em Xcode 27/Swift 6.4. Sem essa remoção o build via SPM falhava mesmo após corrigir a identidade do pacote. Comportamento do plugin não muda — o shim só encaminhava a chamada.

## [2026-09-16] Versionamento das mudanças de SPM
- **Decisão:** Publicadas como tags `v6.2` (estrutura SPM inicial) e `v6.3` (remoção do shim ObjC, versão que efetivamente builda). `app-vistoria/pubspec.yaml` aponta pra `v6.3`.
- **Motivo:** `v6.1` (tag anterior) não tem as mudanças de SPM; era necessário uma tag nova pro consumidor via git conseguir puxar o fix.

## [2026-09-16] Corrigir os 57 problemas do `flutter analyze` em lib/
- **Decisão:** Em `lib/image_editor_pro.dart` e `lib/modules/colors_picker.dart`: remover 6 campos mortos (nunca lidos, só escritos), trocar `WillPopScope`→`PopScope`, `ButtonBar`→`OverflowBar` (usando `spacing: 10` no lugar de `buttonPadding`, que não existe em `OverflowBar` — pode mudar sutilmente o espaçamento visual), `FontAwesomeIcons.smile`→`.faceSmile`, `.red/.green/.blue`→acessores `.r/.g/.b` (via helper `_channel` pra evitar repetir a fórmula 24x), `.value`→`.toARGB32()`, `showLabel: false`→`labelTypes: const []`, e remover 9 `assert(x != null)` mortos + 1 constante não usada em `colors_picker.dart`.
- **Motivo:** Usuário pediu pra corrigir o board de warnings/infos do analyzer (pré-existentes, expostos após o bump pro Flutter 3.47). Todas as substituições seguem exatamente a sugestão de replacement da mensagem de depreciação do próprio Flutter/pacotes, preservando comportamento.

## [2026-09-16] Alinhar config Android de example/ com app-vistoria
- **Decisão:** Em `example/android`: Gradle 8.9→8.14, AGP 8.7.2→8.11.1, Kotlin 1.8.22→2.2.20, `compileSdk` 35→36, `ndkVersion` "28.0.12674087 rc2" (valor inválido/com sufixo de release-candidate) → "28.0.12674087".
- **Motivo:** Build Android do `example/` estava falhando (`Gradle version... is lower than Flutter's minimum supported version` e depois erro do `sdkmanager` por causa do ndkVersion malformado). `app-vistoria` já builda em produção com essas versões, serviu de referência pra não ter que decidir valores no escuro.

## [2026-09-16] Tag v6.4 pras correções de lint + Android
- **Decisão:** Publicada tag `v6.4` (lint fix em `lib/` + alinhamento Android do `example/`), `app-vistoria/pubspec.yaml` apontado pra `v6.4`. Validado com `pub get` + `flutter analyze` (limpo) + `pod install` + `flutter build ios --simulator --no-codesign` (sucesso) direto em `app-vistoria`.
- **Motivo:** Consumidor real só recebe correções de uma tag nova; `v6.3` não tinha os fixes de lint/Android feitos nesta sessão.

## [2026-09-18] Redesign visual do editor de imagem (Pintar/Texto/Emoji/Limpar)
- **Decisão:** Substituídos `FontAwesomeIcons`/`Icons.*` por `HeroIcon` (estilo outline, pacote `heroicons: ^0.11.0`) na AppBar, na toolbar inferior (Pintar/Texto/Emoji/Limpar), no diálogo de cor/tamanho (`FontSizePickerDialog`/`Sliders`) e no bottom sheet de emoji (`Emojies`). Botão "Salvar" da AppBar passou de `TextButton` cru pra pill branco preenchido. `FontSizePickerDialog` e os bottom sheets (`Sliders`, `Emojies`) ganharam cantos arredondados. Toolbar ganhou `minimumSize` nos botões pra tap target melhor. Removida a dependência `font_awesome_flutter` (ficou sem nenhum uso após a troca).
- **Motivo:** Alinhar a única tela do fluxo de fotos que ainda não tinha passado pelo redesign visual "SAMI Design System" do `app-vistoria` (chrome claro, ícones outline, radius 8-12px), conforme `CONTEXTO_REDESIGN.md`. Contrato público do widget (`ImageEditorPro`) e a lógica de desenho/texto/emoji/salvar foram preservados; cores continuam vindo de `appBarColor`/`bottomBarColor` (pacote consumido por mais de um app).

## [2026-09-18] Validação de UI restrita a `flutter analyze`, sem rodar o app
- **Decisão:** Nesta sessão a validação do redesign visual ficou limitada a `flutter analyze` (limpo em `lib/` e `example/`) — sem build/run em emulador Android nem simulador iOS.
- **Motivo:** Usuário pediu explicitamente pra nunca rodar o app/emulador por conta própria; validação visual real é feita manualmente por ele em Android/iOS.

---
> Decisões anteriores arquivadas em: ai-memory/history/decisions-history.md
