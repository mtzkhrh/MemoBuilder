# [MemoBuilder](https://memobuilder.work/)

## サイト概要
例えば日々の小さな思い出や豆知識、モノを置いた場所、機能の実装に関して記述したコードなど、思い出したいことや再度利用したい知識などを記録、整理、共有、検索できるアプリケーション。<br>
「家」ディレクトリと「部屋」ディレクトリを作成でき、メモをディレクトリ構造で保存できる。

## サイトテーマ
個人やグループで利用する場合、記録を引き出しやすく保存するツール。<br>
SNS的な利用をする場合、知識を保存し、他者に活かしてもらう。<br>

## テーマを選んだ理由
プログラミングの学習をしている時に「以前の学習で製作したあのアプリのあのコードが使える」ということが多く、何度もそのコードのあるファイルを開き、探すことがよくありました。また学習の結果としてチートシートを作成したものの、チートシートの中から探す作業や、そもそも記録していたか確認する作業などがあり、結果として手間や時間がかかることもよくありました。このように記憶や記録を探す手間暇をもっと減らすことは出来ないか、効率的に探すことは出来ないかなど色々と考えた結果、メモ帳をPCの階層構造の様に分かりやすく分類し、保存と閲覧ができるアプリケーションがあると便利だと思い、このテーマを選定しました。

## ターゲットユーザ
- 何かを勉強中の人
- 忘れっぽい人
- 再度利用したいデータがある人
- 記憶や記録をシェアしたい人
- 基本的に個人か小さい集団を想定
### 主な利用シーン
- 日々の記録を分かりやすく記録する
	- 「育児」/「好き嫌い」/「細かくしたら食べた物」にんじん
- 思い出したい時に思い出しやすいように記録する。
	- 「家にあるもの」/「掃除用具」/「高水圧洗浄機」外の倉庫
- 何かの作成中に以前の作成手順を参考にしたい時に調べやすい。
	- 「プログラミング」/「rails」/「データをランダム取得する方法」model.sample(n)
- todoリストを記録する
	- 「アプリ開発」/「設計フェーズ」/「ER図」エンティティ

## 使用技術
### フロントエンド
- HTML/CSS
- JavaScript/jQuery

### サーバサイド
- Ruby-2.5.7
- Ruby_on_rails-5.2.4.3

### テスト
- RSpec-3.9.0(model/system)

### 開発環境
- Vagrant(2.2.4)

### 本番環境・デプロイ
- AWS(EC2,nginx,RDS)
- SQL mysql-0.5.3
- HTTPS通信(Certbot)

## 機能一覧
### ディレクトリ構造機能
- 「家」と「部屋」の２階層のディレクトリを作れる
- 作成したディレクトリ下にメモを投稿できる
- 家から順にページ遷移することでメモが見つけやすい

### メモ機能
- 一覧以外にも家の中・部屋の中などで分割して表示できる
- 自分のみ・友達のみ・公開の３種類の公開範囲を選択できる
- データに画像の添付ができる(Refile)
- メモの本文はリッチテキストエディタ(Ckeditor)
- タグ付け機能(acts-as-taggable-on)
- コメント・いいね機能

### 各データの検索機能
- 家・部屋・メモ・ユーザの名前やタイトルで検索できる(ransack)
- 検索するページによって母数が変わるので見つけやすい
- 更新日や名前の昇順降順で並び替えができる

### ストック機能
- ストックすることで投稿者の自他問わずメモをストックできる
- ストック一覧ページで検索もできる

### 友達機能
- 双方のフォロー状態によって関係を分別
	- お互いがフォローしている ＝ 「友達」
	- 自分のみフォローしている ＝ 「承認待ち」
	- 相手のみフォローしている ＝ 「申請」

### 管理者機能
- 投稿の編集・削除
- ユーザ情報の編集・削除

## 設計
### 設計書
- [ER図](https://drive.google.com/file/d/1a5Ef1un2_GitRdnwZ-Pgdp-s8KoaXnn4/view?usp=sharing)
- [ワイヤーフレーム](https://drive.google.com/file/d/1HtUShxXPoxzwMkq5JNd-tEW583mloDYA/view?usp=sharing)
- [詳細設計](https://docs.google.com/spreadsheets/d/1w8F0worbB8bxHyn1_kTAO2r8XC6c1BO5-1p8JhLS-as/edit?usp=sharing)

### 機能一覧
[機能一覧](https://docs.google.com/spreadsheets/d/1AE_4bTmePz_kfmAAMN1GkQFBQoLb83-OLgLhKVb1P-0/edit?usp=sharing)
