FILES=(
  # ----------------------------
  src/Clock.v
  src/Stack.v
  src/Main.v
)

iverilog -o dist/Main.vvp ${FILES[@]}