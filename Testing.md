# **测试说明**

## **1. 准备账号**
|类型|地址|私钥|
|---|---|---|
|Owner|0x8C09f4007c42241B3cEBE832E598cEEA928bD621|36ff3ce540cc9313c970d231e12b77620874375bb9df441fc414864417cef849|
|Admin|0xd27513F91b9375887421e1D35Cc0Ea9130a859bb|984174c732bf69cfc01c80c05c00c8eb5ac6e55238514b021197042dd42c1f91|
|Dispatcher|0xDfD1BE128eD36BDe8d263B98979A1D6ef1FdF946|429ac242fc751c4a7ddf110ecc7c20bffe4af054d658c656521ba1f45e2feb15|
|手续费钱包|0x499A465e20767b975a09c83D4a5872F6d5deD220|10305d98cca482f81c69468ec64913cc89bb9e7458cbad77dec7e03fd2cabfe2|
|测试钱包1|0xcCB98929A6D118d51224F6451F8CBE599E9343BE|a793a6351ee63c9cf6278784f7d3939084d81cd2ef7663ffe8c1931ad07a1f7f|
|测试钱包2|0x11b5A8efFa4E05EF833C8b987bc0c3336eF81eEf|e701b622b54dee377f974013f3b7e84cfc8cd89f9b62134128ef63eced67545e|
***
## **2. 编译合约**
使用以下参数编译Exchange和Custodian两个合约
> 编译器版本: `0.8.9+commit.e5eed63a`  
> EVM版本: `constantinople`  
> 优化: 开启  
> 优化轮数: 13
***
## **3. 部署合约**
- 使用Owner账号部署Exchange合约，无部署参数，部署后的合约地址为0x1dc28e480d37d695796dd465eb4c5ebb39471852  
- 使用Owner账号部署Custodian合约，部署参数为0x1dc28e480d37d695796dd465eb4c5ebb39471852（即Exchange合约的地址），部署后的合约地址为0xE547C11039534654aEDfac6b87a52702450ee4Ee
***
## **4. 初始化Exchange合约**
- 使用Owner账号调用Exchange合约的`setAdmin`方法设置Admin账号为`0xd27513F91b9375887421e1D35Cc0Ea9130a859bb`  
- 使用Admin账号调用Exchange合约的`setCustodian`方法设置通证托管合约地址为`0xE547C11039534654aEDfac6b87a52702450ee4Ee`  
- 使用Admin账号调用Exchange合约的`setDispatcher`方法设置Dispatcher账号为`0xDfD1BE128eD36BDe8d263B98979A1D6ef1FdF946`  
- 使用Admin账号调用Exchange合约的`setFeeWallet`方法设置手续费钱包账号为`0x499A465e20767b975a09c83D4a5872F6d5deD220`  
- 使用Admin账号调用Exchange合约的`setChainPropagationPeriod`方法设置确认块个数为20  
***
## **5. 创建测试通证**
部署两个BEP20测试通证（可以使用YottaCoin合约部署），相关信息如下
|通证名称|通证标识|小数位|发行量|合约地址|
|---|---|---|---|---|
|TestCoin1|TSC1|18|10亿|0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe|
|TestCoin2|TSC2|6|8000万|0x52a6432d0a04a43A92e3b0145A4a5d160369C26f|

分别为测试钱包1和2转账1000万TSC1和100万TSC2
***
## **6. 注册通证**
使用Admin账号调用Exchange合约的`registerToken`方法注册上一步创建的两个测试通证，参数如下

> **TestCoin1:**
> - tokenAddress: 0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe
> - symbol: TSC1
> - decimals: 18

> **TestCoin2:**
> - tokenAddress: 0x52a6432d0a04a43A92e3b0145A4a5d160369C26f
> - symbol: TSC2
> - decimals: 6
***
## **7. 确认注册**
使用Admin账号调用Exchange合约的`confirmTokenRegistration`方法确认上一步注册的两个测试通证，参数需要与上一步相同，分别为

> **TestCoin1:**
> - tokenAddress: 0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe
> - symbol: TSC1
> - decimals: 18

> **TestCoin2:**
> - tokenAddress: 0x52a6432d0a04a43A92e3b0145A4a5d160369C26f
> - symbol: TSC2
> - decimals: 6

之后可以使用任意账号调用Exchange合约的`loadAssetBySymbol`方法查询已确认的通证信息，参数为通证标识和当前时间戳（毫秒级）
***
## **8. 入金**
### **8.1. BNB入金**
可以通过直接发送BNB至Exchange合约`depositBNB`方法进行入金操作
- 使用测试钱包1调用Exchange合约的depositBNB方法，入金0.2BNB
- 使用测试钱包2调用Exchange合约的depositBNB方法，入金0.15BNB

然后对入金金额进行确认，首先是测试钱包1
- 调用Exchange合约的`loadBalanceInAssetUnitsByAddress`方法，参数分别为测试钱包1的地址和BNB的地址（BNB地址为0x0000000000000000000000000000000000000000），返回值为200000000000000000
- 调用Exchange合约的`loadBalanceInAssetUnitsBySymbol`方法，参数分别为测试钱包1的地址和BNB的通证标识（即BNB），返回值为200000000000000000
- 调用Exchange合约的`loadBalanceInPipsByAddress`方法，参数分别为测试钱包1的地址和BNB的地址，返回值为20000000（返回值采用Exchange合约的内部通证精度，所有通证的decimals均在Exchange合约内部被转换为8）
- 调用Exchange合约的`loadBalanceInPipsBySymbol`方法，参数分别为测试钱包1的地址和BNB的通证标识，返回值为20000000
然后确认测试钱包2
- 调用Exchange合约的`loadBalanceInAssetUnitsByAddress`方法，参数分别为测试钱包2的地址和BNB的地址，返回值为150000000000000000
- 调用Exchange合约的`loadBalanceInAssetUnitsBySymbol`方法，参数分别为测试钱包2的地址和BNB的通证标识，返回值为150000000000000000
- 调用Exchange合约的`loadBalanceInPipsByAddress`方法，参数分别为测试钱包2的地址和BNB的地址，返回值为15000000
- 调用Exchange合约的`loadBalanceInPipsBySymbol`方法，参数分别为测试钱包2的地址和BNB的通证标识，返回值为15000000

### **8.2. BEP20通证入金**
BEP20通证的入金方法与BNB入金不同，需要首先由用户发起一笔授权交易，授权地址为Exchange合约地址，之后用户才可以通过调用Exchange合约的`depositTokenByAddress`或`depositTokenBySymbol`方法发起一笔从用户钱包到Exchange合约的入金交易，首先测试下测试钱包1的入金
- 使用测试钱包1调用TestCoin1合约的`approve`方法为Exchange合约授权10万额度，参数为Exchange合约的地址和100000000000000000000000，然后使用测试钱包1调用Exchange合约的`depositTokenByAddress`方法入金10万TSC1，参数为TestCoin1合约的地址和100000000000000000000000
- 使用测试钱包1调用TestCoin2合约的`approve`方法为Exchange合约授权20万额度，参数为Exchange合约的地址和200000000000，然后使用测试钱包1调用Exchange合约的`depositTokenByAddress`方法入金20万TSC2，参数为TestCoin2合约地址和200000000000
- 使用`loadBalanceInAssetUnitsByAddress`等方法验证测试钱包1入金的金额
然后测试下测试钱包2的入金操作
- 使用测试钱包2调用TestCoin1合约的`approve`方法为Exchange合约授权50万额度，参数为Exchange合约的地址和500000000000000000000000，然后使用测试钱包2调用Exchange合约的`depositTokenBySymbol`方法入金50万TSC1，参数为TestCoin1合约标识（TSC1）和500000000000000000000000
- 使用测试钱包2调用TestCoin2合约的`approve`方法为Exchange合约授权8万额度，参数为Exchange合约的地址和80000000000，然后使用测试钱包2调用Exchange合约的`depositTokenBySymbol`方法入金8万TSC2，参数为TestCoin2合约标识（TSC2）和80000000000
- 使用`loadBalanceInAssetUnitsByAddress`等方法验证测试钱包2入金的金额
***
## **9. 提现**
提现操作需要由Dispatcher账号发起，调用Exchange合约的`withdraw`方法，参数为`Withdrawal`结构体，在合约中定义如下：
````javascript
//提现结构体，保存单次提现需要的全部信息
struct Withdrawal {
    //提现方式，通过通证标识符（0）或通证合约地址（1）
    Enums.WithdrawalType withdrawalType;
    //UUIDv1
    uint128 nonce;
    //提现目标钱包的地址，该钱包也负责生成签名walletSignature
    address payable walletAddress;
    //要提现的通证合约标识，withdrawalType为0时使用该字段
    string assetSymbol;
    //要提现的通证合约地址，withdrawalType为1时使用该字段
    address assetAddress;
    //提现数量，使用Exchange合约的内部精度表示
    uint64 quantityInPips;
    //交易手续费，手续费比例不能超过Exchange合约内部定义的手续费比例上限（目前为20%），使用Exchange合约内部精度表示
    uint64 gasFeeInPips;
    //保留字段，固定为true
    bool autoDispatchEnabled;
    //提现操作的ECDSA签名，由walletAddress表示的钱包签发
    bytes walletSignature;
}
````
首先使用测试钱包1执行提现10000TSC1的操作，首先使用以下参数填充Withdrawal结构体
> withdrawalType: 使用通证标识符提现的方式，值为0  
> nonce: 实时生成的UUIDv1，生成方式参照下边的代码部分  
> walletAddress: 要提现的钱包地址，这里为测试钱包1的地址0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe  
> assetSymbol: 要提现的通证标识，这里为TSC1，如果withdrawalType为1，可以不设置该值  
> assetAddress: 要提现的通证合约地址，由于本次操作我们通过通证标识符进行提现，这里可以使用空地址0x0000000000000000000000000000000000000000，如果withdrawalType为1，则需要设置该值  
> quantityInPips: 要提现通证数量，这里为10000TSC1，需要使用Exchange合约的内部精度转换为1000000000000  
> gasFeeInPips: 提现手续费，由中心化交易所计算生成，这里设置为50TSC1（即千分之五的提现手续费），这里也需要使用Exchange合约的内部精度转换为5000000000  
> autoDispatchEnabled: 固定为true  
> walletSignature: 交易签名，由walletAddress表示的钱包签发，签名使用到的字段为`nonce`、`walletAddress`、`assetSymbol`或`assetAddress`（取决于`withdrawalType`）、`quantityInPips`、`autoDispatchEnabled`，参考下边的代码生成

下边的代码演示了签名如何生成
````go
package main

import (
    "encoding/hex"
    "fmt"

    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/crypto"

    uuid "github.com/satori/go.uuid"
)

func main() {
    //生成UUIDv1
    nonce := uuid.NewV1().Bytes()
    //要提现到的钱包地址，这里为测试账号1
    walletAddress := common.HexToAddress("0xcCB98929A6D118d51224F6451F8CBE599E9343BE").Bytes()
    //要提现的通证标识符，这里为TSC1，本次交易采用指定通证标识符的方式，如果使用通证合约地址这里需要改为assetAddress := common.HexToAddress("0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe").Bytes()
    assetSymbol := []byte("TSC1")
    //要提现的TSC1通证的金额，这里为10000TSC1，Exchange合约内部表示形式为1000000000000，签名时需要使用pipToDecimal方法转换为小数字符串，转换结果为10000.00000000
    quantityInPips := []byte(pipToDecimal(1000000000000))
    //保留字段，固定为1（即true）
    autoDispatchEnabled := []byte{1}
    fmt.Println("nonce: ", hex.EncodeToString(nonce))
    fmt.Println("walletAddress: ", hex.EncodeToString(walletAddress))
    fmt.Println("assetSymbol: ", string(assetSymbol))
    fmt.Println("quantityInPips: ", string(quantityInPips))
    fmt.Println("autoDispatchEnabled: ", hex.EncodeToString(autoDispatchEnabled))
    //计算Hash
    hash := crypto.Keccak256Hash(nonce, walletAddress, assetSymbol, quantityInPips, autoDispatchEnabled)
    fmt.Println("Hash: ", hash.Hex())
    //生成带前缀的Hash，合约内部验签需要使用这个Hash值
    prefixedHash := crypto.Keccak256Hash(
        []byte("\x19Ethereum Signed Message:\n32"),
        hash.Bytes(),
    )
    fmt.Println("prefixedHash: ", prefixedHash.Hex())
    //这是测试账号1的私钥
    privateKey, err := crypto.HexToECDSA("a793a6351ee63c9cf6278784f7d3939084d81cd2ef7663ffe8c1931ad07a1f7f")
    if err != nil {
        panic(err)
    }
    //使用测试账号1的私钥进行签名
    sig, err := crypto.Sign(prefixedHash.Bytes(), privateKey)
    if err != nil {
        panic(err)
    }
    //签名Hack
    sig[64] += 27
    fmt.Println("Signature: ", hex.EncodeToString(sig))
}

//该方法将Exchange合约的内部精度形式表示为小数字符串，固定保留8位小数，比如数值1234567890会被转换为字符串"12.34567890"
func pipToDecimal(pips uint64) string {
    var copy uint64 = pips
    var length uint64 = 0
    for copy != 0 {
        length++
        copy /= 10
    }
    if length < 9 {
        length = 9
    }
    length++
    decimal := make([]uint8, length)
    for i := length; i > 0; i-- {
        if length-i == 8 {
            decimal[i-1] = uint8(46)
        } else {
            decimal[i-1] = uint8(48 + (pips % 10))
            pips /= 10
        }
    }
    return string(decimal)
}
````
执行以上代码的输出结果为：
````go
nonce:  4b777a1a42bb11ecbaab7085c2b700ea
walletAddress:  ccb98929a6d118d51224f6451f8cbe599e9343be
assetSymbol:  TSC1
quantityInPips:  10000.00000000
autoDispatchEnabled:  01
Hash:  0x3dc38588689dc8b743eaa5bb40e1448a51a8e077e840b02ac1722c4b3962ebe2
prefixedHash:  0x8f26d7cad4f5adbe3ec671fb383992fe66d6789c9ff66f78bc32c38dccc2cf7d
Signature:  3e59f19ce50363b7cae660f76794d1760f85e4188aeea8c190c9217c01cc4c7d4e674249ab0c87ddc980d81cd267fa6e0736351e0c6bc496e68b9c0680cb51871b
````

最后使用Dispatcher账号发起提现交易，在remix的方法参数中结构体类型使用数组形式表示，下边我们根据`Withdrawal`结构体中的参数顺序进行构造：
````javascript
[0,"0x4b777a1a42bb11ecbaab7085c2b700ea","0xcCB98929A6D118d51224F6451F8CBE599E9343BE","TSC1","0x0000000000000000000000000000000000000000",1000000000000,5000000000,true,"0x3e59f19ce50363b7cae660f76794d1760f85e4188aeea8c190c9217c01cc4c7d4e674249ab0c87ddc980d81cd267fa6e0736351e0c6bc496e68b9c0680cb51871b"]
````
使用该参数执行`withdraw`方法，成功后查看测试钱包1在Exchange合约内的TSC1余额，可以发现减少了10000TSC1，变为90000TSC1，内部形式为9000000000000，手续费账号的TSC1余额由0变为5000000000，结果符合构建的提现参数。
***
## **10. 交易结算**
交易结算操作需要由Dispatcher账号发起，调用Exchange合约的`executeTrade`方法，方法参数有三个，分别为买方订单buy、卖方订单sell和交易信息trade。其中buy和sell的类型是`Order`结构体，trade的类型是`Trade`结构体，定义如下：
````javascript
//订单结构体，保存用户单次挂单中的全部信息
struct Order {
    //签名版本号，目前固定为1
    uint8 signatureHashVersion;
    //UUIDv1
    uint128 nonce;
    //发起订单和生成签名的钱包地址
    address walletAddress;
    //订单类型，市价（Market）订单为0，限价（Limit）订单为1
    Enums.OrderType orderType;
    //订单类型，买单（Buy）为0，卖单（Sell）为1
    Enums.OrderSide side;
    //使用Exchange合约内部精度表示的通证挂单数量，该数量的单位是基础通证（base token）还是计价通证（quota token）是由 isQuantityInQuote字段决定
    uint64 quantityInPips;
    //如果quantityInPips表示计价通证的数量则为true（此时一般为市价买单），否则为false
    bool isQuantityInQuote;
    //对于限价订单，该值表示订单价格，使用Exchange合约内部精度表示
    uint64 limitPriceInPips;
    // 对于止损订单，该值表示止损价格，使用Exchange合约内部精度表示
    uint64 stopPriceInPips;
    //客户端订单ID（可选）
    string clientOrderId;
    //限价订单执行策略，分别为gtc（0）、gtt（1）、ioc（2）、fok（3），目前默认使用gtc
    Enums.OrderTimeInForce timeInForce;
    //防自交策略，分别为dc（0）、co（1）、cn（2）、cb（3），目前默认使用cb
    Enums.OrderSelfTradePrevention selfTradePrevention;
    //如果timeInForce的值是gtt（1），该值表示订单超时的时间戳，目前设置为0即可
    uint64 cancelAfter;
    // ECDSA签名，由walletAddress表示的钱包签发,签名使用到的字段为signatureHashVersion、nonce、walletAddress、marketSymbol（Order结构体中没有该参数，是由executeTrade方法参数中的Trade结构体提供）、orderType、side、quantityInPips、isQuantityInQuote、limitPriceInPips、stopPriceInPips、clientOrderId、timeInForce、selfTradePrevention
    bytes walletSignature;
}

//交易信息结构体，保存一次订单撮合中的全部信息
struct Trade {
    //基础通证标识符
    string baseAssetSymbol;
    //计价通证标识符
    string quoteAssetSymbol;
    //基础通证合约地址
    address baseAssetAddress;
    //计价通证合约地址
    address quoteAssetAddress;
    //基础通证的总交易额（包括手续费），使用Exchange合约内部精度表示
    uint64 grossBaseQuantityInPips;
    //计价通证的总交易额（包括手续费），使用Exchange合约内部精度表示
    uint64 grossQuoteQuantityInPips;
    //买方钱包收到扣除手续费后的基础通证净额，使用Exchange合约内部精度表示
    uint64 netBaseQuantityInPips;
    //卖方钱包收到扣除手续费后的计价通证净额，使用Exchange合约内部精度表示
    uint64 netQuoteQuantityInPips;
    //挂单手续费通证合约的地址
    address makerFeeAssetAddress;
    //吃单手续费通证合约的地址
    address takerFeeAssetAddress;
    //挂单手续费，使用Exchange合约内部精度表示
    uint64 makerFeeQuantityInPips;
    //吃单手续费，使用Exchange合约内部精度表示
    uint64 takerFeeQuantityInPips;
    //交易价格，使用Exchange合约内部精度表示
    uint64 priceInPips;
    //挂单方向（买为0，卖为1）
    Enums.OrderSide makerSide;
}
````
下边我们模拟一笔撮合成功的限价交易，交易对为TSC1-BNB，测试账户1挂买单，以0.0003BNB的价格买入100个TSC1，测试账户2挂卖单，以0.0003BNB的价格卖出150个TSC1，买单为挂单（maker），卖单为吃单（taker），挂单手续费为0.1%，吃单手续费为0.5%，下边我们分别构造结构体，首先是买单：
> signatureHashVersion: 签名版本号，目前固定为1  
> nonce: 实时生成的UUIDv1，参照后边的代码部分  
> walletAddress: 挂买单的钱包地址，此处为测试钱包1的地址0xcCB98929A6D118d51224F6451F8CBE599E9343BE  
> orderType: 订单类型，此处为1（限价单）  
> side: 交易方向，此处为0（买单）  
> quantityInPips: 挂单数量，此处为10000000000  
> isQuantityInQuote: quantityInPips是否为计价通证数量，此处为false  
> limitPriceInPips: 订单价格，此处为30000  
> stopPriceInPips: 止损订单价格，此处为0  
> clientOrderId: 客户端订单ID，此处为空字符串  
> timeInForce: 限价单执行策略，此处为0（gtc）  
> selfTradePrevention: 防自交策略，此处为3（cb）  
> cancelAfter: 限价单执行策略为gtt时的订单超时时间，此处为0  
> walletSignature: 订单签名，参考下边代码生成  
````go
import (
    "encoding/binary"
    "encoding/hex"
    "fmt"

    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/crypto"
    uuid "github.com/satori/go.uuid"
)

func main() {
    //签名版本号，固定为1
    signatureHashVersion := []byte{1}
    //生成UUIDv1
    nonce := uuid.NewV1().Bytes()
    //挂买单的钱包地址，这里为测试账号1
    walletAddress := common.HexToAddress("0xcCB98929A6D118d51224F6451F8CBE599E9343BE").Bytes()
    //交易对名称
    marketSymbol := []byte("TSC1-BNB")
    //订单类型，限价单为1
    orderType := []byte{1}
    //交易方向，买单为0
    side := []byte{0}
    //挂单数量，这里为100TSC1，Exchange合约内部表示形式为10000000000，这里需要使用pipToDecimal方法转换为小数字符串，转换结果为100.00000000
    quantityInPips := []byte(pipToDecimal(10000000000))
    //quantityInPips是否为计价通证数量，此处应为false，转换为0
    isQuantityInQuote := []byte{0}
    //限价单挂单价格，这里为0.0003BNB，Exchange合约内部表示形式为30000，这里需要使用pipToDecimal方法转换为小数字符串，转换结果为0.00030000，其他订单类型不需要这个字段，需要在计算Hash时去掉
    limitPriceInPips := []byte(pipToDecimal(30000))
    //止损单止损价格，其他订单不需要这个字段
    // stopPriceInPips := []byte{}
    //客户端订单ID，这里为空
    clientOrderId := []byte{}
    //限价单执行策略，此处为0（gtc）
    timeInForce := []byte{0}
    //防自交策略，此处为3（cb）
    selfTradePrevention := []byte{3}
    //如果timeInForce的值是gtt（1），该值表示订单超时的时间戳，目前设置为0即可
    cancelAfterUint64 := uint64(0)
    cancelAfter := make([]byte, 8)
    binary.BigEndian.PutUint64(cancelAfter, cancelAfterUint64)
    fmt.Println("signatureHashVersion: ", hex.EncodeToString(signatureHashVersion))
    fmt.Println("nonce: ", hex.EncodeToString(nonce))
    fmt.Println("walletAddress: ", hex.EncodeToString(walletAddress))
    fmt.Println("marketSymbol: ", string(marketSymbol))
    fmt.Println("orderType: ", hex.EncodeToString(orderType))
    fmt.Println("side: ", hex.EncodeToString(side))
    fmt.Println("quantityInPips: ", string(quantityInPips))
    fmt.Println("isQuantityInQuote: ", hex.EncodeToString(isQuantityInQuote))
    fmt.Println("limitPriceInPips: ", string(limitPriceInPips))
    fmt.Println("clientOrderId: ", string(clientOrderId))
    fmt.Println("timeInForde: ", hex.EncodeToString(timeInForce))
    fmt.Println("selfTradePrevention: ", hex.EncodeToString(selfTradePrevention))
    fmt.Println("cancelAfter: ", hex.EncodeToString(cancelAfter))

    //生成交易的Hash,注意非限价单需要去掉limitPriceInPips这个参数
    hash := crypto.Keccak256Hash(signatureHashVersion, nonce, walletAddress, marketSymbol, orderType, side, quantityInPips, isQuantityInQuote, limitPriceInPips, clientOrderId, timeInForce, selfTradePrevention, cancelAfter)
    fmt.Println("Hash: ", hash.Hex())
    //生成带前缀的Hash，合约内部验签需要使用这个Hash值
    prefixedHash := crypto.Keccak256Hash(
        []byte("\x19Ethereum Signed Message:\n32"),
        hash.Bytes(),
    )
    fmt.Println("prefixedHash: ", prefixedHash.Hex())
    //这是测试账号1的私钥
    privateKey, err := crypto.HexToECDSA("a793a6351ee63c9cf6278784f7d3939084d81cd2ef7663ffe8c1931ad07a1f7f")
    if err != nil {
        panic(err)
    }
    //使用测试账号1的私钥进行签名
    sig, err := crypto.Sign(prefixedHash.Bytes(), privateKey)
    if err != nil {
        panic(err)
    }
    //签名Hack
    sig[64] += 27
    fmt.Println("Signature: ", hex.EncodeToString(sig))
}
````
以上代码的执行结果为：
````go
signatureHashVersion:  01
nonce:  10b6bebb42bc11ec9a717085c2b700ea
walletAddress:  ccb98929a6d118d51224f6451f8cbe599e9343be
marketSymbol:  TSC1-BNB
orderType:  01
side:  00
quantityInPips:  100.00000000
isQuantityInQuote:  00
limitPriceInPips:  0.00030000
clientOrderId:
timeInForde:  00
selfTradePrevention:  03
cancelAfter:  0000000000000000
Hash:  0x1752a3c3314f96d0f193d567958f32089ddea3af88cd591baca4e8d3c2450e9a
prefixedHash:  0x90adeb9c4b95e54e522e60ff17b595d2d3df634cf4d23001d7d6f3f0a677ef28
Signature:  952d568dbeedb70907350c43daf5b12100bf080501c7d40cdf19a708da9abccd1e90921100696c2dcb38de192179f92a6dcca0db2d084d2ba73824b705f999fb1c
````
在remix的方法参数中结构体类型使用数组形式表示，下边根据`Order`结构体中的参数顺序构造买单参数：
````javascript
[1,"0x10b6bebb42bc11ec9a717085c2b700ea","0xcCB98929A6D118d51224F6451F8CBE599E9343BE",1,0,10000000000,false,30000,0,"",0,3,0,"0x952d568dbeedb70907350c43daf5b12100bf080501c7d40cdf19a708da9abccd1e90921100696c2dcb38de192179f92a6dcca0db2d084d2ba73824b705f999fb1c"]
````
接下来构造卖单：
> signatureHashVersion: 签名版本号，目前固定为1  
> nonce: 实时生成的UUIDv1，参照上边的代码部分  
> walletAddress: 挂卖单的钱包地址，此处为测试钱包2的地址0x11b5A8efFa4E05EF833C8b987bc0c3336eF81eEf  
> orderType: 订单类型，此处为1（限价单）  
> side: 交易方向，此处为1（卖单）  
> quantityInPips: 挂单数量，此处为15000000000
> isQuantityInQuote: quantityInPips是否为计价通证数量，此处为false  
> limitPriceInPips: 订单价格，此处为30000  
> stopPriceInPips: 止损订单价格，此处为0  
> clientOrderId: 客户端订单ID，此处为空字符串  
> timeInForce: 限价单执行策略，此处为0（gtc）  
> selfTradePrevention: 防自交策略，此处为3（cb）  
> cancelAfter: 限价单执行策略为gtt时的订单超时时间，此处为0  
> walletSignature: 订单签名，参考上边代码生成  

修改上边代码中的参数，然后执行代码生成签名，输出为：
````go
signatureHashVersion:  01
nonce:  7f59f51b42bc11ecaa4b7085c2b700ea
walletAddress:  11b5a8effa4e05ef833c8b987bc0c3336ef81eef
marketSymbol:  TSC1-BNB
orderType:  01
side:  01
quantityInPips:  150.00000000
isQuantityInQuote:  00
limitPriceInPips:  0.00030000
clientOrderId:
timeInForde:  00
selfTradePrevention:  03
cancelAfter:  0000000000000000
Hash:  0x12d6995500a0ebf91ddddc1e3075b108130556901f57ce37e6c761ddbebb9fa0
prefixedHash:  0x880700f71204c8fda6ccc4dac4d1d4a6340cf635f9367f2f652f19ad65e39440
Signature:  d88210e48b508199b6d7f5ecdb14946213d659a3a69713f61632752c05e62d7a2c5d33165c4d642b9dfd6b3260e063b19f04055ce400d8e1fd66a006dafeaa821c
````
接下来用生成的参数按顺序构造卖单参数：
````javascript
[1,"0x7f59f51b42bc11ecaa4b7085c2b700ea","0x11b5A8efFa4E05EF833C8b987bc0c3336eF81eEf",1,1,15000000000,false,30000,0,"",0,3,0,"0xd88210e48b508199b6d7f5ecdb14946213d659a3a69713f61632752c05e62d7a2c5d33165c4d642b9dfd6b3260e063b19f04055ce400d8e1fd66a006dafeaa821c"]
````
最后构造Trade参数：
> baseAssetSymbol: 基础通证标识符，此处为TSC1  
> quoteAssetSymbol: 计价通证标识符，此处为BNB  
> baseAssetAddress: 基础通证合约地址，此处为TSC1的合约地址  
> quoteAssetAddress: 计价通证合约地址，此处为BNB的地址（0x0000000000000000000000000000000000000000）  
> grossBaseQuantityInPips: 基础通证的总交易额（包括手续费），此处为10000000000  
> grossQuoteQuantityInPips: 计价通证的总交易额（包括手续费），此处为3000000（100*0.0003*100000000）  
> netBaseQuantityInPips: 买方钱包收到扣除手续费后的基础通证净额，此处为9990000000（扣除0.1%手续费）  
> netQuoteQuantityInPips: 卖方钱包收到扣除手续费后的计价通证净额，此处为2985000（扣除0.5%手续费）  
> makerFeeAssetAddress: 挂单手续费通证合约的地址，此处为TSC1合约地址  
> takerFeeAssetAddress: 吃单手续费通证合约的地址，此处为BNB地址（0x0000000000000000000000000000000000000000）  
> makerFeeQuantityInPips: 挂单手续费，此处为10000000  
> takerFeeQuantityInPips: 吃单手续费，此处为15000  
> priceInPips: 交易价格，此处为30000  
> makerSide: 挂单方向，此处为0（挂单为买单）  

最后用生成的参数按顺序构造交易参数：
````javascript
["TSC1","BNB","0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe","0x0000000000000000000000000000000000000000",10000000000,3000000,9990000000,2985000,"0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe","0x0000000000000000000000000000000000000000",10000000,15000,30000,0]
````

在remix上使用以上三个参数填充`executeTrade`方法的参数表，然后使用Dispatcher账号执行`executeTrade`方法后查看Exchange合约内余额，可以看到测试账号1的BNB由20000000变为17000000，减少了3000000，TSC1由9000000000000变为9009990000000；测试账号2的BNB由15000000变为17985000，TSC1由50000000000000变为49990000000000；手续费账号的BNB由0变为15000，TSC1由5000000000变为5010000000，以上变化符合构造的交易参数。

由于此时卖单并没有全部撮合完成，可以使用任意账号调用Exchange合约的`loadPartiallyFilledOrderQuantityInPips`方法并传入订单Hash值0xd0833d69a094a52f34e6710587227e3cc7c71415a705f7eceafabee6b990d9f0来查看已撮合完成的额度，此时返回值为10000000000，与结算的额度一致。

由于上一笔交易卖单挂单150TSC1，但是只成功了100TSC1，因此下一步继续匹配一笔市价买单，本次买单的挂单数量为0.02BNB，参数如下：
> signatureHashVersion: 签名版本号，目前固定为1  
> nonce: 实时生成的UUIDv1，参照前边的代码部分  
> walletAddress: 挂买单的钱包地址，此处为测试钱包1的地址0xcCB98929A6D118d51224F6451F8CBE599E9343BE  
> orderType: 订单类型，此处为0（市价单）  
> side: 交易方向，此处为0（买单）  
> quantityInPips: 挂单数量，此处为2000000（BNB计价）  
> isQuantityInQuote: quantityInPips是否为计价通证数量，此处为true（因为是市价买单）  
> limitPriceInPips: 订单价格，此处为0  
> stopPriceInPips: 止损订单价格，此处为0  
> clientOrderId: 客户端订单ID，此处为空字符串  
> timeInForce: 限价单执行策略，此处为0（gtc）  
> selfTradePrevention: 防自交策略，此处为3（cb）  
> cancelAfter: 限价单执行策略为gtt时的订单超时时间，此处为0  
> walletSignature: 订单签名，参考上边代码生成  

注意，由于市价单的limitPriceInPips参数为0，计算Hash时需要去掉该参数，执行代码得到输出为：
````go
signatureHashVersion:  01
nonce:  2556d39442bd11ecabcb7085c2b700ea
walletAddress:  ccb98929a6d118d51224f6451f8cbe599e9343be
marketSymbol:  TSC1-BNB
orderType:  00
side:  00
quantityInPips:  0.02000000
isQuantityInQuote:  01
limitPriceInPips:  0.00000000
clientOrderId:
timeInForde:  00
selfTradePrevention:  03
cancelAfter:  0000000000000000
Hash:  0x7e4173b8cf658bf032ccf289eeb14b38aaf8658e65598507dc59edc7fec9eccc
prefixedHash:  0xfbff17e4a5b23210d0b3961058077dfef3357e561adbeebd3c300397d8075364
Signature:  bc931b692ab3de0b05ac44b4aa12fe62bd8c99d46539cf773235cc8aa79644960c336beab6062e7398caade0166796c4a6fdc040d5bd7056cebc2d617cbf25f81b
````
用生成的参数按顺序构造买单参数：
````javascript
[1,"0x2556d39442bd11ecabcb7085c2b700ea","0xcCB98929A6D118d51224F6451F8CBE599E9343BE",0,0,2000000,true,0,0,"",0,3,0,"0xbc931b692ab3de0b05ac44b4aa12fe62bd8c99d46539cf773235cc8aa79644960c336beab6062e7398caade0166796c4a6fdc040d5bd7056cebc2d617cbf25f81b"]
````
由于本次撮合的是新的买单和上一笔卖单，因此仍然使用上一次的卖单参数：
````javascript
[1,"0x7f59f51b42bc11ecaa4b7085c2b700ea","0x11b5A8efFa4E05EF833C8b987bc0c3336eF81eEf",1,1,15000000000,false,30000,0,"",0,3,0,"0xd88210e48b508199b6d7f5ecdb14946213d659a3a69713f61632752c05e62d7a2c5d33165c4d642b9dfd6b3260e063b19f04055ce400d8e1fd66a006dafeaa821c"]
````
最后构造`Trade`结构体，由于本次的卖单为挂单，买单为吃单，注意结构体中相关参数的变化，比如makerFeeAssetAddress、takerFeeAssetAddress、makerSide等参数：
> baseAssetSymbol: 基础通证标识符，此处为TSC1  
> quoteAssetSymbol: 计价通证标识符，此处为BNB  
> baseAssetAddress: 基础通证合约地址，此处为TSC1的合约地址  
> quoteAssetAddress: 计价通证合约地址，此处为BNB的地址（0x0000000000000000000000000000000000000000）  
> grossBaseQuantityInPips: 基础通证的总交易额（包括手续费），此处为5000000000  
> grossQuoteQuantityInPips: 计价通证的总交易额（包括手续费），此处为1500000（50*0.0003*100000000）  
> netBaseQuantityInPips: 买方钱包收到扣除手续费后的基础通证净额，此处为4975000000（扣除0.5%手续费）  
> netQuoteQuantityInPips: 卖方钱包收到扣除手续费后的计价通证净额，此处为1498500（扣除0.1%手续费）  
> makerFeeAssetAddress: 挂单手续费通证合约的地址，此处为BNB合约地址（0x0000000000000000000000000000000000000000）  
> takerFeeAssetAddress: 吃单手续费通证合约的地址，此处为TSC1合约地址  
> makerFeeQuantityInPips: 挂单手续费，此处为1500  
> takerFeeQuantityInPips: 吃单手续费，此处为25000000  
> priceInPips: 交易价格，此处为30000  
> makerSide: 挂单方向，此处为1（挂单为卖单）  

然后用生成的参数按顺序构造交易参数：
````javascript
["TSC1","BNB","0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe","0x0000000000000000000000000000000000000000",5000000000,1500000,4975000000,1498500,"0x0000000000000000000000000000000000000000","0x7C28F63e0671D7e7BF1c6A8d81Dd0D7a93004FCe",1500,25000000,30000,1]
````

在remix上使用以上三个参数填充`executeTrade`方法的参数表，然后使用Dispatcher账号执行`executeTrade`方法后查看Exchange合约内余额，可以看到测试账号1的BNB由17000000变为15500000，减少了1500000，TSC1由9009990000000变为9014965000000；测试账号2的BNB由17985000变为19483500，TSC1由49990000000000变为49985000000000；手续费账号的BNB由15000变为16500，TSC1由5010000000变为5035000000，以上变化符合构造的交易参数。

由于此时的市价买单没有全部完成，可以使用`loadPartiallyFilledOrderQuantityInPips`方法查询已匹配成功的数额，参数为该买单的订单哈希值0x97aa400907128ffbb001ebf2879ee8f9204e20207bd5d781a162405eda58f45b，可以看到已完成的数额为1500000，与交易参数一致。
***

## **11. 批量交易结算**
通过调用Exchange合约的`executeTrades`方法可以批量进行交易结算，方法参数有三个，分别为买方订单数组buys、卖方订单数组sells和交易信息数组trades。其中buys和sells的类型是`Order`结构体数组，trades的类型是`Trade`结构体数组，注意各数组的参数顺序要匹配正确。执行成功后，事务会发出一个`TradesExecuted`类型的事件，其中包含了`ExecRet`类型的数组，数组中每一个`ExecRet`类型的对象都包含了对应索引的结算操作是否成功，以及失败原因，可通过监听该事件来跟踪每一笔结算的执行结果。`ExecRet`结构体定义如下：
````javascript
//executeTrades中的执行结果
struct ExecRet {
    //对应索引的结算操作是否成功
    bool success;
    //如果执行失败，该变量中保存失败信息
    string err;
}
````

## **12. 取消订单执行**
由用户钱包调用Exchange合约的`invalidateOrderNonce`方法，并提供一个UUIDv1作为参数，当执行成功并经过`chainPropagationPeriod`指定的块数后，该账号所有订单时间戳小于UUIDv1所包含时间戳的未上链订单会在`executeTrade`方法执行时被阻止。
***
## **13. 用户钱包退出**
当用户想退出交易所时可以按以下步骤执行：

a. 用户钱包调用Exchange合约的`exitWallet`方法（无参数），该方法会在调用成功后会立刻阻止用户入金操作（仍可进行出金和订单结算操作），在经过chainPropagationPeriod参数指定的块数确认后，届时该账号的出入金和订单结算操作都会被阻止。可通过`isWalletExit`和`isWalletExitFinalized`两个方法查询退出状态，参数均为要查询的钱包地址。
> 当`exitWallet`方法执行成功但是未经过`chainPropagationPeriod`指定的块数确认时，`isWalletExit`方法返回`true`，`isWalletExitFinalized`方法返回`false`  
> 当经过`chainPropagationPeriod`指定的块数确认后，两个方法均返回true。  

b. `exitWallet`方法调用成功且经过`chainPropagationPeriod`指定的块数确认后，用户钱包可以通过调用Exchange合约的`withdrawExit`方法并提供要提现的通证合约地址作为参数来提现全部指定类型的通证到自己的钱包。如果用户想提现个人的所有类型通证可以调用`withdrawAllExit`方法实现。

c. 当该用户想重新启用钱包时，可以调用Exchange合约的`clearWalletExit`方法，该方法将清除Exchange合约中记录的用户退出状态，执行成功后该钱包将重新恢复出入金和执行订单等操作。