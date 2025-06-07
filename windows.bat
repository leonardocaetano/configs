@echo off

if not exist c:\home (
   mkdir -p c:\home
)

del c:\home\.emacs
mklink /h c:\home\.emacs c:\dev\configs\.emacs
