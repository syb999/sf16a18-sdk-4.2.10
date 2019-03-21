#!/bin/ash
command_arr="
0                                
CWA_GEN_GetRegister              
CWA_GEN_SetRegister              
CWA_TRX_SwitchMode               
CWA_GEN_GetVersion               
CWA_TRX_SetRFChannel             
CWA_TRX_GetRFChannel             
CWA_TRX_SetChannelBW             
CWA_TRX_GetChannelBW             
CWA_TRX_SetRxGain                
CWA_TRX_GetRxGain                
CWA_TRX_SetTxPower               
CWA_TRX_GetTxPower               
CWA_TRX_SetOpMode                
CWA_TRX_GetOpMode                
CWA_TRX_GetStatus                
CWA_TRX_SetCalConfig             
CWA_TRX_GetCalConfig             
CWA_TRX_DoCalibration            
CWA_TRX_GetCalStatus             
CWA_APP_SetOpMode                
CWA_APP_GetOpMode                
CWA_APP_GetStatus                
CWA_APP_SetCalConfig             
CWA_APP_GetCalConfig             
CWA_APP_DoCalibration            
CWA_APP_GetCalStatus             
CWA_AUX_SetAdcConfig             
CWA_AUX_GetAdcConfig             
CWA_AUX_SetAdcSrc                
CWA_AUX_GetAdcSrc                
CWA_AUX_DoAdcConv                
CWA_AUX_GetAdcResult             
0                                
0                                
0                                
0                                
CWA_APP_SetHKConfig              
CWA_APP_GetHKConfig              
CWA_AUX_SetAdcOpMode             
CWA_AUX_GetAdcOpMode             
CWA_AUX_SetAdcInput              
CWA_AUX_GetAdcInput              
CWA_APP_GetTemperature
0                                
CWA_TRX_SetRfAppConfig
CWA_TRX_GetRfAppConfig
0                                
0                                
0                                
0                                
TST_Cmd_Setup_HbRx               
TST_Cmd_Setup_HbTx               
TST_Cmd_Setup_LbRx               
TST_Cmd_Setup_LbTx               
TST_Cmd_Setup_Hb                 
TST_Cmd_Setup_Lb                 
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
CWA_TRX_SetTxGain                
CWA_TRX_GetTxGain                
CWA_GEN_SetRSB                   
CWA_CLK_SetAspBaseClk            
CWA_CLK_SetAspTimerClk           
CWA_CLK_SetXO                    
CWA_TRX_CalWbPll                 
CWA_CLK_CalClkPll                
CWA_CLK_GetClkPllStatus          
0                                
CWA_TRX_CalSX                    
CWA_CLK_SetClkPll                
CWA_AUX_CalAdc                   
CWA_TRX_GetWbPllStatus           
CWA_TRX_CalRxDc                  
CWA_TRX_CalTxDc                  
CWA_TRX_CalChBw                  
CWA_TRX_CalPADrvTank             
CWA_TRX_CalIqc                   
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
0                                
FUN_Cmd_CLK_SetClkPllOutputClkbus
FUN_Cmd_APP_stopTrxLbHbAuxAdc    
FUN_Cmd_GEN_SetFreqCntr          
FUN_Cmd_GEN_BinarySearch         
FUN_Cmd_GEN_LinearSearch         
FUN_Cmd_TRX_SetSxCalConfig       
FUN_Cmd_TRX_SetBWConfig          
FUN_Cmd_TRX_Switch2ONTX          
FUN_Cmd_TRX_Switch2ONTRXCAL      
FUN_Cmd_TRX_LLSwitch2ONRX        
FUN_Cmd_TRX_LLSwitch2ONTX        
FUN_Cmd_GEN_UsTimerTimerOutput   
FUN_Cmd_GEN_SetTestPin           
"
