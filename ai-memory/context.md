# Contexto do Projeto

## Stack
- Flutter 3.47.0 (via fvm), Dart, plugin nativo Android + iOS
- Android: Kotlin/Java, pluginClass `ImageEditorProPlugin` (androidPackage `zeeshux7860.theindianappguy.image_editor_pro`)
- iOS: Swift, pluginClass `SwiftImageEditorProPlugin` (classe Swift direta, sem shim ObjC)
- Ícones da UI: `heroicons: ^0.11.0` (estilo outline) — substituiu `font_awesome_flutter`, que foi removido do `pubspec.yaml` por ficar sem uso.

## Arquitetura
- Repo é o próprio plugin fork `image_editor_pro` (github.com/MayconProgramr/image_editor_pro), consumido via dependência git por apps como `app-vistoria`.
- `example/` dentro do repo é o app de exemplo do próprio plugin (dependência `path: ../`).
- iOS suporta dual CocoaPods + Swift Package Manager (SPM):
  - `ios/image_editor_pro.podspec` — build via CocoaPods (`s.source_files = 'image_editor_pro/Sources/image_editor_pro/**/*'`)
  - `ios/image_editor_pro/Package.swift` — build via SPM, target único Swift, depende de `FlutterFramework`
  - Ambos apontam para o mesmo código-fonte em `ios/image_editor_pro/Sources/image_editor_pro/`

## Padrões e Convenções
- Claude nunca deve rodar o app (emulador Android/simulador iOS/Chrome) sozinho — validação visual é feita manualmente pelo usuário. Limitar validação a `flutter analyze`/testes estáticos.
- Pasta do package SPM no iOS **precisa** se chamar exatamente igual ao nome do package Dart (`image_editor_pro`), tanto o nome do diretório em `ios/` quanto (para dependências git) o nome do repositório no GitHub — SwiftPM deriva a "identity" do pacote a partir do nome do diretório/repo, não do campo `name:` do `Package.swift`.
- SPM (via integração do Xcode usada pelo Flutter) **não suporta** target com Swift + Objective-C misturados no mesmo target ("mixed language source files; feature not supported") — plugins com shim ObjC precisam remover o shim e apontar `pluginClass` direto pra classe Swift, ou dividir em dois targets separados.
- pubspec.yaml usa o formato moderno `flutter.plugin.platforms` (android/ios separados), não mais o campo legado único `pluginClass` compartilhado entre plataformas.
- Configuração Android (`example/android`) deve ficar alinhada com a do app real consumidor `app-vistoria` (Gradle, AGP, Kotlin, compileSdk, ndkVersion) — são projetos irmãos e `app-vistoria` já builda em produção, então serve de referência quando o `example/` estiver desatualizado.

## Estrutura Relevante
- `ios/image_editor_pro/Sources/image_editor_pro/SwiftImageEditorProPlugin.swift` — implementação única do plugin no iOS
- `ios/image_editor_pro/Package.swift` — manifesto SPM
- `ios/image_editor_pro.podspec` — manifesto CocoaPods
- Consumidor real testado: `../app-vistoria` (pubspec.yaml usa `git: url + ref` apontando pra tag deste repo)
