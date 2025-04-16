// Generator Class

class generator;

  mailbox gen2drv;
  int expect_q[$];

  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat (10) begin
      gcd_packet pkt = new();
      pkt.randomize();
      pkt.display("[GEN] Generated packet ->");

      // Sending packet to driver
      gen2drv.put(pkt);

      // Saving expected output for scoreboard
      expect_q.push_back(calc_gcd(pkt.A, pkt.B));
    end
  endtask

endclass
