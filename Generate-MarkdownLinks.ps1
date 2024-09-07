# ファイルリストを再帰的に取得し、インデント付きで Markdown リンクを生成する関数
function Generate-MarkdownLinks {
  param (
      [string]$Path,
      [int]$IndentLevel = 0
  )

  # 指定されたディレクトリ内のアイテムを取得
  $items = Get-ChildItem -Path $Path

  foreach ($item in $items) {
      # インデントを生成
      $indent = " " * ($IndentLevel * 4)

      if ($item.PSIsContainer) {
          # ディレクトリの場合、そのディレクトリ名を出力し、再帰的に処理
          Write-Output "$indent- **$($item.Name)**"
          Generate-MarkdownLinks -Path $item.FullName -IndentLevel ($IndentLevel + 1)
      } else {
          # ファイルの場合、Markdown リンクを生成して出力
          Write-Output "$indent- [$($item.Name)](./$($item.FullName))"
      }
  }
}

# 出力ファイルのパス
$outputFile = ".\links.md"

# 結果をファイルに保存するために、標準出力をリダイレクト
$null = Out-File -FilePath $outputFile

# 指定されたディレクトリを再帰的に処理し、結果をファイルに追加
Generate-MarkdownLinks -Path "C:\path\to\your\directory" | Add-Content -Path $outputFile