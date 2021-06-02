module Clock
  ( clock,
    shutdownFlag
  );

  output reg clock;
  input shutdownFlag;

  initial clock = 1;

  always #100 if (!shutdownFlag) clock = ~clock;

endmodule
