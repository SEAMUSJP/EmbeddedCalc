以下は、プロジェクトのREADMEを日本語で作成したものです。

---

# EmbeddedCalc

EmbeddedCalcは、基本的な算術演算に加え、16進数変換、2進数表現、浮動小数点から固定小数点への変換などの高度な機能を備えたmacOS用の電卓アプリケーションです。

## 機能

- **基本的な算術演算**: 足し算、引き算、掛け算、割り算を実行できます。
- **16進数対応**: 10進数と16進数の間で数値の基数を切り替えることができます。
- **2進数表現**: 現在の数値の2進数表現を表示します。
- **浮動小数点から固定小数点への変換**: 浮動小数点と固定小数点の表現を相互に変換できます。
- **常に最前面に表示**: 電卓ウィンドウを他のウィンドウの上に固定できます。
- **キーボードショートカット**: キーボード入力に対応し、計算を素早く行うことができます。

## はじめに

### 必要な環境

- macOS 13.3 (Ventura) 以降
- Xcode 14.3 以降
- Swift 5.7 以降

### インストール

1. リポジトリをクローンします:

   ```bash
   git clone https://github.com/yourusername/EmbeddedCalc.git
   ```

2. プロジェクトをXcodeで開きます:

   ```bash
   cd EmbeddedCalc
   open EmbeddedCalc.xcodeproj
   ```

3. プロジェクトをビルドして実行します:

   `EmbeddedCalc`スキームを選択し、ターゲットデバイス（例: `My Mac`）を選んで、`Cmd + R`を押してプロジェクトをビルドおよび実行します。

## 使い方

### 基本操作

1. **計算の実行**: ボタンやキーボードを使って数値と演算（`+`, `-`, `*`, `/`）を入力します。`=`を押して結果を表示します。
   
2. **数値基数の切り替え**: 電卓の上部にあるピッカーを使用して、10進数（`10`）と16進数（`16`）の間で切り替えます。
   
3. **2進数ビュー**: `#`ボタンを押すと、現在の数値の2進数表現を表示するウィンドウが開きます。
   
4. **浮動小数点から固定小数点への変換**: `FF`ボタンを押して、浮動小数点と固定小数点の表現を相互に変換します。変換に必要な`m`値と`n`値を入力します。
   
5. **常に最前面に表示**: ピンのアイコンを押すと、電卓ウィンドウが常に他のウィンドウの上に表示されます。

### キーボードショートカット

- **数字と演算**: キーボードを使って数字と演算を入力します。
- **クリア（AC）**: `Shift + C`を押して表示をクリアします。
- **符号の切り替え（+/-）**: `Shift + S`を押して現在の数値の符号を切り替えます。
- **コピー（Cmd + C）**: 現在の表示値をコピーします。
- **ペースト（Cmd + V）**: クリップボードから値をペーストして表示に反映させます。
- **2進数ビュー（#）**: `Shift + #`を押して2進数ビューを開きます。

## テストの実行

このプロジェクトには、電卓の基本機能をテストするユニットテストが含まれています。

### Xcodeでのテスト実行

1. プロジェクトをXcodeで開きます。
2. `EmbeddedCalcTests`スキームを選択します。
3. `Cmd + U`を押してすべてのテストを実行します。

### テストカバレッジ

- **CalculatorModelTests**: `CalculatorModel`の基本的な算術演算と状態管理をテストします。
- **CalculatorViewModelTests**: `CalculatorViewModel`でのユーザーインタラクションと状態更新をテストします。

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細については[LICENSE](LICENSE)ファイルを参照してください。
