# Render デプロイメントガイド

## 🚀 Renderサービス設定値

### Web Service 設定
```yaml
Name: blog-app-mvp
Runtime: Ruby
Region: Oregon (US West)
Branch: feature/MVP_Production_Only
Build Command: ./bin/render-build.sh
Start Command: bundle exec puma -C config/puma.rb
Instance Type: Starter
```

### 環境変数設定
```bash
RAILS_MASTER_KEY=75a2235a478bd7108f500da4af7102c2
WEB_CONCURRENCY=2
RAILS_ENV=production
DATABASE_URL=[PostgreSQL Internal Database URL]
```

### PostgreSQL データベース設定
```yaml
Name: blog-app-db
Database Name: blog_app_production
User: blog_app
Region: Oregon (US West)
Plan: Starter (Free)
```

## 📝 デプロイメント手順

### Phase 1: データベース作成
1. Render Dashboard → New + → PostgreSQL
2. 上記設定でデータベース作成
3. Internal Database URLをコピー

### Phase 2: Web Service作成
1. Render Dashboard → New + → Web Service
2. GitHub repository連携
3. umaume/BLOG-APP選択
4. feature/MVP_Production_Only ブランチ選択
5. 上記設定値を入力

### Phase 3: 環境変数設定
1. Web Service設定画面で Environment Variables追加
2. 必要な環境変数をすべて設定
3. DATABASE_URLにPostgreSQLのInternal URLを設定

### Phase 4: デプロイ実行
1. "Create Web Service" ボタンクリック
2. 自動ビルド・デプロイ開始
3. ログ監視

## 🔍 デプロイ後確認項目

### 必須チェック項目
- [ ] サイトが正常にアクセス可能
- [ ] ユーザー登録・ログイン機能
- [ ] 記事作成・表示機能
- [ ] コメント・いいね機能
- [ ] 検索機能
- [ ] レスポンシブデザイン

### パフォーマンスチェック
- [ ] ページロード時間 (< 3秒)
- [ ] 画像表示の確認
- [ ] JavaScript機能の動作

## 🚨 トラブルシューティング

### よくあるエラーと対処法

#### 1. アセットプリコンパイルエラー
```bash
# ログで確認すべき箇所
Looking for: assets:precompile
エラーメッセージをチェック
```

#### 2. データベース接続エラー
```bash
# 確認項目
- DATABASE_URLが正しく設定されているか
- PostgreSQLが正常に起動しているか
```

#### 3. RAILS_MASTER_KEYエラー
```bash
# 確認項目
- RAILS_MASTER_KEYが正しく設定されているか
- credentials.yml.encファイルが存在するか
```

## 📊 デプロイメント成功基準

### 技術的成功基準
- ✅ ビルド成功 (exit code 0)
- ✅ サーバー起動成功
- ✅ 全ページアクセス可能
- ✅ 全機能正常動作

### ユーザビリティ成功基準
- ✅ 直感的なナビゲーション
- ✅ レスポンシブデザイン
- ✅ エラーハンドリング
- ✅ パフォーマンス

## 🔄 継続的デプロイメント

### 今後の更新手順
1. ローカルで開発・テスト
2. GitHubにプッシュ
3. Renderで自動デプロイ
4. 本番環境で動作確認

### モニタリング
- Renderダッシュボードでリソース使用状況監視
- アプリケーションログの定期確認
- ユーザーフィードバックの収集