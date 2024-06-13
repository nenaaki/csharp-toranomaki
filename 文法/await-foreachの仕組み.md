### `await foreach` と `foreach` の違い

#### 基本的な違い

- **`foreach`**:
  - 同期的にコレクション（`IEnumerable<T>`）を反復処理。
  - すべての反復操作が同期的に実行され、次の要素を取得するまでブロッキングされる。

```csharp
foreach (var item in collection)
{
    ProcessItem(item); // 同期的な処理
}
```

- **`await foreach`**:
  - 非同期ストリーム（`IAsyncEnumerable<T>`）を非同期に反復処理。
  - 各反復で `MoveNextAsync` を非同期に呼び出し、次の要素を取得する際に非同期で待機。

```csharp
await foreach (var item in asyncCollection)
{
    await ProcessItemAsync(item); // 非同期的な処理
}
```

#### 非同期化される範囲の違い
- **`foreach`**:

  - 反復操作全体が同期的に行われ、各反復はブロッキングされる。

- **`await foreach`**:

  - 反復操作が非同期に行われ、各反復で非同期に待機。
  - 非同期I/O操作を伴うシナリオに適しており、アプリケーションの応答性を向上させる。

#### 非同期ストリームの実装例

```csharp
public async IAsyncEnumerable<int> GetNumbersAsync()
{
    for (int i = 0; i < 10; i++)
    {
        await Task.Delay(100); // 非同期的にデータを準備
        yield return i;
    }
}

public async Task ProcessNumbersAsync()
{
    await foreach (var number in GetNumbersAsync())
    {
        await Task.Delay(50); // 非同期的に各要素を処理
        Console.WriteLine(number);
    }
}
```

### まとめ
- **`foreach`**:

  - 同期的なコレクションの反復処理。
  - 各反復でブロッキングが発生。

- **`await foreach`**:

  - 非同期ストリームの反復処理。
  - 各反復で非同期に待機。
  - 非同期I/O操作を伴うシナリオに最適。