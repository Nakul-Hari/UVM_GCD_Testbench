// Driver Class
class driver;
    virtual gcd_if vif;
    mailbox gen2drv;

    function new(virtual gcd_if vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction
  
  
    task display_mailbox(mailbox mbox, string header = "[DRIVER] Mailbox Contents:");
        automatic int count = mbox.num();
        automatic gcd_packet pkt;
        automatic gcd_packet queue_copy[$];  // Temporary queue to store items

        $display("%s (Size: %0d)", header, count);

        // Dequeue all items temporarily and display them
        for (int i = 0; i < count; i++) begin
            mbox.get(pkt);
            queue_copy.push_back(pkt);

            $display("  Packet[%0d] -> A = %0d, B = %0d",
                     i, pkt.A, pkt.B);
        end

        // Put them back into the mailbox
        foreach (queue_copy[i]) begin
            mbox.put(queue_copy[i]);
        end
    endtask

  
    task run();
        gcd_packet pkt;

        vif.cb.Rst <= 1;
        repeat (2) @(vif.cb);  // Reset pulse
        vif.cb.Rst <= 0;

        forever begin
          
          if (!gen2drv.num()) begin
            
            $display("[%0t] DRIVER: Input mailbox is empty, finishing...", $time);
            repeat (5) @(vif.cb);
            break;
            
    		end
            
            // Get packet from generator
            gen2drv.get(pkt);
            // display_mailbox(gen2drv); // Used for debugging

            // Wait random time before sending operands
            repeat ($urandom_range(1, 5)) @(vif.cb);

            vif.cb.A_in <= pkt.A;
            vif.cb.B_in <= pkt.B;
            vif.cb.operands_val <= pkt.operands_valid;

            @(vif.cb);  // One clock

            vif.cb.operands_val <= 0;  // De-assert after sending
            @(vif.cb);

            wait (vif.gcd_valid === 1);

            repeat ($urandom_range(1, 5)) @(vif.cb);
            vif.cb.ack <= 1;
            @(vif.cb);
            vif.cb.ack <= 0;

          //$display("[%0t] DRIVER: Packet with A = %0d, B = %0d sent",  $time, pkt.A, pkt.B);// Used for debugging
            
              
        end

        $display("[%0t] DRIVER: Task completed!", $time);
    endtask

endclass
