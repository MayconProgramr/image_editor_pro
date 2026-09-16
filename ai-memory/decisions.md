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

---
> Decisões anteriores arquivadas em: ai-memory/history/decisions-history.md
