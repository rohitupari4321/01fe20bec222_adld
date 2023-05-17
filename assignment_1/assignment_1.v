module tb;
reg clk,car,reset;
reg [1:0]e_password;
wire front_sensor,back_sensor;
wire [3:0]car_count;

car_park PARKING(clk,car,reset,e_password,front_sensor,back_sensor,car_count);

initial clk=0;
always #5 clk=~clk;

initial begin
$monitor($time, " reset=%b  car=%b  e_password=%b  front_sensor=%b  back_sensor=%b  car_count=%d",reset,car,e_password,front_sensor,back_sensor,car_count);
 car=1'b0;
 reset=1'b1;

#15 car=1'b1;             // car-1
   reset=1'b0; 
   e_password=2'b10;    //wrong password

#10 e_password=2'b11;  //corrrect password

#10 car=1'b1;            // car-2 

#10 car=1'b0;

#10 car=1'b1;            // car-3

#100 $finish;

 end
endmodule



module car_park(clk,car,reset,e_password,front_sensor,back_sensor,car_count);

parameter password=2'b11;
parameter input_car=2'b00,pass_check=2'b01,car_park=2'b10;

input clk,car,reset;
input [1:0]e_password;
output reg front_sensor,back_sensor;
output reg [3:0]car_count;

reg [1:0]cur_state,next_state;

always@(posedge clk)
begin
if(reset)
begin
cur_state<=input_car;
car_count<=4'b0000;
end
else
cur_state<=next_state;
end

always@(posedge clk)
begin
   case(cur_state)
   input_car: begin
		back_sensor=1'b0;
	      	if(car==1'b1)
              	begin
              	  front_sensor=1'b1;
                  next_state <= pass_check;       
	      	end
                else
              	 next_state <= input_car;
              end

  
   pass_check:begin
               if(e_password==password)
                begin
                next_state<=car_park;
                end
               
               else 
                begin
                next_state<=pass_check;
                end
              end


   car_park:begin
              back_sensor=1'b1;
              front_sensor=1'b0;
             car_count<=car_count+1;
             next_state<=input_car;
             end

 default:begin
             next_state<=input_car;
         end

  endcase
end
endmodule









              
              
		
