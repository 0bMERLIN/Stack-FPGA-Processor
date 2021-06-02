module Stack
  ( push,
    pop,
    popDone,
    
    b0,
    b1,
    b2,
    b3,
    b4,
    b5,
    b6,
    b7,

    out
  );

input push;
input pop;

input b0;
input b1;
input b2;
input b3;
input b4;
input b5;
input b6;
input b7;

output integer out;
output reg popDone;

integer stackP;
integer stackM[255:0];
integer stackMInitializer;

integer debugInt;
initial debugInt = 0;

initial stackP = 0;

initial for(
  stackMInitializer = 0;
  stackMInitializer < 256;
  stackMInitializer = stackMInitializer + 1)
  stackM[stackMInitializer] = 0;


always @(posedge push) begin

  debugInt[0] <= b0;
  debugInt[1] <= b1;
  debugInt[2] <= b2;
  debugInt[3] <= b3;
  debugInt[4] <= b4;
  debugInt[5] <= b5;
  debugInt[6] <= b6;
  debugInt[7] <= b7;



  // #10 $display("Push:", debugInt);//b0,b1,b2,b3,b4,b5,b6,b7);

  stackM[stackP][0] <= b0;
  stackM[stackP][1] <= b1;
  stackM[stackP][2] <= b2;
  stackM[stackP][3] <= b3;
  stackM[stackP][4] <= b4;
  stackM[stackP][5] <= b5;
  stackM[stackP][6] <= b6;
  stackM[stackP][7] <= b7;

  stackP <= stackP + 1;


end


always @(posedge pop) begin

  // $display("Pop:", out);

  stackP <= stackP - 1;
  
  popDone <= 1;
  popDone <= 0;
  
  out = stackM[stackP - 1];
  
end


endmodule