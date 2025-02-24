// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ControlFlow {
    // if-else
    function ifElseTest(uint256 num1) public pure returns (bool) {
        if (num1 == 0) {
            return (true);
        } else {
            return (false);
        }
    }

    // for循环
    function forLoopTest() public pure returns (uint256) {
        uint sum = 0;

        for (uint i = 0; i < 10; i++) {
            sum += i;
        }

        return (sum);
    }

    // while循环
    function whileTest() public pure returns (uint256) {
        uint sum = 0;

        uint i = 0;

        while (i < 10) {
            sum += i;
            i++;
        }

        return (sum);
    }

    // do-while循环
    function doWhileTest() public pure returns (uint256) {
        uint sum = 0;

        uint i = 0;

        do {
            sum += i;
            i++;
        } while (i < 10);

        return (sum);
    }

    // 另外,还有continue（立即进入下一个循环）和 break（跳出当前循环）关键字可以使用。
}

contract Loop {
    function loop() public pure {
        // for loop
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                // Skip to next iteration with continue
                continue;
            }

            if (i == 5) {
                // Exit loop with break
                break;
            }
        }

        // while loop
        uint256 j;

        while (j < 10) {
            j++;
        }
    }
}

// Solidity 支持 for、while 和 do while 循环。但不要编写无限循环的代码，因为这可能会触及 gas 上限，导致你的交易失败。

// 由于上述原因，while 和 do while 循环很少被使用。

// 优先使用 for 循环，并确保循环条件能够正确终止，以避免交易失败和 gas 浪费。
