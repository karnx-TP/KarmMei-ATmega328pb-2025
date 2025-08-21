`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers:
// 
// Create Date: 07/22/2024 09:44:47 PM
// Design Name: 
// Module Name: ProgramMemorywithFSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//top level of Memory of FSM block and Program Memory block
module ProgramMemorywithFSM_withoutinternalsignals(
                input clk,
                input [13:0] PC,
                input PC_RD,
                input BS1, XTAL1, WR, OE, //WR and OE are active low
                input [1:0] XA,
                input [7:0] DATA,
                output logic RDY, 
                output logic [15:0]Dout
    );
    
    logic [1:0] BkSel;
    logic [7:0] DBI;
    logic EnBuf, EnAdrLat, Adr_0;
    logic DB_WR, DB_RD, Data_RD;
    logic Erase, Prog;
    logic RD;
    logic RD_highbyte;
    logic EN_ChipErase;
   
             
    assign DBI[7:0] = DATA[7:0];
    assign Adr_0 = BS1;
    Memory_FSM_withoutinternalsignals FSMofMemory(.*);
    ProgramMemory_withoutinternalsignals ProgramMem(.*);

    
    
    
endmodule