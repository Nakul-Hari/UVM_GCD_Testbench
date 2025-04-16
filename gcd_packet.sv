// Packet generator

class gcd_packet;
    rand bit [7:0] A;
    rand bit [7:0] B;
    bit operands_valid;

    function new();
        operands_valid = 1'b1;
    endfunction

    // Constraint to make A and B meaningful
    constraint c_valid {
        A inside {[10:200]};  // Avoid trivial cases
        B inside {[10:200]};
    }

    // Displaying the generated packets for debugging
    function void display(string prefix = "");
        $display("%s A = %0d, B = %0d, operands_valid = %0b", prefix, A, B, operands_valid);
    endfunction
  
    // Deep copy method
    function gcd_packet copy();
        gcd_packet pkt_copy = new();
        pkt_copy.A = this.A;
        pkt_copy.B = this.B;
        pkt_copy.operands_valid = this.operands_valid;
        return pkt_copy;
    endfunction
  
endclass
