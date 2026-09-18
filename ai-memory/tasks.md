# Tarefas do Projeto

### Pendentes
- Commitar neste repo (`image_editor_pro`) as mudanças do redesign visual do editor (`pubspec.yaml`, `lib/image_editor_pro.dart`, `lib/modules/all_emojies.dart`, `lib/modules/text.dart`) — feitas nesta sessão, ainda não commitadas.
- Testar visualmente (Android/iOS, manualmente pelo usuário) o redesign do editor de imagem antes de publicar tag nova — validação nesta sessão ficou só em `flutter analyze`.
- Em `app-vistoria`: commitar `pubspec.yaml` (`ref: v6.4`) — só editado e validado localmente, não commitado nesta sessão.
- Testar build local do `example/` deste repo no iOS (falha hoje por questão cosmética: a pasta local se chama `EditorImagem`, não `image_editor_pro`, e SwiftPM exige nome do diretório = nome do package para dependências `path:`; não afeta consumidores reais via git). Decidir se vale renomear a pasta local.
- Em `app-vistoria`: revisar e commitar `pubspec.yaml` (URL/ref atualizados pra `image_editor_pro.git` / `v6.3`) — não foi commitado nesta sessão, só editado e validado localmente.
- Avaliar, no médio prazo, migração completa pra SPM puro em `app-vistoria` (remover Podfile) — Flutter já indica que todos os plugins suportam SPM, mas isso é decisão separada, não decidida ainda.

### Em andamento
- (nenhuma)

### Concluídas
- Redesign visual da tela de editor de imagem (AppBar, toolbar Pintar/Texto/Emoji/Limpar, diálogos de cor/tamanho/emoji): troca de `FontAwesomeIcons`/`Icons.*` por `HeroIcon`, botão "Salvar" em pill preenchido, cantos arredondados nos bottom sheets/dialog, `font_awesome_flutter` removido — `flutter analyze` limpo em `lib/` e `example/`.
- Reestruturação do plugin iOS pra suportar SPM + CocoaPods dual (commits `24623b7`, `7ed47f9` no repo `image_editor_pro`, tags `v6.2` e `v6.3`).
- Rename do repositório GitHub `EditorImagem` → `image_editor_pro`.
- Validação de build real em `app-vistoria` (consumidor via git) com `flutter build ios --simulator --no-codesign` — sucesso, warning de SPM não aparece mais.
- Correção dos 57 problemas do `flutter analyze` em `lib/` (campos mortos, APIs depreciadas, asserts mortos).
- Alinhamento da config Android de `example/` com `app-vistoria` (Gradle, AGP, Kotlin, compileSdk, ndkVersion) — `flutter build apk --debug` passou a compilar.
- Commit/push das correções de lint e Android (commits `b609f94`, `273fcd7`, `6f6d937`), tag `v6.4` publicada e validada em `app-vistoria` (pub get + analyze + pod install + build ios simulator, tudo ok).
