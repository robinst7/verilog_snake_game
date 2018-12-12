module snake_body(update,start,VGA_clk,snakeHead,snakeBody,xCount,yCount,size, KB_clk, data);
	input update , start,VGA_clk, KB_clk, data;
	input[9:0]xCount, yCount;
	input wire[4:0] size ;
	wire reset ;
	output  snakeHead,snakeBody;
	reg [9:0] snakeX[0:31];
	reg [8:0] snakeY[0:31];
	reg [9:0] snakeHeadX;
	reg [9:0] snakeHeadY;
	integer  count2, count3,count1;
	reg snakeHead;
	reg snakeBody;
	wire [9:0] xCount;
	wire [9:0] yCount;
	wire [4:0] direction;
	kbInput kb(KB_clk, data, direction, reset,start);
	
	always@(posedge update)
	begin
	if(start)
	begin
		if(direction != 5'b11111)begin
		for(count1 = 31; count1 > 0; count1 = count1 - 1)
			begin
				if(count1 <= size - 1)
				begin
					snakeX[count1] = snakeX[count1 - 1];
					snakeY[count1] = snakeY[count1 - 1];
				end
			end
			end
		case(direction)
			5'b00010: snakeY[0] <= (snakeY[0] - 5);
			5'b00100: snakeX[0] <= (snakeX[0] - 5);
			5'b01000: snakeY[0] <= (snakeY[0] + 5);
			5'b10000: snakeX[0] <= (snakeX[0] + 5);
			5'b11111:begin snakeX[0] <= snakeX[0];
			snakeY[0] <= snakeY[0]; end 
			endcase	
		end
	else if(~start)
	begin
		for(count3 = 1; count3 < 32; count3 = count3+1)
			begin
			snakeX[count3] = 700;
			snakeY[count3] = 500;
			end
			snakeX[0] = 300;
			snakeY[0] = 300;
	end
	
	end
	
	
	
	
	
	always@(posedge VGA_clk)
	begin
	
		snakeBody =0 ;
		
		for(count2 = 1; count2 < size; count2 = count2 + 1)
		begin
				
			if(snakeBody ==0 )
			snakeBody = ((xCount > snakeX[count2] && xCount < snakeX[count2]+5) && (yCount > snakeY[count2] && yCount < snakeY[count2]+5));
		
		
		end
	end


	
	always@(posedge VGA_clk)
	begin	
		snakeHead = (xCount > snakeX[0] && xCount < (snakeX[0]+5)) && (yCount > snakeY[0] && yCount < (snakeY[0]+5));
	end
	

endmodule 

module kbInput(KB_clk, data, direction,reset,start);

	input KB_clk, data,start;
	output reg [4:0] direction;
	output reg reset = 0; 
	reg [7:0] code;
	reg [10:0]keyCode, previousCode;
	integer count = 0;

always@(negedge KB_clk)
	begin
		keyCode[count] = data;
		count = count + 1;			
		if(count == 11)
		begin
			if(previousCode == 8'hF0)
			begin
				code <= keyCode[8:1];
			end
			previousCode = keyCode[8:1];
			count = 0;
		end
	end
	
	always@(*)
	if(start == 1'b0)
		begin
			reset = 1;
			 direction=5'b11111;
		end
	else
		begin
			if(reset == 1)
				begin
				reset = 0;
				direction=5'b11111;
				end
				
			
			if(code == 8'h1D && direction != 5'b01000) //up 
				direction = 5'b00010;					
			else if(code == 8'h1C && direction != 5'b10000)//left
				direction = 5'b00100;
			else if(code == 8'h1B && direction != 5'b00010)
				direction = 5'b01000;//down
			else if(code == 8'h23 && direction != 5'b00100)
				direction = 5'b10000;//right
			else
				//direction = 5'b11111;
			   direction = direction;
			
		end	
endmodule