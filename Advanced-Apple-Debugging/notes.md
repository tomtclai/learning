
command alias -- Yay_Autolayout expression -l objc -0 -- [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] recursiveDescription]


command alias -H "Yay_Autolayout will get the root view and recursively dump all the subviews and their frames" -h "Recursively dump views" -- Yay_Autolayout expression -l objc -O -- [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] recursiveDescription]