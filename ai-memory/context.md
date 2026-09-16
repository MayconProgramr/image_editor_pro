# Contexto do Projeto

## Stack
- Flutter 3.47.0 (via fvm), Dart, plugin nativo Android + iOS
- Android: Kotlin/Java, pluginClass `ImageEditorProPlugin` (androidPackage `zeeshux7860.theindianappguy.image_editor_pro`)
- iOS: Swift, pluginClass `SwiftImageEditorProPlugin` (classe Swift direta, sem shim ObjC)

## Arquitetura
- Repo é o próprio plugin fork `image_editor_pro` (github.com/MayconProgramr/image_editor_pro), consumido via dependência git por apps como `app-vistoria`.
- `example/` dentro do repo é o app de exemplo do próprio plugin (dependência `path: ../`).
- iOS suporta dual CocoaPods + Swift Package Manager (SPM):
  - `ios/image_editor_pro.podspec` — build via CocoaPods (`s.source_files = 'image_editor_pro/Sources/image_editor_pro/**/*'`)
  - `ios/image_editor_pro/Package.swift` — build via SPM, target único Swift, depende de `FlutterFramework`
  - Ambos apontam para o mesmo código-fonte em `ios/image_editor_pro/Sources/image_editor_pro/`

## Padrões e Convenções
- Pasta do package SPM no iOS **precisa** se chamar exatamente igual ao nome do package Dart (`image_editor_pro`), tanto o nome do diretório em `ios/` quanto (para dependências git) o nome do repositório no GitHub — SwiftPM deriva a "identity" do pacote a partir do nome do diretório/repo, não do campo `name:` do `Package.swift`.
- SPM (via integração do Xcode usada pelo Flutter) **não suporta** target com Swift + Objective-C misturados no mesmo target ("mixed language source files; feature not supported") — plugins com shim ObjC precisam remover o shim e apontar `pluginClass` direto pra classe Swift, ou dividir em dois targets separados.
- pubspec.yaml usa o formato moderno `flutter.plugin.platforms` (android/ios separados), não mais o campo legado único `pluginClass` compartilhado entre plataformas.

## Estrutura Relevante
- `ios/image_editor_pro/Sources/image_editor_pro/SwiftImageEditorProPlugin.swift` — implementação única do plugin no iOS
- `ios/image_editor_pro/Package.swift` — manifesto SPM
- `ios/image_editor_pro.podspec` — manifesto CocoaPods
- Consumidor real testado: `../app-vistoria` (pubspec.yaml usa `git: url + ref` apontando pra tag deste repo)
