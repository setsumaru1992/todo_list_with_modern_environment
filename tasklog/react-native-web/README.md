- もしかしたら期待を下回るから保留するかも
  - 期待
    - Web2.0の動的な動きを後押しする魔法のような仕組みが整っているだろうから、エンジニアが自前で頑張らなきゃいけない部分が減る
  - 実際
    - divタグがViewタグになってnativeアプリとも共用できることのみがメリットという印象
    - まだ動かしてないけど、魔法感はない。onclickでreduxのreducer動かすみたいな感じでやること変わんなさそう。学習コストは低いけど、だったらわざわざやってみなくていいかな。
  - 過剰な期待がなくなった今
    - 一旦このリポジトリ外で練習してみる。
      - 試すなら慣れ親しんだcreate-react-appだな
      - 必要になってからexpoで遊ぶ
    - ネイティブアプリっぽく、この動作の時はこのデザインだよねっていうデザインや動作がデフォルトで揃ってるっぽいのは強み。それは体感してから使うか決めたい
- 導入
  - [これ](http://necolas.github.io/react-native-web/docs/?path=/docs/overview-getting-started--page)をもとにcreate-react-appに導入
  - [これ](https://github.com/necolas/react-native-web#examples)を元にHelloWorldをしてみる。（↑に←のindex.jsをコピペしたのみ。それで動いた）
    - Viewタグでdivタグ、Textタグでdivタグ内のテキスト要素構築している
    - きっちいなぁ。単なるReactをさらに学習コスト少し上乗せしたくらいの印象。予感していた通り、わざわざWebをこれで作るメリットはない。
    - 逆にアプリ作る時には学習コスト少なく作れるから最適。慣れたWeb側で練習してからアプリに着手すれば心理的コスト低めにいける。
    - デザインもWebで固定ヘッダ・フッタとか無理して作るのをデフォルトでできるからそこはいい。
    - とりあえず、このリポジトリで本格的に遊ぶ対象にしなくていいや
- はなからスマホユーザ対象のサイトを作るなら便利かも。
  - デフォルトPCサイト用な作り方してからスマホに寄せるより、モバイルファーストな書き方した方がよさそうだから。