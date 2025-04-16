// Scoreboard Class

class scoreboard;
   int expect_q[$];

  function new(ref int expect_q[$]);
        this.expect_q = expect_q;
    endfunction
  

    task display_expect_q(int expect_q[$], string header = "[SCOREBOARD] Expected GCD Queue:");
      $display("%s (Size: %0d)", header, expect_q.size());

      foreach (expect_q[i]) begin
        $display("  Expect[%0d] -> GCD = %0d", i, expect_q[i]);
      end
    endtask
  
  
    task check_output(int actual, time timestamp);
        int expected;
      
      	//display_expect_q(expect_q); //Used for debugging
      
        if (expect_q.empty()) begin
            $display("[%0t] SCOREBOARD: Expect queue empty, nothing to check!", timestamp);
        end else begin
            expected = expect_q.pop_front();

            if (actual === expected) begin
                $display("[PASS] Time=%0t | DUT: %0d Expected: %0d", 
                          timestamp, actual, expected);
            end else begin
                $display("[FAIL] Time=%0t | DUT: %0d Expected: %0d", 
                          timestamp, actual, expected);
            end
        end
    endtask
endclass

