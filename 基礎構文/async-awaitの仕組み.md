### `async` / `await` の仕組みについて

`async` / `await` は、非同期プログラミングを簡素化し、読みやすくするために導入されたC#の機能です。この構文を使うことで、非同期操作のコールバック地獄を回避し、直線的なコードスタイルで非同期処理を記述できます。

#### 基本的な概念

- **`async` 修飾子**:
  - メソッド、ラムダ式、または匿名メソッドに適用されます。
  - 非同期メソッドであることを示し、`await` キーワードを使用できるようにします。
  - 非同期メソッドは `Task` または `Task<T>` を返す必要があります。

- **`await` キーワード**:
  - 非同期操作が完了するまでメソッドの実行を一時停止し、操作完了後に実行を再開します。
  - `await` される操作は、通常 `Task` または `Task<T>` 型のオブジェクトです。

#### `async` / `await` の動作

1. **非同期メソッドの呼び出し**:
   - 非同期メソッドが呼び出されると、すぐに `Task` が返されます。この `Task` はメソッドの進行を表します。

2. **非同期操作の開始**:
   - 非同期メソッド内で `await` キーワードにより非同期操作が開始されます。

3. **一時停止とコールバック**:
   - `await` により、非同期操作が完了するまでメソッドの実行が一時停止されます。
   - 操作が完了すると、メソッドの実行が中断された位置から再開されます。

4. **例外処理**:
   - `await` により例外が発生した場合、その例外はメソッド呼び出し元に伝播します。

#### 例

```csharp
public async Task<int> GetDataAsync()
{
    HttpClient client = new HttpClient();
    string result = await client.GetStringAsync("http://example.com");
    return result.Length;
}

public async Task Example()
{
    int length = await GetDataAsync();
    Console.WriteLine($"Data length: {length}");
}
```

#### 詳細な説明

`async` / `await` は、コンパイラによって状態マシンに変換されます。これにより、非同期操作の進行状況が管理され、操作完了後にメソッドの実行が正しく再開されるようにします。

- **状態マシンの生成**:
  - 非同期メソッドは、コンパイラによって状態マシンに変換されます。この状態マシンは、非同期操作の進行状況を管理し、操作完了後にメソッドの再開を処理します。

- **メソッドの再開**:
  - 非同期操作が完了すると、`await` の後のコードが続行されます。`await` による中断前のコンテキストは保存され、中断後に適切に復元されます。

- **リソース管理**:
  - 非同期メソッド内で使用されるリソースは、`using` ステートメントなどの構文を使用して管理できます。`await` による中断があっても、リソースの解放は確実に行われます。

#### 例: 状態マシンの概念

以下は、`async` / `await` の状態マシンの概念を簡略化したものです。

```csharp
public Task<int> GetDataAsync()
{
    var stateMachine = new GetDataAsyncStateMachine();
    stateMachine.MoveNext();
    return stateMachine.Task;
}

private class GetDataAsyncStateMachine : IAsyncStateMachine
{
    public Task<int> Task { get; private set; }
    private int state = -1;
    private TaskAwaiter<string> awaiter;

    public void MoveNext()
    {
        if (state == -1)
        {
            var client = new HttpClient();
            awaiter = client.GetStringAsync("http://example.com").GetAwaiter();
            if (!awaiter.IsCompleted)
            {
                state = 0;
                awaiter.OnCompleted(MoveNext);
                return;
            }
        }
        if (state == 0)
        {
            var result = awaiter.GetResult();
            Task = System.Threading.Tasks.Task.FromResult(result.Length);
        }
    }

    public void SetStateMachine(IAsyncStateMachine stateMachine) { }
}
```

このように、`async` / `await` を使用することで、非同期プログラミングの複雑さを隠し、シンプルで直感的なコードを書けるようにするための強力なツールを提供します。コンパイラが状態マシンを生成してくれるため、開発者はその内部の複雑さを意識することなく非同期処理を実装できます。

### `async` / `await` で `void` を返すべきではない理由と例外

#### 理由

1. **エラーハンドリングの難しさ**:
   - `void` を返す `async` メソッドは、呼び出し元がエラーをキャッチすることができません。例外がスローされても、呼び出し元で適切に処理できないため、エラーの追跡とデバッグが困難になります。
   - `Task` または `Task<T>` を返す `async` メソッドでは、`await` によって例外が呼び出し元に伝播し、適切にキャッチおよび処理できます。

2. **非同期プログラミングの一貫性**:
   - 非同期メソッドが `void` を返すと、他の非同期メソッドと一貫性が取れなくなります。通常、非同期メソッドは `Task` または `Task<T>` を返すため、特別なケースを扱う必要が出てきます。

3. **コールバックの扱い**:
   - `Task` または `Task<T>` を返す非同期メソッドでは、メソッドの完了を待つことができ、続けて実行するアクションを簡単に設定できます。`void` を返す場合、このような操作が難しくなります。

#### 例外

1. **イベントハンドラー**:
   - イベントハンドラーは `void` を返すことが求められるため、`async void` メソッドが使われます。これらはデリゲートで定義され、戻り値が `void` であることが前提となっています。
   - 例外は `TaskScheduler.UnobservedTaskException` イベントでキャッチされるか、アプリケーションのデフォルトの例外処理によって処理されます。

```csharp
public class Example
{
    public event EventHandler MyEvent;

    public async void OnMyEvent()
    {
        // 非同期に何かを実行
        await Task.Delay(1000);
        Console.WriteLine("Event triggered");
    }

    public void RaiseEvent()
    {
        MyEvent?.Invoke(this, EventArgs.Empty);
    }
}
```

2. **トップレベルのエントリポイント**:
    - C# 7.1 からは、`Main` メソッドで `async Task` がサポートされるようになりましたが、それ以前はエントリポイントは `void` でなければなりませんでした。その場合、非同期処理を行うために `async void` が使われることがありました。

```csharp
public class Program
{
    public static async Task Main(string[] args)
    {
        await RunAsync();
    }

    private static async Task RunAsync()
    {
        await Task.Delay(1000);
        Console.WriteLine("Hello, world!");
    }
}
```
3. WPF の `ICommand.Execute` メソッド:
    - WPF でコマンドを実装する場合、`ICommand.Execute` メソッドのシグネチャは `void` です。非同期処理を行うために、`async void` を使用することがあります。
    - この場合でも、エラーハンドリングが難しくなるため、非同期処理を内部で `Task` に委譲し、適切にエラーハンドリングを行うことが推奨されます。

```csharp
public class AsyncCommand : ICommand
{
    public event EventHandler CanExecuteChanged;

    public bool CanExecute(object parameter) => true;

    public async void Execute(object parameter)
    {
        try
        {
            await ExecuteAsync(parameter);
        }
        catch (Exception ex)
        {
            // エラーハンドリング
            Console.WriteLine(ex);
        }
    }

    private Task ExecuteAsync(object parameter)
    {
        // 非同期処理
        return Task.Delay(1000);
    }
}
```

### まとめ

1. 推奨される方法:

    - 非同期メソッドは、基本的に `Task` または `Task<T>` を返すべきです。これにより、エラーハンドリングが簡単になり、一貫した非同期プログラミングが可能になります。

1. 例外的なケース:

    - イベントハンドラーや特定のエントリポイント、WPF の `ICommand.Execute` などでは `async void` を使用する必要がありますが、これらは例外的なケースであり、通常のメソッドでは避けるべきです。