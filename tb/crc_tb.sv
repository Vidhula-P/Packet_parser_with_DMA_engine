module crc_tb;
	logic clk;
	logic rst;
	logic [255:0] data_raw;
	logic [31:0]  crc;
	logic done;

	crc crc_dut (
		.clk(clk),
		.rst(rst),
		.data_raw(data_raw),
		.crc(crc),
		.done(done)
	);

	//Timescale
	timeunit 10ns; timeprecision 100ps;

	//Clock generation
	initial clk = 1'b0;
	always #5 clk = ~clk;

	// Stimulus
	initial begin
		rst = 1;
		data_raw = 0;
		#7 @(posedge clk);
		rst = 0;
		data_raw = 256'h0123456789ABCDEF00112233445566778899AABBCCDDEEFF0F1E2D3C4B5A6978;
		repeat (40) @(posedge clk); //wait for output
		if (done)
			$display("CRC- %h", crc);
		else
			$display("Premature exit");
		$finish;
	end
endmodule
