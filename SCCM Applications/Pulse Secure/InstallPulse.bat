@echo off
:: Pulse requires a full path to read the configuration file in the MSI switch
:: Thus requiring a batch file for the different path at each Distribution Points
::
:: Leon Chung | leonc@nyu.edu
:: 2016.11.02: Initial commit
:: 2017.05.22: Updated config file
::

:: Install Pulse with Config file, MSI option is case sensitive
start /wait msiexec.exe /i "pulse-win-5.2r4.0-b667-64bit.msi" /qn CONFIGFILE="%~dp0COMPANY_CONFIG.jnprpreconfig" /l*v "%temp%\pulsesecure.log"

:: Report back to SCCM Server
exit /b %errorlevel%
