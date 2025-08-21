`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers: W.W., P.T. 
// 
// Create Date: 07/18/2024 08:12:08 PM
// Design Name: 
// Module Name: Memory_FSM
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


module Memory_FSM(
            input clk,
            input PC_RD, BS1, XTAL1, WR, OE, //WR and OE are active low
            input [1:0] XA,
            input [13:0] PC,
            input [7:0] DATA,
            output logic RD, Erase, Prog,
            output logic [1:0] BkSel,
            output logic EnBuf, EnAdrLat,
            output logic DB_WR, DB_RD, RD_highbyte,
            output logic EN_ChipErase,
            //output logic Adr_0,
            output logic RDY,
            output logic EN_Erase,
            output logic [2:0] wAdr_sideselect,
            output logic Data_RD
                );


//logic Data_RD; //used along with PC_RD to gen RD signal at second half clk
                
enum logic [2:0] {command_NoOperation, command_ChipErase, command_WriteFlash, command_LoadAddressLowByte,
                  command_LoadAddressHighByte, command_LoadDataLowByte, command_LoadDataHighByte, command_ReadFlash} command;                


enum logic [3:0] {NoOperation, ChipErase, StartWriteFlash, LoadAddressLowByte_PG, LoadAddressHighByte_PG,
                  LoadDataLowByte_PG, LoadDataHighByte_PG, Internal_Page_Erase, Program_Page, Page_Write_Done,
                  StartReadFlash, LoadAddressHighByte_RD, LoadAddressLowByte_RD, ReadDataLowByte, ReadDataHighByte} current_state;

/*
always @(posedge WR)
    begin
        EN_Erase <= 1;
        EN_Erase <= #100ns 0;
    end */
    
logic go_to_Program_Page, go_to_Page_Write_Done, Chip_Erase_Done;

always@(*)
    begin
        if (go_to_Program_Page == 1)
            begin
                go_to_Program_Page <= 0;
                #3.2ms current_state <= Program_Page;
            end
    end
always@(*)
    begin
        if (go_to_Page_Write_Done == 1)
            begin
                go_to_Page_Write_Done <= 0;
                #3.2ms current_state <= Page_Write_Done;
            end
    end
always@(*)
    begin
        if (Chip_Erase_Done == 1)
            begin
                Chip_Erase_Done <= 0;
                #3.2ms current_state <= NoOperation;
            end
    end
always@(*) //FSM logic
    begin
        if ((XA == 2'b10) && (DATA == 8'b00000000) && (XTAL1 == 1))
            command <= command_NoOperation;
            
        else if ((XA == 2'b10) && (BS1 == 0) && (DATA == 8'b10000000) && (XTAL1 == 1))
            command <= command_ChipErase; 
            
        else if ((XA == 2'b10) && (BS1 == 0) && (DATA == 8'b00010000) && (XTAL1 == 1))
            command <= command_WriteFlash;
        
        else if ((XA == 2'b10) && (BS1 == 0) && (DATA == 8'b00000010) && (XTAL1 == 1))
            command <= command_ReadFlash;   
            
        else if ((XA == 2'b00) && (BS1 == 0) && (XTAL1 == 1))
            command <= command_LoadAddressLowByte;   
            
        else if ((XA == 2'b00) && (BS1 == 1) && (XTAL1 == 1))
            command <= command_LoadAddressHighByte;    
            
        else if ((XA == 2'b01) && (BS1 == 0) && (XTAL1 == 1))
            command <= command_LoadDataLowByte;  
            
        else if ((XA == 2'b01) && (BS1 == 1) && (XTAL1 == 1))
            command <= command_LoadDataHighByte;  
        else
            command <= command;  
    
         if (command == command_NoOperation)
            begin
            current_state <= NoOperation;
             RDY <= 1;
                Prog <= 0;
                Erase <= 0;
                Data_RD <= 0;
                DB_WR <= 0;
                EnBuf <= 0;
                EnAdrLat <= 0;
               // Adr_0 = 0;
                EN_ChipErase <= 0;
                DB_RD <= 0;
                RD_highbyte <= 0;
                    if ((command == command_ReadFlash) && (PC_RD == 0))
                        current_state <= StartReadFlash;
                    else if (command == command_WriteFlash)
                        current_state <= StartWriteFlash;
                    else if ((command == command_ChipErase) && (PC_RD == 0))
                        current_state <= ChipErase;
            
            end       
        
        if (current_state == NoOperation)
            begin
                RDY <= 1;
                Prog <= 0;
                Erase <= 0;
                Data_RD <= 0;
                DB_WR <= 0;
                EnBuf <= 0;
                EnAdrLat <= 0;
               // Adr_0 = 0;
                EN_ChipErase <= 0;
                DB_RD <= 0;
                RD_highbyte <= 0;
                    if ((command == command_ReadFlash) && (PC_RD == 0))
                        current_state = StartReadFlash;
                    else if (command == command_WriteFlash)
                        current_state = StartWriteFlash;
                    else if ((command == command_ChipErase) && (PC_RD == 0))
                        current_state = ChipErase;
            end
        else if (current_state == ChipErase)
            begin
                RDY = 0;
                EN_ChipErase = 1;
                Chip_Erase_Done = 1;
                end
             //#3.2ms current_state = NoOperation; //still unsure of time it takes to perform Chip Erase
        
        else if (current_state == StartReadFlash) 
            begin 
                DB_RD = 1;  
                    if (PC_RD == 1)
                        current_state = NoOperation;
                    else if (command == command_LoadAddressHighByte)
                        current_state = LoadAddressHighByte_RD;
            end    
        else if (current_state == LoadAddressHighByte_RD) 
            begin
                if (clk == 1)
                    DB_RD = 1;
                else if (clk == 0)
                    DB_RD = 0;
                    if (PC_RD == 1)
                        current_state = NoOperation;
                    else if(command == command_LoadAddressLowByte)
                        current_state = LoadAddressLowByte_RD;
            end
        else if (current_state == LoadAddressLowByte_RD)
            begin
                if (clk == 1)
                    DB_RD <= 1;
                else if (clk == 0)
                    DB_RD <= 0;
                    if (PC_RD == 1)
                        current_state <= NoOperation;
                    else if ((OE == 0) && (BS1 == 0))
                        current_state <= ReadDataLowByte;
                    else if ((OE == 0) && (BS1 == 1))
                        current_state <= ReadDataHighByte;
            end                        
        else if (current_state == ReadDataLowByte)
                    begin
                    DB_RD <= 0; 
                    Data_RD <= 1;
                    RD_highbyte <= 0; 
                    if (PC_RD == 1)
                        current_state <= NoOperation;
                    else if ((OE == 0) && (BS1 == 1))
                        current_state <= ReadDataHighByte;
                    else if (OE == 1)
                        current_state <= NoOperation;
            end                
        else if (current_state == ReadDataHighByte)
            begin
                DB_RD <= 0;
                Data_RD <= 1;
                RD_highbyte <= 1;
                    if (PC_RD == 1)
                        current_state <= NoOperation;
                    else if ((OE == 0) && (BS1 == 0))
                        current_state <= ReadDataLowByte;
                    else if (OE == 1)
                        current_state <= NoOperation;                    
            end
        else if (current_state == StartWriteFlash)
            begin
                DB_WR = 1;
                EnBuf = 0;
                EnAdrLat = 0;
                    if (command == command_LoadAddressLowByte)
                        current_state = LoadAddressLowByte_PG;
            end
        else if (current_state == LoadAddressLowByte_PG)
            begin
                EnAdrLat = 1;
                DB_WR = 1;
                EnBuf = 0;
                //Adr_0 = 0;
                if (clk == 1)
                    EnAdrLat = 1;
                else
                    EnAdrLat = 0;
                    if (command == command_LoadDataLowByte)
                        current_state = LoadDataLowByte_PG;
            end
        else if (current_state == LoadDataLowByte_PG)
            begin
                DB_WR = 1;
                EnAdrLat = 0;
                //Adr_0 = 0;
                if (clk == 1)
                    EnBuf = 1;
                else
                    EnBuf = 0;
                    if (command == command_LoadDataHighByte)
                        current_state = LoadDataHighByte_PG;
            end
        else if (current_state == LoadDataHighByte_PG)
            begin
                DB_WR = 1;
                EnAdrLat = 0;
                //Adr_0 = 1;
                if (clk == 1)
                    EnBuf = 1;
                else
                    EnBuf = 0;
                    if (command == command_LoadAddressLowByte)
                        current_state = LoadAddressLowByte_PG;
                    else if (command == command_LoadAddressHighByte)
                        current_state = LoadAddressHighByte_PG;
            end
        else if (current_state == LoadAddressHighByte_PG)
            begin
                if (WR == 0)//(EN_Erase == 1)
                    begin
                        current_state = Internal_Page_Erase;
                    end
                else
                    begin 
                        current_state = current_state;
                    end
                DB_WR = 1;
                EnBuf = 0;
                wAdr_sideselect[2:0] = DATA[6:4];
                        if (clk == 1)
                            EnAdrLat = 1;
                        else
                            begin
                            EnAdrLat = 0;
                            end
            end
        else if (current_state == Internal_Page_Erase)  
            begin
                DB_WR = 0;
                EnAdrLat = 0;
                EnBuf = 0;
                RDY = 0;
                Prog = 0;
                Erase = 1;
                go_to_Program_Page = 1;
            end         
        else if (current_state == Program_Page) 
            begin
                DB_WR = 0;
                EnAdrLat = 0;
                EnBuf = 0;
                RDY = 0;
                Erase = 0;
                Prog = 1;
                go_to_Page_Write_Done = 1;
            end
        else if (current_state == Page_Write_Done)
            begin
                DB_WR = 0;
                EnAdrLat = 0;
                EnBuf = 0;
                Prog = 0;
                Erase = 0;
                RDY = 1;
                    if (command == command_LoadAddressLowByte)
                        current_state = LoadAddressLowByte_PG;
                    else if (command == command_NoOperation) 
                        current_state = NoOperation;
            end
         else
            ;
       
    end


always_comb //BkSel logic
    begin    
        if (((PC_RD^(DB_RD || Data_RD)) == 1) && ((Prog == 1) || (Erase == 1)) && (PC[13:11] != 3'b111) && (wAdr_sideselect == 3'b111))
            BkSel[1:0] = 2'b01;
        else if (((PC_RD^ (DB_RD || Data_RD)) == 1) && ((Prog == 1) || (Erase == 1)) && (PC[13:11] == 3'b111) && (wAdr_sideselect != 3'b111))    
            BkSel[1:0] = 2'b10;
        else if ((Prog == 0) && (Erase == 0) && ((PC_RD ^ (DB_RD || Data_RD) ) == 1))
            BkSel[1:0] = 2'b00;
        else if ((PC_RD == 0) && (Data_RD == 0) && (DB_RD == 0) && ((Prog == 1) || (Erase == 1)))
            BkSel[1:0] = 2'b11;
        else
            BkSel[1:0] = BkSel[1:0];
    end

always@ (negedge clk) //RD produced at second half of clock
    begin
        if ((PC_RD ^ Data_RD == 1) && (BkSel[1:0] != 2'b01))
                RD = 1; 
    end

always @(posedge clk) 
    begin
        if (RD == 1)
            RD = 0;
    end
    
    
           
endmodule
