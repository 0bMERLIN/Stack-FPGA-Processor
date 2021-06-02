/*

0000 = end program
1010 = push a zero
1011 = increment
1100 = decrement
1101 = jump where stack = [<destination>, <boolean condition>, ...]
1110 = is zero
1111 = is not zero
11111= duplicate
111111=blink

push(2)

n: decrement

nzero?
push(n)
jump



; //////// ASSEMBLER ////////
0  push(0)
1  increment
2  increment

3  decrement
4  push(0)
5  increment
6  increment
7  increment
8  zero?
9  jump

; //////// RAW BINARY ////////
1010 1011 1010 1011 1010 1011 1101



*/

module Main;



  //////////////////////////// PROG /////////////////////////////
  integer programFillerCounter;
  integer program[256:0];
  initial begin
    
    for (programFillerCounter = 0; programFillerCounter < 256; programFillerCounter = programFillerCounter + 1) begin
      
      program[programFillerCounter] = 'b0000;
    end
    
    // push a two
    program[0] = 'b1010;
    program[1] = 'b1011;
    program[2] = 'b1011;
    program[3] = 'b1011;

    // decrement
    program[4] = 'b1100;
    
    // if is not zero
    program[5] = 'b11111;
    program[6] = 'b1111;

    // jump to instruction 3
    program[7] = 'b1010; // push address 4
    program[8] = 'b1011;
    program[9] = 'b1011;
    program[10] = 'b1011;
    program[11] = 'b1011;
    program[12] = 'b111111;
    program[13]= 'b1101; // jump

  end

  //////////////////////////// STACK ////////////////////////////
  reg psh;
  reg pop;
  integer i;
  wire integer o;
  wire popDone;

  initial psh = 0;
  initial pop = 0;
  initial i = 0;
  Stack stack(psh,pop,popDone,i[0],i[1],i[2],i[3],i[4],i[5],i[6],i[7],o);


  //////////////////////////// CLOCK ////////////////////////////
  integer currClock;
  integer maxClock;
  initial maxClock = 100;
  initial currClock = 0;
  wire clockSignal;
  reg shutdown;
  initial shutdown = 0;

  Clock clock(clockSignal,shutdown);

  always @(posedge clockSignal) begin
    currClock <= currClock + 1;
    if (currClock >= maxClock) shutdown <= 1;
  end

  always @(posedge shutdown) begin
    $display("Finished.");
    $finish;
  end


  ///////////////////////// INTERPRETER /////////////////////////
  integer ip;
  initial ip = 0;

  integer debugLogs;
  initial debugLogs = 0;

  integer condition;
  integer address;

  initial begin
    condition = 0;
    address = 0;
  end

  always @(posedge clockSignal) begin
    
    ip <= ip + 1;

    if (debugLogs) begin
      $display("_____________________________");
      $display("ip:", ip);
    end

    case (program[ip])

      ////////// PUSH ZERO //////////
      'b1010: begin
        if (debugLogs) $display("current instruction: Push 0");
        i <= 0;
        psh <= 1;
        psh <= 0;
      end

      ////////// INCREMENT /////////
      'b1011: begin
        if (debugLogs) $display("current instruction: Increment");
        pop <= 1;
        pop <= 0;
        #2 i <= o + 1;
        #5 psh <= 1;
        #5 psh <= 0;
      end

      ////////// DECREMENT /////////
      'b1100: begin
        if (debugLogs) $display("current instruction: Decrement");
        pop <= 1;
        pop <= 0;
        #2 i <= o - 1;
        #5 psh <= 1;
        #5 psh <= 0;
      end

      ////////// IS ZERO ///////////
      'b1110: begin
        if (debugLogs) $display("current instruction: Is Zero");
        pop <= 1;
        pop <= 0;
        #2 i <= o < 1;
        #5 psh <= 1;
        #5 psh <= 0;
      end

      //////// IS NOT ZERO /////////
      'b1111: begin
        if (debugLogs) $display("current instruction: Is not Zero");
        pop <= 1;
        pop <= 0;
        #2 i <= o > 0;
        #5 psh <= 1;
        #5 psh <= 0;
      end

      ///////// DUPLICATE /////////
      'b11111: begin
        if (debugLogs) $display("current instruction: Duplicate");
        pop <= 1;
        pop <= 0;
        #2 i <= o;
        #5 psh <= 1;
        #5 psh <= 0;
        #10 psh <= 1;
        #10 psh <= 0;
      end

      ////////// JUMP ////////////
      'b1101: begin
        if (debugLogs) $display("current instruction: Jump");
        pop <= 1;
        pop <= 0;
        #2 address <= o;
        
        #4 pop <= 1;
        #4 pop <= 0;
        #6 condition <= o;

        #15 begin
          if (condition > 0)
            #20 ip <= address;
        end
      end

      ////////// BLINK ///////////
      'b111111: begin
        if (debugLogs) $display("current instruction: Blink");
        #10 $display("blink!");
      end

      //////////// END ////////////
      default: begin
        if (debugLogs) $display("Processor: Terminating instruction");
        $finish;
      end

    endcase
  end



endmodule
