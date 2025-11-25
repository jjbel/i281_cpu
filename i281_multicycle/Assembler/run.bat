@echo off

if "%1"=="" (
    echo Usage: run.bat filename.asm
    exit /b
)

javac i281assembler.java
java i281assembler ./"%1".asm
