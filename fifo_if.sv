`timescale 1ns/1ps
interface fifo_if (input bit clk);
  logic rst_n;
  logic [31:0] data_in;
  logic [31:0] data_out;
  logic wr_en;
  logic rd_en;
  logic full;
  logic empty;
  logic overflow;
  logic underflow;
  logic [3:0] counter;
endinterface

/*
module fifo #(parameter W = 8, parameter D = 32) (
    input logic [W-1 : 0] data_in,
    input logic clk, rst_n, wr_en, rd_en,
    output logic [W-1 : 0] data_out,
    output logic full, empty, overflow, underflow,
    output logic [$clog2(D) : 0] counter
);
*/