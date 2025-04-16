// Monitor Class
class monitor;
    virtual gcd_if vif;
    scoreboard sb;	
  	

  function new(virtual gcd_if vif,scoreboard sb);
        this.vif = vif;
        this.sb = sb;
    endfunction
  
  

    task run();
        bit prev_gcd_valid = 0;

        forever begin
            @(posedge vif.Clk);

            if (vif.gcd_valid === 1 && prev_gcd_valid === 0) begin
                // Check the output when gcd_valid is asserted
                sb.check_output(vif.gcd_out, $time);
            end

           prev_gcd_valid = vif.gcd_valid;

            // Exit when the expect_queue in the scoreboard is empty
          if (sb.expect_q.empty()) begin
                $display("[%0t] MONITOR: All transactions checked, finishing...", $time);
              		repeat (5) @(posedge vif.Clk);  // Add some clock cycles for synchronization
                break;
            end
        end

        $display("[%0t] MONITOR: Task completed!", $time);
    endtask
endclass
