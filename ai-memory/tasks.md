# Tarefas do Projeto

### Pendentes
- Testar build local do `example/` deste repo (falha hoje por questão cosmética: a pasta local se chama `EditorImagem`, não `image_editor_pro`, e SwiftPM exige nome do diretório = nome do package para dependências `path:`; não afeta consumidores reais via git). Decidir se vale renomear a pasta local.
- Em `app-vistoria`: revisar e commitar `pubspec.yaml` (URL/ref atualizados pra `image_editor_pro.git` / `v6.3`) — não foi commitado nesta sessão, só editado e validado localmente.
- Avaliar, no médio prazo, migração completa pra SPM puro em `app-vistoria` (remover Podfile) — Flutter já indica que todos os plugins suportam SPM, mas isso é decisão separada, não decidida ainda.

### Em andamento
- (nenhuma)

### Concluídas
- Reestruturação do plugin iOS pra suportar SPM + CocoaPods dual (commits `24623b7`, `7ed47f9` no repo `image_editor_pro`, tags `v6.2` e `v6.3`).
- Rename do repositório GitHub `EditorImagem` → `image_editor_pro`.
- Validação de build real em `app-vistoria` (consumidor via git) com `flutter build ios --simulator --no-codesign` — sucesso, warning de SPM não aparece mais.
