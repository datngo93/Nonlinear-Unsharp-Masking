close all;
clear;
clc;

addpath(genpath('source-code/'));

img = imread('02_ori.png');

figure;
imshow([double(img)/255,NUM(img)]);