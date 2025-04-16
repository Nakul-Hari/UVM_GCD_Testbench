// GCD Function (Golden Model)
function int calc_gcd(input int a, input int b);
    int temp;

    // Special case: if a is 0, return 1

    while (b != 0) begin
        temp = b;
        b = a % b;
        a = temp;
        if (a == 0) 
           return b;
    end
  
    return a;
  
endfunction