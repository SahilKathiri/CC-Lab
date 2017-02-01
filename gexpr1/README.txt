1. To make the executable 
   $make 
2. To clean the 
   $make clean
3. To run (taking statments from a file)
   $bin/gexpr < inp/stm1
   
   $bin/gexpr < inp/stm2

4. To run (interactively>
   $bin/gexpr
   ?? x = 2;
        movl    $2, %eax
        movl    %eax, x
   ?? y = 3;
        movl    $3, %eax
        movl    %eax, y
   ?? z = x + y * 4;
        movl    x, %eax
        pushl   %eax
        movl    y, %eax
        pushl   %eax
        movl    $4, %eax
        popl    %ebx
        imul    %ebx, %eax
        popl    %ebx
        addl    %ebx, %eax
        movl    %eax, z
   ?? z;
       z = 14


