command:
    [7:5]   :   operation
    [4]     :   Dst Reg
    [3]     :   Src Reg
    [2:0]   :   Imm data

Src Reg ==> Dst Reg

exception:
    `CMD_LDSP   :   Load Pc or Lr
        cmd[4]  
            1   :   load Pc
            0   :   load Lr
        cmd[4] == cmd[3]
            1   :   from extern valiue
            0   :   from reg