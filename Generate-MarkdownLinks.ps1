# 除外するディレクトリおよびファイルの名前を指定
$excludeDirs = @(".src", "img", ".devcontainer")
$excludeFiles = @("README.md")

# ヘッダーファイルとフッターファイルのパスを指定
$headerFile = ".\.src\header.md"
$footerFile = ".\.src\footer.md"

# ファイルリストを再帰的に取得し、インデント付きで Markdown リンクを生成する関数
function Generate-MarkdownLinks {
    param (
        [string]$Path,
        [int]$IndentLevel = 0,
        [ref]$LinksArray
    )

    # 指定されたディレクトリ内のアイテムを取得
    $items = Get-ChildItem -Path $Path

    foreach ($item in $items) {
        # 除外リストに含まれているか確認
        if ($excludeDirs -contains $item.Name -or $excludeFiles -contains $item.Name) {
            continue
        }

        # インデントを生成
        $indent = " " * ($IndentLevel * 4)

        if ($item.PSIsContainer) {
            # ディレクトリの場合、そのディレクトリ名を出力し、再帰的に処理
            $LinksArray.Value += "$indent- **$($item.Name)**`n"
            Generate-MarkdownLinks -Path $item.FullName -IndentLevel ($IndentLevel + 1) -LinksArray $LinksArray
        } else {
            # ファイルの場合、拡張子が .md でない場合はスキップ
            if ($item.Extension -ne ".md") {
                continue
            }
            # ファイルの場合、拡張子を除去してMarkdownリンクを生成して出力
            $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
            $LinksArray.Value += "$indent- [$fileNameWithoutExtension](./$($item.FullName))`n"
        }
    }
}

# 出力ファイルのパス
$outputFile = ".\README.md"

# ヘッダーとフッターの内容を読み込む（改行を保持）
$headerContent = Get-Content -Path $headerFile -Raw
$footerContent = Get-Content -Path $footerFile -Raw

# リンクリストを格納する変数を初期化
$linksArray = @()
Generate-MarkdownLinks -Path ".\" -LinksArray ([ref]$linksArray)

# ヘッダー、リンクリスト、フッターを結合して出力ファイルに保存
$headerContent + $linksArray + $footerContent | Set-Content -Path $outputFile -NoNewline
