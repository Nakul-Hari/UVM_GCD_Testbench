

// GCD Interface
interface gcd_if(input bit Clk);
    logic [7:0] A_in;
    logic [7:0] B_in;
    logic operands_val;
    logic ack;
    logic [7:0] gcd_out;
    logic gcd_valid;
    logic Rst;

    // Clocking blocks
    clocking cb @(posedge Clk);
        output A_in, B_in, operands_val, ack, Rst;
        input gcd_out, gcd_valid;
    endclocking
endinterface