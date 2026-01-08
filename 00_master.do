/*-----------------------------------------------------
File: 00_master.do
Purpose: Master-do file 
Users: Tejas  
-------------------------------------------------------*/

clear all
set more off
macro drop _all

// Set root 
// this is for the root directory 
//net install here, from("https://raw.githubusercontent.com/korenmiklos/here/master/")
here, set

cd "D:\Banking and Balance Sheets Updated" // It's in the D drive of my laptop 

// Set globals for main directories

global raw "03_raw"
global clean "04_clean"
global code "02_code"
global latex "05_latex"
global figures "$latex/figures"
global tables "$latex/tables"
global shape "$raw/shapefiles"


// this is for graph formatting 
//*net install scheme-modern, from("https://raw.githubusercontent.com/mdroste/stata-scheme-modern/master/")
set scheme modern,perm
 // Run
