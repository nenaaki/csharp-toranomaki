## `event` と `MulticastDelegate`

### 概要
C# の `event` は、特定のメソッドシグネチャを持つデリゲートを利用してイベントハンドリングを実現します。イベントハンドラーが登録されると、デリゲートのインスタンスが `MulticastDelegate` に保持されます。これにより、複数のハンドラーが同じイベントに対して登録され、発行される際にすべてのハンドラーが順番に呼び出されます。

### `MulticastDelegate` の操作

1. **イベントの登録**
   - イベントハンドラーをイベントに登録する場合、`+=` 演算子を使用します。これは、`MulticastDelegate.Combine` メソッドを使用して、デリゲートのリストに新しいハンドラーを追加することと同等です。

    ```csharp
    public event EventHandler MyEvent;

    public void AddHandler(EventHandler handler)
    {
        MyEvent += handler;
    }
    ```

2. **イベントの解除**
   - イベントハンドラーを解除する場合、`-=` 演算子を使用します。これは、`MulticastDelegate.Remove` メソッドを使用して、デリゲートのリストからハンドラーを削除することと同等です。

    ```csharp
    public void RemoveHandler(EventHandler handler)
    {
        MyEvent -= handler;
    }
    ```

3. **イベントの発行**
   - イベントを発行すると、`Invoke` メソッドが呼び出され、登録されたすべてのハンドラーが順番に呼び出されます。この時、デリゲートのリストに登録されているすべてのメソッドが実行されます。

    ```csharp
    public void RaiseEvent()
    {
        MyEvent?.Invoke(this, EventArgs.Empty);
    }
    ```


### スレッドセーフな操作

スレッドセーフにイベントを発行するために、イベントハンドラーの参照をローカル変数にコピーする手法が一般的です。これにより、他のスレッドがイベントハンドラーを変更しても、安全にイベントを発行できます。

```csharp
EventHandler handler = MyEvent;
handler?.Invoke(this, EventArgs.Empty);
```


### まとめ

C# の `event` はデリゲートの一種であり、`System.MulticastDelegate` を基にしています。`event` を操作することで、実際には `MulticastDelegate` のインスタンスを操作していることになります。これにより、複数のイベントハンドラーを効率的に管理し、順番に呼び出すことができます。スレッドセーフな操作のためには、ローカル変数にデリゲートのコピーを取ることが推奨されます。
