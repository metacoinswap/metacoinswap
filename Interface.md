# **接口说明**

## **1. 合约初始化**
### **function setAdmin(address newAdmin) external onlyOwner**
> 功能: 设置Exchange合约的管理员钱包地址  
> 调用方: Owner账号  
> 参数: 
> - newAdmin: 新管理员钱包地址  
> 
> Payable：false  
> 成功条件：newAdmin不可为0且不可为旧管理员钱包账号  
> 事件：无  
***
### **function removeAdmin() external onlyOwner**
> 功能: 删除Exchange合约的管理员钱包地址  
> 调用方: Owner账号  
> 参数: 无  
> Payable: false  
> 成功条件: 无  
> 事件: 无  
***
### **function setCustodian(address newCustodian) external onlyAdmin**
> 功能: 为Exchange合约设置Custodian合约的地址  
> 调用方: Admin账号  
> 参数:
> - newCustodian: Custodian合约地址  
> 
> Payable: false  
> 成功条件: Custodian合约地址只能在Exchange合约中被设置一次，且该地址必须指向合约  
> 事件: 无
***
### **function setDispatcher(address newDispatcherWallet) external onlyAdmin**
> 功能: 设置Dispatcher账号的钱包地址  
> 调用方: Admin账号  
> 参数: 
> - newDispatcherWallet: 新Dispatcher账号的钱包地址  
> 
> Payable: false  
> 成功条件: `newDispatcherWallet`不可为0且不可为旧Dispatcher账号的钱包地址  
> 事件: `event DispatcherChanged(address previousValue, address newValue)`
***
### **function removeDispatcher() external onlyAdmin**
> 功能: 删除Exchange合约的Dispatcher账号的钱包地址  
> 调用方: Admin账号  
> 参数: 无  
> Payable: false  
> 成功条件: `newDispatcherWallet`不可为0且不可为旧Dispatcher账号的钱包地址  
> 事件: `event DispatcherChanged(address previousValue, address newValue)`
***
### **function setFeeWallet(address newFeeWallet) external onlyAdmin**
> 功能: 设置Exchange合约的手续费钱包地址  
> 调用方: Admin账号  
> 参数:  
> - newFeeWallet: 新手续费钱包地址  
> 
> Payable: false  
> 成功条件: `newFeeWallet`不可为0且不可为旧手续费钱包地址  
> 事件: `event FeeWalletChanged(address previousValue, address newValue)`
***
### **function setChainPropagationPeriod(uint256 newChainPropagationPeriod) external onlyAdmin**
> 功能: 某些操作需要在事务上链后再等待`chainPropagationPeriod`指定的块数后才起作用，该方法即用于设置该值  
> 调用方: Admin账号  
> 参数:  
> - newChainPropagationPeriod: 新`chainPropagationPeriod`值  
> 
> Payable: false  
> 成功条件: `newChainPropagationPeriod`需要小于Exchange合约中对该值的最大限制（目前合约中硬编码为201600）  
> 事件：`event ChainPropagationPeriodChanged(uint256 previousValue, uint256 newValue)`
***
## **2. 通证注册**
### **function registerToken(IBEP20 tokenAddress, string calldata symbol, uint8 decimals) external onlyAdmin**
> 功能: 在Exchange合约内注册通证信息  
> 调用方: Admin账号  
> 参数:
> - tokenAddress: 要注册的通证地址  
> - symbol: 要注册的通证标识符  
> - decimals: 要注册的通证小数位数  
> 
> Payable: false  
> 成功条件:
> - tokenAddress不为0且该地址必须指向合约  
> - symbol长度大于0  
> - decimals小于等于32  
> - 该通证没有被确认（由`confirmTokenRegistration`方法确认），即未注册成功过  
> 
> 事件: `event TokenRegistered(IBEP20 indexed assetAddress, string assetSymbol, uint8 decimals)`
***
### **function confirmTokenRegistration(IBEP20 tokenAddress, string calldata symbol, uint8 decimals) external onlyAdmin**
> 功能: 在Exchange合约内确认通证注册信息，确认后的通证才可在进行出入金和交易等操作  
> 调用方: Admin账号  
> 参数:  
> - tokenAddress: 要注册的通证地址  
> - symbol: 要注册的通证标识符  
> - decimals: 要注册的通证小数位数  
> 
> Payable: false  
> 成功条件:
> - 已经通过`registerToken`方法进行过注册且还未通过`confirmTokenRegistration`方法进行确认  
> - 参数需与`registerToken`方法的调用参数一致 
>  
> 事件: `event TokenRegistrationConfirmed(IBEP20 indexed assetAddress, string assetSymbol, uint8 decimals)`
***
### **function addTokenSymbol(IBEP20 tokenAddress, string calldata symbol) external onlyAdmin**
> 功能: 为通证增加标识符  
> 调用方: Admin账号  
> 参数:
> - tokenAddress: 要增加标识符的通证合约地址  
> - symbol: 要增加的通证标识符
>   
> Payable: false  
> 成功条件:
> - 该通证已通过`confirmTokenRegistration`方法进行确认  
> - symbol不可为BNB  
> 
> 事件: `event TokenSymbolAdded(IBEP20 indexed assetAddress, string assetSymbol)`
***
## **3. 入金**
### **function depositBNB() external payable**
> 功能: 入金BNB  
> 调用方: 任意用户账号  
> 参数: 无  
> Payable: true  
> 成功条件:
> - 用户钱包未退出  
> - 入金金额大于0  
> 
> 事件: `event Deposited(uint64 index, address indexed wallet, address indexed assetAddress, string indexed assetSymbolIndex, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
### **function depositTokenByAddress(IBEP20 tokenAddress, uint256 quantityInAssetUnits) external**
> 功能: 通过通证合约地址入金BEP20通证  
> 调用方: 任意用户账号  
> 参数:
> - tokenAddress: 要入金的BEP20通证的合约地址  
> - quantityInAssetUnits: 入金的额度，使用通证合约内部精度表示  
> 
> Payable: false  
> 成功条件:  
> - 用户钱包需先在  tokenAddress    指向的BEP20通证合约上调用`approve`方法为Exchange合约授权`quantityInAssetUnits`指定额度的BEP20代币  
> - `tokenAddres`s不为0  
> - 用户钱包未退出  
> - 入金金额`quantityInAssetUnits`大于0
> 
> 事件: `event Deposited(uint64 index, address indexed wallet, address indexed assetAddress, string indexed assetSymbolIndex, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
### **function depositTokenBySymbol(string calldata assetSymbol, uint256 quantityInAssetUnits) external**
> 功能: 通过通证标识符入金BEP20通证  
> 调用方: 任意用户账号  
> - 参数:
> - assetSymbol: 要入金的BEP20通证的标识符  
> - quantityInAssetUnits: 入金的额度，使用通证合约内部精度表示  
> 
> Payable: false  
> 成功条件:
> - 通证标识符已注册并确认  
> - 用户钱包未退出  
> - 入金金额`quantityInAssetUnits`大于0  
> 
> 事件: `event Deposited(uint64 index, address indexed wallet, address indexed assetAddress, string indexed assetSymbolIndex, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
## **4. 提现**
### **function withdraw(Structs.Withdrawal memory withdrawal) public override onlyDispatcher**
> 功能: 用户指定要提现的通证和额度，签名后由Dispatcher账号执行该方法，提现过程需要手续费，由交易所计算完成  
> 调用方: Dispatcher账号  
> 参数:  
> - withdrawal: `Structs.Withdrawal`结构体，包含提现相关的信息并由用户钱包签名，各字段定义参考结构体说明一节  
> 
> Payable: false  
> 成功条件:
> - 用户钱包未退出  
> - `withdrawal`中的签名需验证通过  
> - 提现手续费需低于合约内定义的最大费率（目前硬编码为20%）  
> - 同一笔提现事务不能重复提交  
> 
> 事件: `event Withdrawn(address indexed wallet, address indexed assetAddress, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
## **5. 交易结算**
### **function executeTrade(Structs.Order memory buy, Structs.Order memory sell, Structs.Trade memory trade) public override onlyDispatcher**
> 功能: 由用户钱包发起并签名的订单，在撮合成功后交由Dispatcher账号调用`executeTrade`方法将数据上链，届时相关账户的余额会根据交易信息发生相应变化  
> 调用方: Dispatcher账号  
> 参数: 
> - buy: `Structs.Order`结构体，买方订单，各字段定义参考结构体说明一节  
> - sell: `Structs.Order`结构体，卖方订单，各字段定义参考结构体说明一节  
> - trade: `Structs.Trade`结构体，表示撮合成功的一对订单的相关信息，各字段定义参考结构体说明一节  
> 
> Payable: false  
> 成功条件:
> - 买方和卖方钱包均未退出  
> - 买方和卖方的钱包地址不能相同（防自交）  
> - trade参数中的`baseAssetAddress`（基础通证地址）和`quoteAssetAddress`（定价通证地址）不能相同  
> - trade参数中的`baseAssetSymbol`和`quoteAssetSymbol`对应的通证必须要在buy/sell订单发起之前注册并确认  
> - trade参数中的`makerFeeAssetAddress`/`takerFeeAssetAddress`（挂单/吃单手续费地址）必须为`baseAssetAddress`或`quoteAssetAddress`，且两者不能相同  
> - trade参数中的`grossBaseQuantityInPips`（基础通证总交易量）参数必须大于0  
> - trade参数中的`grossQuoteQuantityInPips`（计价通证总交易量）参数必须大于0  
> - 如果为限价订单，那么trade参数中的`grossBaseQuantityInPips`乘以buy/sell参数中的`limitPriceInPips`需要小于等于trade参数中的`grossQuoteQuantityInPips`
> - 如果buy/sell参数中的`nonce`字段中的时间戳小于`invalidateOrderNonce`方法为该用户钱包指定的值，则该交易会被阻止执行  
> - buy/sell参数中的签名需验证通过  
> - buy/sell参数中的提现手续费需低于合约内定义的最大费率（目前硬编码为20%）  
> - trade中的`netBaseQuantityInPips`（去掉手续费的基础通证净成交额）与对应手续费相加需要等于`grossBaseQuantityInPips`，同样`netQuoteQuantityInPips`（去掉手续费的基础通证净成交额）与对应手续费相加需要等于`grossQuoteQuantityInPips`  
> - 挂单金额全部撮合成功的订单会被阻止执行  
> - buy/sell参数中的`isQuantityInQuote`为true时，该订单必须为市价订单  
> - 每笔订单被撮合成功的总额度不能超过挂单的金额  
> 
> 事件: `event TradeExecuted(address buyWallet, address sellWallet, string indexed baseAssetSymbolIndex, string indexed quoteAssetSymbolIndex, string baseAssetSymbol, string quoteAssetSymbol, uint64 baseQuantityInPips, uint64 quoteQuantityInPips, uint64 tradePriceInPips, bytes32 buyOrderHash, bytes32 sellOrderHash)`
***

### **function executeTrades(Structs.Order[] memory buys, Structs.Order[] memory sells, Structs.Trade[] memory trades) public override onlyDispatcher**
> 功能: 由用户钱包发起并签名的多个订单，在撮合成功后交由Dispatcher账号调用`executeTrades`方法将数据批量上链，届时相关账户的余额会根据交易信息发生相应变化  
> 调用方: Dispatcher账号  
> 参数: 
> - buys: `Structs.Order`结构体数组，买方订单数组  
> - sells: `Structs.Order`结构体数组，卖方订单数组  
> - trades: `Structs.Trade`结构体数组，撮合信息数组  
> 
> Payable: false  
> 成功条件:
> - buys、sells和trades的长度相等   
> 
> 事件: 
> - `event TradeExecuted(address buyWallet, address sellWallet, string indexed baseAssetSymbolIndex, string indexed quoteAssetSymbolIndex, string baseAssetSymbol, string quoteAssetSymbol, uint64 baseQuantityInPips, uint64 quoteQuantityInPips, uint64 tradePriceInPips, bytes32 buyOrderHash, bytes32 sellOrderHash)`
> - `event TradesExecuted(Structs.ExecRet[] vals)`
***
## **6. 取消订单执行**
### **function invalidateOrderNonce(uint128 nonce) external**
> 功能: nonce参数为UUIDv1，可从中分析出获取该UUID时的时间戳，当用户钱包调用该方法且块高度超过当前块加上`chainPropagationPeriod`后，在该时间戳之前发起的订单会被`executeTrade`方法阻止执行  
> 调用方: 用户钱包账号  
> 参数:
> - nonce: UUIDv1类型  
> 
> Payable: false  
> 成功条件:
> - 由`nonce`解出的时间戳不能超过当前时间一天以上  
> - 本次的UUID参数解出的时间戳必须大于上一次调用时的UUID参数  
> - 本次调用时间需大于上次调用加上`chainPropagationPeriod`指定的块数确认的时间  
> 
> 事件: `event OrderNonceInvalidated(address indexed wallet, uint128 nonce, uint128 timestampInMs, uint256 effectiveBlockNumber)`
***
## **7. 用户钱包退出**
### **function exitWallet() external**
> 功能: 用户钱包调用该方法且经过`chainPropagationPeriod`指定的块数确认后，由该钱包发起的出入金和执行订单操作都会被阻止  
> 调用方: 用户钱包账号  
> 参数: 无  
> Payable: false  
> 成功条件:
> - 如钱包账号之前调用过该方法，则再次调用会失败
> 
> 事件: `event WalletExited(address indexed wallet, uint256 effectiveBlockNumber)`
***
### **function withdrawExit(address assetAddress) external**
> 功能: 当钱包调用`exitWallet`方法且经过`chainPropagationPeriod`指定的块数确认后，可通过该方法提现全部指定的通证至用户的钱包  
> 调用方: 用户钱包账号  
> 参数:
> - assetAddress: 要提现的通证合约地址  
> 
> Payable: false  
> 成功条件:
> - 用户钱包需已调用`exitWallet`方法且经过`chainPropagationPeriod`指定的块数确认  
> - 用户在Exchange合约中的对应该通证的金额需要大于0  
> 
> 事件: `event WalletExitWithdrawn(address indexed wallet, address indexed assetAddress, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
### **function withdrawAllExit() external**
> 功能: 当钱包调用`exitWallet`方法且经过`chainPropagationPeriod`指定的块数确认后，可通过该方法提现全部类型的通证（余额不为0）至用户的钱包  
> 调用方: 用户钱包账号  
> 参数: 无  
> Payable: false  
> 成功条件:
> - 用户钱包需已调用`exitWallet`方法且经过`chainPropagationPeriod`指定的块数确认  
> 
> 事件: `event WalletExitWithdrawn(address indexed wallet, address indexed assetAddress, string assetSymbol, uint64 quantityInPips, uint64 newExchangeBalanceInPips, uint256 newExchangeBalanceInAssetUnits)`
***
### **function clearWalletExit() external**
> 功能: 已退出的用户钱包可通过调用该方法清除退出状态，之后该钱包的出入金和执行订单操作会恢复正常  
> 调用方: 任意用户钱包账号  
> 参数: 无  
> Payable: false  
> 成功条件:
> - 用户钱包需已退出  
> 
> 事件: `event WalletExitCleared(address indexed wallet)`
***
## **8. 只读方法**
### **function loadAssetBySymbol(string calldata assetSymbol, uint64 timestampInMs) external view**
> 功能: 根据通证标识符获取通证信息  
> 参数:
> - assetSymbol: 要查询的通证标识符  
> - timestampInMs: 当前的时间戳（毫秒级）  
> 
> 返回值: `Structs.Asset`结构体，各字段定义参考结构体说明一节  
***
### **function loadBalanceInAssetUnitsByAddress(address wallet, address assetAddress) external view returns (uint256)**
> 功能: 获取用户钱包中某通证的余额（通过通证合约地址）  
> 参数:
> - wallet: 要查询的用户钱包地址  
> - assetAddress: 要查询的通证合约地址  
> 
> 返回值: 用户的余额，由该通证内部精度表示（精度由通证合约的decimal决定）
***
### **function loadBalanceInAssetUnitsBySymbol(address wallet, string calldata assetSymbol) external view returns (uint256)**
> 功能: 取用户钱包中某通证的余额（通过通证标识符）  
> 参数: 
> - wallet: 要查询的用户钱包地址  
> - assetSymbol: 要查询的通证标识符  
> 
> 返回值: 用户的余额，由该通证内部精度表示（精度由通证合约的decimal决定）
***
### **function loadBalanceInPipsByAddress(address wallet, address assetAddress) external view returns (uint64)**
> 功能: 获取用户钱包中某通证的余额（通过通证合约地址）  
> 参数:
> - wallet: 要查询的用户钱包地址  
> - assetAddress: 要查询的通证合约地址  
> 
> 返回值: 用户的余额，由Exchange合约内部精度表示
***
### **function loadBalanceInPipsBySymbol(address wallet, string calldata assetSymbol) external view returns (uint64)**
> 功能: 获取用户钱包中某通证的余额（通过通证标识符）  
> 参数:
> - wallet: 要查询的用户钱包地址  
> - assetSymbol: 要查询的通证标识符  
> 
> 返回值: 用户的余额，由Exchange合约内部精度表示
***
### **function loadFeeWallet() external view returns (address)**
> 功能: 获取手续费钱包地址  
> 参数: 无  
> 返回值: 手续费钱包地址  
***
### **function loadPartiallyFilledOrderQuantityInPips(bytes32 orderHash) external view returns (uint64)**
> 功能: 获取某订单已成交的额度  
> 参数:
> - orderHash: 订单hash值  
> 
> 返回值: `orderHash`指定的订单已成交的数额，由Exchange合约内部精度表示
***
### **function loadBalanceAssetAddress(address wallet) external view returns (address[] memory)**
> 功能: 获取用户钱包中余额不为0的通证合约的地址列表  
> 参数:
> - wallet: 要查询的用户钱包地址  
> 
> 返回值: 用户钱包中余额不为0的通证合约的地址的数组
***
### **function isWalletExit(address wallet) public view returns (bool)**
> 功能: 查询钱包是否调用`exitWallet`方法成功  
> 参数:
> - wallet: 要查询的用户钱包地址  
> 
> 返回值: 用户是否退出
***
### **function isWalletExitFinalized(address wallet) public view returns (bool)**
> 功能: 查询钱包是否调用`exitWallet`方法成功且经过`chainPropagationPeriod`指定的块数确认  
> 参数:
> - wallet: 要查询的用户钱包地址  
> 
> 返回值: 钱包是否彻底退出  
***
## **9. 结构体说明**
a. Asset结构体
````javascript
//该结构体用于定义交易所中注册的一个通证
struct Asset {
    //通证定义是否存在
    bool exists;
    //通证合约的地址
    address assetAddress;
    //通证标识符
    string symbol;
    //通证精度
    uint8 decimals;
    //通证是否已由confirmTokenRegistration方法确认
    bool isConfirmed;
    //通证由confirmTokenRegistration确认时的时间戳
    uint64 confirmedTimestampInMs;
}
````
b. Withdraw结构体
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
c. Order结构体
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
````
d. Trade结构体
````javascript
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
e. ExecRet结构体
````javascript
//executeTrades中的执行结果
struct ExecRet {
    //对应索引的结算操作是否成功
    bool success;
    //如果执行失败，该变量中保存失败信息
    string err;
}
````
***
## **10. 事件说明**
a. DispatcherChanged
> 说明: 当Admin账号调用`setDispatcher`方法修改Dispatcher账号成功后发出该事件  
> 参数:  
> - uint256 previousValue: 修改之前的Dispatcher账号  
> - uint256 newValue: 修改之后的Dispatcher账号    
***
b. FeeWalletChanged
> 说明: 当Admin账号调用`setFeeWallet`方法修改手续费钱包账号成功后发出该事件  
> 参数:  
> - uint256 previousValue: 修改之前的手续费钱包账号  
> - uint256 newValue: 修改之后的手续费钱包账号    
***
c. ChainPropagationPeriodChanged
> 说明: Admin账号调用`setChainPropagationPeriod`方法修改`chainPropagationPeriod`成功后发出该事件  
> 参数: 
> - uint256 previousValue: 修改之前的`chainPropagationPeriod`值  
> - uint256 newValue: 修改之后的`chainPropagationPeriod`值  
***
d. Deposited
> 说明: 入金事件，当用户通过`depositBNB`入金BNB以及通过`depositAsset`或`depositAssetBySymbol`入金BEP20通证成功后发出该事件  
> 参数:  
> - uint64 index: 入金事务序号，每笔入金事件index自增1  
> - address indexed wallet: 执行入金操作的钱包地址  
> - address indexed assetAddress: 入金的通症合约地址  
> - string indexed assetSymbolIndex: 入金的通证标识符（用于索引）  
> - string assetSymbol: 入金的通证标识符  
> - uint64 quantityInPips: 入金金额，使用Exchange合约内部精度表示  
> - uint64 newExchangeBalanceInPips: 用户入金后的该通证余额，使用Exchange合约内部精度表示  
> - uint256 newExchangeBalanceInAssetUnits: 用户入金后的该通证余额，使用通证合约的精度表示
>***
e. OrderNonceInvalidated
> 说明: 取消订单执行事件，当用户调用`invalidateOrderNonce`方法成功后发出该事件  
> 参数:  
> - address indexed wallet: 调用`invalidateOrderNonce`方法的钱包地址  
> - uint128 nonce: 当用户调用`invalidateOrderNonce`方法时传入的UUIDv1参数  
> - uint128 timestampInMs: 从`nonce`参数中解析出的时间戳（毫秒级）  
> - uint256 effectiveBlockNumber: `invalidateOrderNonce`方法生效时的块序号  
***
f. TokenRegistered
> 说明: 通证注册事件，当Admin账号调用`registerToken`方法成功后发出该事件  
> 参数: 
> - IBEP20 indexed assetAddress: 要注册的BEP20通证地址  
> - string assetSymbol: 要注册的BEP20通证标识符  
> - uint8 decimals: 要注册的BEP20通证精度  
***
g. TokenRegistrationConfirmed
> 说明: 确认通证注册事件，当Admin账号调用`confirmAssetRegistration`方法成功后发出该事件    
> 参数: 
> - IBEP20 indexed assetAddress: 被确认的BEP20通证地址  
> - string assetSymbol: 被确认的BEP20通证标识符  
> - uint8 decimals: 被确认的BEP20通证精度  
***
h. TokenSymbolAdded
> 说明: 添加通证标识符事件，当Admin账号调用`addTokenSymbol`方法成功后发出该事件  
> 参数:
> - IBEP20 indexed assetAddress: 要添加标识符的通证合约地址  
> - string assetSymbol: 要添加的通证标识符
***
i. TradeExecuted
> 说明: 交易结算事件，当Dispatcher账号调用`executeTrade`方法时发出该事件  
> 参数: 
> - address buyWallet: 发起买单的钱包地址  
> - address sellWallet: 发起卖单的钱包地址  
> - string indexed baseAssetSymbolIndex: 基础通证的标识符（索引用）  
> - string indexed quoteAssetSymbolIndex: 计价通证的标识符（索引用）  
> - string baseAssetSymbol: 基础通证的标识符  
> - string quoteAssetSymbol: 计价通证的标识符
> - uint64 baseQuantityInPips: 基础通证的交易额，使用Exchange合约的内部精度表示  
> - uint64 quoteQuantityInPips: 计价通证的交易额，使用Exchange合约的内部精度表示
> - uint64 tradePriceInPips: 交易价格，使用Exchange合约的内部精度表示
> - bytes32 buyOrderHash: 买单的哈希值
> - bytes32 sellOrderHash: 卖单的哈希值
***
j. TradesExecuted
> 说明: 批量交易结算事件，当Dispatcher账号调用`executeTrades`方法时发出该事件  
> 参数: 
> - Structs.ExecRet[] vals: 数组包含每一笔结算的执行结果，参考`ExecRet`结构体的说明
***
k. WalletExited
> 说明: 用户钱包退出事件，当用户钱包调用`exitWallet`方法退出交易所后发出该事件  
> 参数:  
> - address indexed wallet: 要退出的钱包地址  
> - uint256 effectiveBlockNumber: 退出操作生效时的块序号
***
l. WalletExitWithdrawn
> 说明: 当用户钱包通过`withdrawExit`方法提现通证余额成功后发出该事件  
> 参数:  
> - address indexed wallet: 发起提现操作的钱包地址  
> - address indexed assetAddress: 要提现的通证合约地址  
> - string assetSymbol: 要提现的通证标识符  
> - uint64 quantityInPips: 提现金额，使用Exchange合约的内部精度表示  
> - uint64 newExchangeBalanceInPips: 提现后交易所内该通证的余额，使用Exchange合约的内部精度表示
> - uint256 newExchangeBalanceInAssetUnits: 提现后交易所内该通证的余额，使用该通证合约的精度表示
***
m. WalletExitCleared
> 说明: 当用户钱包调用`exitWallet`方法成功后发出该事件  
> 参数:  
> - address indexed wallet: 要清除退出状态的钱包地址  
***
n. Withdrawn
> 说明: 当Dispatcher账号调用`withdraw`方法成功后发出该事件  
> 参数:  
> - address indexed wallet: 发起提现操作的钱包地址  
> - address indexed assetAddress: 要提现的通证合约地址  
> - string assetSymbol: 要提现的通证标识符  
> - uint64 newExchangeBalanceInPips: 提现后交易所内该通证的余额，使用Exchange合约的内部精度表示
> - uint256 newExchangeBalanceInAssetUnits: 提现后交易所内该通证的余额，使用该通证合约的精度表示