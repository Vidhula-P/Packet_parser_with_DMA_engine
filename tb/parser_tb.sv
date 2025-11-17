module parser_tb;

  timeunit 10ns; 
  timeprecision 100ps;

  localparam WIDTH = 32;

  logic clk, rst;

  logic [WIDTH-1:0] data_in;
  logic             valid_in;
  logic             ready_in;

  logic [WIDTH-1:0] data_out;
  logic             valid_out;
  logic             ready_out;

  // Test packet fields
  logic [127:0] eth_hdr;
  logic [159:0] ip_hdr; 
  logic [159:0] tcp_hdr;
  logic [319:0] payload;

  logic [767:0] full_data;   // 128 + 160 + 160 + 320 = 768 bits total

  // ---------------------------
  // DUT
  // ---------------------------
  packet_parser #(
      .WIDTH(WIDTH)
  ) dut (
      .clk      (clk),
      .rst      (rst),
      .data_in  (data_in),
      .valid_in (valid_in),
      .ready_in (ready_in),
      .data_out (data_out),
      .valid_out(valid_out),
      .ready_out(ready_out)
  );

  // ---------------------------
  // Clock gen (10 ns period)
  // ---------------------------
  initial clk = 0;
  always #5 clk = ~clk;

  // -------------------------------------------
  // Send one 32-bit word (task)
  // -------------------------------------------
  task send_word(input logic [31:0] word);
    begin
      valid_in = 1;
      data_in  = word;
    	// wait for a clock edge
  		@(posedge clk);
  		// If parser wasn't ready that clock, wait until it is ready on subsequent clocks
  		while (!ready_in) @(posedge clk);
      valid_in = 0;
			@(posedge clk); 
    end
  endtask

  // -------------------------------------------
  // Stimulus
  // -------------------------------------------
  initial begin
		rst = 1;
    rst = 0;
    valid_in = 0;
    ready_out = 1;  // FIFO ready
    repeat (5) @(posedge clk);
    rst = 1; 
		@(posedge clk); // wait one clock cycle

    // Prepare headers 
    eth_hdr = 128'hA1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1; //the header was 14B but was padded by (pretend) software driver
		ip_hdr = 160'hB2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2; 
		tcp_hdr = 160'hC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3; 
		payload = 320'hD4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099;

    full_data = {eth_hdr, ip_hdr, tcp_hdr, payload};
		//$display("Full data- %h", full_data);
		// Send MSB → LSB (matches the parser shift order)
   	for (int i = 767; i >= 0; i -= 32) begin
      send_word(full_data[i-:32]);  // part-select from i downto i-31
			$display("Word sent in testbench- %032h", full_data[i-:32]);
    end

    // Give time for parser to finish PAYLOAD
    repeat (10) @(posedge clk);

    $display("---- Parser Internal Headers ----");
    $display("ETH:     %032h", dut.ethernet_header);
    $display("IP :     %040h", dut.ip_header);
    $display("TCP:     %040h", dut.tcp_header);
    $display("PAYLOAD: %080h", dut.payload_data);
		
		@(posedge clk);
    $finish;
  end

endmodule

