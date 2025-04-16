`timescale 1ns/1ps


`include "gcd_if.sv"
`include "gcd_pkg.sv"

import gcd_pkg::*;



module tb_top;

    bit Clk;
    always #5 Clk = ~Clk;  // 100MHz clock

    gcd_if gcd_vif(Clk);

    // Mailboxes
    mailbox gen2drv = new();

    // Scoreboard expected values
    int expect_q[$];

    // DUT
    top_module dut (
        .A_in(gcd_vif.A_in),
        .B_in(gcd_vif.B_in),
        .operands_val(gcd_vif.operands_val),
        .Clk(Clk),
        .Rst(gcd_vif.Rst),
        .ack(gcd_vif.ack),
        .gcd_out(gcd_vif.gcd_out),
        .gcd_valid(gcd_vif.gcd_valid)
    );

    // Class Handles
    generator gen;
    driver drv;
    scoreboard sb;
    monitor mon;
    
  
  
    initial begin
        Clk = 0;

        $display("*********************************************************************************");
        $display("******************************SIMULATION STARTED*********************************");
        $display("*********************************************************************************");

        // Creating instances
      	gen = new(gen2drv);
;

        // Run generator first
        fork
            gen.run();
        join



        $display("*********************************************************************************");
        $display("******************************PACKETS GENERATED**********************************");
        $display("*********************************************************************************");
      
      
        // Send expected_q to scoreboard
        expect_q = gen.expect_q;
      
      	// Creating instances
        sb  = new(expect_q);
      	mon = new(gcd_vif, sb);
      	drv = new(gcd_vif, gen2drv);

        // Run driver and monitor in parallel
        fork
            drv.run();
            mon.run();
        join

        $display("*********************************************************************************");
        $display("******************************SIMULATION COMPLETED*******************************");
        $display("*********************************************************************************");

        $finish;
    end

endmodule
