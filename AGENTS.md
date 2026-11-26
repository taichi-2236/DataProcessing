# AGENTS.md — AIエージェント向けプロジェクトガイド

このドキュメントは、AIアシスタント・コーディングエージェントが本リポジトリ（`DataProcessing`）の構造・データフロー・設計規約を素早く正確に把握するためのリファレンスです。

---

## 1. プロジェクト概要

**RoboCup SSL (Small Size League)** ロボットの実験ログ（主に Foxglove `.mcap` ログおよびロボット搭載SDカードの `.BIN` ログ）を変換・解析・可視化するための **MATLAB** プロジェクトです。

- **主な用途**:
  - プッシュドリブル実験（直線・円軌道追従）におけるロボット・ボール軌跡の描画（PDF出力）および軌道追従誤差の評価
  - 実験ログからのアニメーション動画（`.avi`）生成
  - SDカードバイナリログからのドリブラ制御データ（PWM・エンコーダ・回転方向信号など）の可視化
  - ボール速度減衰・フィールド転がり抵抗などの計測データ解析および簡易シミュレーション

---

## 2. ディレクトリ構成

```text
DataProcessing/
├── AGENTS.md                 # 本ファイル（AI向けディレクトリ・設計ガイド）
├── startup.m                 # MATLAB初期化スクリプト（src/, scripts/ のパス追加と基本パス変数定義）
├── .gitignore                # 生成物 (output/) および変換中間ファイル (data/json/ 等) の除外設定
├── scripts/                  # ユーザーが直接実行するエントリポイントスクリプト群
│   ├── import_foxglove.m     # Foxgloveログ (.mcap/.json/.csv) を読み込みワークスペース変数へ展開
│   ├── run_plot_master.m     # ワークスペース上の実験データから "Ready" 区間を抽出し軌跡PDFを出力
│   ├── run_auto_batch.m      # パターン一致する複数 .mcap ファイルを一括変換・軌跡PDF出力
│   ├── import_sdcard.m       # SDカードログ (.BIN) を CSV へ変換し data/csv/from_SD/ へ格納
│   ├── plot_sd_log.m         # SDカード由来CSVからドリブラPWM・エンコーダ推移グラフをPDF出力
│   └── sim/
│       └── sim_ball_chase.m  # ode45 を用いたボール追従の簡易数値シミュレーション
├── src/                      # 再利用可能な関数・クラス群（startup.m で検索パスに追加）
│   ├── +Constants/
│   │   └── FileParam.m       # プロジェクト内各ディレクトリ・外部ツールの絶対パス定数クラス
│   ├── +index/               # データ配列の列インデックス定義パッケージ
│   │   ├── BallIdx.m         # ボール配列 [N×7] の列番号定義
│   │   ├── RobotIdx.m        # ロボット配列 [N×9×M] の列番号定義
│   │   └── RefInfoIdx.m      # Referee情報配列 [K×4] の列番号定義
│   ├── +traj/                # 目標経路（リファレンス軌道）定義パッケージ
│   │   ├── Line.m            # 直線セグメントクラス
│   │   ├── Arc.m             # 円・円弧セグメントクラス
│   │   └── preset.m          # 定番経路プリセット ("Circle", "CircStrt_Out" 等) のファクトリ関数
│   ├── io/                   # ログ変換・データ読込モジュール
│   │   ├── load_vision_log.m # .mcap / .json / .csv を統合的に読み込み構造体 logData を返す中核関数
│   │   ├── convert_mcap2json.m # mcap CLI を呼び出し .mcap → JSON Lines (.json) へ変換
│   │   ├── format_mcap_topics.m # mcap トピック指定オプションとファイル名タグを生成
│   │   ├── convert_json2csv.m  # JSON Lines (.json) を解析・平坦化して .csv へ変換
│   │   └── convert_bin.m     # Binary2csv (drop_here.exe) を呼び出し .bin → .csv / .mcap へ変換
│   ├── analysis/             # 数値計算・データ解析補助関数
│   │   ├── find_discontinuous_idx.m # 整数インデックス列の不連続点を検出し連続区間ごとに分割
│   │   ├── func_R.m          # 2次元回転行列 [cos -sin; sin cos] の生成
│   │   └── LSM_1D.m          # 1次最小二乗法（直線近似 polyfit/polyval ラッパー）
│   └── viz/                  # 可視化・グラフ出力モジュール
│       ├── plot_field.m      # RoboCup SSL フィールド（Div A / B）の描画
│       ├── plot_orbit.m      # フィールド・目標経路・ロボット/ボール軌跡・速度/姿勢ベクトルの統合描画
│       ├── plot_err_traj2ball.m # 目標経路に対するボール追従誤差の時系列グラフ描画
│       ├── sslrobot.m        # SSLロボット機体形状（欠円ボディ＋5つのVisionマーカ）の描画
│       ├── render_anim.m     # ロボット・ボール軌跡のアニメーション動画 (.avi) レンダリング
│       └── output_figure.m   # データファイル名からプレフィックスを整理してPDF保存
├── tools/
│   └── mcap-windows-amd64.exe # .mcap 展開用の公式 mcap CLI バイナリ（Windows x64用）
├── data/                     # 実験データ格納ディレクトリ
│   ├── mcap/                 # Foxglove 記録データ (.mcap) [Git管理]
│   ├── bin/                  # SDカード記録バイナリ (.BIN) [Git管理]
│   ├── dat/                  # 旧形式・個別計測データ (.dat, サブフォルダ含む) [Git管理]
│   ├── txt/                  # テキストログ (.txt) [Git管理]
│   ├── csv/                  # CSVデータ置き場
│   │   ├── from_foxglove/    # .mcap/.json から自動生成されたCSV [Git除外・中間生成物]
│   │   └── from_SD/          # .BIN から自動生成されたCSV [Git除外・中間生成物]
│   └── json/                 # .mcap から自動生成された JSON Lines [Git除外・中間生成物]
├── output/                   # 出力先ディレクトリ（スクリプト実行時に自動生成）[Git除外]
│   ├── figure/               # 出力グラフ (.pdf)
│   └── movie/                # 出力アニメーション動画 (.avi)
└── archive/                  # リファクタリング前の旧スクリプト保管庫（原則編集不要）
    ├── script_animation/
    ├── script_calc/
    ├── script_formatting/
    └── script_plot/
```

---

## 3. 主要データ処理パイプライン

MATLAB で作業を開始する際は、最初にプロジェクトルートの **`startup.m`** を実行して `src/` と `scripts/` をパスに追加します。

### A. Foxglove（`.mcap`）Vision・Referee ログ解析フロー

1. **変換・読込パイプライン (`load_vision_log.m` が自動実行)**
   - `data/mcap/<name>.mcap`
   - ──(`convert_mcap2json` + `tools/mcap-windows-amd64.exe`)──▶ `data/json/<name>_vision_ref.json`（JSON Lines形式）
   - ──(`convert_json2csv`)──▶ `data/csv/from_foxglove/foxglove_data_<name>_vision_ref.csv`
   - ──(`load_vision_log`)──▶ MATLAB 構造体 `logData`（すでに `.json` や `.csv` がある場合は途中段階からの読込も可能）
2. **実行パターン**
   - **対話的解析**: `scripts/import_foxglove.m` でワークスペースに変数展開後、`scripts/run_plot_master.m` で描画設定を調整して実行。
   - **一括バッチ処理**: `scripts/run_auto_batch.m` でファイル名パターンに一致する `.mcap` をループ処理し、`output/figure/` に `track_*.pdf` を一括出力。

### B. SDカード（`.BIN`）ログ解析フロー

1. **バイナリ変換 (`scripts/import_sdcard.m`)**
   - `data/bin/<name>.BIN` ──(`convert_bin` + `../Binary2csv/drop_here.exe`)──▶ `data/csv/from_SD/<name>.csv`
2. **波形プロット (`scripts/plot_sd_log.m`)**
   - `data/csv/from_SD/<name>.csv` を `readmatrix` で読み込み、ドリブラPWMやエンコーダ値をプロットして `output/figure/sd_log/` にPDF出力。

---

## 4. データ構造・単位系・座標系の重要仕様

コードの読解・改修時に最も間違いやすいポイントは以下の通りです。

### 単位系の違い（重要）

| データ種別 / 対象 | 位置 | 速度 | 角度 | 時間 / フレーム |
| :--- | :--- | :--- | :--- | :--- |
| **Vision生ログ・`logData` 配列** (`ball`, `raw_ball`, `*_robot`) | **`mm`** | **`mm/s`** | `rad` | `sequence` 番号（カメラ周期 **60 fps** 前提） |
| **描画・経路モジュール** (`plot_orbit`, `plot_field`, `traj.*`, `sslrobot`, `render_anim`) | **`m`** | **`m/s`** | `rad` | 秒 `s`（例: `(1:N)/60`） |
| **SDカードCSVログ** (`plot_sd_log.m`) | — | — | — | 時刻列 `ms` |

> **注意**: `logData` から抽出したロボット・ボールの座標や速度を `plot_orbit` や `render_anim` に渡す際は、必ず **`/ 1000` で `[mm]` → `[m]` に単位変換**してください（`run_plot_master.m`・`run_auto_batch.m` 参照）。

### `logData` 構造体と `+index` パッケージの対応

`load_vision_log()` が返す `logData` の主要フィールドは以下の列構造を持ちます。列参照には必ず `index.*` クラスを使用してください。

- **`logData.ball` / `logData.raw_ball`**: `[N × 7]` double 行列（`index.BallIdx`）
  - `1:seq`, `2:x`, `3:y`, `4:vx`, `5:vy`, `6:speed`, `7:conf`（フィルタ済み `ball` の `conf` は `NaN`）
- **`logData.blue_robot` / `logData.raw_blue_robot` / `logData.yellow_robot` / `logData.raw_yellow_robot`**: `[N × 9 × M]` double 3次元配列（`index.RobotIdx`、該当機体なしの場合は `[]`）
  - 第2次元: `1:seq`, `2:id`, `3:x`, `4:y`, `5:angle`, `6:vx`, `7:vy`, `8:speed`, `9:conf`
  - 第3次元 `M`: 検出されたユニークなロボットID順（`logData.robotIds` にID一覧を保持。1台実験では `(:, :, 1)` を参照）
- **`logData.ref_info`**: `[K × 4]` string 配列（`index.RefInfoIdx`）
  - `1:seq`, `2:cmd`, `3:stage`, `4:state`
  - **実験有効区間の抽出**: Refereeコマンド `ref_info(:, ref.cmd) == "Ready"` となる `seq`（Visionの行インデックスに対応）を取り出して開始・終了フレームを決定します。1ファイル内に複数回の試行が含まれる場合は `find_discontinuous_idx()` で不連続箇所を分割します。

---

## 5. 主要モジュールAPI早見表

### パス管理 (`+Constants`)
- `paths = Constants.FileParam()`
  - `MainFolderPath`, `Binary2CsvPath`（デフォルトでリポジトリ1階層上の `../Binary2csv/` を参照）
  - `DataBinDir`, `DataMcapDir`, `DataJsonDir`, `DataCsvDir`, `DataDatDir`, `DataTxtDir`
  - `OutputFigureDir` (`output/figure`), `OutputMovieDir` (`output/movie`), `McapExePath` (`tools/mcap-windows-amd64.exe`)

### 目標経路 (`+traj`)
- `traj.Line(startPos, finishPos, LineStyle=..., Color=..., LineWidth=...)`: `startPos`, `finishPos` は `[2×1]` 列ベクトル `[m]`
- `traj.Arc(centerPos, radius, AngleRange=[0, 2*pi], ...)`: `centerPos` は `[2×1]` 列ベクトル `[m]`、`radius` は `[m]`
- `traj.preset(name)`: 定義済み経路の cell 配列を返す。対応名: `"Circle"`, `"CircStrt_Out"`, `"CircStrt_In"`, `"Straight"`

### 入出力 (`src/io/`)
- `format_mcap_topics(topics)`: 対応トピック名は `"vision"`, `"referee"`, `"aggregated_svgs"`, `"return_packet"`, `"target_state"`, `"obstacle"`。未定義トピックはエラーになるため、新トピック追加時は本関数と `convert_json2csv.m` を更新する。

### 描画・保存 (`src/viz/`)
- `output_figure(datafile, dir, tag, cropflag)`:
  - 元ファイル名から先頭の `^\w*_data_`（例: `foxglove_data_`, `SD_data_`）を正規表現で自動除去し、`<tag><cleanName>.pdf` として保存する。
  - `cropflag = true`（デフォルト）時は `exportgraphics(gca, ...)` で余白をクロップして出力。

---

## 6. 外部依存・動作環境

- **OS**: Windows 前提（`tools/mcap-windows-amd64.exe` および `drop_here.exe` を `system()` 経由で実行）
- **MATLAB**: `arguments` ブロック（R2019b+）、`exportgraphics` / `xregion`（R2020a / R2023a+）、Image Processing Toolbox（`render_anim.m` の `imresize`）を使用
- **外部リポジトリ依存（SDカード変換時のみ）**: 親ディレクトリ隣にある `../Binary2csv/drop_here.exe`（`RoboDragons/Binary2csv`）を参照

---

## 7. AIエージェント向け作業ルール・コーディング規約

1. **ハードコードパスの禁止**:
   - ファイルパスの組み立てには必ず `Constants.FileParam()` と `fullfile()` を使用してください。
2. **列インデックス定数の徹底**:
   - Vision / Referee 配列の列アクセスにマジックナンバー（`robot(:, 3:4)` など）を使わず、`r = index.RobotIdx; b = index.BallIdx; ref = index.RefInfoIdx;` を経由してください。
3. **責務の分離（`src/` vs `scripts/` vs `archive/`）**:
   - 汎用的な処理・クラス・描画関数は `src/` 配下の適切なフォルダ（`io/`, `analysis/`, `viz/`, `+traj/`, `+index/`, `+Constants/`）に配置する。
   - 個別の実験条件設定・バッチ実行スクリプトは `scripts/` に配置する。
   - `archive/` は旧構成のバックアップであるため、明示的に指示されない限り編集・依存しないでください。
4. **MATLAB コーディングスタイル**:
   - 新規・改修関数では `arguments ... end` ブロックによる型・サイズ検証と、`Opts.<Name>` による Name-Value 引数パターンを踏襲してください。
   - 文字コードは **UTF-8** を維持してください。
5. **大容量データファイルの扱い**:
   - `data/` 配下には多数のバイナリ（`.mcap`, `.BIN`）や大容量の `.csv` / `.json` / `.dat` が含まれます。調査時はファイル一覧や先頭数行のみを確認し、巨大ファイル全体をコンテキストに読み込まないよう注意してください。
