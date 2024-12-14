`timescale 1ns / 100ps

module tb_symmetricFIR();

parameter CLK_PERIOD          = 2;
parameter DATA_WIDTH          = 12;
parameter COEFF_WIDTH         = 8;
parameter TEST_CYCLES         = 100;
parameter AMPLITUDE           = 500;
parameter NOISE_AMPLITUDE     = 50;
parameter DATA_DELAY          = 12;

real PI                       = 3.14159265359;
real sine_value, noisy_sine;

reg                                             clk_i = 1;
reg                                             rst_i = 1;
reg                                             load_i;
reg signed  [                  COEFF_WIDTH-1:0] coef0_i;
reg signed  [                  COEFF_WIDTH-1:0] coef1_i;
reg signed  [                  COEFF_WIDTH-1:0] coef2_i;
reg signed  [                  COEFF_WIDTH-1:0] coef3_i;
reg signed  [                  COEFF_WIDTH-1:0] coef4_i;
reg signed  [                  COEFF_WIDTH-1:0] coef5_i;
reg signed  [                   DATA_WIDTH-1:0] signal_i;
wire signed [ (DATA_WIDTH+1+COEFF_WIDTH+1)-1:0] signal_o;

integer i;

symmetricFIR #(
  .DATA_WIDTH(DATA_WIDTH), 
  .COEFF_WIDTH(COEFF_WIDTH)) 
dut(
  .clk_i(clk_i),
  .rst_i(rst_i),
  .load_i(load_i),
  .coef0_i(coef0_i),
  .coef1_i(coef1_i),
  .coef2_i(coef2_i),
  .coef3_i(coef3_i),
  .coef4_i(coef4_i),
  .coef5_i(coef5_i),
  .signal_i(signal_i),
  .signal_o(signal_o)
);

initial begin
  forever #(CLK_PERIOD/2) clk_i = ~clk_i;
end

task load_coeffs();
begin
  @(negedge clk_i);
  load_i  = 1;
  coef0_i = $random % (2 ** (COEFF_WIDTH-1));
  coef1_i = $random % (2 ** (COEFF_WIDTH-1));
  coef2_i = $random % (2 ** (COEFF_WIDTH-1));
  coef3_i = $random % (2 ** (COEFF_WIDTH-1));
  coef4_i = $random % (2 ** (COEFF_WIDTH-1));
  coef5_i = $random % (2 ** (COEFF_WIDTH-1));
  @(negedge clk_i);
  load_i  = 0;
end
endtask

task load_signals();
begin
  @(negedge clk_i);
  for (i=0; i<TEST_CYCLES; i=i+1) begin
    // Generate sine wave for multiple periods
    sine_value = AMPLITUDE * $sin(2 * PI * i / (DATA_DELAY));
    // Add noise
    noisy_sine = sine_value + ($random % (2*NOISE_AMPLITUDE + 1) - NOISE_AMPLITUDE);
    
    // Ensure the value fits within DATA_WIDTH bits (signed)
    if (noisy_sine > (2**(DATA_WIDTH-1) - 1)) 
        noisy_sine = (2**(DATA_WIDTH-1) - 1);
    if (noisy_sine < -(2**(DATA_WIDTH-1)))
        noisy_sine = -(2**(DATA_WIDTH-1));
                
    // Convert to fixed-point and assign to input
    signal_i = $rtoi(noisy_sine);
    @(negedge clk_i);
  end
end
endtask

task reset_phase();
begin
  rst_i     = 1;
  load_i    = 0;
  coef0_i   = 0;
  coef1_i   = 0;
  coef2_i   = 0;
  coef3_i   = 0;
  coef4_i   = 0;
  coef5_i   = 0;
  signal_i  = 0;
  repeat(4) @(negedge clk_i);
  rst_i     = 0;
end
endtask

initial begin
  reset_phase();
  load_coeffs();
  load_signals();
  repeat(10) @(posedge clk_i);
  $finish;
end

endmodule