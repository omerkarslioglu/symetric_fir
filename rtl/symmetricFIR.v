`timescale 1ns / 100ps

module symmetricFIR #(
  parameter DATA_WIDTH = 12,
  parameter COEFF_WIDTH = 8
)(
  input                                             clk_i,
  input                                             rst_i,
  input                                             load_i,
  /* coefficients can be loaded by load_i signal */
  input signed  [                  COEFF_WIDTH-1:0] coef0_i,
  input signed  [                  COEFF_WIDTH-1:0] coef1_i,
  input signed  [                  COEFF_WIDTH-1:0] coef2_i,
  input signed  [                  COEFF_WIDTH-1:0] coef3_i,
  input signed  [                  COEFF_WIDTH-1:0] coef4_i,
  input signed  [                  COEFF_WIDTH-1:0] coef5_i,
  /* input signal to enter filter */
  input signed  [                   DATA_WIDTH-1:0] signal_i,
  /* output signal*/
  output signed [ (DATA_WIDTH+1+COEFF_WIDTH+1)-1:0] signal_o
);

reg signed    [                  DATA_WIDTH-1:0] delayed_signal       [  0:DATA_WIDTH-1];
reg signed    [                 COEFF_WIDTH-1:0] coeff                [             0:5];
      
reg signed    [              (DATA_WIDTH-1)+1:0] a                    [             0:5]; // first floor sum (+1 bit for overflow)
reg signed    [(DATA_WIDTH+1+COEFF_WIDTH+1)-1:0] pa                   [             0:2]; // second floor sum (procution result bit + 1 bit for overflow)
reg signed    [(DATA_WIDTH+1+COEFF_WIDTH+1)-1:0] pa_last                                ; // add two producted adder
reg signed    [  (DATA_WIDTH+1+COEFF_WIDTH)-1:0] p                    [             0:5]; // production

integer i = 0;

always @(posedge clk_i or posedge rst_i) begin
  if (rst_i) begin
    for (i = 0; i < DATA_WIDTH; i=i+1) begin
      delayed_signal[i] <= 0;
    end
  end else begin
    // Shift in new input sample
    for (i = DATA_WIDTH-1; i > 0; i=i-1) begin
      delayed_signal[i] <= delayed_signal[i-1];
    end
    delayed_signal[0] <= signal_i;
  end
end

always @(posedge clk_i or posedge rst_i) begin
  if(rst_i) begin
    for (i = 0; i < 6; i=i+1) begin
      coeff[i] <= 0;
    end
  end else begin
    if(load_i == 1'b1) begin
      coeff[0] <= coef0_i;
      coeff[1] <= coef1_i;
      coeff[2] <= coef2_i;
      coeff[3] <= coef3_i;
      coeff[4] <= coef4_i;
      coeff[5] <= coef5_i;
    end
  end
end

always @* begin
  a[0] = signal_i + delayed_signal[11];
  a[1] = delayed_signal[1] +  delayed_signal[10];
  a[2] = delayed_signal[2] +  delayed_signal[9];
  a[3] = delayed_signal[3] +  delayed_signal[8];
  a[4] = delayed_signal[4] +  delayed_signal[7];
  a[5] = delayed_signal[5] +  delayed_signal[6];
end

always @* begin
  p[0] = a[0] * coeff[0];
  p[1] = a[1] * coeff[1];
  p[2] = a[2] * coeff[2];
  p[3] = a[3] * coeff[3];
  p[4] = a[4] * coeff[4];
  p[5] = a[5] * coeff[5];
end

always @* begin
  pa[0] = p[0] + p[1];
  pa[1] = p[2] + p[3];
  pa[2] = p[4] + p[5];
end

always @* begin
  pa_last = pa[0] + pa[1];
end

assign signal_o = pa_last + pa[2];

endmodule