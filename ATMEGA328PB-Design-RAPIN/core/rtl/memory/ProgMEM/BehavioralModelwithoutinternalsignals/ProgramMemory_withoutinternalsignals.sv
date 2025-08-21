module ProgramMemory_withoutinternalsignals(
                input [13:0] PC,
                input [7:0] DBI,
                input [1:0] BkSel,
                input EnBuf, EnAdrLat, Adr_0,
                input DB_WR, DB_RD, PC_RD, Data_RD,
                input Erase, Prog,
                input RD_highbyte,
                input EN_ChipErase,
                input RD,
                output logic [15:0]Dout
);

// initails , waiting for nvm
integer file ,code ;

//internal RD, ER, WR signals
logic i_RD_RWW, i_ER_RWW, i_WR_RWW;
logic i_RD_NRWW, i_ER_NRWW, i_WR_NRWW;
//logics for latch enables
logic EN_RD_A_highbyte, EN_RD_A_lowbyte;
logic EN_wAdr_highbyte, EN_wAdr_lowbyte;
logic EN_WRBUF;
logic EN_Dout_Latch;

logic [15:0] Dout_beforedelay;
logic [1:0] BkSel_L;
logic [14:0] RD_A;

logic [14:0] tmp_RD_access_highbyte;
logic [14:0] tmp_RD_access_lowbyte;
logic [127:0][7:0] Out_WRBUF;
logic [6:0] tmp_wAdrbyteselect; //for byte selection of Write Buffer Latch
logic [14:0]wAdr;

reg  [255:0][127:0][7:0] memory;

assign tmp_wAdrbyteselect[6:1] = wAdr[6:1];
assign tmp_wAdrbyteselect[0] = Adr_0; 


assign tmp_RD_access_highbyte[14:1] = RD_A[14:1];
assign tmp_RD_access_highbyte[0] = 1;
assign tmp_RD_access_lowbyte[14:1] = RD_A[14:1];
assign tmp_RD_access_lowbyte[0] = 0;

 //32767 bytes of memory 


always_comb//latching BkSel
    begin
        if ((PC_RD || DB_RD || DB_WR || Prog || Erase || Data_RD) == 1)
            BkSel_L[1:0] = BkSel [1:0];
    end

assign EN_RD_A_highbyte = (DB_RD && (Adr_0)) || PC_RD;
assign EN_RD_A_lowbyte =  (DB_RD && (~Adr_0)) || PC_RD;

always_comb //low byte RD_A latch
    begin
        if (EN_RD_A_lowbyte == 1)
            begin
                if (PC_RD == 1)//latching PC for reading
                    begin
                        RD_A [7:1] <= PC [6:0]; //last bit is don't care
                        RD_A [0] <= 1'b0;
                    end
                else if (((DB_RD == 1) && (Adr_0 == 0)) == 1) //latching data address low byte for reading
                    RD_A [7:0] <= DBI [7:0];
            end
        else
            RD_A[7:0] <= RD_A[7:0];

    end

always_comb //high byte RD_A latch
    begin
        if (EN_RD_A_highbyte == 1)
            begin
                if (PC_RD == 1)//latching PC for reading
                    RD_A [14:8] <= PC [13:7]; 
                else if (((DB_RD == 1) && (Adr_0 == 1)) == 1) //latching data address high byte for reading
                    RD_A [14:8] <= DBI [6:0];
            end
        else
            RD_A[14:8] <= RD_A[14:8];
    end


assign EN_wAdr_lowbyte = DB_WR && ((~Adr_0) && EnAdrLat);
assign EN_wAdr_highbyte = DB_WR && (Adr_0 && EnAdrLat);

always_comb //low byte wAdr latch
    begin
        if (EN_wAdr_lowbyte == 1)
                wAdr[7:0] <= DBI[7:0];
        else
            wAdr[7:0] <= wAdr[7:0];
    end

always_comb //high byte wAdr latch
    begin
        if (EN_wAdr_highbyte == 1)
                wAdr[14:8] <= DBI[6:0];
        else
            wAdr[14:8] <= wAdr[14:8];
    end

assign EN_WRBUF = DB_WR && EnBuf;

always_comb //128 byte Write Buffer
    begin
        if (EN_WRBUF == 1)
            Out_WRBUF[tmp_wAdrbyteselect[6:0]][7:0] <= DBI[7:0];
        else
            Out_WRBUF <= Out_WRBUF;
    end

always_comb  //Verify Address Control Logic
    begin //assume correct signals for RD, Program, Erase
        if ((BkSel_L == 2'b00) && (RD == 1)) //reading
            begin
                i_WR_RWW = 0;
                i_WR_NRWW = 0;
                i_ER_RWW = 0;
                i_ER_NRWW = 0;
                if (RD_A[14:12] != 3'b111) //reading RWW side
                    begin
                        i_RD_RWW = 1;
                        i_RD_NRWW = 0;
                    end
                else //reading NRWW side
                    begin
                        i_RD_RWW = 0;
                        i_RD_NRWW = 1;
                    end            
            end
        
        else if (BkSel_L == 2'b01) //RWW read, NRWW write
            begin
                i_RD_NRWW = 0;
                i_ER_RWW = 0;
                i_WR_RWW = 0;
                if ((RD == 1) && (RD_A[14:12] != 3'b111)) //if reading in the RWW side
                    begin
                        i_RD_RWW = 1;
                    end
                else //reading address incorrect, not outputting i_RD signal
                    begin
                        i_RD_RWW = 0;
                    end

                if ((Prog == 1) && (wAdr[14:12] == 3'b111)) //&& (RD_A[14:12] != 3'b111)) //if programing in the NRWW side
                    begin
                        i_WR_NRWW = 1;
                        i_ER_NRWW = 0;
                    end
                else if ((Erase == 1) && (wAdr[14:12] == 3'b111)) //if erasing in the NRWW side
                    begin
                        i_WR_NRWW = 0;
                        i_ER_NRWW = 1;
                    end                
                else //programming or erasing in the wrong side (wrong address), not outputting programm and erase signals
                    begin
                        i_WR_NRWW = 0;
                        i_ER_NRWW = 0;
                    end 
            end

        else if (BkSel_L == 2'b10) //RWW write, NRWW read
            begin
                i_RD_RWW = 0;
                i_ER_NRWW = 0;
                i_WR_NRWW = 0;
                if ((RD == 1) && (RD_A[14:12] == 3'b111)) //if reading in the NRWW side
                    begin
                        i_RD_NRWW = 1;
                    end
                else //reading address incorrect, not outputting i_RD signal
                    begin
                        i_RD_NRWW = 0;
                    end

                if ((Prog == 1) && (wAdr[14:12] != 3'b111)) //if programing in the RWW side
                    begin
                        i_WR_RWW = 1;
                        i_ER_RWW = 0;
                    end
                else if ((Erase == 1) && (wAdr[14:12] != 3'b111)) //if erasing in the RWW side
                    begin
                        i_WR_RWW = 0;
                        i_ER_RWW = 1;
                    end                
                else //programming or erasing in the wrong side (wrong address), not outputting programm and erase signals
                    begin
                        i_WR_RWW = 0;
                        i_ER_RWW = 0;
                    end 
            end
        
        else if ((BkSel_L == 2'b11) && (Prog == 1)) //programming
            begin
                i_RD_RWW = 0;
                i_RD_NRWW = 0;
                i_ER_RWW = 0;
                i_ER_NRWW = 0;
                if (wAdr[14:12] != 3'b111) //programming RWW side
                    begin
                        i_WR_RWW = 1;
                        i_WR_NRWW = 0;
                    end
                else //programming NRWW side
                    begin
                        i_WR_RWW = 0;
                        i_WR_NRWW = 1;
                    end            
            end

        else if ((BkSel_L == 2'b11) && (Erase == 1)) //erasing
            begin
                i_RD_RWW = 0;
                i_RD_NRWW = 0;
                i_WR_RWW = 0;
                i_WR_NRWW = 0;
                if (wAdr[14:12] != 3'b111) //erasing RWW side
                    begin
                        i_ER_RWW = 1;
                        i_ER_NRWW = 0;
                    end
                else //erasing NRWW side
                    begin
                        i_ER_RWW = 0;
                        i_ER_NRWW = 1;
                    end            
            end
        else //idle
            begin
                i_RD_RWW = 0;
                i_WR_RWW = 0;
                i_ER_RWW = 0;
                i_RD_NRWW = 0;
                i_WR_NRWW = 0;
                i_ER_NRWW = 0;            
            end
    end

//memory RWW side
always @ (*)
    begin

        if (i_ER_RWW == 1)
                #3.19ms memory[wAdr[14:7]][127:0] <= 1024'b0;
        
        else if (i_WR_RWW == 1)
                #3.19ms memory[wAdr[14:7]][127:0] <= Out_WRBUF[127:0];
        
        else //idle
                ;
    end

//memory NRWW side
always @ (*)
    begin
        if (i_ER_NRWW == 1)
                 #3.19ms memory[wAdr[14:7]][127:0] <= 1024'b0;
        
        else if (i_WR_NRWW == 1)
                #3.19ms  memory[wAdr[14:7]][127:0] <= Out_WRBUF[127:0];
        
        else //idle
                ;
    end
    
always @ (*)
    begin
        if (EN_ChipErase == 1)
            #3.19ms memory[255:0] <= 262144'b0;
        else
            ;       
    end

//output latch
assign EN_Dout_Latch = ((i_RD_RWW == 1) || (i_RD_NRWW == 1));

always@ (*)
    begin
        #24.9ns
        if (EN_Dout_Latch == 1) //storing read outputs
            begin
                    Dout[15:8] <= memory[tmp_RD_access_highbyte[14:7]][tmp_RD_access_highbyte[6:0]];
                if (((Data_RD == 1) && (RD_A[0] == 1)) || (RD_highbyte == 1))
                    Dout[7:0] <= memory[tmp_RD_access_highbyte[14:7]][tmp_RD_access_highbyte[6:0]];
                else
                    Dout[7:0] <= memory[tmp_RD_access_lowbyte[14:7]][tmp_RD_access_lowbyte[6:0]];           
            end

        else//idle
            Dout <= Dout;
    end

// ADD memory initialization
initial begin
    foreach (memory[i]) begin
        for(int j ; j < 128 ; j++) begin
            memory[i][j] = 8'hff;
        end
    end  
    file = $fopen("../../02_design/02_rtl/src/memory/instruction/Document.bin" , "rb");
    
    if (file == 0) begin
        $display("Could not open file");
    end

    // $display("../../02_design/02_rtl/src/core/binaries/Document.bin");
    for(int i = 0 ; i < 256 ; i++) begin
        for (int j = 0 ; j < 128 ; j++) begin
        code = $fread(memory[i][j],file);
        // code = $fread(memory[i][j+1],file);        
        // $display(i);
        // $display(j);
        // $displayh(memory[i][j]);
        end
    end          
    $fclose(file);
end

//assign #24.9ns Dout[15:0] = Dout_beforedelay[15:0]; 
endmodule