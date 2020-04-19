# このプロジェクトの目的
最新アプリ環境の実験場。ドメイン知識と技術環境の両方を実験するとスピードが遅いため、サービス内容を最小限に環境だけに特化して実験するリポジトリ

ビジネス面に直接関係ない技術自体の勉強は下記ディレクトリで調査
https://github.com/setsumaru1992/internal_application_study_reports


# 20200412構想
思いの外長くなったので、
時代が変わった後に互換不可能な新構成を試したい時には
このREADMEや構成含め「v1」というディレクトリにアーカイブ化して、
ルートディレクトリかv2ディレクトリに新構成用のREADMEやファイルを置く

## やりたいこと
達成したいこと
- DX改善のための知識・経験を遊んで増やす。ソフト面、ハード面両方にアプローチ
- 仕事や自分が本格サービスを運用する時になった時に使える知識を獲得したい

### 問題圏
- アプリケーションのユーザビリティ向上（ソフト改善）
- 運用性向上（ハード改善）
  - アプリケーションの運用
  - インフラの運用

各問題圏についてやりたいことを列挙していく

形式
- やりたいこと
  - できるようになることで実現できること
    - 抱えている問題
      - ~
    - 実現できること
      - ~
  - 具体的に何をしたいのか
    - ~

#### アプリケーションのユーザビリティ向上（ソフト改善）
- ReactNativeWebを使いこなしたい
  - できるようになることで実現できること
    - 抱えている問題
      - サーバサイドとの通信でページ遷移によるWeb1.0な方法ばっかり使っている
      - モダンな動的な動きは作れるけど作るのに腰が重い
      - なぜなら自前で用意しなければいけない仕組みが多いから
    - 実現できること
      - ネイティブアプリで当たり前になっているWeb2.0のヌルヌルした動的な動きを実現
  - 具体的に何をしたいのか
    - 表題ママ

#### 運用性向上（ハード改善） - アプリケーションの運用
- GraphQL使いたい。GraphQLというよりはアポロ
  - できるようになることで実現できること
    - 抱えている問題
      - Web2.0でやること
        - ☆クライアントサイドとサーバサイドの分離
        - 「☆」によりクライアントサイドでJSをヌルヌル動的に動かせる
        - 「☆」はクライアントサイドでデータを持つことを必要とする
      - クライアントサイドでデータ管理するのは面倒くさい。Fluxがあるけど、自前でデータ管理する仕組みを作るのが面倒くさい。
        - 「自前でデータ管理する仕組み」
          - 自分でデータ持っていればクライアントサイドでデータを持ち、なければサーバサイドに投げる
          - 必要に応じて最新のサーバサイド情報に更新
          - クライアントサイドで自走できるようにできるだけ詳細な情報を管理できる必要がある。管理とは柔軟にデータを扱えるようにすること。
          - 至極面倒
          - 簡易データベースを内製するって。。。MVCを内製するだけでも億劫なのに。。
    - 実現できること
      - クライアントサイドのデータ管理をまるっとライブラリに委託できる。
  - 具体的に何をしたいのか
    - 表題ママ
- unicornで立ち上げたい
  - できるようになることで実現できること
    - 抱えている問題
      - `rails s`で実行されるpumaしか知らない。というかpumaもそんな知らない。
      - 大量アクセスを捌くのはWebサーバとアプリケーションサーバであり、Webサーバについてはnginxを自前で立てているからちょっとわかるけど、アプリケーションサーバについては何も知らない
    - 実現できること
      - 本番で実用可能なunicorn(スレッドでなくプロセスで処理)を使ってアプリケーションサーバについてちょっと知る
  - 具体的に何をしたいのか
    - 表題ママ
- dcronによりアプリケーションで定期実行JOBを管理したい
  - できるようになることで実現できること
    - 抱えている問題
      - 定期実行をcronとJenkinsでやっており、しかもそのサーバはサービスとJenkinsの載ったモノリシックサーバ
      - 記録が残らないし、可読性も悪いし、既存の定期実行を変えるのが億劫
    - 実現できること
      - アプリケーション都合の定期実行はアプリケーションコードに書いてバージョン管理
  - 具体的に何をしたいのか
    - 表題ママ
- TypeScriptが書けるようになりたい
  - できるようになることで実現できること
    - 抱えている問題
      - 型づけなく実装している
    - 実現できること
      - 型を付けたい
  - 具体的に何をしたいのか
    - 表題ママ
- CircleCIでテスト駆動開発をやろうと思えばいつでもできるようにしたい
  - できるようになることで実現できること
    - 抱えている問題
      - テストコードを書いたことあるけど、テスト書くのが面倒だし、書かないことを合理化できちゃう
    - 実現できること
      - 一度慣れて、書きたい時にかけるようにする
  - 具体的に何をしたいのか
    - 表題ママ
- Railsの本番環境運用
  - できるようになることで実現できること
    - 抱えている問題
      - 今まで自作アプリはdevモードで本番でも運用させてきたので子供くさい
    - 実現できること
      - 大人な運用をすることで自信をつける
  - 具体的に何をしたいのか
    - 表題ママ

#### 運用性向上（ハード改善） - インフラの運用
- コンテナ環境でアプリケーション開発・本番運用をしたい
  - できるようになることで実現できること
    - 抱えている問題
      - 秘伝のタレ運用をしているので、インフラ移行で腰が重い
      - 複数台運用をやるなんていったら地獄
    - 実現できること
      - 秘伝のタレ運用から脱却することでアプリの移植性を高め、インスタンス切り替えを楽にする
  - 具体的に何をしたいのか
    1. Docker(docker-compose)でアプリのコンテナ化
    2. k8sでオーケストレーション
- AWSの流儀にしたがってEC2で稼働するアプリケーションをセキュアに外部公開
  - できるようになることで実現できること
    - 抱えている問題
      - 今クラウドサービスは使っているが、AWSでサービス運用していない
      - 今部分的にAWSを使っているのでAWSに移行したい
      - AWSでサービス公開する方法がわからない
    - 実現できること
      - AWSでセキュアなサービス運用ができる
  - 具体的に何をしたいのか
    - 表題ママ



## 必要なこと（手をつける順）
優先度を決めるにあたって考えること
- 明日新サービスを作るとなった時にすぐ必要になるものを先にやる
- (多分↑と考えること同じだが)先にやっておかないと手戻りが多いものを先にやる

### トップレベルのTODO
- [x] Railsで最低限のHelloWorldアプリケーション環境を構築
- [x] アプリケーション環境の最低限のコンテナ化
   - 今後の設定を書くにもDockerfileに書くことを強制し、Infrastracture as a codeを実現
- [ ] 最低限の~~ReactNativeWeb~~ React実装によりフロントとバックを分ける
- [ ] 最低限GraphQLの設定をしてフロントとバックの接合をさせる
- [ ] 必要に応じて以下を設定
  - [ ] unicorn
  - [ ] dcron
  - [ ] TypeScript
  - [ ] circleCI
  - [ ] Railsの本番環境設定
  - [ ] webpack込みのrails6を入れられるdocker構成作成
- [ ] コンテナ環境で遊ぶ
  - [ ] (準備)無駄なマイクロサービスを作り、複数サービス稼働状態を作る
  - [ ] 複数サービス運用をやってみる
  - [ ] k8sやってみる
  - [ ] 無理ならdocker-compose

### TODOごとの記録
`tasklog`ディレクトリに記載