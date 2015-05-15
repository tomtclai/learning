//
//  IntStack.h
//  pushpopstack
//
//  Created by Tsz Chun Lai on 9/24/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __pushpopstack__IntStack__
#define __pushpopstack__IntStack__

#include <stdio.h>
class IntStack
{
//    friend &ostream operator<< (const & ostream)
//    {
//        
//    }
    
    public:
        IntStack();
    
        int Pop();
        void Push(int num);
    
        int Peek();
        int Size();
    
        bool IsEmpty();
        bool IsFull();
    
        ~IntStack();
};

#endif /* defined(__pushpopstack__IntStack__) */
