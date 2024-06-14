# Value Object を使う

Value Object（値オブジェクト）は、プログラム内で単一の値を表現するオブジェクトです。Value Objectは、その値がオブジェクトの同一性に関係なく、その値自体が重要な意味を持つ場合に使用されます。主な特徴は次のとおりです。

1. **不変性（Immutable）**: Value Objectは不変性を持ちます。つまり、作成後にその値が変更されることはありません。これにより、データの安全性やスレッドセーフ性が確保されます。

2. **同一性の基準ではない**: Value Objectはその値自体が重要であり、オブジェクトの同一性が重要ではありません。つまり、異なるオブジェクトでも同じ値を持つ場合は等価であると見なされます。

3. **比較可能**: Value Objectは比較可能であり、等価性や順序関係を確立することができます。同じ値を持つ2つのValue Objectは等価であると見なされます。

Value Objectは、ドメインモデル内で概念的な「もの」や「概念」を表現するために使用されます。

例えば、日付、金額、座標などがValue Objectの典型的な例です。これらの値は、それ自体が重要であり、同じ値を持つオブジェクトが等価であるべきです。Value Objectは、データの整合性を維持し、コードをより理解しやすくするために役立ちます。

また、異なる単位の値を誤って演算してしまうバグをコンパイル時に検出できます。


以下に、望ましいValue Objectの例を示します。

1. **日付（Date）**: 日付は不変の値であり、その値自体が重要です。たとえば、生年月日やイベントの日付などが該当します。.NET には `DateTime`型が標準実装されています。

1. **金額（Money）**: 金額は不変であり、同じ金額を持つオブジェクトは等価です。通貨の単位と金額を含むオブジェクトがValue Objectとして使用されます。

1. **住所（Address）**: 住所は不変の値であり、同じ住所を持つオブジェクトは等価です。国名、郵便番号、都道府県、市町村、番地などを含むValue Objectとして表現されます。

1. **座標（Coordinate）**: 経度と緯度からなる座標は不変の値であり、同じ座標を持つオブジェクトは等価です。地理的位置を表現するために使用されます。

1. **電話番号（PhoneNumber）**: 電話番号は不変の値であり、同じ番号を持つオブジェクトは等価です。国コード、市外局番、番号などを含むValue Objectとして表現されます。

1. **長さ（Length）**: 長さは不変の値であり、同じ長さを持つオブジェクトは等価です。単位（メートル、センチメートル、インチなど）と数値を含むValue Objectとして表現されます。

1. **重さ（Weight）**: 重さは不変の値であり、同じ重さを持つオブジェクトは等価です。単位（キログラム、ポンドなど）と数値を含むValue Objectとして表現されます。

これらの例は、その値自体が重要であり、不変性が望ましい場合にValue Objectとして使用されます。Value Objectは、ドメインモデル内で概念的な「もの」や「概念」を表現し、データの整合性を維持するために役立ちます。

### 実例

金額についてC#12で最も簡潔に実装したものが以下のコードとなります。

```csharp
record struct Money(decimal Amount, string Currency);

```

上記のコードとほぼ等価なコードは古いC#は以下のようなものとなります。

```csharp
public struct Money
{
    public decimal Amount { get; }
    public string Currency { get; }

    public Money(decimal amount, string currency)
    {
        Amount = amount;
        Currency = currency;
    }

    public bool Equals(Money other)
    {
        return Amount == other.Amount && Currency == other.Currency;
    }

    public override int GetHashCode()
    {
        unchecked
        {
            var hash = 17;
            hash = hash * 23 + Amount.GetHashCode();
            hash = hash * 23 + Currency.GetHashCode();
            return hash;
        }
    }

    public override string ToString()
    {
        return $"{Amount} {Currency}";
    }
}
```
