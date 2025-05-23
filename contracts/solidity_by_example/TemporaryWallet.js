// 1. 创建临时钱包（发送1 ETH）
walletFactory.createTemporaryWallet({value: ethers.utils.parseEther("1.0")})

// 2. 查看钱包信息
walletFactory.getWalletInfo(1)

// 3. 销毁钱包
walletFactory.destroyWallet(1)

// 4. 查看统计信息
walletFactory.getStats()