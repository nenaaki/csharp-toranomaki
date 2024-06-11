### `struct` と `ref struct` の違い

C# には二種類の構造体があります：通常の構造体 (`struct`) と参照構造体 (`ref struct`) です。これらは異なる目的と使用方法を持っています。

#### `struct`

`struct` は値型であり、スタックに割り当てられます。主な特徴は次の通りです：

- **値型**：`struct` は値型であり、インスタンスがコピーされると、その値もコピーされます。
- **メモリ割り当て**：通常はスタックに割り当てられますが、ボックス化されるとヒープに割り当てられることもあります。
- **既定のコンストラクタ**：既定のコンストラクタを定義できません（既定の値を持つフィールドを作成することはできます）。
- **継承**：他の型を継承できず、継承することもできません。ただし、インターフェースの実装は可能です。

#### 使用例

```csharp
public struct Point
{
    public int X { get; set; }
    public int Y { get; set; }
}
```

### `ref struct`

`ref struct` は参照型の構造体であり、特定のメモリ制約があります。主な特徴は次の通りです：

- **参照型**：`ref struct` はスタック上に割り当てられる参照型です。これにより、特定のメモリ管理シナリオで効率的に動作します。
- **メモリ割り当て**：常にスタック上に割り当てられ、ヒープに割り当てられることはありません。
- **スコープ制限**：`ref struct` はアロケータ（`stackalloc` や `Span<T>`）によって制限されるスコープでのみ使用できます。クラスのフィールドとして使用することはできません。
- **ボックス化禁止**：ボックス化できないため、object 型として扱うことはできません。
- **非同期メソッドでの使用制限**：非同期メソッド（`async`/`await`）やイテレータ（`yield return`）では使用できません。

#### 使用例
ref struct の典型的な例は、`Span<T>` です。
```csharp
public ref struct Span<T>
{
    // Span<T> の実装
}
```
#### 使用の具体例
```csharp
public ref struct RefPoint
{
    public int X;
    public int Y;

    public RefPoint(int x, int y)
    {
        X = x;
        Y = y;
    }

    public void Increment()
    {
        X++;
        Y++;
    }
}

public class Example
{
    public void UseRefPoint()
    {
        Span<int> numbers = stackalloc int[10];
        for (int i = 0; i < numbers.Length; i++)
        {
            numbers[i] = i;
        }

        RefPoint point = new RefPoint(1, 2);
        point.Increment();
    }
}
```

### まとめ
- `struct` は値型であり、コピーされるとその値もコピーされます。通常、スタックに割り当てられます。
- `ref struct` は参照型であり、スタック上に割り当てられ、特定のメモリ管理シナリオで効率的に動作します。`Span<T>` などの特定の状況でのみ使用され、非同期メソッドやクラスのフィールドとして使用することはできません。

これらの違いを理解することで、メモリ効率の良いコードを記述し、適切なシナリオでこれらの構造体を選択して使用することができます。
