 
****************************************
Report : resources
Design : pipeline
Version: S-2021.06-SP1
Date   : Sun Apr 17 19:16:47 2022
****************************************

Resource Sharing Report for design pipeline in file ../Pipeline/pipeline.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1192    | DW01_cmp2    | width=2    |               | lt_529 lt_536        |
| r1193    | DW01_cmp2    | width=2    |               | lt_529_I2 lt_536_I2  |
| r1194    | DW01_cmp2    | width=2    |               | lt_529_I3 lt_536_I3  |
| r1196    | DW01_add     | width=32   |               | if_stage_0/add_61    |
|          |              |            |               | if_stage_0/add_66    |
| r1197    | DW01_add     | width=32   |               | if_stage_0/add_62    |
|          |              |            |               | if_stage_0/add_67    |
| r1248    | DW01_cmp6    | width=32   |               | ex_stage_0/brcond/eq_101 |
       |              |            |               | ex_stage_0/brcond/gte_104 |
      |              |            |               | ex_stage_0/brcond/lt_103 |
       |              |            |               | ex_stage_0/brcond/ne_102 |
| r1249    | DW01_cmp2    | width=32   |               | ex_stage_0/brcond/gte_106 |
      |              |            |               | ex_stage_0/brcond/lt_105 |
| r1250    | DW01_cmp6    | width=32   |               | ex_stage_0/brcond/eq_101_I2 |
    |              |            |               | ex_stage_0/brcond/gte_104_I2 |
   |              |            |               | ex_stage_0/brcond/lt_103_I2 |
    |              |            |               | ex_stage_0/brcond/ne_102_I2 |
| r1251    | DW01_cmp2    | width=32   |               | ex_stage_0/brcond/gte_106_I2 |
   |              |            |               | ex_stage_0/brcond/lt_105_I2 |
| r1252    | DW01_cmp6    | width=32   |               | ex_stage_0/brcond/eq_101_I3 |
    |              |            |               | ex_stage_0/brcond/gte_104_I3 |
   |              |            |               | ex_stage_0/brcond/lt_103_I3 |
    |              |            |               | ex_stage_0/brcond/ne_102_I3 |
| r1253    | DW01_cmp2    | width=32   |               | ex_stage_0/brcond/gte_106_I3 |
   |              |            |               | ex_stage_0/brcond/lt_105_I3 |
| r1325    | DW01_add     | width=3    |               | add_1_root_add_87_2  |
| r1327    | DW01_cmp2    | width=2    |               | lt_246               |
| r1329    | DW01_cmp2    | width=2    |               | lt_246_I2            |
| r1331    | DW01_cmp2    | width=2    |               | lt_246_I3            |
| r1333    | DW01_cmp2    | width=2    |               | lt_261               |
| r1335    | DW01_cmp2    | width=2    |               | lt_261_I2            |
| r1337    | DW01_cmp2    | width=2    |               | lt_261_I3            |
| r1339    | DW01_cmp6    | width=5    |               | eq_517               |
| r1341    | DW01_cmp6    | width=5    |               | eq_519               |
| r1343    | DW01_cmp6    | width=5    |               | eq_521               |
| r1345    | DW01_inc     | width=30   |               | if_stage_0/add_34    |
| r1347    | DW01_add     | width=32   |               | if_stage_0/add_63    |
| r1349    | DW01_add     | width=32   |               | if_stage_0/add_91    |
| r1351    | DW01_cmp6    | width=5    |               | id_stage_0/ne_328    |
| r1353    | DW01_cmp6    | width=6    |               | id_stage_0/ne_328_2  |
| r1355    | DW01_cmp6    | width=6    |               | id_stage_0/ne_328_3  |
| r1357    | DW01_cmp6    | width=6    |               | id_stage_0/ne_328_4  |
| r1359    | DW01_cmp6    | width=6    |               | id_stage_0/ne_328_5  |
| r1361    | DW01_cmp6    | width=5    |               | id_stage_0/ne_337    |
| r1363    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_2  |
| r1365    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_3  |
| r1367    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_4  |
| r1369    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_5  |
| r1371    | DW01_cmp6    | width=5    |               | id_stage_0/ne_337_6  |
| r1373    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_7  |
| r1375    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_8  |
| r1377    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_9  |
| r1379    | DW01_cmp6    | width=6    |               | id_stage_0/ne_337_10 |
| r1381    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_39 |
| r1383    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_39_I2 |
| r1385    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_39_I3 |
| r1387    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_53 |
| r1389    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_53_I2 |
| r1391    | DW01_cmp6    | width=5    |               | id_stage_0/regf_0/eq_53_I3 |
| r1399    | DW01_add     | width=32   |               | ex_stage_0/alu_0/add_54 |
| r1401    | DW01_sub     | width=32   |               | ex_stage_0/alu_0/sub_55 |
| r1403    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_57 |
| r1405    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_58 |
| r1407    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/srl_61 |
        |              | SH_width=5 |               |                      |
| r1409    | DW01_ash     | A_width=32 |               | ex_stage_0/alu_0/sll_62 |
        |              | SH_width=5 |               |                      |
| r1411    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/sra_63 |
        |              | SH_width=5 |               |                      |
| r1413    | DW01_add     | width=32   |               | ex_stage_0/alu_0/add_54_I2 |
| r1415    | DW01_sub     | width=32   |               | ex_stage_0/alu_0/sub_55_I2 |
| r1417    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_57_I2 |
| r1419    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_58_I2 |
| r1421    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/srl_61_I2 |
     |              | SH_width=5 |               |                      |
| r1423    | DW01_ash     | A_width=32 |               | ex_stage_0/alu_0/sll_62_I2 |
     |              | SH_width=5 |               |                      |
| r1425    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/sra_63_I2 |
     |              | SH_width=5 |               |                      |
| r1427    | DW01_add     | width=32   |               | ex_stage_0/alu_0/add_54_I3 |
| r1429    | DW01_sub     | width=32   |               | ex_stage_0/alu_0/sub_55_I3 |
| r1431    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_57_I3 |
| r1433    | DW01_cmp2    | width=32   |               | ex_stage_0/alu_0/lt_58_I3 |
| r1435    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/srl_61_I3 |
     |              | SH_width=5 |               |                      |
| r1437    | DW01_ash     | A_width=32 |               | ex_stage_0/alu_0/sll_62_I3 |
     |              | SH_width=5 |               |                      |
| r1439    | DW_rash      | A_width=32 |               | ex_stage_0/alu_0/sra_63_I3 |
     |              | SH_width=5 |               |                      |
| r1441    | DW01_cmp2    | width=7    |               | ic_stage_0/gt_61     |
| r1443    | DW01_cmp2    | width=7    |               | ic_stage_0/gt_66     |
| r1445    | DW01_cmp2    | width=7    |               | ic_stage_0/gt_66_I2  |
| r1447    | DW01_inc     | width=2    |               | ic_stage_0/add_67_I2 |
| r1449    | DW01_cmp2    | width=7    |               | ic_stage_0/gt_66_I3  |
| r1451    | DW01_inc     | width=2    |               | ic_stage_0/add_67_I3 |
| r1558    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_46_I3 |
    |              | B_width=32 |               | ex_stage_0/alu_0/mult_47_I3 |
| r1560    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_45_I3 |
    |              | B_width=32 |               |                      |
| r1667    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_46_I2 |
    |              | B_width=32 |               | ex_stage_0/alu_0/mult_47_I2 |
| r1669    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_45_I2 |
    |              | B_width=32 |               |                      |
| r1776    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_46 |
       |              | B_width=32 |               | ex_stage_0/alu_0/mult_47 |
| r1778    | DW02_mult    | A_width=32 |               | ex_stage_0/alu_0/mult_45 |
       |              | B_width=32 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| ex_stage_0/alu_0/mult_45              |                    |                |
|                    | DW02_mult        | csa                |                |
| r1222              | DW02_mult        | csa                |                |
| ex_stage_0/alu_0/mult_45_I2           |                    |                |
|                    | DW02_mult        | csa                |                |
| r1224              | DW02_mult        | csa                |                |
| ex_stage_0/alu_0/mult_45_I3           |                    |                |
|                    | DW02_mult        | csa                |                |
| r1226              | DW02_mult        | csa                |                |
| if_stage_0/add_91  | DW01_add         | rpl                |                |
| r1196              | DW01_add         | rpl                |                |
| r1197              | DW01_add         | rpl                |                |
| r1248              | DW01_cmp6        | rpl                |                |
| r1250              | DW01_cmp6        | rpl                |                |
| r1252              | DW01_cmp6        | rpl                |                |
| if_stage_0/add_34  | DW01_inc         | rpl                |                |
| if_stage_0/add_63  | DW01_add         | rpl                |                |
| ex_stage_0/alu_0/add_54               |                    |                |
|                    | DW01_add         | rpl                |                |
| ex_stage_0/alu_0/sub_55               |                    |                |
|                    | DW01_sub         | rpl                |                |
| ex_stage_0/alu_0/sll_62               |                    |                |
|                    | DW01_ash         | mx2                |                |
| ex_stage_0/alu_0/add_54_I2            |                    |                |
|                    | DW01_add         | rpl                |                |
| ex_stage_0/alu_0/sub_55_I2            |                    |                |
|                    | DW01_sub         | rpl                |                |
| ex_stage_0/alu_0/sll_62_I2            |                    |                |
|                    | DW01_ash         | mx2                |                |
| ex_stage_0/alu_0/add_54_I3            |                    |                |
|                    | DW01_add         | rpl                |                |
| ex_stage_0/alu_0/sub_55_I3            |                    |                |
|                    | DW01_sub         | rpl                |                |
| ex_stage_0/alu_0/sll_62_I3            |                    |                |
|                    | DW01_ash         | mx2                |                |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_4
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_5
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_2
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_3
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_1
****************************************

Resource Sharing Report for design DW02_mult_A_width32_B_width32

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=62   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : mult
****************************************

No implementations to report
 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : mult
****************************************

No implementations to report
 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : mult
****************************************

No implementations to report
 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage
****************************************

Resource Sharing Report for design mult_stage in file
        /afs/umich.edu/user/x/y/xyuanzhi/470/test/syn/eecs-470-final-project/Mult/mult_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r56      | DW01_add     | width=64   |               | add_20               |
| r160     | DW02_mult    | A_width=8  |               | mult_22              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_20             | DW01_add         | cla                |                |
| mult_22            | DW02_mult        | csa                |                |
===============================================================================

 
****************************************
Design : mult_stage_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : psel_gen_REQS3_WIDTH6
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : wand_sel_WIDTH6
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : wand_sel_WIDTH6
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : wand_sel_WIDTH6
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH3_INWIDTH8
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH3_INWIDTH8
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH3_INWIDTH8
****************************************

No implementations to report
 
****************************************
Design : Dcache
****************************************

Resource Sharing Report for design Dcache in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/final/eecs-470-final-project/Cache/dcache.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r148     | DW01_cmp6    | width=4    |               | eq_68                |
| r150     | DW01_cmp6    | width=8    |               | eq_69                |
| r152     | DW01_cmp6    | width=4    |               | ne_81                |
| r154     | DW01_cmp6    | width=8    |               | ne_81_2              |
| r156     | DW01_cmp6    | width=2    |               | ne_81_3              |
| r158     | DW01_cmp6    | width=32   |               | ne_81_4              |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| ne_81_4            | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : LSQ
****************************************

Resource Sharing Report for design LSQ in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/final/eecs-470-final-project/LSQ/LSQ.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1120    | DW01_cmp2    | width=7    |               | gt_101 gt_101_I2     |
|          |              |            |               | gt_101_I3            |
| r1122    | DW01_cmp2    | width=7    |               | gt_101_I2_I1         |
|          |              |            |               | gt_101_I2_I2         |
|          |              |            |               | gt_101_I2_I3         |
| r1124    | DW01_cmp2    | width=7    |               | gt_101_I3_I1         |
|          |              |            |               | gt_101_I3_I2         |
|          |              |            |               | gt_101_I3_I3         |
| r1126    | DW01_cmp2    | width=7    |               | gt_101_I4_I1         |
|          |              |            |               | gt_101_I4_I2         |
|          |              |            |               | gt_101_I4_I3         |
| r1128    | DW01_cmp2    | width=7    |               | gt_101_I5_I1         |
|          |              |            |               | gt_101_I5_I2         |
|          |              |            |               | gt_101_I5_I3         |
| r1130    | DW01_cmp2    | width=7    |               | gt_101_I6_I1         |
|          |              |            |               | gt_101_I6_I2         |
|          |              |            |               | gt_101_I6_I3         |
| r1132    | DW01_cmp2    | width=7    |               | gt_101_I7_I1         |
|          |              |            |               | gt_101_I7_I2         |
|          |              |            |               | gt_101_I7_I3         |
| r1134    | DW01_cmp2    | width=7    |               | gt_101_I8_I1         |
|          |              |            |               | gt_101_I8_I2         |
|          |              |            |               | gt_101_I8_I3         |
| r1136    | DW01_cmp2    | width=7    |               | gt_101_I9_I1         |
|          |              |            |               | gt_101_I9_I2         |
|          |              |            |               | gt_101_I9_I3         |
| r1138    | DW01_cmp2    | width=7    |               | gt_101_I10_I1        |
|          |              |            |               | gt_101_I10_I2        |
|          |              |            |               | gt_101_I10_I3        |
| r1140    | DW01_cmp2    | width=7    |               | gt_101_I11_I1        |
|          |              |            |               | gt_101_I11_I2        |
|          |              |            |               | gt_101_I11_I3        |
| r1142    | DW01_cmp2    | width=7    |               | gt_101_I12_I1        |
|          |              |            |               | gt_101_I12_I2        |
|          |              |            |               | gt_101_I12_I3        |
| r1144    | DW01_cmp2    | width=7    |               | gt_101_I13_I1        |
|          |              |            |               | gt_101_I13_I2        |
|          |              |            |               | gt_101_I13_I3        |
| r1146    | DW01_cmp2    | width=7    |               | gt_101_I14_I1        |
|          |              |            |               | gt_101_I14_I2        |
|          |              |            |               | gt_101_I14_I3        |
| r1148    | DW01_cmp2    | width=7    |               | gt_101_I15_I1        |
|          |              |            |               | gt_101_I15_I2        |
|          |              |            |               | gt_101_I15_I3        |
| r1150    | DW01_cmp2    | width=7    |               | gt_101_I16_I1        |
|          |              |            |               | gt_101_I16_I2        |
|          |              |            |               | gt_101_I16_I3        |
| r1185    | DW01_inc     | width=4    |               | add_229_I2           |
|          |              |            |               | add_230_I2           |
| r1186    | DW01_add     | width=4    |               | add_229_I3           |
|          |              |            |               | add_230_I3           |
| r1247    | DW01_cmp2    | width=7    |               | gt_74                |
| r1249    | DW01_cmp2    | width=7    |               | gt_74_I2             |
| r1251    | DW01_inc     | width=2    |               | add_85_I2            |
| r1253    | DW01_cmp2    | width=7    |               | gt_74_I3             |
| r1255    | DW01_inc     | width=2    |               | add_85_I3            |
| r1257    | DW01_add     | width=4    |               | add_94               |
| r1259    | DW01_cmp6    | width=7    |               | eq_101               |
| r1261    | DW01_cmp6    | width=7    |               | eq_101_I2_I1         |
| r1263    | DW01_cmp6    | width=7    |               | eq_101_I3_I1         |
| r1265    | DW01_cmp6    | width=7    |               | eq_101_I4_I1         |
| r1267    | DW01_cmp6    | width=7    |               | eq_101_I5_I1         |
| r1269    | DW01_cmp6    | width=7    |               | eq_101_I6_I1         |
| r1271    | DW01_cmp6    | width=7    |               | eq_101_I7_I1         |
| r1273    | DW01_cmp6    | width=7    |               | eq_101_I8_I1         |
| r1275    | DW01_cmp6    | width=7    |               | eq_101_I9_I1         |
| r1277    | DW01_cmp6    | width=7    |               | eq_101_I10_I1        |
| r1279    | DW01_cmp6    | width=7    |               | eq_101_I11_I1        |
| r1281    | DW01_cmp6    | width=7    |               | eq_101_I12_I1        |
| r1283    | DW01_cmp6    | width=7    |               | eq_101_I13_I1        |
| r1285    | DW01_cmp6    | width=7    |               | eq_101_I14_I1        |
| r1287    | DW01_cmp6    | width=7    |               | eq_101_I15_I1        |
| r1289    | DW01_cmp6    | width=7    |               | eq_101_I16_I1        |
| r1291    | DW01_cmp6    | width=7    |               | eq_101_I2            |
| r1293    | DW01_cmp6    | width=7    |               | eq_101_I2_I2         |
| r1295    | DW01_cmp6    | width=7    |               | eq_101_I3_I2         |
| r1297    | DW01_cmp6    | width=7    |               | eq_101_I4_I2         |
| r1299    | DW01_cmp6    | width=7    |               | eq_101_I5_I2         |
| r1301    | DW01_cmp6    | width=7    |               | eq_101_I6_I2         |
| r1303    | DW01_cmp6    | width=7    |               | eq_101_I7_I2         |
| r1305    | DW01_cmp6    | width=7    |               | eq_101_I8_I2         |
| r1307    | DW01_cmp6    | width=7    |               | eq_101_I9_I2         |
| r1309    | DW01_cmp6    | width=7    |               | eq_101_I10_I2        |
| r1311    | DW01_cmp6    | width=7    |               | eq_101_I11_I2        |
| r1313    | DW01_cmp6    | width=7    |               | eq_101_I12_I2        |
| r1315    | DW01_cmp6    | width=7    |               | eq_101_I13_I2        |
| r1317    | DW01_cmp6    | width=7    |               | eq_101_I14_I2        |
| r1319    | DW01_cmp6    | width=7    |               | eq_101_I15_I2        |
| r1321    | DW01_cmp6    | width=7    |               | eq_101_I16_I2        |
| r1323    | DW01_cmp6    | width=7    |               | eq_101_I3            |
| r1325    | DW01_cmp6    | width=7    |               | eq_101_I2_I3         |
| r1327    | DW01_cmp6    | width=7    |               | eq_101_I3_I3         |
| r1329    | DW01_cmp6    | width=7    |               | eq_101_I4_I3         |
| r1331    | DW01_cmp6    | width=7    |               | eq_101_I5_I3         |
| r1333    | DW01_cmp6    | width=7    |               | eq_101_I6_I3         |
| r1335    | DW01_cmp6    | width=7    |               | eq_101_I7_I3         |
| r1337    | DW01_cmp6    | width=7    |               | eq_101_I8_I3         |
| r1339    | DW01_cmp6    | width=7    |               | eq_101_I9_I3         |
| r1341    | DW01_cmp6    | width=7    |               | eq_101_I10_I3        |
| r1343    | DW01_cmp6    | width=7    |               | eq_101_I11_I3        |
| r1345    | DW01_cmp6    | width=7    |               | eq_101_I12_I3        |
| r1347    | DW01_cmp6    | width=7    |               | eq_101_I13_I3        |
| r1349    | DW01_cmp6    | width=7    |               | eq_101_I14_I3        |
| r1351    | DW01_cmp6    | width=7    |               | eq_101_I15_I3        |
| r1353    | DW01_cmp6    | width=7    |               | eq_101_I16_I3        |
| r1355    | DW01_add     | width=4    |               | add_173              |
| r1357    | DW01_cmp6    | width=7    |               | eq_268_2             |
| r1359    | DW01_cmp2    | width=6    |               | gt_268               |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report
 
****************************************
Design : RS
****************************************

Resource Sharing Report for design RS in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/final/eecs-470-final-project/RS/RS.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r3444    | DW01_cmp2    | width=7    |               | gt_175 gt_313        |
| r3445    | DW01_cmp2    | width=7    |               | gt_177 gt_177_I2     |
|          |              |            |               | gt_177_I3 gt_188     |
|          |              |            |               | gt_188_I2 gt_188_I3  |
| r3447    | DW01_cmp2    | width=7    |               | gt_177_I2_I1         |
|          |              |            |               | gt_177_I2_I2         |
|          |              |            |               | gt_177_I2_I3         |
|          |              |            |               | gt_188_I2_I1         |
|          |              |            |               | gt_188_I2_I2         |
|          |              |            |               | gt_188_I2_I3         |
| r3449    | DW01_cmp2    | width=7    |               | gt_177_I3_I1         |
|          |              |            |               | gt_177_I3_I2         |
|          |              |            |               | gt_177_I3_I3         |
|          |              |            |               | gt_188_I3_I1         |
|          |              |            |               | gt_188_I3_I2         |
|          |              |            |               | gt_188_I3_I3         |
| r3451    | DW01_cmp2    | width=7    |               | gt_186 gt_337        |
| r3455    | DW01_cmp2    | width=7    |               | gt_175_I2 gt_313_I2  |
| r3459    | DW01_cmp2    | width=7    |               | gt_186_I2 gt_337_I2  |
| r3463    | DW01_cmp2    | width=7    |               | gt_175_I3 gt_313_I3  |
| r3467    | DW01_cmp2    | width=7    |               | gt_186_I3 gt_337_I3  |
| r3472    | DW01_cmp2    | width=7    |               | gt_387 gt_387_I2     |
|          |              |            |               | gt_387_I3            |
| r3474    | DW01_cmp2    | width=7    |               | gt_387_I2_I1         |
|          |              |            |               | gt_387_I2_I2         |
|          |              |            |               | gt_387_I2_I3         |
| r3476    | DW01_cmp2    | width=7    |               | gt_387_I3_I1         |
|          |              |            |               | gt_387_I3_I2         |
|          |              |            |               | gt_387_I3_I3         |
| r3478    | DW01_cmp2    | width=7    |               | gt_387_I4_I1         |
|          |              |            |               | gt_387_I4_I2         |
|          |              |            |               | gt_387_I4_I3         |
| r3480    | DW01_cmp2    | width=7    |               | gt_387_I5_I1         |
|          |              |            |               | gt_387_I5_I2         |
|          |              |            |               | gt_387_I5_I3         |
| r3482    | DW01_cmp2    | width=7    |               | gt_387_I6_I1         |
|          |              |            |               | gt_387_I6_I2         |
|          |              |            |               | gt_387_I6_I3         |
| r3484    | DW01_cmp2    | width=7    |               | gt_387_I7_I1         |
|          |              |            |               | gt_387_I7_I2         |
|          |              |            |               | gt_387_I7_I3         |
| r3486    | DW01_cmp2    | width=7    |               | gt_387_I8_I1         |
|          |              |            |               | gt_387_I8_I2         |
|          |              |            |               | gt_387_I8_I3         |
| r3488    | DW01_cmp2    | width=7    |               | gt_387_I9_I1         |
|          |              |            |               | gt_387_I9_I2         |
|          |              |            |               | gt_387_I9_I3         |
| r3490    | DW01_cmp2    | width=7    |               | gt_387_I10_I1        |
|          |              |            |               | gt_387_I10_I2        |
|          |              |            |               | gt_387_I10_I3        |
| r3492    | DW01_cmp2    | width=7    |               | gt_387_I11_I1        |
|          |              |            |               | gt_387_I11_I2        |
|          |              |            |               | gt_387_I11_I3        |
| r3494    | DW01_cmp2    | width=7    |               | gt_387_I12_I1        |
|          |              |            |               | gt_387_I12_I2        |
|          |              |            |               | gt_387_I12_I3        |
| r3496    | DW01_cmp2    | width=7    |               | gt_387_I13_I1        |
|          |              |            |               | gt_387_I13_I2        |
|          |              |            |               | gt_387_I13_I3        |
| r3498    | DW01_cmp2    | width=7    |               | gt_387_I14_I1        |
|          |              |            |               | gt_387_I14_I2        |
|          |              |            |               | gt_387_I14_I3        |
| r3500    | DW01_cmp2    | width=7    |               | gt_387_I15_I1        |
|          |              |            |               | gt_387_I15_I2        |
|          |              |            |               | gt_387_I15_I3        |
| r3502    | DW01_cmp2    | width=7    |               | gt_387_I16_I1        |
|          |              |            |               | gt_387_I16_I2        |
|          |              |            |               | gt_387_I16_I3        |
| r3504    | DW01_cmp2    | width=7    |               | gt_393 gt_393_I2     |
|          |              |            |               | gt_393_I3            |
| r3506    | DW01_cmp2    | width=7    |               | gt_393_I2_I1         |
|          |              |            |               | gt_393_I2_I2         |
|          |              |            |               | gt_393_I2_I3         |
| r3508    | DW01_cmp2    | width=7    |               | gt_393_I3_I1         |
|          |              |            |               | gt_393_I3_I2         |
|          |              |            |               | gt_393_I3_I3         |
| r3510    | DW01_cmp2    | width=7    |               | gt_393_I4_I1         |
|          |              |            |               | gt_393_I4_I2         |
|          |              |            |               | gt_393_I4_I3         |
| r3512    | DW01_cmp2    | width=7    |               | gt_393_I5_I1         |
|          |              |            |               | gt_393_I5_I2         |
|          |              |            |               | gt_393_I5_I3         |
| r3514    | DW01_cmp2    | width=7    |               | gt_393_I6_I1         |
|          |              |            |               | gt_393_I6_I2         |
|          |              |            |               | gt_393_I6_I3         |
| r3516    | DW01_cmp2    | width=7    |               | gt_393_I7_I1         |
|          |              |            |               | gt_393_I7_I2         |
|          |              |            |               | gt_393_I7_I3         |
| r3518    | DW01_cmp2    | width=7    |               | gt_393_I8_I1         |
|          |              |            |               | gt_393_I8_I2         |
|          |              |            |               | gt_393_I8_I3         |
| r3520    | DW01_cmp2    | width=7    |               | gt_393_I9_I1         |
|          |              |            |               | gt_393_I9_I2         |
|          |              |            |               | gt_393_I9_I3         |
| r3522    | DW01_cmp2    | width=7    |               | gt_393_I10_I1        |
|          |              |            |               | gt_393_I10_I2        |
|          |              |            |               | gt_393_I10_I3        |
| r3524    | DW01_cmp2    | width=7    |               | gt_393_I11_I1        |
|          |              |            |               | gt_393_I11_I2        |
|          |              |            |               | gt_393_I11_I3        |
| r3526    | DW01_cmp2    | width=7    |               | gt_393_I12_I1        |
|          |              |            |               | gt_393_I12_I2        |
|          |              |            |               | gt_393_I12_I3        |
| r3528    | DW01_cmp2    | width=7    |               | gt_393_I13_I1        |
|          |              |            |               | gt_393_I13_I2        |
|          |              |            |               | gt_393_I13_I3        |
| r3530    | DW01_cmp2    | width=7    |               | gt_393_I14_I1        |
|          |              |            |               | gt_393_I14_I2        |
|          |              |            |               | gt_393_I14_I3        |
| r3532    | DW01_cmp2    | width=7    |               | gt_393_I15_I1        |
|          |              |            |               | gt_393_I15_I2        |
|          |              |            |               | gt_393_I15_I3        |
| r3534    | DW01_cmp2    | width=7    |               | gt_393_I16_I1        |
|          |              |            |               | gt_393_I16_I2        |
|          |              |            |               | gt_393_I16_I3        |
| r3716    | DW01_cmp2    | width=5    |               | lt_96                |
| r3718    | DW01_cmp2    | width=5    |               | lt_103               |
| r3720    | DW01_cmp6    | width=7    |               | eq_177               |
| r3722    | DW01_cmp6    | width=7    |               | eq_177_I2_I1         |
| r3724    | DW01_cmp6    | width=7    |               | eq_177_I3_I1         |
| r3726    | DW01_cmp6    | width=7    |               | eq_188               |
| r3728    | DW01_cmp6    | width=7    |               | eq_188_I2_I1         |
| r3730    | DW01_cmp6    | width=7    |               | eq_188_I3_I1         |
| r3732    | DW01_cmp6    | width=7    |               | eq_177_I2            |
| r3734    | DW01_cmp6    | width=7    |               | eq_177_I2_I2         |
| r3736    | DW01_cmp6    | width=7    |               | eq_177_I3_I2         |
| r3738    | DW01_cmp6    | width=7    |               | eq_188_I2            |
| r3740    | DW01_cmp6    | width=7    |               | eq_188_I2_I2         |
| r3742    | DW01_cmp6    | width=7    |               | eq_188_I3_I2         |
| r3744    | DW01_cmp6    | width=7    |               | eq_177_I3            |
| r3746    | DW01_cmp6    | width=7    |               | eq_177_I2_I3         |
| r3748    | DW01_cmp6    | width=7    |               | eq_177_I3_I3         |
| r3750    | DW01_cmp6    | width=7    |               | eq_188_I3            |
| r3752    | DW01_cmp6    | width=7    |               | eq_188_I2_I3         |
| r3754    | DW01_cmp6    | width=7    |               | eq_188_I3_I3         |
| r3756    | DW01_cmp6    | width=7    |               | eq_387               |
| r3758    | DW01_cmp6    | width=7    |               | eq_387_I2_I1         |
| r3760    | DW01_cmp6    | width=7    |               | eq_387_I3_I1         |
| r3762    | DW01_cmp6    | width=7    |               | eq_387_I4_I1         |
| r3764    | DW01_cmp6    | width=7    |               | eq_387_I5_I1         |
| r3766    | DW01_cmp6    | width=7    |               | eq_387_I6_I1         |
| r3768    | DW01_cmp6    | width=7    |               | eq_387_I7_I1         |
| r3770    | DW01_cmp6    | width=7    |               | eq_387_I8_I1         |
| r3772    | DW01_cmp6    | width=7    |               | eq_387_I9_I1         |
| r3774    | DW01_cmp6    | width=7    |               | eq_387_I10_I1        |
| r3776    | DW01_cmp6    | width=7    |               | eq_387_I11_I1        |
| r3778    | DW01_cmp6    | width=7    |               | eq_387_I12_I1        |
| r3780    | DW01_cmp6    | width=7    |               | eq_387_I13_I1        |
| r3782    | DW01_cmp6    | width=7    |               | eq_387_I14_I1        |
| r3784    | DW01_cmp6    | width=7    |               | eq_387_I15_I1        |
| r3786    | DW01_cmp6    | width=7    |               | eq_387_I16_I1        |
| r3788    | DW01_cmp6    | width=7    |               | eq_393               |
| r3790    | DW01_cmp6    | width=7    |               | eq_393_I2_I1         |
| r3792    | DW01_cmp6    | width=7    |               | eq_393_I3_I1         |
| r3794    | DW01_cmp6    | width=7    |               | eq_393_I4_I1         |
| r3796    | DW01_cmp6    | width=7    |               | eq_393_I5_I1         |
| r3798    | DW01_cmp6    | width=7    |               | eq_393_I6_I1         |
| r3800    | DW01_cmp6    | width=7    |               | eq_393_I7_I1         |
| r3802    | DW01_cmp6    | width=7    |               | eq_393_I8_I1         |
| r3804    | DW01_cmp6    | width=7    |               | eq_393_I9_I1         |
| r3806    | DW01_cmp6    | width=7    |               | eq_393_I10_I1        |
| r3808    | DW01_cmp6    | width=7    |               | eq_393_I11_I1        |
| r3810    | DW01_cmp6    | width=7    |               | eq_393_I12_I1        |
| r3812    | DW01_cmp6    | width=7    |               | eq_393_I13_I1        |
| r3814    | DW01_cmp6    | width=7    |               | eq_393_I14_I1        |
| r3816    | DW01_cmp6    | width=7    |               | eq_393_I15_I1        |
| r3818    | DW01_cmp6    | width=7    |               | eq_393_I16_I1        |
| r3820    | DW01_cmp6    | width=7    |               | eq_387_I2            |
| r3822    | DW01_cmp6    | width=7    |               | eq_387_I2_I2         |
| r3824    | DW01_cmp6    | width=7    |               | eq_387_I3_I2         |
| r3826    | DW01_cmp6    | width=7    |               | eq_387_I4_I2         |
| r3828    | DW01_cmp6    | width=7    |               | eq_387_I5_I2         |
| r3830    | DW01_cmp6    | width=7    |               | eq_387_I6_I2         |
| r3832    | DW01_cmp6    | width=7    |               | eq_387_I7_I2         |
| r3834    | DW01_cmp6    | width=7    |               | eq_387_I8_I2         |
| r3836    | DW01_cmp6    | width=7    |               | eq_387_I9_I2         |
| r3838    | DW01_cmp6    | width=7    |               | eq_387_I10_I2        |
| r3840    | DW01_cmp6    | width=7    |               | eq_387_I11_I2        |
| r3842    | DW01_cmp6    | width=7    |               | eq_387_I12_I2        |
| r3844    | DW01_cmp6    | width=7    |               | eq_387_I13_I2        |
| r3846    | DW01_cmp6    | width=7    |               | eq_387_I14_I2        |
| r3848    | DW01_cmp6    | width=7    |               | eq_387_I15_I2        |
| r3850    | DW01_cmp6    | width=7    |               | eq_387_I16_I2        |
| r3852    | DW01_cmp6    | width=7    |               | eq_393_I2            |
| r3854    | DW01_cmp6    | width=7    |               | eq_393_I2_I2         |
| r3856    | DW01_cmp6    | width=7    |               | eq_393_I3_I2         |
| r3858    | DW01_cmp6    | width=7    |               | eq_393_I4_I2         |
| r3860    | DW01_cmp6    | width=7    |               | eq_393_I5_I2         |
| r3862    | DW01_cmp6    | width=7    |               | eq_393_I6_I2         |
| r3864    | DW01_cmp6    | width=7    |               | eq_393_I7_I2         |
| r3866    | DW01_cmp6    | width=7    |               | eq_393_I8_I2         |
| r3868    | DW01_cmp6    | width=7    |               | eq_393_I9_I2         |
| r3870    | DW01_cmp6    | width=7    |               | eq_393_I10_I2        |
| r3872    | DW01_cmp6    | width=7    |               | eq_393_I11_I2        |
| r3874    | DW01_cmp6    | width=7    |               | eq_393_I12_I2        |
| r3876    | DW01_cmp6    | width=7    |               | eq_393_I13_I2        |
| r3878    | DW01_cmp6    | width=7    |               | eq_393_I14_I2        |
| r3880    | DW01_cmp6    | width=7    |               | eq_393_I15_I2        |
| r3882    | DW01_cmp6    | width=7    |               | eq_393_I16_I2        |
| r3884    | DW01_cmp6    | width=7    |               | eq_387_I3            |
| r3886    | DW01_cmp6    | width=7    |               | eq_387_I2_I3         |
| r3888    | DW01_cmp6    | width=7    |               | eq_387_I3_I3         |
| r3890    | DW01_cmp6    | width=7    |               | eq_387_I4_I3         |
| r3892    | DW01_cmp6    | width=7    |               | eq_387_I5_I3         |
| r3894    | DW01_cmp6    | width=7    |               | eq_387_I6_I3         |
| r3896    | DW01_cmp6    | width=7    |               | eq_387_I7_I3         |
| r3898    | DW01_cmp6    | width=7    |               | eq_387_I8_I3         |
| r3900    | DW01_cmp6    | width=7    |               | eq_387_I9_I3         |
| r3902    | DW01_cmp6    | width=7    |               | eq_387_I10_I3        |
| r3904    | DW01_cmp6    | width=7    |               | eq_387_I11_I3        |
| r3906    | DW01_cmp6    | width=7    |               | eq_387_I12_I3        |
| r3908    | DW01_cmp6    | width=7    |               | eq_387_I13_I3        |
| r3910    | DW01_cmp6    | width=7    |               | eq_387_I14_I3        |
| r3912    | DW01_cmp6    | width=7    |               | eq_387_I15_I3        |
| r3914    | DW01_cmp6    | width=7    |               | eq_387_I16_I3        |
| r3916    | DW01_cmp6    | width=7    |               | eq_393_I3            |
| r3918    | DW01_cmp6    | width=7    |               | eq_393_I2_I3         |
| r3920    | DW01_cmp6    | width=7    |               | eq_393_I3_I3         |
| r3922    | DW01_cmp6    | width=7    |               | eq_393_I4_I3         |
| r3924    | DW01_cmp6    | width=7    |               | eq_393_I5_I3         |
| r3926    | DW01_cmp6    | width=7    |               | eq_393_I6_I3         |
| r3928    | DW01_cmp6    | width=7    |               | eq_393_I7_I3         |
| r3930    | DW01_cmp6    | width=7    |               | eq_393_I8_I3         |
| r3932    | DW01_cmp6    | width=7    |               | eq_393_I9_I3         |
| r3934    | DW01_cmp6    | width=7    |               | eq_393_I10_I3        |
| r3936    | DW01_cmp6    | width=7    |               | eq_393_I11_I3        |
| r3938    | DW01_cmp6    | width=7    |               | eq_393_I12_I3        |
| r3940    | DW01_cmp6    | width=7    |               | eq_393_I13_I3        |
| r3942    | DW01_cmp6    | width=7    |               | eq_393_I14_I3        |
| r3944    | DW01_cmp6    | width=7    |               | eq_393_I15_I3        |
| r3946    | DW01_cmp6    | width=7    |               | eq_393_I16_I3        |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : pe_OUTWIDTH4_INWIDTH16
****************************************

No implementations to report
 
****************************************
Design : num_ones
****************************************

Resource Sharing Report for design num_ones in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/eecs-470-final-project/num_ones/num_ones.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r271     | DW01_add     | width=5    |               | add_4_root_add_6_root_add_12_I16 |
| r273     | DW01_add     | width=5    |               | add_2_root_add_6_root_add_12_I16 |
| r275     | DW01_add     | width=4    |               | add_12_root_add_12_I16 |
| r277     | DW01_add     | width=3    |               | add_13_root_add_12_I16 |
| r279     | DW01_add     | width=2    |               | add_14_root_add_12_I16 |
| r281     | DW01_add     | width=5    |               | add_1_root_add_6_root_add_12_I16 |
| r283     | DW01_add     | width=5    |               | add_5_root_add_6_root_add_12_I16 |
| r285     | DW01_add     | width=5    |               | add_3_root_add_6_root_add_12_I16 |
| r287     | DW01_add     | width=5    |               | add_0_root_add_6_root_add_12_I16 |
===============================================================================


No implementations to report
 
****************************************
Design : num_ones
****************************************

Resource Sharing Report for design num_ones in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/eecs-470-final-project/num_ones/num_ones.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r271     | DW01_add     | width=5    |               | add_4_root_add_6_root_add_12_I16 |
| r273     | DW01_add     | width=5    |               | add_2_root_add_6_root_add_12_I16 |
| r275     | DW01_add     | width=4    |               | add_12_root_add_12_I16 |
| r277     | DW01_add     | width=3    |               | add_13_root_add_12_I16 |
| r279     | DW01_add     | width=2    |               | add_14_root_add_12_I16 |
| r281     | DW01_add     | width=5    |               | add_1_root_add_6_root_add_12_I16 |
| r283     | DW01_add     | width=5    |               | add_5_root_add_6_root_add_12_I16 |
| r285     | DW01_add     | width=5    |               | add_3_root_add_6_root_add_12_I16 |
| r287     | DW01_add     | width=5    |               | add_0_root_add_6_root_add_12_I16 |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : psel_gen_REQS3_WIDTH16
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : psel_gen_REQS3_WIDTH16
****************************************

No implementations to report
 
****************************************
Design : Map_Table
****************************************

Resource Sharing Report for design Map_Table in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/final/eecs-470-final-project/MapTable/Map_Table.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1063    | DW01_cmp2    | width=7    |               | gt_62                |
| r1065    | DW01_cmp2    | width=5    |               | gt_62_2              |
| r1067    | DW01_cmp2    | width=5    |               | gt_63                |
| r1069    | DW01_cmp6    | width=7    |               | eq_63                |
| r1071    | DW01_cmp2    | width=7    |               | gt_63_2              |
| r1073    | DW01_cmp6    | width=7    |               | eq_64                |
| r1075    | DW01_cmp2    | width=7    |               | gt_62_I2             |
| r1077    | DW01_cmp2    | width=5    |               | gt_62_2_I2           |
| r1079    | DW01_cmp2    | width=5    |               | gt_63_I2             |
| r1081    | DW01_cmp6    | width=7    |               | eq_63_I2             |
| r1083    | DW01_cmp2    | width=7    |               | gt_63_2_I2           |
| r1085    | DW01_cmp6    | width=7    |               | eq_64_I2             |
| r1087    | DW01_cmp2    | width=7    |               | gt_62_I3             |
| r1089    | DW01_cmp2    | width=5    |               | gt_62_2_I3           |
| r1091    | DW01_cmp2    | width=5    |               | gt_63_I3             |
| r1093    | DW01_cmp6    | width=7    |               | eq_63_I3             |
| r1095    | DW01_cmp2    | width=7    |               | gt_63_2_I3           |
| r1097    | DW01_cmp6    | width=7    |               | eq_64_I3             |
| r1099    | DW01_cmp6    | width=5    |               | eq_75                |
| r1101    | DW01_cmp6    | width=5    |               | eq_83                |
| r1103    | DW01_cmp6    | width=5    |               | eq_91                |
| r1105    | DW01_cmp6    | width=5    |               | eq_72_I2             |
| r1107    | DW01_cmp6    | width=5    |               | eq_75_I2             |
| r1109    | DW01_cmp6    | width=5    |               | eq_75_I2_I2          |
| r1111    | DW01_cmp6    | width=5    |               | eq_80_I2             |
| r1113    | DW01_cmp6    | width=5    |               | eq_83_I2             |
| r1115    | DW01_cmp6    | width=5    |               | eq_83_I2_I2          |
| r1117    | DW01_cmp6    | width=5    |               | eq_88_I2             |
| r1119    | DW01_cmp6    | width=5    |               | eq_91_I2             |
| r1121    | DW01_cmp6    | width=5    |               | eq_91_I2_I2          |
| r1123    | DW01_cmp6    | width=5    |               | eq_72_I3             |
| r1125    | DW01_cmp6    | width=5    |               | eq_75_I3             |
| r1127    | DW01_cmp6    | width=5    |               | eq_72_I2_I3          |
| r1129    | DW01_cmp6    | width=5    |               | eq_75_I2_I3          |
| r1131    | DW01_cmp6    | width=5    |               | eq_75_I3_I3          |
| r1133    | DW01_cmp6    | width=5    |               | eq_80_I3             |
| r1135    | DW01_cmp6    | width=5    |               | eq_83_I3             |
| r1137    | DW01_cmp6    | width=5    |               | eq_80_I2_I3          |
| r1139    | DW01_cmp6    | width=5    |               | eq_83_I2_I3          |
| r1141    | DW01_cmp6    | width=5    |               | eq_83_I3_I3          |
| r1143    | DW01_cmp6    | width=5    |               | eq_88_I3             |
| r1145    | DW01_cmp6    | width=5    |               | eq_91_I3             |
| r1147    | DW01_cmp6    | width=5    |               | eq_88_I2_I3          |
| r1149    | DW01_cmp6    | width=5    |               | eq_91_I2_I3          |
| r1151    | DW01_cmp6    | width=5    |               | eq_91_I3_I3          |
===============================================================================


No implementations to report
 
****************************************
Design : ROB
****************************************

Resource Sharing Report for design ROB in file
        /afs/umich.edu/user/c/h/chenhaom/eecs470/projects/final/eecs-470-final-project/ROB/ROB.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r3946    | DW01_dec     | width=7    |               | sub_0QX148           |
|          |              |            |               | sub_0QX149           |
|          |              |            |               | sub_0QX149_2         |
|          |              |            |               | sub_0QX151           |
|          |              |            |               | sub_0QX151_2         |
|          |              |            |               | sub_0QX157           |
|          |              |            |               | sub_0QX159 sub_80    |
| r3951    | DW_div_uns   | a_width=6  |               | rem_121 rem_244      |
|          |              | b_width=6  |               | rem_245 rem_246      |
|          |              |            |               | rem_247              |
| r3952    | DW01_inc     | width=7    |               | add_121_2 add_244_2  |
|          |              |            |               | add_245_2 add_246_2  |
|          |              |            |               | add_247_2            |
| r3953    | DW01_inc     | width=7    |               | add_121_I2           |
|          |              |            |               | add_244_I2           |
|          |              |            |               | add_245_I2           |
|          |              |            |               | add_246_I2           |
|          |              |            |               | add_247_I2           |
| r3954    | DW_div_uns   | a_width=7  |               | rem_121_I2           |
|          |              | b_width=6  |               | rem_244_I2           |
|          |              |            |               | rem_245_I2           |
|          |              |            |               | rem_246_I2           |
|          |              |            |               | rem_247_I2           |
| r3955    | DW01_inc     | width=7    |               | add_121_2_I2         |
|          |              |            |               | add_244_2_I2         |
|          |              |            |               | add_245_2_I2         |
|          |              |            |               | add_246_2_I2         |
|          |              |            |               | add_247_2_I2         |
| r3956    | DW01_add     | width=7    |               | add_121_I3           |
|          |              |            |               | add_244_I3           |
|          |              |            |               | add_245_I3           |
|          |              |            |               | add_246_I3           |
|          |              |            |               | add_247_I3           |
| r3957    | DW_div_uns   | a_width=7  |               | rem_121_I3           |
|          |              | b_width=6  |               | rem_244_I3           |
|          |              |            |               | rem_245_I3           |
|          |              |            |               | rem_246_I3           |
|          |              |            |               | rem_247_I3           |
| r3958    | DW01_inc     | width=7    |               | add_121_2_I3         |
|          |              |            |               | add_244_2_I3         |
|          |              |            |               | add_245_2_I3         |
|          |              |            |               | add_246_2_I3         |
|          |              |            |               | add_247_2_I3         |
| r3966    | DW_div_uns   | a_width=32 |               | rem_0QX148           |
|          |              | b_width=6  |               | rem_0QX149           |
|          |              |            |               | rem_0QX149_2         |
|          |              |            |               | rem_0QX151           |
|          |              |            |               | rem_0QX151_2         |
|          |              |            |               | rem_0QX157           |
|          |              |            |               | rem_0QX159           |
| r3967    | DW_div_uns   | a_width=6  |               | rem_0QX149_3         |
|          |              | b_width=6  |               | rem_0QX151_3         |
|          |              |            |               | rem_0QX151_4         |
|          |              |            |               | rem_0QX157_2         |
| r3968    | DW01_inc     | width=8    |               | add_0QX151_5         |
|          |              |            |               | add_0QX157_3         |
|          |              |            |               | add_1_root_sub_0QX185_01 |
       |              |            |               | add_1_root_sub_0QX186_01 |
       |              |            |               | add_1_root_sub_0QX187_01 |
       |              |            |               | add_1_root_sub_0QX189_01 |
       |              |            |               | add_1_root_sub_0QX190_01 |
       |              |            |               | add_1_root_sub_0QX191_01 |
       |              |            |               | add_1_root_sub_188_I2 |
| r3969    | DW_div_uns   | a_width=7  |               | rem_0QX151_5         |
|          |              | b_width=6  |               | rem_0QX157_3         |
| r3974    | DW01_dec     | width=7    |               | sub_0QX159_2         |
|          |              |            |               | sub_0QX185           |
|          |              |            |               | sub_0QX186           |
|          |              |            |               | sub_0QX187           |
|          |              |            |               | sub_0QX189           |
|          |              |            |               | sub_0QX190           |
|          |              |            |               | sub_0QX191 sub_188   |
|          |              |            |               | sub_277 sub_278      |
|          |              |            |               | sub_279              |
| r3975    | DW_div_uns   | a_width=32 |               | rem_0QX159_4         |
|          |              | b_width=6  |               | rem_0QX185           |
|          |              |            |               | rem_0QX186           |
|          |              |            |               | rem_0QX187           |
|          |              |            |               | rem_0QX189           |
|          |              |            |               | rem_0QX190           |
|          |              |            |               | rem_0QX191 rem_188   |
|          |              |            |               | rem_277 rem_278      |
|          |              |            |               | rem_279              |
| r3978    | DW01_inc     | width=8    |               | add_0QX159_3         |
|          |              |            |               | add_1_root_sub_277_I2 |
          |              |            |               | add_1_root_sub_278_I2 |
          |              |            |               | add_1_root_sub_279_I2 |
| r3982    | DW01_inc     | width=7    |               | add_188_2 add_277_2  |
|          |              |            |               | add_278_2 add_279_2  |
| r4000    | DW_div_uns   | a_width=32 |               | rem_0QX185_02        |
|          |              | b_width=6  |               | rem_0QX186_02        |
|          |              |            |               | rem_0QX187_02        |
|          |              |            |               | rem_0QX189_02        |
|          |              |            |               | rem_0QX190_02        |
|          |              |            |               | rem_0QX191_02        |
|          |              |            |               | rem_188_I3           |
|          |              |            |               | rem_277_I3           |
|          |              |            |               | rem_278_I3           |
|          |              |            |               | rem_279_I3           |
| r4001    | DW01_inc     | width=7    |               | add_188_2_I3         |
|          |              |            |               | add_277_2_I3         |
|          |              |            |               | add_278_2_I3         |
|          |              |            |               | add_279_2_I3         |
| r4062    | DW01_cmp2    | width=6    |               | gte_80               |
| r4070    | DW01_cmp6    | width=32   |               | eq_80_2              |
| r4072    | DW01_sub     | width=6    |               | sub_1_root_sub_80_5  |
| r4074    | DW01_cmp2    | width=6    |               | lt_100               |
| r4076    | DW01_cmp2    | width=6    |               | lt_101               |
| r4082    | DW_div_uns   | a_width=32 |               | rem_125              |
|          |              | b_width=6  |               |                      |
| r4084    | DW01_inc     | width=6    |               | add_125_2            |
| r4086    | DW01_cmp2    | width=7    |               | gt_138               |
| r4088    | DW01_cmp2    | width=7    |               | gt_138_I2            |
| r4090    | DW01_cmp2    | width=7    |               | gt_138_I3            |
| r4096    | DW_div_uns   | a_width=32 |               | rem_158              |
|          |              | b_width=6  |               |                      |
| r4100    | DW_div_uns   | a_width=6  |               | rem_0QX159_2         |
|          |              | b_width=6  |               |                      |
| r4102    | DW_div_uns   | a_width=6  |               | rem_0QX159_5         |
|          |              | b_width=6  |               |                      |
| r4104    | DW_div_uns   | a_width=7  |               | rem_0QX159_3         |
|          |              | b_width=6  |               |                      |
| r4106    | DW01_inc     | width=7    |               | add_0QX159_7         |
| r4108    | DW_div_uns   | a_width=7  |               | rem_0QX159_6         |
|          |              | b_width=6  |               |                      |
| r4110    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX185_01 |
| r4112    | DW_div_uns   | a_width=32 |               | rem_0QX185_01        |
|          |              | b_width=6  |               |                      |
| r4114    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX186_01 |
| r4116    | DW_div_uns   | a_width=32 |               | rem_0QX186_01        |
|          |              | b_width=6  |               |                      |
| r4118    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX187_01 |
| r4120    | DW_div_uns   | a_width=32 |               | rem_0QX187_01        |
|          |              | b_width=6  |               |                      |
| r4122    | DW01_dec     | width=8    |               | sub_0_root_sub_188_I2 |
| r4124    | DW_div_uns   | a_width=32 |               | rem_188_I2           |
|          |              | b_width=6  |               |                      |
| r4126    | DW01_inc     | width=7    |               | add_188_2_I2         |
| r4128    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX189_01 |
| r4130    | DW_div_uns   | a_width=32 |               | rem_0QX189_01        |
|          |              | b_width=6  |               |                      |
| r4132    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX190_01 |
| r4134    | DW_div_uns   | a_width=32 |               | rem_0QX190_01        |
|          |              | b_width=6  |               |                      |
| r4136    | DW01_dec     | width=8    |               | sub_0_root_sub_0QX191_01 |
| r4138    | DW_div_uns   | a_width=32 |               | rem_0QX191_01        |
|          |              | b_width=6  |               |                      |
| r4140    | DW01_dec     | width=8    |               | sub_0_root_sub_277_I2 |
| r4142    | DW_div_uns   | a_width=32 |               | rem_277_I2           |
|          |              | b_width=6  |               |                      |
| r4144    | DW01_inc     | width=7    |               | add_277_2_I2         |
| r4146    | DW01_dec     | width=8    |               | sub_0_root_sub_278_I2 |
| r4148    | DW_div_uns   | a_width=32 |               | rem_278_I2           |
|          |              | b_width=6  |               |                      |
| r4150    | DW01_inc     | width=7    |               | add_278_2_I2         |
| r4152    | DW01_dec     | width=8    |               | sub_0_root_sub_279_I2 |
| r4154    | DW_div_uns   | a_width=32 |               | rem_279_I2           |
|          |              | b_width=6  |               |                      |
| r4156    | DW01_inc     | width=7    |               | add_279_2_I2         |
| r4266    | DW01_dec     | width=8    |               | add_1_root_sub_0QX185_02 |
       |              |            |               | add_1_root_sub_0QX186_02 |
       |              |            |               | add_1_root_sub_0QX187_02 |
       |              |            |               | add_1_root_sub_0QX189_02 |
       |              |            |               | add_1_root_sub_0QX190_02 |
       |              |            |               | add_1_root_sub_0QX191_02 |
       |              |            |               | add_1_root_sub_188_I3 |
          |              |            |               | add_1_root_sub_277_I3 |
          |              |            |               | add_1_root_sub_278_I3 |
          |              |            |               | add_1_root_sub_279_I3 |
| r4268    | DW01_add     | width=8    |               | sub_0_root_sub_0QX185_02 |
       |              |            |               | sub_0_root_sub_0QX186_02 |
       |              |            |               | sub_0_root_sub_0QX187_02 |
       |              |            |               | sub_0_root_sub_0QX189_02 |
       |              |            |               | sub_0_root_sub_0QX190_02 |
       |              |            |               | sub_0_root_sub_0QX191_02 |
       |              |            |               | sub_0_root_sub_188_I3 |
          |              |            |               | sub_0_root_sub_277_I3 |
          |              |            |               | sub_0_root_sub_278_I3 |
          |              |            |               | sub_0_root_sub_279_I3 |
| r4379    | DW01_sub     | width=6    |               | sub_1_root_add_80    |
| r4381    | DW01_inc     | width=6    |               | add_0_root_add_80    |
| r4383    | DW01_sub     | width=6    |               | sub_80_3             |
| r4491    | DW01_dec     | width=8    |               | sub_1_root_sub_0_root_sub_125 |
| r4493    | DW01_add     | width=8    |               | add_0_root_sub_0_root_sub_125 |
| r4601    | DW01_dec     | width=8    |               | sub_1_root_sub_0_root_sub_158 |
| r4603    | DW01_add     | width=8    |               | add_0_root_sub_0_root_sub_158 |
| r4709    | DW02_mult    | A_width=6  |               | mult_add_158_2_aco   |
|          |              | B_width=1  |               |                      |
| r4711    | DW01_inc     | width=6    |               | add_158_2_aco        |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| sub_1_root_add_80  | DW01_sub         | rpl                |                |
| sub_1_root_sub_80_5                   |                    |                |
|                    | DW01_sub         | rpl                |                |
| r3966              | DW_div_uns       | rpl                |                |
| r3969              | DW_div_uns       | rpl                |                |
| r3954              | DW_div_uns       | rpl                |                |
| r3957              | DW_div_uns       | rpl                |                |
| r3975              | DW_div_uns       | rpl                |                |
| r4000              | DW_div_uns       | rpl                |                |
| rem_125            | DW_div_uns       | rpl                |                |
| rem_158            | DW_div_uns       | rpl                |                |
| rem_0QX159_3       | DW_div_uns       | rpl                |                |
| rem_0QX159_6       | DW_div_uns       | rpl                |                |
| rem_0QX185_01      | DW_div_uns       | rpl                |                |
| rem_0QX186_01      | DW_div_uns       | rpl                |                |
| rem_0QX187_01      | DW_div_uns       | rpl                |                |
| rem_188_I2         | DW_div_uns       | rpl                |                |
| rem_0QX189_01      | DW_div_uns       | rpl                |                |
| rem_0QX190_01      | DW_div_uns       | rpl                |                |
| rem_0QX191_01      | DW_div_uns       | rpl                |                |
| rem_277_I2         | DW_div_uns       | rpl                |                |
| rem_278_I2         | DW_div_uns       | rpl                |                |
| rem_279_I2         | DW_div_uns       | rpl                |                |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_23
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_21
****************************************

Resource Sharing Report for design DW_div_uns_a_width7_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=7  |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_19
****************************************

Resource Sharing Report for design DW_div_uns_a_width7_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=7  |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_18
****************************************

Resource Sharing Report for design DW_div_uns_a_width7_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=7  |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_17
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_15
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_14
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_13
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_11
****************************************

Resource Sharing Report for design DW_div_uns_a_width7_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=7  |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_10
****************************************

Resource Sharing Report for design DW_div_uns_a_width7_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=7  |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_9
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_8
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_7
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_6
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_5
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_4
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_3
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_2
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_1
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

 
****************************************
Design : ROB_DW_div_uns_0
****************************************

Resource Sharing Report for design DW_div_uns_a_width32_b_width6

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW_div       | a_width=32 |               | u_div                |
|          |              | b_width=6  |               |                      |
|          |              | tc_mode=0  |               |                      |
|          |              | rem_mode=1 |               |                      |
===============================================================================

1
