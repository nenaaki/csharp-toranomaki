## ユニットテスト用プラットフォームの選択

MSTest、xUnit、およびNUnitは、C#のユニットテストフレームワークの中で広く使用されている3つの主要な選択肢です。以下にそれぞれのフレームワークの特徴と比較を示します。

### MSTest

- **マイクロソフトの提供**: MSTestはMicrosoftによって提供され、Visual Studioに統合されています。そのため、Visual Studioのエコシステムとの親和性が高く、開発者にとっては使いやすい環境を提供します。
- **豊富な機能**: MSTestはパラメータ化されたテスト、データソースからのテストデータの取得、テストのランダムな順序付けなど、多くの機能をサポートしています。
- **コードカバレッジのサポート**: Visual Studio Enterprise版ではコードカバレッジの計測やレポートが統合されており、MSTestとの組み合わせで容易に利用できます。

### xUnit

- **オープンソースと活発なコミュニティ**: xUnitはオープンソースであり、活発なコミュニティによってサポートされています。そのため、バグの修正や新機能の追加が迅速に行われ、コードの品質や機能の向上が期待できます。
- **簡潔な構文と豊富な拡張機能**: xUnitの構文はシンプルで直感的であり、豊富な拡張機能やカスタマイズオプションが提供されています。
- **コードカバレッジのサポート**: xUnitはコードカバレッジの計測やレポートを簡単に生成できる機能を提供しています。

### NUnit

- **柔軟性と機能の豊富さ**: NUnitは柔軟性が高く、豊富な機能を提供しています。特に、テストの並列実行、データ駆動テスト、SetUp/TearDownメソッドなどの機能が強力です。
- **.NET Frameworkと.NET Coreの両方をサポート**: NUnitは.NET Frameworkと.NET Coreの両方をサポートしており、クロスプラットフォームでの利用が可能です。
- **長い歴史と安定性**: NUnitは長い歴史を持ち、安定しているという評判があります。そのため、多くのプロジェクトで広く利用されています。

これらの選択肢の中から最適なものを選択するには、プロジェクトの要件や開発チームの好み、既存のエコシステムとの親和性などを考慮する必要があります。

## 筆者の場合

ユニットテストとコードカバレッジに拘ったあるプロジェクトで、筆者は xUnit を選択しました。

標準ツールとオープンソースツールのみでコードカバレッジのレポートを生成することが出来たからです。

以下はその時に用いた`coverage.ps1`です。
```
$Result = dotnet test --collect "XPlat Code Coverage"
$Reports = $Result | Select-String coverage.cobertura.xml | ForEach-Object { $_.Line.Trim() } | Join-String -Separator ';'
reportgenerator "-reports:$Reports" "-targetdir:./Report" "-reporttype:Html"
```
注）dotnet test を事前にすべてパスしている必要があります。