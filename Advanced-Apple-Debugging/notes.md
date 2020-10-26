
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



-- 

entire thing `r`

(lldb) p/x $rdx 
(unsigned long) $1 = 0x0123456789abcdef

(lldb)  p/x $r9
(unsigned long) $11 = 0x0123456789abcdef


dobule word `e`, `d`

(lldb) p/x $edx 
(unsigned int) $2 = 0x89abcdef

(lldb)  p/x $r9d
(unsigned int) $13 = 0x89abcdef

half word `n/a`, `w`
(lldb) p/x $dx 
(unsigned short) $3 = 0xcdef

(lldb) p/x $r9w
(unsigned short) $14 = 0xcdef

lower half `l`
(lldb) p/x $dl
(unsigned char) $4 = 0xef

(lldb) p/x $r9l
(unsigned char) $16 = 0xef

higher half `h`
(lldb) p/x $dh
(unsigned char) $5 = 0xcd

