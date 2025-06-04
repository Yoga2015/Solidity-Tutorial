// 1. 部署BasicCalculator和AdvancedCalculator
const basic = await BasicCalculator.deploy();
const advanced = await AdvancedCalculator.deploy();

// 2. 部署CalculatorProxy
const proxy = await CalculatorProxy.deploy();

// 3. 通过代理调用计算器
await proxy.calculate(basic.address, "add", 5, 3); // 8
await proxy.calculate(advanced.address, "add", type(uint).max, 1); // 抛出溢出错误

// 4. 批量计算
await proxy.batchCalculate(
    [basic.address, advanced.address],
    ["add", "multiply"],
    [2, 3],
    [3, 4]
); // 返回 [5, 12]