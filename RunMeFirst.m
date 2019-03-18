% Please run this script to add the current path and sub-directories to
% the searching path. 

% Add current directory and sub-directories to searching path
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
addpath(genpath(dir));

% Now, please try the testing function under the BathTest directory
% 1. watermarkingWithAttacksTest.m