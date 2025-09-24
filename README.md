# verilog
2025 2-2학기 전전설II 과제 제출

## 하드웨어 연결 안될 떄
install_drivers_wrapper.bat \Xilinx\Vivado\2016.4\data\xicom\cable_drivers\nt64 c:\Xilinx\Vivado\2016.4\install.log c:\Xilinx\Vivado\2016.4\

C:\Xilinx\2025.1\data\xicom\cable_drivers\nt64\dlc10_win10

[기존 드라이버 삭제]
windows > device manager > Programming cables(or 인식할 수 없는 장치?) > right click to select Uninstall 

[cmd 관리자모드]
cd <Vivado install path>\data\xicom\cable_drivers\nt64
install_drivers_wrapper.bat <Vivado install path>\data\xicom\cable_drivers\nt64 <Vivado install path>\install.log <Vivado install path>\

[예시]
install_drivers_wrapper.bat C:\Xilinx\2025.1\data\xicom\cable_drivers\nt64 C:\Xilinx\2025.1\install.log C:\Xilinx\2025.1\

[참고]
C:\Xilinx\2025.1\data\xicom\cable_drivers\nt64 에서 <Vivado install path> = C:\Xilinx\2025.1

## 4주차. clock을 버튼스위치로 설정하기 위해

1. synthesis 진행
2. implementation 진행 <- 아마 여기서 막힐겁니다. 오류메시지 기억하고 3번으로 넘어가세요
3. Source > Constraints(새로 생겼을겁니다) > constrs_1 > ~~~.xdc 파일 열기
4. set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF] 붙여넣기 (2번에서 나왔던 오류메시지 그대로 붙여넣어셔야 합니다)
