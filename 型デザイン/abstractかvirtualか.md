## オーバーライドの仕方

クラス内でオーバーライドする対象を `abstract` または `virtual` で修飾します。
派生先クラスでオーバーライドする場合は `override` 修飾子を明示的に記述する必要があります。

### `abstract` と `virtual` の比較

`abstract`と`virtual`は、C#でオブジェクト指向プログラミングを行う際に、メソッドやプロパティを継承クラスで再定義（オーバーライド）するために使用されるキーワードです。以下に、それぞれの用い方と違いについて説明します。

#### `abstract` の用い方

`abstract`キーワードは、クラスやメンバー（メソッド、プロパティ、イベントなど）が抽象的であることを示します。抽象クラスはインスタンス化できず、継承して具体的な実装を提供する必要があります。抽象メンバーは、抽象クラス内で宣言され、派生クラスで必ずオーバーライドしなければなりません。

##### 特徴
- **抽象クラス**：インスタンス化できない。
- **抽象メンバー**：派生クラスでオーバーライドが必須。
- **宣言のみ**：実装を持たない。

##### 使用例

```csharp
public abstract class Animal
{
    // 抽象メソッド
    public abstract void MakeSound();

    // 抽象プロパティ
    public abstract string Name { get; set; }
}

public class Dog : Animal
{
    // 抽象メソッドのオーバーライド
    public override void MakeSound()
    {
        Console.WriteLine("Woof");
    }

    // 抽象プロパティのオーバーライド
    public override string Name { get; set; }
}
```

#### `virtual` の用い方

`virtual`キーワードは、メソッドやプロパティを派生クラスでオーバーライド可能にするために使用されます。`virtual`メンバーは、基底クラスで既に実装されており、派生クラスで必要に応じてその実装を変更することができます。

##### 特徴
- **既に実装を持つ**：基底クラスで実装されている。
- **オーバーライド可能**：派生クラスでオーバーライドが任意。
- **再利用可能**：基底クラスの実装をそのまま使用することも、変更することも可能。

##### 使用例

```csharp
public class Animal
{
    // 仮想メソッド
    public virtual void MakeSound()
    {
        Console.WriteLine("Some generic animal sound");
    }

    // 仮想プロパティ
    public virtual string Name { get; set; }
}

public class Dog : Animal
{
    // 仮想メソッドのオーバーライド
    public override void MakeSound()
    {
        Console.WriteLine("Woof");
    }

    // 仮想プロパティのオーバーライド
    public override string Name { get; set; }
}
```

#### `abstract` と `virtual` の比較

| 特徴                     | `abstract`                           | `virtual`                              |
|--------------------------|--------------------------------------|----------------------------------------|
| **メンバーの実装**       | 実装なし（宣言のみ）                 | 既に実装を持つ                         |
| **オーバーライドの必要性**| 派生クラスで必ずオーバーライドが必要 | 派生クラスでのオーバーライドは任意     |
| **クラスのインスタンス化**| 抽象クラスはインスタンス化不可       | 通常のクラス（インスタンス化可能）     |
| **使用例**               | 抽象クラス内でのメンバー宣言に使用   | 基底クラス内でのオーバーライド可能なメンバーに使用 |

#### 具体例による比較

```csharp
public abstract class Shape
{
    // 抽象メソッド
    public abstract double Area();
}

public class Circle : Shape
{
    private double radius;

    public Circle(double radius)
    {
        this.radius = radius;
    }

    // 抽象メソッドのオーバーライド
    public override double Area()
    {
        return Math.PI * radius * radius;
    }
}

public class BaseClass
{
    // 仮想メソッド
    public virtual void Display()
    {
        Console.WriteLine("BaseClass Display");
    }
}

public class DerivedClass : BaseClass
{
    // 仮想メソッドのオーバーライド
    public override void Display()
    {
        Console.WriteLine("DerivedClass Display");
    }
}
```

`abstract`は、派生クラスで具体的な実装を提供しなければならないため、共通のインターフェースや基本的な構造を提供する際に使用されます。

一方、`virtual`は、基底クラスで基本的な実装を提供し、必要に応じて派生クラスでその実装を変更する際に使用されます。
