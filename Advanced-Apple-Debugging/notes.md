
## x64 calling convention

The following registers are used as parameters when a function is called in x64 assembly. Try and commit these to memory, as you’ll use these frequently in the future:

Arg | Register
----|---------
1   | RDI
2   | RSI
3   | RDX
4   | RCX
5   | R8
6   | R9

If there are more than six parameters, program stack is used


-----

command alias -- Yay_Autolayout expression -l objc -0 -- [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] recursiveDescription]


command alias -H "Yay_Autolayout will get the root view and recursively dump all the subviews and their frames" -h "Recursively dump views" -- Yay_Autolayout expression -l objc -O -- [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] recursiveDescription]



```
command regex getcls 's/(([0-9]|\$|\@|\[).*)/cpo [%1 class]/' 's/(.+)/expression -l swift -O -- type(of: %1)/

command regex getcls 's/(([0-9]|\$|\@|\[).*)/cpo [%1 class]/
```

“ex -l swift -O -- UIApplication.shared.perform(NSSelectorFromString("statusBar"))”

Excerpt From: “Advanced Apple Debugging.'


“ ex -l swift -O -- UIApplication.shared.perform(NSSelectorFromString("statusBar"))”

Excerpt From: “Advanced Apple Debugging.” Apple Books. '


“command regex swiftperfsel 's/(.+)\s+(\w+)/expression -l swift -O -- %1.perform(NSSelectorFromString("%2"))/”

Excerpt From: “Advanced Apple Debugging.” Apple Books. 



