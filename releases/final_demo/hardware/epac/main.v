//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module audio_0_avalon_audio_slave_arbitrator (
                                               // inputs:
                                                audio_0_avalon_audio_slave_irq,
                                                audio_0_avalon_audio_slave_readdata,
                                                clk,
                                                cpu_0_data_master_address_to_slave,
                                                cpu_0_data_master_latency_counter,
                                                cpu_0_data_master_read,
                                                cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                cpu_0_data_master_write,
                                                cpu_0_data_master_writedata,
                                                reset_n,

                                               // outputs:
                                                audio_0_avalon_audio_slave_address,
                                                audio_0_avalon_audio_slave_chipselect,
                                                audio_0_avalon_audio_slave_irq_from_sa,
                                                audio_0_avalon_audio_slave_read,
                                                audio_0_avalon_audio_slave_readdata_from_sa,
                                                audio_0_avalon_audio_slave_reset,
                                                audio_0_avalon_audio_slave_write,
                                                audio_0_avalon_audio_slave_writedata,
                                                cpu_0_data_master_granted_audio_0_avalon_audio_slave,
                                                cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave,
                                                cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave,
                                                cpu_0_data_master_requests_audio_0_avalon_audio_slave,
                                                d1_audio_0_avalon_audio_slave_end_xfer
                                             )
;

  output  [  1: 0] audio_0_avalon_audio_slave_address;
  output           audio_0_avalon_audio_slave_chipselect;
  output           audio_0_avalon_audio_slave_irq_from_sa;
  output           audio_0_avalon_audio_slave_read;
  output  [ 31: 0] audio_0_avalon_audio_slave_readdata_from_sa;
  output           audio_0_avalon_audio_slave_reset;
  output           audio_0_avalon_audio_slave_write;
  output  [ 31: 0] audio_0_avalon_audio_slave_writedata;
  output           cpu_0_data_master_granted_audio_0_avalon_audio_slave;
  output           cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave;
  output           cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave;
  output           cpu_0_data_master_requests_audio_0_avalon_audio_slave;
  output           d1_audio_0_avalon_audio_slave_end_xfer;
  input            audio_0_avalon_audio_slave_irq;
  input   [ 31: 0] audio_0_avalon_audio_slave_readdata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] audio_0_avalon_audio_slave_address;
  wire             audio_0_avalon_audio_slave_allgrants;
  wire             audio_0_avalon_audio_slave_allow_new_arb_cycle;
  wire             audio_0_avalon_audio_slave_any_bursting_master_saved_grant;
  wire             audio_0_avalon_audio_slave_any_continuerequest;
  wire             audio_0_avalon_audio_slave_arb_counter_enable;
  reg     [  2: 0] audio_0_avalon_audio_slave_arb_share_counter;
  wire    [  2: 0] audio_0_avalon_audio_slave_arb_share_counter_next_value;
  wire    [  2: 0] audio_0_avalon_audio_slave_arb_share_set_values;
  wire             audio_0_avalon_audio_slave_beginbursttransfer_internal;
  wire             audio_0_avalon_audio_slave_begins_xfer;
  wire             audio_0_avalon_audio_slave_chipselect;
  wire             audio_0_avalon_audio_slave_end_xfer;
  wire             audio_0_avalon_audio_slave_firsttransfer;
  wire             audio_0_avalon_audio_slave_grant_vector;
  wire             audio_0_avalon_audio_slave_in_a_read_cycle;
  wire             audio_0_avalon_audio_slave_in_a_write_cycle;
  wire             audio_0_avalon_audio_slave_irq_from_sa;
  wire             audio_0_avalon_audio_slave_master_qreq_vector;
  wire             audio_0_avalon_audio_slave_non_bursting_master_requests;
  wire             audio_0_avalon_audio_slave_read;
  wire    [ 31: 0] audio_0_avalon_audio_slave_readdata_from_sa;
  reg              audio_0_avalon_audio_slave_reg_firsttransfer;
  wire             audio_0_avalon_audio_slave_reset;
  reg              audio_0_avalon_audio_slave_slavearbiterlockenable;
  wire             audio_0_avalon_audio_slave_slavearbiterlockenable2;
  wire             audio_0_avalon_audio_slave_unreg_firsttransfer;
  wire             audio_0_avalon_audio_slave_waits_for_read;
  wire             audio_0_avalon_audio_slave_waits_for_write;
  wire             audio_0_avalon_audio_slave_write;
  wire    [ 31: 0] audio_0_avalon_audio_slave_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave;
  reg              cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register_in;
  wire             cpu_0_data_master_requests_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_saved_grant_audio_0_avalon_audio_slave;
  reg              d1_audio_0_avalon_audio_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register;
  wire    [ 24: 0] shifted_address_to_audio_0_avalon_audio_slave_from_cpu_0_data_master;
  wire             wait_for_audio_0_avalon_audio_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~audio_0_avalon_audio_slave_end_xfer;
    end


  assign audio_0_avalon_audio_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave));
  //assign audio_0_avalon_audio_slave_readdata_from_sa = audio_0_avalon_audio_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign audio_0_avalon_audio_slave_readdata_from_sa = audio_0_avalon_audio_slave_readdata;

  assign cpu_0_data_master_requests_audio_0_avalon_audio_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111440) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //audio_0_avalon_audio_slave_arb_share_counter set values, which is an e_mux
  assign audio_0_avalon_audio_slave_arb_share_set_values = 1;

  //audio_0_avalon_audio_slave_non_bursting_master_requests mux, which is an e_mux
  assign audio_0_avalon_audio_slave_non_bursting_master_requests = cpu_0_data_master_requests_audio_0_avalon_audio_slave;

  //audio_0_avalon_audio_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign audio_0_avalon_audio_slave_any_bursting_master_saved_grant = 0;

  //audio_0_avalon_audio_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign audio_0_avalon_audio_slave_arb_share_counter_next_value = audio_0_avalon_audio_slave_firsttransfer ? (audio_0_avalon_audio_slave_arb_share_set_values - 1) : |audio_0_avalon_audio_slave_arb_share_counter ? (audio_0_avalon_audio_slave_arb_share_counter - 1) : 0;

  //audio_0_avalon_audio_slave_allgrants all slave grants, which is an e_mux
  assign audio_0_avalon_audio_slave_allgrants = |audio_0_avalon_audio_slave_grant_vector;

  //audio_0_avalon_audio_slave_end_xfer assignment, which is an e_assign
  assign audio_0_avalon_audio_slave_end_xfer = ~(audio_0_avalon_audio_slave_waits_for_read | audio_0_avalon_audio_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave = audio_0_avalon_audio_slave_end_xfer & (~audio_0_avalon_audio_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //audio_0_avalon_audio_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign audio_0_avalon_audio_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave & audio_0_avalon_audio_slave_allgrants) | (end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave & ~audio_0_avalon_audio_slave_non_bursting_master_requests);

  //audio_0_avalon_audio_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_0_avalon_audio_slave_arb_share_counter <= 0;
      else if (audio_0_avalon_audio_slave_arb_counter_enable)
          audio_0_avalon_audio_slave_arb_share_counter <= audio_0_avalon_audio_slave_arb_share_counter_next_value;
    end


  //audio_0_avalon_audio_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_0_avalon_audio_slave_slavearbiterlockenable <= 0;
      else if ((|audio_0_avalon_audio_slave_master_qreq_vector & end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave) | (end_xfer_arb_share_counter_term_audio_0_avalon_audio_slave & ~audio_0_avalon_audio_slave_non_bursting_master_requests))
          audio_0_avalon_audio_slave_slavearbiterlockenable <= |audio_0_avalon_audio_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master audio_0/avalon_audio_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = audio_0_avalon_audio_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //audio_0_avalon_audio_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign audio_0_avalon_audio_slave_slavearbiterlockenable2 = |audio_0_avalon_audio_slave_arb_share_counter_next_value;

  //cpu_0/data_master audio_0/avalon_audio_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = audio_0_avalon_audio_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //audio_0_avalon_audio_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign audio_0_avalon_audio_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave = cpu_0_data_master_requests_audio_0_avalon_audio_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register_in = cpu_0_data_master_granted_audio_0_avalon_audio_slave & cpu_0_data_master_read & ~audio_0_avalon_audio_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register = {cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register, cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave = cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave_shift_register;

  //audio_0_avalon_audio_slave_writedata mux, which is an e_mux
  assign audio_0_avalon_audio_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_audio_0_avalon_audio_slave = cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave;

  //cpu_0/data_master saved-grant audio_0/avalon_audio_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_audio_0_avalon_audio_slave = cpu_0_data_master_requests_audio_0_avalon_audio_slave;

  //allow new arb cycle for audio_0/avalon_audio_slave, which is an e_assign
  assign audio_0_avalon_audio_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign audio_0_avalon_audio_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign audio_0_avalon_audio_slave_master_qreq_vector = 1;

  //~audio_0_avalon_audio_slave_reset assignment, which is an e_assign
  assign audio_0_avalon_audio_slave_reset = ~reset_n;

  assign audio_0_avalon_audio_slave_chipselect = cpu_0_data_master_granted_audio_0_avalon_audio_slave;
  //audio_0_avalon_audio_slave_firsttransfer first transaction, which is an e_assign
  assign audio_0_avalon_audio_slave_firsttransfer = audio_0_avalon_audio_slave_begins_xfer ? audio_0_avalon_audio_slave_unreg_firsttransfer : audio_0_avalon_audio_slave_reg_firsttransfer;

  //audio_0_avalon_audio_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign audio_0_avalon_audio_slave_unreg_firsttransfer = ~(audio_0_avalon_audio_slave_slavearbiterlockenable & audio_0_avalon_audio_slave_any_continuerequest);

  //audio_0_avalon_audio_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_0_avalon_audio_slave_reg_firsttransfer <= 1'b1;
      else if (audio_0_avalon_audio_slave_begins_xfer)
          audio_0_avalon_audio_slave_reg_firsttransfer <= audio_0_avalon_audio_slave_unreg_firsttransfer;
    end


  //audio_0_avalon_audio_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign audio_0_avalon_audio_slave_beginbursttransfer_internal = audio_0_avalon_audio_slave_begins_xfer;

  //audio_0_avalon_audio_slave_read assignment, which is an e_mux
  assign audio_0_avalon_audio_slave_read = cpu_0_data_master_granted_audio_0_avalon_audio_slave & cpu_0_data_master_read;

  //audio_0_avalon_audio_slave_write assignment, which is an e_mux
  assign audio_0_avalon_audio_slave_write = cpu_0_data_master_granted_audio_0_avalon_audio_slave & cpu_0_data_master_write;

  assign shifted_address_to_audio_0_avalon_audio_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //audio_0_avalon_audio_slave_address mux, which is an e_mux
  assign audio_0_avalon_audio_slave_address = shifted_address_to_audio_0_avalon_audio_slave_from_cpu_0_data_master >> 2;

  //d1_audio_0_avalon_audio_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_audio_0_avalon_audio_slave_end_xfer <= 1;
      else 
        d1_audio_0_avalon_audio_slave_end_xfer <= audio_0_avalon_audio_slave_end_xfer;
    end


  //audio_0_avalon_audio_slave_waits_for_read in a cycle, which is an e_mux
  assign audio_0_avalon_audio_slave_waits_for_read = audio_0_avalon_audio_slave_in_a_read_cycle & 0;

  //audio_0_avalon_audio_slave_in_a_read_cycle assignment, which is an e_assign
  assign audio_0_avalon_audio_slave_in_a_read_cycle = cpu_0_data_master_granted_audio_0_avalon_audio_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = audio_0_avalon_audio_slave_in_a_read_cycle;

  //audio_0_avalon_audio_slave_waits_for_write in a cycle, which is an e_mux
  assign audio_0_avalon_audio_slave_waits_for_write = audio_0_avalon_audio_slave_in_a_write_cycle & 0;

  //audio_0_avalon_audio_slave_in_a_write_cycle assignment, which is an e_assign
  assign audio_0_avalon_audio_slave_in_a_write_cycle = cpu_0_data_master_granted_audio_0_avalon_audio_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = audio_0_avalon_audio_slave_in_a_write_cycle;

  assign wait_for_audio_0_avalon_audio_slave_counter = 0;
  //assign audio_0_avalon_audio_slave_irq_from_sa = audio_0_avalon_audio_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign audio_0_avalon_audio_slave_irq_from_sa = audio_0_avalon_audio_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //audio_0/avalon_audio_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module audio_and_video_config_0_avalon_av_config_slave_arbitrator (
                                                                    // inputs:
                                                                     audio_and_video_config_0_avalon_av_config_slave_readdata,
                                                                     audio_and_video_config_0_avalon_av_config_slave_waitrequest,
                                                                     clk,
                                                                     cpu_0_data_master_address_to_slave,
                                                                     cpu_0_data_master_byteenable,
                                                                     cpu_0_data_master_latency_counter,
                                                                     cpu_0_data_master_read,
                                                                     cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                                     cpu_0_data_master_write,
                                                                     cpu_0_data_master_writedata,
                                                                     reset_n,

                                                                    // outputs:
                                                                     audio_and_video_config_0_avalon_av_config_slave_address,
                                                                     audio_and_video_config_0_avalon_av_config_slave_byteenable,
                                                                     audio_and_video_config_0_avalon_av_config_slave_read,
                                                                     audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa,
                                                                     audio_and_video_config_0_avalon_av_config_slave_reset,
                                                                     audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa,
                                                                     audio_and_video_config_0_avalon_av_config_slave_write,
                                                                     audio_and_video_config_0_avalon_av_config_slave_writedata,
                                                                     cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave,
                                                                     cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave,
                                                                     cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave,
                                                                     cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave,
                                                                     d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer
                                                                  )
;

  output  [  1: 0] audio_and_video_config_0_avalon_av_config_slave_address;
  output  [  3: 0] audio_and_video_config_0_avalon_av_config_slave_byteenable;
  output           audio_and_video_config_0_avalon_av_config_slave_read;
  output  [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa;
  output           audio_and_video_config_0_avalon_av_config_slave_reset;
  output           audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;
  output           audio_and_video_config_0_avalon_av_config_slave_write;
  output  [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_writedata;
  output           cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave;
  output           cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave;
  output           cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave;
  output           cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;
  output           d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer;
  input   [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata;
  input            audio_and_video_config_0_avalon_av_config_slave_waitrequest;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] audio_and_video_config_0_avalon_av_config_slave_address;
  wire             audio_and_video_config_0_avalon_av_config_slave_allgrants;
  wire             audio_and_video_config_0_avalon_av_config_slave_allow_new_arb_cycle;
  wire             audio_and_video_config_0_avalon_av_config_slave_any_bursting_master_saved_grant;
  wire             audio_and_video_config_0_avalon_av_config_slave_any_continuerequest;
  wire             audio_and_video_config_0_avalon_av_config_slave_arb_counter_enable;
  reg     [  2: 0] audio_and_video_config_0_avalon_av_config_slave_arb_share_counter;
  wire    [  2: 0] audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value;
  wire    [  2: 0] audio_and_video_config_0_avalon_av_config_slave_arb_share_set_values;
  wire             audio_and_video_config_0_avalon_av_config_slave_beginbursttransfer_internal;
  wire             audio_and_video_config_0_avalon_av_config_slave_begins_xfer;
  wire    [  3: 0] audio_and_video_config_0_avalon_av_config_slave_byteenable;
  wire             audio_and_video_config_0_avalon_av_config_slave_end_xfer;
  wire             audio_and_video_config_0_avalon_av_config_slave_firsttransfer;
  wire             audio_and_video_config_0_avalon_av_config_slave_grant_vector;
  wire             audio_and_video_config_0_avalon_av_config_slave_in_a_read_cycle;
  wire             audio_and_video_config_0_avalon_av_config_slave_in_a_write_cycle;
  wire             audio_and_video_config_0_avalon_av_config_slave_master_qreq_vector;
  wire             audio_and_video_config_0_avalon_av_config_slave_non_bursting_master_requests;
  wire             audio_and_video_config_0_avalon_av_config_slave_read;
  wire    [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa;
  reg              audio_and_video_config_0_avalon_av_config_slave_reg_firsttransfer;
  wire             audio_and_video_config_0_avalon_av_config_slave_reset;
  reg              audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable;
  wire             audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable2;
  wire             audio_and_video_config_0_avalon_av_config_slave_unreg_firsttransfer;
  wire             audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;
  wire             audio_and_video_config_0_avalon_av_config_slave_waits_for_read;
  wire             audio_and_video_config_0_avalon_av_config_slave_waits_for_write;
  wire             audio_and_video_config_0_avalon_av_config_slave_write;
  wire    [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave;
  reg              cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register_in;
  wire             cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_saved_grant_audio_and_video_config_0_avalon_av_config_slave;
  reg              d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register;
  wire    [ 24: 0] shifted_address_to_audio_and_video_config_0_avalon_av_config_slave_from_cpu_0_data_master;
  wire             wait_for_audio_and_video_config_0_avalon_av_config_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~audio_and_video_config_0_avalon_av_config_slave_end_xfer;
    end


  assign audio_and_video_config_0_avalon_av_config_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave));
  //assign audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa = audio_and_video_config_0_avalon_av_config_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa = audio_and_video_config_0_avalon_av_config_slave_readdata;

  assign cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111450) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa = audio_and_video_config_0_avalon_av_config_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa = audio_and_video_config_0_avalon_av_config_slave_waitrequest;

  //audio_and_video_config_0_avalon_av_config_slave_arb_share_counter set values, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_arb_share_set_values = 1;

  //audio_and_video_config_0_avalon_av_config_slave_non_bursting_master_requests mux, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_non_bursting_master_requests = cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;

  //audio_and_video_config_0_avalon_av_config_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_any_bursting_master_saved_grant = 0;

  //audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value = audio_and_video_config_0_avalon_av_config_slave_firsttransfer ? (audio_and_video_config_0_avalon_av_config_slave_arb_share_set_values - 1) : |audio_and_video_config_0_avalon_av_config_slave_arb_share_counter ? (audio_and_video_config_0_avalon_av_config_slave_arb_share_counter - 1) : 0;

  //audio_and_video_config_0_avalon_av_config_slave_allgrants all slave grants, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_allgrants = |audio_and_video_config_0_avalon_av_config_slave_grant_vector;

  //audio_and_video_config_0_avalon_av_config_slave_end_xfer assignment, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_end_xfer = ~(audio_and_video_config_0_avalon_av_config_slave_waits_for_read | audio_and_video_config_0_avalon_av_config_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave = audio_and_video_config_0_avalon_av_config_slave_end_xfer & (~audio_and_video_config_0_avalon_av_config_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //audio_and_video_config_0_avalon_av_config_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave & audio_and_video_config_0_avalon_av_config_slave_allgrants) | (end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave & ~audio_and_video_config_0_avalon_av_config_slave_non_bursting_master_requests);

  //audio_and_video_config_0_avalon_av_config_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_and_video_config_0_avalon_av_config_slave_arb_share_counter <= 0;
      else if (audio_and_video_config_0_avalon_av_config_slave_arb_counter_enable)
          audio_and_video_config_0_avalon_av_config_slave_arb_share_counter <= audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value;
    end


  //audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable <= 0;
      else if ((|audio_and_video_config_0_avalon_av_config_slave_master_qreq_vector & end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave) | (end_xfer_arb_share_counter_term_audio_and_video_config_0_avalon_av_config_slave & ~audio_and_video_config_0_avalon_av_config_slave_non_bursting_master_requests))
          audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable <= |audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master audio_and_video_config_0/avalon_av_config_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable2 = |audio_and_video_config_0_avalon_av_config_slave_arb_share_counter_next_value;

  //cpu_0/data_master audio_and_video_config_0/avalon_av_config_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //audio_and_video_config_0_avalon_av_config_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave = cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register_in = cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave & cpu_0_data_master_read & ~audio_and_video_config_0_avalon_av_config_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register = {cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register, cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave = cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave_shift_register;

  //audio_and_video_config_0_avalon_av_config_slave_writedata mux, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave = cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave;

  //cpu_0/data_master saved-grant audio_and_video_config_0/avalon_av_config_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_audio_and_video_config_0_avalon_av_config_slave = cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;

  //allow new arb cycle for audio_and_video_config_0/avalon_av_config_slave, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign audio_and_video_config_0_avalon_av_config_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign audio_and_video_config_0_avalon_av_config_slave_master_qreq_vector = 1;

  //~audio_and_video_config_0_avalon_av_config_slave_reset assignment, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_reset = ~reset_n;

  //audio_and_video_config_0_avalon_av_config_slave_firsttransfer first transaction, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_firsttransfer = audio_and_video_config_0_avalon_av_config_slave_begins_xfer ? audio_and_video_config_0_avalon_av_config_slave_unreg_firsttransfer : audio_and_video_config_0_avalon_av_config_slave_reg_firsttransfer;

  //audio_and_video_config_0_avalon_av_config_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_unreg_firsttransfer = ~(audio_and_video_config_0_avalon_av_config_slave_slavearbiterlockenable & audio_and_video_config_0_avalon_av_config_slave_any_continuerequest);

  //audio_and_video_config_0_avalon_av_config_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          audio_and_video_config_0_avalon_av_config_slave_reg_firsttransfer <= 1'b1;
      else if (audio_and_video_config_0_avalon_av_config_slave_begins_xfer)
          audio_and_video_config_0_avalon_av_config_slave_reg_firsttransfer <= audio_and_video_config_0_avalon_av_config_slave_unreg_firsttransfer;
    end


  //audio_and_video_config_0_avalon_av_config_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_beginbursttransfer_internal = audio_and_video_config_0_avalon_av_config_slave_begins_xfer;

  //audio_and_video_config_0_avalon_av_config_slave_read assignment, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_read = cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave & cpu_0_data_master_read;

  //audio_and_video_config_0_avalon_av_config_slave_write assignment, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_write = cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave & cpu_0_data_master_write;

  assign shifted_address_to_audio_and_video_config_0_avalon_av_config_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //audio_and_video_config_0_avalon_av_config_slave_address mux, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_address = shifted_address_to_audio_and_video_config_0_avalon_av_config_slave_from_cpu_0_data_master >> 2;

  //d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer <= 1;
      else 
        d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer <= audio_and_video_config_0_avalon_av_config_slave_end_xfer;
    end


  //audio_and_video_config_0_avalon_av_config_slave_waits_for_read in a cycle, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_waits_for_read = audio_and_video_config_0_avalon_av_config_slave_in_a_read_cycle & audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;

  //audio_and_video_config_0_avalon_av_config_slave_in_a_read_cycle assignment, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_in_a_read_cycle = cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = audio_and_video_config_0_avalon_av_config_slave_in_a_read_cycle;

  //audio_and_video_config_0_avalon_av_config_slave_waits_for_write in a cycle, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_waits_for_write = audio_and_video_config_0_avalon_av_config_slave_in_a_write_cycle & audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;

  //audio_and_video_config_0_avalon_av_config_slave_in_a_write_cycle assignment, which is an e_assign
  assign audio_and_video_config_0_avalon_av_config_slave_in_a_write_cycle = cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = audio_and_video_config_0_avalon_av_config_slave_in_a_write_cycle;

  assign wait_for_audio_and_video_config_0_avalon_av_config_slave_counter = 0;
  //audio_and_video_config_0_avalon_av_config_slave_byteenable byte enable port mux, which is an e_mux
  assign audio_and_video_config_0_avalon_av_config_slave_byteenable = (cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //audio_and_video_config_0/avalon_av_config_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module bridge_0_avalon_master_arbitrator (
                                           // inputs:
                                            bridge_0_avalon_master_address,
                                            bridge_0_avalon_master_byteenable,
                                            bridge_0_avalon_master_read,
                                            bridge_0_avalon_master_write,
                                            bridge_0_avalon_master_writedata,
                                            bridge_0_granted_sdram_0_s1,
                                            bridge_0_qualified_request_sdram_0_s1,
                                            bridge_0_read_data_valid_sdram_0_s1,
                                            bridge_0_read_data_valid_sdram_0_s1_shift_register,
                                            bridge_0_requests_sdram_0_s1,
                                            clk,
                                            d1_sdram_0_s1_end_xfer,
                                            reset_n,
                                            sdram_0_s1_readdata_from_sa,
                                            sdram_0_s1_waitrequest_from_sa,

                                           // outputs:
                                            bridge_0_avalon_master_address_to_slave,
                                            bridge_0_avalon_master_readdata,
                                            bridge_0_avalon_master_waitrequest
                                         )
;

  output  [ 23: 0] bridge_0_avalon_master_address_to_slave;
  output  [ 15: 0] bridge_0_avalon_master_readdata;
  output           bridge_0_avalon_master_waitrequest;
  input   [ 23: 0] bridge_0_avalon_master_address;
  input   [  1: 0] bridge_0_avalon_master_byteenable;
  input            bridge_0_avalon_master_read;
  input            bridge_0_avalon_master_write;
  input   [ 15: 0] bridge_0_avalon_master_writedata;
  input            bridge_0_granted_sdram_0_s1;
  input            bridge_0_qualified_request_sdram_0_s1;
  input            bridge_0_read_data_valid_sdram_0_s1;
  input            bridge_0_read_data_valid_sdram_0_s1_shift_register;
  input            bridge_0_requests_sdram_0_s1;
  input            clk;
  input            d1_sdram_0_s1_end_xfer;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 23: 0] bridge_0_avalon_master_address_last_time;
  wire    [ 23: 0] bridge_0_avalon_master_address_to_slave;
  reg     [  1: 0] bridge_0_avalon_master_byteenable_last_time;
  reg              bridge_0_avalon_master_read_last_time;
  wire    [ 15: 0] bridge_0_avalon_master_readdata;
  wire             bridge_0_avalon_master_run;
  wire             bridge_0_avalon_master_waitrequest;
  reg              bridge_0_avalon_master_write_last_time;
  reg     [ 15: 0] bridge_0_avalon_master_writedata_last_time;
  wire             r_1;
  wire             r_2;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (bridge_0_qualified_request_sdram_0_s1 | bridge_0_read_data_valid_sdram_0_s1 | ~bridge_0_requests_sdram_0_s1);

  //cascaded wait assignment, which is an e_assign
  assign bridge_0_avalon_master_run = r_1 & r_2;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = (bridge_0_granted_sdram_0_s1 | ~bridge_0_qualified_request_sdram_0_s1) & ((~bridge_0_qualified_request_sdram_0_s1 | ~bridge_0_avalon_master_read | (bridge_0_read_data_valid_sdram_0_s1 & bridge_0_avalon_master_read))) & ((~bridge_0_qualified_request_sdram_0_s1 | ~(bridge_0_avalon_master_read | bridge_0_avalon_master_write) | (1 & ~sdram_0_s1_waitrequest_from_sa & (bridge_0_avalon_master_read | bridge_0_avalon_master_write))));

  //optimize select-logic by passing only those address bits which matter.
  assign bridge_0_avalon_master_address_to_slave = {1'b1,
    bridge_0_avalon_master_address[22 : 0]};

  //bridge_0/avalon_master readdata mux, which is an e_mux
  assign bridge_0_avalon_master_readdata = sdram_0_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign bridge_0_avalon_master_waitrequest = ~bridge_0_avalon_master_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //bridge_0_avalon_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_address_last_time <= 0;
      else 
        bridge_0_avalon_master_address_last_time <= bridge_0_avalon_master_address;
    end


  //bridge_0/avalon_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= bridge_0_avalon_master_waitrequest & (bridge_0_avalon_master_read | bridge_0_avalon_master_write);
    end


  //bridge_0_avalon_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_address != bridge_0_avalon_master_address_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_byteenable_last_time <= 0;
      else 
        bridge_0_avalon_master_byteenable_last_time <= bridge_0_avalon_master_byteenable;
    end


  //bridge_0_avalon_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_byteenable != bridge_0_avalon_master_byteenable_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_read_last_time <= 0;
      else 
        bridge_0_avalon_master_read_last_time <= bridge_0_avalon_master_read;
    end


  //bridge_0_avalon_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_read != bridge_0_avalon_master_read_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_write_last_time <= 0;
      else 
        bridge_0_avalon_master_write_last_time <= bridge_0_avalon_master_write;
    end


  //bridge_0_avalon_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_write != bridge_0_avalon_master_write_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_writedata_last_time <= 0;
      else 
        bridge_0_avalon_master_writedata_last_time <= bridge_0_avalon_master_writedata;
    end


  //bridge_0_avalon_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_writedata != bridge_0_avalon_master_writedata_last_time) & bridge_0_avalon_master_write)
        begin
          $write("%0d ns: bridge_0_avalon_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module character_lcd_0_avalon_lcd_slave_arbitrator (
                                                     // inputs:
                                                      character_lcd_0_avalon_lcd_slave_readdata,
                                                      character_lcd_0_avalon_lcd_slave_waitrequest,
                                                      clk,
                                                      cpu_0_data_master_address_to_slave,
                                                      cpu_0_data_master_byteenable,
                                                      cpu_0_data_master_dbs_address,
                                                      cpu_0_data_master_dbs_write_8,
                                                      cpu_0_data_master_latency_counter,
                                                      cpu_0_data_master_read,
                                                      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                      cpu_0_data_master_write,
                                                      reset_n,

                                                     // outputs:
                                                      character_lcd_0_avalon_lcd_slave_address,
                                                      character_lcd_0_avalon_lcd_slave_chipselect,
                                                      character_lcd_0_avalon_lcd_slave_read,
                                                      character_lcd_0_avalon_lcd_slave_readdata_from_sa,
                                                      character_lcd_0_avalon_lcd_slave_reset,
                                                      character_lcd_0_avalon_lcd_slave_waitrequest_from_sa,
                                                      character_lcd_0_avalon_lcd_slave_write,
                                                      character_lcd_0_avalon_lcd_slave_writedata,
                                                      cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave,
                                                      cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave,
                                                      cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave,
                                                      cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave,
                                                      cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave,
                                                      d1_character_lcd_0_avalon_lcd_slave_end_xfer
                                                   )
;

  output           character_lcd_0_avalon_lcd_slave_address;
  output           character_lcd_0_avalon_lcd_slave_chipselect;
  output           character_lcd_0_avalon_lcd_slave_read;
  output  [  7: 0] character_lcd_0_avalon_lcd_slave_readdata_from_sa;
  output           character_lcd_0_avalon_lcd_slave_reset;
  output           character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;
  output           character_lcd_0_avalon_lcd_slave_write;
  output  [  7: 0] character_lcd_0_avalon_lcd_slave_writedata;
  output           cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave;
  output           cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave;
  output           cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave;
  output           cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave;
  output           cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;
  output           d1_character_lcd_0_avalon_lcd_slave_end_xfer;
  input   [  7: 0] character_lcd_0_avalon_lcd_slave_readdata;
  input            character_lcd_0_avalon_lcd_slave_waitrequest;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [  7: 0] cpu_0_data_master_dbs_write_8;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input            reset_n;

  wire             character_lcd_0_avalon_lcd_slave_address;
  wire             character_lcd_0_avalon_lcd_slave_allgrants;
  wire             character_lcd_0_avalon_lcd_slave_allow_new_arb_cycle;
  wire             character_lcd_0_avalon_lcd_slave_any_bursting_master_saved_grant;
  wire             character_lcd_0_avalon_lcd_slave_any_continuerequest;
  wire             character_lcd_0_avalon_lcd_slave_arb_counter_enable;
  reg     [  2: 0] character_lcd_0_avalon_lcd_slave_arb_share_counter;
  wire    [  2: 0] character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value;
  wire    [  2: 0] character_lcd_0_avalon_lcd_slave_arb_share_set_values;
  wire             character_lcd_0_avalon_lcd_slave_beginbursttransfer_internal;
  wire             character_lcd_0_avalon_lcd_slave_begins_xfer;
  wire             character_lcd_0_avalon_lcd_slave_chipselect;
  wire             character_lcd_0_avalon_lcd_slave_end_xfer;
  wire             character_lcd_0_avalon_lcd_slave_firsttransfer;
  wire             character_lcd_0_avalon_lcd_slave_grant_vector;
  wire             character_lcd_0_avalon_lcd_slave_in_a_read_cycle;
  wire             character_lcd_0_avalon_lcd_slave_in_a_write_cycle;
  wire             character_lcd_0_avalon_lcd_slave_master_qreq_vector;
  wire             character_lcd_0_avalon_lcd_slave_non_bursting_master_requests;
  wire             character_lcd_0_avalon_lcd_slave_pretend_byte_enable;
  wire             character_lcd_0_avalon_lcd_slave_read;
  wire    [  7: 0] character_lcd_0_avalon_lcd_slave_readdata_from_sa;
  reg              character_lcd_0_avalon_lcd_slave_reg_firsttransfer;
  wire             character_lcd_0_avalon_lcd_slave_reset;
  reg              character_lcd_0_avalon_lcd_slave_slavearbiterlockenable;
  wire             character_lcd_0_avalon_lcd_slave_slavearbiterlockenable2;
  wire             character_lcd_0_avalon_lcd_slave_unreg_firsttransfer;
  wire             character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;
  wire             character_lcd_0_avalon_lcd_slave_waits_for_read;
  wire             character_lcd_0_avalon_lcd_slave_waits_for_write;
  wire             character_lcd_0_avalon_lcd_slave_write;
  wire    [  7: 0] character_lcd_0_avalon_lcd_slave_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_0;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_1;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_2;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_3;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_saved_grant_character_lcd_0_avalon_lcd_slave;
  reg              d1_character_lcd_0_avalon_lcd_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_character_lcd_0_avalon_lcd_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~character_lcd_0_avalon_lcd_slave_end_xfer;
    end


  assign character_lcd_0_avalon_lcd_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave));
  //assign character_lcd_0_avalon_lcd_slave_readdata_from_sa = character_lcd_0_avalon_lcd_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_readdata_from_sa = character_lcd_0_avalon_lcd_slave_readdata;

  assign cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave = ({cpu_0_data_master_address_to_slave[24 : 1] , 1'b0} == 25'h1111472) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign character_lcd_0_avalon_lcd_slave_waitrequest_from_sa = character_lcd_0_avalon_lcd_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_waitrequest_from_sa = character_lcd_0_avalon_lcd_slave_waitrequest;

  //character_lcd_0_avalon_lcd_slave_arb_share_counter set values, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_arb_share_set_values = (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave)? 4 :
    1;

  //character_lcd_0_avalon_lcd_slave_non_bursting_master_requests mux, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_non_bursting_master_requests = cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;

  //character_lcd_0_avalon_lcd_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_any_bursting_master_saved_grant = 0;

  //character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value = character_lcd_0_avalon_lcd_slave_firsttransfer ? (character_lcd_0_avalon_lcd_slave_arb_share_set_values - 1) : |character_lcd_0_avalon_lcd_slave_arb_share_counter ? (character_lcd_0_avalon_lcd_slave_arb_share_counter - 1) : 0;

  //character_lcd_0_avalon_lcd_slave_allgrants all slave grants, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_allgrants = |character_lcd_0_avalon_lcd_slave_grant_vector;

  //character_lcd_0_avalon_lcd_slave_end_xfer assignment, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_end_xfer = ~(character_lcd_0_avalon_lcd_slave_waits_for_read | character_lcd_0_avalon_lcd_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave = character_lcd_0_avalon_lcd_slave_end_xfer & (~character_lcd_0_avalon_lcd_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //character_lcd_0_avalon_lcd_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave & character_lcd_0_avalon_lcd_slave_allgrants) | (end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave & ~character_lcd_0_avalon_lcd_slave_non_bursting_master_requests);

  //character_lcd_0_avalon_lcd_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          character_lcd_0_avalon_lcd_slave_arb_share_counter <= 0;
      else if (character_lcd_0_avalon_lcd_slave_arb_counter_enable)
          character_lcd_0_avalon_lcd_slave_arb_share_counter <= character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value;
    end


  //character_lcd_0_avalon_lcd_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          character_lcd_0_avalon_lcd_slave_slavearbiterlockenable <= 0;
      else if ((|character_lcd_0_avalon_lcd_slave_master_qreq_vector & end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave) | (end_xfer_arb_share_counter_term_character_lcd_0_avalon_lcd_slave & ~character_lcd_0_avalon_lcd_slave_non_bursting_master_requests))
          character_lcd_0_avalon_lcd_slave_slavearbiterlockenable <= |character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master character_lcd_0/avalon_lcd_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = character_lcd_0_avalon_lcd_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //character_lcd_0_avalon_lcd_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_slavearbiterlockenable2 = |character_lcd_0_avalon_lcd_slave_arb_share_counter_next_value;

  //cpu_0/data_master character_lcd_0/avalon_lcd_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = character_lcd_0_avalon_lcd_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //character_lcd_0_avalon_lcd_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave = cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((!cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave) & cpu_0_data_master_write));
  //local readdatavalid cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave = cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read & ~character_lcd_0_avalon_lcd_slave_waits_for_read;

  //character_lcd_0_avalon_lcd_slave_writedata mux, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_writedata = cpu_0_data_master_dbs_write_8;

  //master is always granted when requested
  assign cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave = cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave;

  //cpu_0/data_master saved-grant character_lcd_0/avalon_lcd_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_character_lcd_0_avalon_lcd_slave = cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;

  //allow new arb cycle for character_lcd_0/avalon_lcd_slave, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign character_lcd_0_avalon_lcd_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign character_lcd_0_avalon_lcd_slave_master_qreq_vector = 1;

  //~character_lcd_0_avalon_lcd_slave_reset assignment, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_reset = ~reset_n;

  assign character_lcd_0_avalon_lcd_slave_chipselect = cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave;
  //character_lcd_0_avalon_lcd_slave_firsttransfer first transaction, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_firsttransfer = character_lcd_0_avalon_lcd_slave_begins_xfer ? character_lcd_0_avalon_lcd_slave_unreg_firsttransfer : character_lcd_0_avalon_lcd_slave_reg_firsttransfer;

  //character_lcd_0_avalon_lcd_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_unreg_firsttransfer = ~(character_lcd_0_avalon_lcd_slave_slavearbiterlockenable & character_lcd_0_avalon_lcd_slave_any_continuerequest);

  //character_lcd_0_avalon_lcd_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          character_lcd_0_avalon_lcd_slave_reg_firsttransfer <= 1'b1;
      else if (character_lcd_0_avalon_lcd_slave_begins_xfer)
          character_lcd_0_avalon_lcd_slave_reg_firsttransfer <= character_lcd_0_avalon_lcd_slave_unreg_firsttransfer;
    end


  //character_lcd_0_avalon_lcd_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_beginbursttransfer_internal = character_lcd_0_avalon_lcd_slave_begins_xfer;

  //character_lcd_0_avalon_lcd_slave_read assignment, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_read = cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read;

  //character_lcd_0_avalon_lcd_slave_write assignment, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_write = ((cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_write)) & character_lcd_0_avalon_lcd_slave_pretend_byte_enable;

  //character_lcd_0_avalon_lcd_slave_address mux, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_address = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1 : 0]};

  //d1_character_lcd_0_avalon_lcd_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_character_lcd_0_avalon_lcd_slave_end_xfer <= 1;
      else 
        d1_character_lcd_0_avalon_lcd_slave_end_xfer <= character_lcd_0_avalon_lcd_slave_end_xfer;
    end


  //character_lcd_0_avalon_lcd_slave_waits_for_read in a cycle, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_waits_for_read = character_lcd_0_avalon_lcd_slave_in_a_read_cycle & character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;

  //character_lcd_0_avalon_lcd_slave_in_a_read_cycle assignment, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_in_a_read_cycle = cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = character_lcd_0_avalon_lcd_slave_in_a_read_cycle;

  //character_lcd_0_avalon_lcd_slave_waits_for_write in a cycle, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_waits_for_write = character_lcd_0_avalon_lcd_slave_in_a_write_cycle & character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;

  //character_lcd_0_avalon_lcd_slave_in_a_write_cycle assignment, which is an e_assign
  assign character_lcd_0_avalon_lcd_slave_in_a_write_cycle = cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = character_lcd_0_avalon_lcd_slave_in_a_write_cycle;

  assign wait_for_character_lcd_0_avalon_lcd_slave_counter = 0;
  //character_lcd_0_avalon_lcd_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  assign character_lcd_0_avalon_lcd_slave_pretend_byte_enable = (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave)? cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave :
    -1;

  assign {cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_3,
cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_2,
cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_1,
cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_0 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_1 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_2 :
    cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //character_lcd_0/avalon_lcd_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module clocks_0_avalon_clocks_slave_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  clocks_0_avalon_clocks_slave_readdata,
                                                  main_clock_0_out_address_to_slave,
                                                  main_clock_0_out_read,
                                                  main_clock_0_out_write,
                                                  reset_n,

                                                 // outputs:
                                                  clocks_0_avalon_clocks_slave_address,
                                                  clocks_0_avalon_clocks_slave_readdata_from_sa,
                                                  d1_clocks_0_avalon_clocks_slave_end_xfer,
                                                  main_clock_0_out_granted_clocks_0_avalon_clocks_slave,
                                                  main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave,
                                                  main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave,
                                                  main_clock_0_out_requests_clocks_0_avalon_clocks_slave
                                               )
;

  output           clocks_0_avalon_clocks_slave_address;
  output  [  7: 0] clocks_0_avalon_clocks_slave_readdata_from_sa;
  output           d1_clocks_0_avalon_clocks_slave_end_xfer;
  output           main_clock_0_out_granted_clocks_0_avalon_clocks_slave;
  output           main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave;
  output           main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave;
  output           main_clock_0_out_requests_clocks_0_avalon_clocks_slave;
  input            clk;
  input   [  7: 0] clocks_0_avalon_clocks_slave_readdata;
  input            main_clock_0_out_address_to_slave;
  input            main_clock_0_out_read;
  input            main_clock_0_out_write;
  input            reset_n;

  wire             clocks_0_avalon_clocks_slave_address;
  wire             clocks_0_avalon_clocks_slave_allgrants;
  wire             clocks_0_avalon_clocks_slave_allow_new_arb_cycle;
  wire             clocks_0_avalon_clocks_slave_any_bursting_master_saved_grant;
  wire             clocks_0_avalon_clocks_slave_any_continuerequest;
  wire             clocks_0_avalon_clocks_slave_arb_counter_enable;
  reg              clocks_0_avalon_clocks_slave_arb_share_counter;
  wire             clocks_0_avalon_clocks_slave_arb_share_counter_next_value;
  wire             clocks_0_avalon_clocks_slave_arb_share_set_values;
  wire             clocks_0_avalon_clocks_slave_beginbursttransfer_internal;
  wire             clocks_0_avalon_clocks_slave_begins_xfer;
  wire             clocks_0_avalon_clocks_slave_end_xfer;
  wire             clocks_0_avalon_clocks_slave_firsttransfer;
  wire             clocks_0_avalon_clocks_slave_grant_vector;
  wire             clocks_0_avalon_clocks_slave_in_a_read_cycle;
  wire             clocks_0_avalon_clocks_slave_in_a_write_cycle;
  wire             clocks_0_avalon_clocks_slave_master_qreq_vector;
  wire             clocks_0_avalon_clocks_slave_non_bursting_master_requests;
  wire    [  7: 0] clocks_0_avalon_clocks_slave_readdata_from_sa;
  reg              clocks_0_avalon_clocks_slave_reg_firsttransfer;
  reg              clocks_0_avalon_clocks_slave_slavearbiterlockenable;
  wire             clocks_0_avalon_clocks_slave_slavearbiterlockenable2;
  wire             clocks_0_avalon_clocks_slave_unreg_firsttransfer;
  wire             clocks_0_avalon_clocks_slave_waits_for_read;
  wire             clocks_0_avalon_clocks_slave_waits_for_write;
  reg              d1_clocks_0_avalon_clocks_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             main_clock_0_out_arbiterlock;
  wire             main_clock_0_out_arbiterlock2;
  wire             main_clock_0_out_continuerequest;
  wire             main_clock_0_out_granted_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave;
  reg              main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register;
  wire             main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register_in;
  wire             main_clock_0_out_requests_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_saved_grant_clocks_0_avalon_clocks_slave;
  wire             p1_main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register;
  wire             wait_for_clocks_0_avalon_clocks_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~clocks_0_avalon_clocks_slave_end_xfer;
    end


  assign clocks_0_avalon_clocks_slave_begins_xfer = ~d1_reasons_to_wait & ((main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave));
  //assign clocks_0_avalon_clocks_slave_readdata_from_sa = clocks_0_avalon_clocks_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign clocks_0_avalon_clocks_slave_readdata_from_sa = clocks_0_avalon_clocks_slave_readdata;

  assign main_clock_0_out_requests_clocks_0_avalon_clocks_slave = ((1) & (main_clock_0_out_read | main_clock_0_out_write)) & main_clock_0_out_read;
  //clocks_0_avalon_clocks_slave_arb_share_counter set values, which is an e_mux
  assign clocks_0_avalon_clocks_slave_arb_share_set_values = 1;

  //clocks_0_avalon_clocks_slave_non_bursting_master_requests mux, which is an e_mux
  assign clocks_0_avalon_clocks_slave_non_bursting_master_requests = main_clock_0_out_requests_clocks_0_avalon_clocks_slave;

  //clocks_0_avalon_clocks_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign clocks_0_avalon_clocks_slave_any_bursting_master_saved_grant = 0;

  //clocks_0_avalon_clocks_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign clocks_0_avalon_clocks_slave_arb_share_counter_next_value = clocks_0_avalon_clocks_slave_firsttransfer ? (clocks_0_avalon_clocks_slave_arb_share_set_values - 1) : |clocks_0_avalon_clocks_slave_arb_share_counter ? (clocks_0_avalon_clocks_slave_arb_share_counter - 1) : 0;

  //clocks_0_avalon_clocks_slave_allgrants all slave grants, which is an e_mux
  assign clocks_0_avalon_clocks_slave_allgrants = |clocks_0_avalon_clocks_slave_grant_vector;

  //clocks_0_avalon_clocks_slave_end_xfer assignment, which is an e_assign
  assign clocks_0_avalon_clocks_slave_end_xfer = ~(clocks_0_avalon_clocks_slave_waits_for_read | clocks_0_avalon_clocks_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave = clocks_0_avalon_clocks_slave_end_xfer & (~clocks_0_avalon_clocks_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //clocks_0_avalon_clocks_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign clocks_0_avalon_clocks_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave & clocks_0_avalon_clocks_slave_allgrants) | (end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave & ~clocks_0_avalon_clocks_slave_non_bursting_master_requests);

  //clocks_0_avalon_clocks_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clocks_0_avalon_clocks_slave_arb_share_counter <= 0;
      else if (clocks_0_avalon_clocks_slave_arb_counter_enable)
          clocks_0_avalon_clocks_slave_arb_share_counter <= clocks_0_avalon_clocks_slave_arb_share_counter_next_value;
    end


  //clocks_0_avalon_clocks_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clocks_0_avalon_clocks_slave_slavearbiterlockenable <= 0;
      else if ((|clocks_0_avalon_clocks_slave_master_qreq_vector & end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave) | (end_xfer_arb_share_counter_term_clocks_0_avalon_clocks_slave & ~clocks_0_avalon_clocks_slave_non_bursting_master_requests))
          clocks_0_avalon_clocks_slave_slavearbiterlockenable <= |clocks_0_avalon_clocks_slave_arb_share_counter_next_value;
    end


  //main_clock_0/out clocks_0/avalon_clocks_slave arbiterlock, which is an e_assign
  assign main_clock_0_out_arbiterlock = clocks_0_avalon_clocks_slave_slavearbiterlockenable & main_clock_0_out_continuerequest;

  //clocks_0_avalon_clocks_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign clocks_0_avalon_clocks_slave_slavearbiterlockenable2 = |clocks_0_avalon_clocks_slave_arb_share_counter_next_value;

  //main_clock_0/out clocks_0/avalon_clocks_slave arbiterlock2, which is an e_assign
  assign main_clock_0_out_arbiterlock2 = clocks_0_avalon_clocks_slave_slavearbiterlockenable2 & main_clock_0_out_continuerequest;

  //clocks_0_avalon_clocks_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign clocks_0_avalon_clocks_slave_any_continuerequest = 1;

  //main_clock_0_out_continuerequest continued request, which is an e_assign
  assign main_clock_0_out_continuerequest = 1;

  assign main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave = main_clock_0_out_requests_clocks_0_avalon_clocks_slave & ~((main_clock_0_out_read & ((|main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register))));
  //main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register_in = main_clock_0_out_granted_clocks_0_avalon_clocks_slave & main_clock_0_out_read & ~clocks_0_avalon_clocks_slave_waits_for_read & ~(|main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register);

  //shift register p1 main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register = {main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register, main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register_in};

  //main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register <= 0;
      else 
        main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register <= p1_main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register;
    end


  //local readdatavalid main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave, which is an e_mux
  assign main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave = main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave_shift_register;

  //master is always granted when requested
  assign main_clock_0_out_granted_clocks_0_avalon_clocks_slave = main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave;

  //main_clock_0/out saved-grant clocks_0/avalon_clocks_slave, which is an e_assign
  assign main_clock_0_out_saved_grant_clocks_0_avalon_clocks_slave = main_clock_0_out_requests_clocks_0_avalon_clocks_slave;

  //allow new arb cycle for clocks_0/avalon_clocks_slave, which is an e_assign
  assign clocks_0_avalon_clocks_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign clocks_0_avalon_clocks_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign clocks_0_avalon_clocks_slave_master_qreq_vector = 1;

  //clocks_0_avalon_clocks_slave_firsttransfer first transaction, which is an e_assign
  assign clocks_0_avalon_clocks_slave_firsttransfer = clocks_0_avalon_clocks_slave_begins_xfer ? clocks_0_avalon_clocks_slave_unreg_firsttransfer : clocks_0_avalon_clocks_slave_reg_firsttransfer;

  //clocks_0_avalon_clocks_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign clocks_0_avalon_clocks_slave_unreg_firsttransfer = ~(clocks_0_avalon_clocks_slave_slavearbiterlockenable & clocks_0_avalon_clocks_slave_any_continuerequest);

  //clocks_0_avalon_clocks_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clocks_0_avalon_clocks_slave_reg_firsttransfer <= 1'b1;
      else if (clocks_0_avalon_clocks_slave_begins_xfer)
          clocks_0_avalon_clocks_slave_reg_firsttransfer <= clocks_0_avalon_clocks_slave_unreg_firsttransfer;
    end


  //clocks_0_avalon_clocks_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign clocks_0_avalon_clocks_slave_beginbursttransfer_internal = clocks_0_avalon_clocks_slave_begins_xfer;

  //clocks_0_avalon_clocks_slave_address mux, which is an e_mux
  assign clocks_0_avalon_clocks_slave_address = main_clock_0_out_address_to_slave;

  //d1_clocks_0_avalon_clocks_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_clocks_0_avalon_clocks_slave_end_xfer <= 1;
      else 
        d1_clocks_0_avalon_clocks_slave_end_xfer <= clocks_0_avalon_clocks_slave_end_xfer;
    end


  //clocks_0_avalon_clocks_slave_waits_for_read in a cycle, which is an e_mux
  assign clocks_0_avalon_clocks_slave_waits_for_read = clocks_0_avalon_clocks_slave_in_a_read_cycle & 0;

  //clocks_0_avalon_clocks_slave_in_a_read_cycle assignment, which is an e_assign
  assign clocks_0_avalon_clocks_slave_in_a_read_cycle = main_clock_0_out_granted_clocks_0_avalon_clocks_slave & main_clock_0_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = clocks_0_avalon_clocks_slave_in_a_read_cycle;

  //clocks_0_avalon_clocks_slave_waits_for_write in a cycle, which is an e_mux
  assign clocks_0_avalon_clocks_slave_waits_for_write = clocks_0_avalon_clocks_slave_in_a_write_cycle & 0;

  //clocks_0_avalon_clocks_slave_in_a_write_cycle assignment, which is an e_assign
  assign clocks_0_avalon_clocks_slave_in_a_write_cycle = main_clock_0_out_granted_clocks_0_avalon_clocks_slave & main_clock_0_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = clocks_0_avalon_clocks_slave_in_a_write_cycle;

  assign wait_for_clocks_0_avalon_clocks_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //clocks_0/avalon_clocks_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_jtag_debug_module_arbitrator (
                                            // inputs:
                                             clk,
                                             cpu_0_data_master_address_to_slave,
                                             cpu_0_data_master_byteenable,
                                             cpu_0_data_master_debugaccess,
                                             cpu_0_data_master_latency_counter,
                                             cpu_0_data_master_read,
                                             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                             cpu_0_data_master_write,
                                             cpu_0_data_master_writedata,
                                             cpu_0_instruction_master_address_to_slave,
                                             cpu_0_instruction_master_latency_counter,
                                             cpu_0_instruction_master_read,
                                             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                             cpu_0_jtag_debug_module_readdata,
                                             cpu_0_jtag_debug_module_resetrequest,
                                             reset_n,

                                            // outputs:
                                             cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_jtag_debug_module_address,
                                             cpu_0_jtag_debug_module_begintransfer,
                                             cpu_0_jtag_debug_module_byteenable,
                                             cpu_0_jtag_debug_module_chipselect,
                                             cpu_0_jtag_debug_module_debugaccess,
                                             cpu_0_jtag_debug_module_readdata_from_sa,
                                             cpu_0_jtag_debug_module_resetrequest_from_sa,
                                             cpu_0_jtag_debug_module_write,
                                             cpu_0_jtag_debug_module_writedata,
                                             d1_cpu_0_jtag_debug_module_end_xfer
                                          )
;

  output           cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  output  [  8: 0] cpu_0_jtag_debug_module_address;
  output           cpu_0_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_0_jtag_debug_module_byteenable;
  output           cpu_0_jtag_debug_module_chipselect;
  output           cpu_0_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  output           cpu_0_jtag_debug_module_resetrequest_from_sa;
  output           cpu_0_jtag_debug_module_write;
  output  [ 31: 0] cpu_0_jtag_debug_module_writedata;
  output           d1_cpu_0_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_debugaccess;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 24: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata;
  input            cpu_0_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_allgrants;
  wire             cpu_0_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_0_jtag_debug_module_any_bursting_master_saved_grant;
  wire             cpu_0_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_0_jtag_debug_module_arb_addend;
  wire             cpu_0_jtag_debug_module_arb_counter_enable;
  reg     [  2: 0] cpu_0_jtag_debug_module_arb_share_counter;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_counter_next_value;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_winner;
  wire             cpu_0_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_0_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_0_jtag_debug_module_begins_xfer;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_0_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_0_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire             cpu_0_jtag_debug_module_end_xfer;
  wire             cpu_0_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_0_jtag_debug_module_grant_vector;
  wire             cpu_0_jtag_debug_module_in_a_read_cycle;
  wire             cpu_0_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_0_jtag_debug_module_master_qreq_vector;
  wire             cpu_0_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  reg              cpu_0_jtag_debug_module_reg_firsttransfer;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_0_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_0_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_0_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_0_jtag_debug_module_unreg_firsttransfer;
  wire             cpu_0_jtag_debug_module_waits_for_read;
  wire             cpu_0_jtag_debug_module_waits_for_write;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  reg              d1_cpu_0_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
  wire    [ 24: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master;
  wire    [ 24: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master;
  wire             wait_for_cpu_0_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cpu_0_jtag_debug_module_end_xfer;
    end


  assign cpu_0_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  //assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata;

  assign cpu_0_data_master_requests_cpu_0_jtag_debug_module = ({cpu_0_data_master_address_to_slave[24 : 11] , 11'b0} == 25'h1110800) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_0_jtag_debug_module_arb_share_set_values = 1;

  //cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_0_jtag_debug_module_non_bursting_master_requests = cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module |
    cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign cpu_0_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_share_counter_next_value = cpu_0_jtag_debug_module_firsttransfer ? (cpu_0_jtag_debug_module_arb_share_set_values - 1) : |cpu_0_jtag_debug_module_arb_share_counter ? (cpu_0_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_0_jtag_debug_module_allgrants = (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector);

  //cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_end_xfer = ~(cpu_0_jtag_debug_module_waits_for_read | cpu_0_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_end_xfer & (~cpu_0_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & cpu_0_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests);

  //cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_0_jtag_debug_module_arb_counter_enable)
          cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_0_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests))
          cpu_0_jtag_debug_module_slavearbiterlockenable <= |cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_0_jtag_debug_module_slavearbiterlockenable2 = |cpu_0_jtag_debug_module_arb_share_counter_next_value;

  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_0_jtag_debug_module_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_data_master_requests_cpu_0_jtag_debug_module & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_instruction_master_arbiterlock);
  //local readdatavalid cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_read & ~cpu_0_jtag_debug_module_waits_for_read;

  //cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_0_jtag_debug_module_writedata = cpu_0_data_master_writedata;

  assign cpu_0_instruction_master_requests_cpu_0_jtag_debug_module = (({cpu_0_instruction_master_address_to_slave[24 : 11] , 11'b0} == 25'h1110800) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  assign cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_instruction_master_requests_cpu_0_jtag_debug_module & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read & ~cpu_0_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[0];

  //cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[0] && cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[1];

  //cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[1] && cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_double_vector = {cpu_0_jtag_debug_module_master_qreq_vector, cpu_0_jtag_debug_module_master_qreq_vector} & ({~cpu_0_jtag_debug_module_master_qreq_vector, ~cpu_0_jtag_debug_module_master_qreq_vector} + cpu_0_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_0_jtag_debug_module_arb_winner = (cpu_0_jtag_debug_module_allow_new_arb_cycle & | cpu_0_jtag_debug_module_grant_vector) ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_0_jtag_debug_module_allow_new_arb_cycle)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= |cpu_0_jtag_debug_module_grant_vector ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_0_jtag_debug_module_grant_vector = {(cpu_0_jtag_debug_module_chosen_master_double_vector[1] | cpu_0_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_0_jtag_debug_module_chosen_master_double_vector[0] | cpu_0_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_rot_left = (cpu_0_jtag_debug_module_arb_winner << 1) ? (cpu_0_jtag_debug_module_arb_winner << 1) : 1;

  //cpu_0/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_0_jtag_debug_module_grant_vector)
          cpu_0_jtag_debug_module_arb_addend <= cpu_0_jtag_debug_module_end_xfer? cpu_0_jtag_debug_module_chosen_master_rot_left : cpu_0_jtag_debug_module_grant_vector;
    end


  assign cpu_0_jtag_debug_module_begintransfer = cpu_0_jtag_debug_module_begins_xfer;
  //assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest;

  assign cpu_0_jtag_debug_module_chipselect = cpu_0_data_master_granted_cpu_0_jtag_debug_module | cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  //cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_firsttransfer = cpu_0_jtag_debug_module_begins_xfer ? cpu_0_jtag_debug_module_unreg_firsttransfer : cpu_0_jtag_debug_module_reg_firsttransfer;

  //cpu_0_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_unreg_firsttransfer = ~(cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_jtag_debug_module_any_continuerequest);

  //cpu_0_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (cpu_0_jtag_debug_module_begins_xfer)
          cpu_0_jtag_debug_module_reg_firsttransfer <= cpu_0_jtag_debug_module_unreg_firsttransfer;
    end


  //cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_0_jtag_debug_module_beginbursttransfer_internal = cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_0_jtag_debug_module_arbitration_holdoff_internal = cpu_0_jtag_debug_module_begins_xfer & cpu_0_jtag_debug_module_firsttransfer;

  //cpu_0_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_0_jtag_debug_module_write = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //cpu_0_jtag_debug_module_address mux, which is an e_mux
  assign cpu_0_jtag_debug_module_address = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master >> 2) :
    (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master >> 2);

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master = cpu_0_instruction_master_address_to_slave;
  //d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_0_jtag_debug_module_end_xfer <= 1;
      else 
        d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end


  //cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_read = cpu_0_jtag_debug_module_in_a_read_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_read_cycle = (cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_0_jtag_debug_module_in_a_read_cycle;

  //cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_write = cpu_0_jtag_debug_module_in_a_write_cycle & 0;

  //cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_write_cycle = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_0_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_0_jtag_debug_module_counter = 0;
  //cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_0_jtag_debug_module_byteenable = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign cpu_0_jtag_debug_module_debugaccess = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cpu_0_jtag_debug_module + cpu_0_instruction_master_granted_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module + cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_custom_instruction_master_arbitrator (
                                                    // inputs:
                                                     clk,
                                                     cpu_0_custom_instruction_master_multi_start,
                                                     cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa,
                                                     cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa,
                                                     reset_n,

                                                    // outputs:
                                                     cpu_0_custom_instruction_master_multi_done,
                                                     cpu_0_custom_instruction_master_multi_result,
                                                     cpu_0_custom_instruction_master_reset_n,
                                                     cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0,
                                                     cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select
                                                  )
;

  output           cpu_0_custom_instruction_master_multi_done;
  output  [ 31: 0] cpu_0_custom_instruction_master_multi_result;
  output           cpu_0_custom_instruction_master_reset_n;
  output           cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0;
  output           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select;
  input            clk;
  input            cpu_0_custom_instruction_master_multi_start;
  input            cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa;
  input   [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa;
  input            reset_n;

  wire             cpu_0_custom_instruction_master_multi_done;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_result;
  wire             cpu_0_custom_instruction_master_reset_n;
  wire             cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select;
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select = 1'b1;
  assign cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0 = cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select & cpu_0_custom_instruction_master_multi_start;
  //cpu_0_custom_instruction_master_multi_result mux, which is an e_mux
  assign cpu_0_custom_instruction_master_multi_result = {32 {cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select}} & cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa;

  //multi_done mux, which is an e_mux
  assign cpu_0_custom_instruction_master_multi_done = {1 {cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select}} & cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa;

  //cpu_0_custom_instruction_master_reset_n local reset_n, which is an e_assign
  assign cpu_0_custom_instruction_master_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_data_master_arbitrator (
                                      // inputs:
                                       audio_0_avalon_audio_slave_irq_from_sa,
                                       audio_0_avalon_audio_slave_readdata_from_sa,
                                       audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa,
                                       audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa,
                                       cfi_flash_0_s1_wait_counter_eq_0,
                                       character_lcd_0_avalon_lcd_slave_readdata_from_sa,
                                       character_lcd_0_avalon_lcd_slave_waitrequest_from_sa,
                                       clk,
                                       cpu_0_data_master_address,
                                       cpu_0_data_master_byteenable,
                                       cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                       cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave,
                                       cpu_0_data_master_byteenable_main_clock_0_in,
                                       cpu_0_data_master_byteenable_sdram_0_s1,
                                       cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave,
                                       cpu_0_data_master_granted_audio_0_avalon_audio_slave,
                                       cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave,
                                       cpu_0_data_master_granted_cfi_flash_0_s1,
                                       cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave,
                                       cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_granted_main_clock_0_in,
                                       cpu_0_data_master_granted_onchip_memory2_0_s1,
                                       cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave,
                                       cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave,
                                       cpu_0_data_master_granted_sdram_0_s1,
                                       cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave,
                                       cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave,
                                       cpu_0_data_master_granted_sysid_control_slave,
                                       cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave,
                                       cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave,
                                       cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave,
                                       cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave,
                                       cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                       cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave,
                                       cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_qualified_request_main_clock_0_in,
                                       cpu_0_data_master_qualified_request_onchip_memory2_0_s1,
                                       cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave,
                                       cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave,
                                       cpu_0_data_master_qualified_request_sdram_0_s1,
                                       cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave,
                                       cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave,
                                       cpu_0_data_master_qualified_request_sysid_control_slave,
                                       cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave,
                                       cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave,
                                       cpu_0_data_master_read,
                                       cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave,
                                       cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave,
                                       cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                       cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave,
                                       cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_read_data_valid_main_clock_0_in,
                                       cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
                                       cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave,
                                       cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                       cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave,
                                       cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave,
                                       cpu_0_data_master_read_data_valid_sysid_control_slave,
                                       cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave,
                                       cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave,
                                       cpu_0_data_master_requests_audio_0_avalon_audio_slave,
                                       cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave,
                                       cpu_0_data_master_requests_cfi_flash_0_s1,
                                       cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave,
                                       cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_requests_main_clock_0_in,
                                       cpu_0_data_master_requests_onchip_memory2_0_s1,
                                       cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave,
                                       cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave,
                                       cpu_0_data_master_requests_sdram_0_s1,
                                       cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave,
                                       cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave,
                                       cpu_0_data_master_requests_sysid_control_slave,
                                       cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave,
                                       cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave,
                                       cpu_0_data_master_write,
                                       cpu_0_data_master_writedata,
                                       cpu_0_jtag_debug_module_readdata_from_sa,
                                       d1_audio_0_avalon_audio_slave_end_xfer,
                                       d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer,
                                       d1_character_lcd_0_avalon_lcd_slave_end_xfer,
                                       d1_cpu_0_jtag_debug_module_end_xfer,
                                       d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                       d1_main_clock_0_in_end_xfer,
                                       d1_onchip_memory2_0_s1_end_xfer,
                                       d1_red_leds_avalon_parallel_port_slave_end_xfer,
                                       d1_sd_card_0_avalon_sdcard_slave_end_xfer,
                                       d1_sdram_0_s1_end_xfer,
                                       d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer,
                                       d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer,
                                       d1_sysid_control_slave_end_xfer,
                                       d1_to_external_bus_bridge_0_avalon_slave_end_xfer,
                                       d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                       d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer,
                                       incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0,
                                       jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                       main_clock_0_in_readdata_from_sa,
                                       main_clock_0_in_waitrequest_from_sa,
                                       onchip_memory2_0_s1_readdata_from_sa,
                                       red_leds_avalon_parallel_port_slave_readdata_from_sa,
                                       reset_n,
                                       sd_card_0_avalon_sdcard_slave_readdata_from_sa,
                                       sd_card_0_avalon_sdcard_slave_waitrequest_from_sa,
                                       sdram_0_s1_readdata_from_sa,
                                       sdram_0_s1_waitrequest_from_sa,
                                       seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa,
                                       seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa,
                                       sysid_control_slave_readdata_from_sa,
                                       to_external_bus_bridge_0_avalon_slave_irq_from_sa,
                                       to_external_bus_bridge_0_avalon_slave_readdata_from_sa,
                                       to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa,
                                       video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa,

                                      // outputs:
                                       cpu_0_data_master_address_to_slave,
                                       cpu_0_data_master_dbs_address,
                                       cpu_0_data_master_dbs_write_16,
                                       cpu_0_data_master_dbs_write_8,
                                       cpu_0_data_master_irq,
                                       cpu_0_data_master_latency_counter,
                                       cpu_0_data_master_readdata,
                                       cpu_0_data_master_readdatavalid,
                                       cpu_0_data_master_waitrequest
                                    )
;

  output  [ 24: 0] cpu_0_data_master_address_to_slave;
  output  [  1: 0] cpu_0_data_master_dbs_address;
  output  [ 15: 0] cpu_0_data_master_dbs_write_16;
  output  [  7: 0] cpu_0_data_master_dbs_write_8;
  output  [ 31: 0] cpu_0_data_master_irq;
  output  [  1: 0] cpu_0_data_master_latency_counter;
  output  [ 31: 0] cpu_0_data_master_readdata;
  output           cpu_0_data_master_readdatavalid;
  output           cpu_0_data_master_waitrequest;
  input            audio_0_avalon_audio_slave_irq_from_sa;
  input   [ 31: 0] audio_0_avalon_audio_slave_readdata_from_sa;
  input   [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa;
  input            audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input   [  7: 0] character_lcd_0_avalon_lcd_slave_readdata_from_sa;
  input            character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_byteenable_cfi_flash_0_s1;
  input            cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave;
  input            cpu_0_data_master_byteenable_main_clock_0_in;
  input   [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  input   [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave;
  input            cpu_0_data_master_granted_audio_0_avalon_audio_slave;
  input            cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave;
  input            cpu_0_data_master_granted_cfi_flash_0_s1;
  input            cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave;
  input            cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_granted_main_clock_0_in;
  input            cpu_0_data_master_granted_onchip_memory2_0_s1;
  input            cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave;
  input            cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave;
  input            cpu_0_data_master_granted_sdram_0_s1;
  input            cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave;
  input            cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave;
  input            cpu_0_data_master_granted_sysid_control_slave;
  input            cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave;
  input            cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave;
  input            cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave;
  input            cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave;
  input            cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave;
  input            cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_qualified_request_main_clock_0_in;
  input            cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  input            cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave;
  input            cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave;
  input            cpu_0_data_master_qualified_request_sdram_0_s1;
  input            cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave;
  input            cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave;
  input            cpu_0_data_master_qualified_request_sysid_control_slave;
  input            cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave;
  input            cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave;
  input            cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave;
  input            cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave;
  input            cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_read_data_valid_main_clock_0_in;
  input            cpu_0_data_master_read_data_valid_onchip_memory2_0_s1;
  input            cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave;
  input            cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave;
  input            cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave;
  input            cpu_0_data_master_read_data_valid_sysid_control_slave;
  input            cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave;
  input            cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave;
  input            cpu_0_data_master_requests_audio_0_avalon_audio_slave;
  input            cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;
  input            cpu_0_data_master_requests_cfi_flash_0_s1;
  input            cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;
  input            cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_requests_main_clock_0_in;
  input            cpu_0_data_master_requests_onchip_memory2_0_s1;
  input            cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;
  input            cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;
  input            cpu_0_data_master_requests_sdram_0_s1;
  input            cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;
  input            cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;
  input            cpu_0_data_master_requests_sysid_control_slave;
  input            cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;
  input            cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_audio_0_avalon_audio_slave_end_xfer;
  input            d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer;
  input            d1_character_lcd_0_avalon_lcd_slave_end_xfer;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  input            d1_main_clock_0_in_end_xfer;
  input            d1_onchip_memory2_0_s1_end_xfer;
  input            d1_red_leds_avalon_parallel_port_slave_end_xfer;
  input            d1_sd_card_0_avalon_sdcard_slave_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
  input            d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_to_external_bus_bridge_0_avalon_slave_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input            d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
  input   [  7: 0] incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;
  input            jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  input   [  7: 0] main_clock_0_in_readdata_from_sa;
  input            main_clock_0_in_waitrequest_from_sa;
  input   [ 31: 0] onchip_memory2_0_s1_readdata_from_sa;
  input   [ 31: 0] red_leds_avalon_parallel_port_slave_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata_from_sa;
  input            sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;
  input   [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa;
  input   [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            to_external_bus_bridge_0_avalon_slave_irq_from_sa;
  input   [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata_from_sa;
  input            to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;
  input   [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 24: 0] cpu_0_data_master_address_last_time;
  wire    [ 24: 0] cpu_0_data_master_address_to_slave;
  reg     [  3: 0] cpu_0_data_master_byteenable_last_time;
  reg     [  1: 0] cpu_0_data_master_dbs_address;
  wire    [  1: 0] cpu_0_data_master_dbs_increment;
  reg     [  1: 0] cpu_0_data_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_0_data_master_dbs_rdv_counter_inc;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire    [ 31: 0] cpu_0_data_master_irq;
  wire             cpu_0_data_master_is_granted_some_slave;
  reg     [  1: 0] cpu_0_data_master_latency_counter;
  wire    [  1: 0] cpu_0_data_master_next_dbs_rdv_counter;
  reg              cpu_0_data_master_read_but_no_slave_selected;
  reg              cpu_0_data_master_read_last_time;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_readdatavalid;
  wire             cpu_0_data_master_run;
  wire             cpu_0_data_master_waitrequest;
  reg              cpu_0_data_master_write_last_time;
  reg     [ 31: 0] cpu_0_data_master_writedata_last_time;
  reg     [  7: 0] dbs_8_reg_segment_0;
  reg     [  7: 0] dbs_8_reg_segment_1;
  reg     [  7: 0] dbs_8_reg_segment_2;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_0_data_master_latency_counter;
  wire    [  7: 0] p1_dbs_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_8_reg_segment_2;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_0_data_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  wire             r_3;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave | ~cpu_0_data_master_requests_audio_0_avalon_audio_slave) & ((~cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave | ~cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave) & ((~cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & ((cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave | ((cpu_0_data_master_write & !cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0])) | ~cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave)) & ((~cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave | ~cpu_0_data_master_read | (1 & ~character_lcd_0_avalon_lcd_slave_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave | ~cpu_0_data_master_write | (1 & ~character_lcd_0_avalon_lcd_slave_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) & (cpu_0_data_master_granted_cpu_0_jtag_debug_module | ~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_read | (1 & ~d1_cpu_0_jtag_debug_module_end_xfer & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave) & ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write))));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_data_master_run = r_0 & r_1 & r_2 & r_3;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & ((cpu_0_data_master_qualified_request_main_clock_0_in | ((cpu_0_data_master_write & !cpu_0_data_master_byteenable_main_clock_0_in & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0])) | ~cpu_0_data_master_requests_main_clock_0_in)) & ((~cpu_0_data_master_qualified_request_main_clock_0_in | ~cpu_0_data_master_read | (1 & ~main_clock_0_in_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_main_clock_0_in | ~cpu_0_data_master_write | (1 & ~main_clock_0_in_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_onchip_memory2_0_s1 | ~cpu_0_data_master_requests_onchip_memory2_0_s1) & (cpu_0_data_master_granted_onchip_memory2_0_s1 | ~cpu_0_data_master_qualified_request_onchip_memory2_0_s1) & ((~cpu_0_data_master_qualified_request_onchip_memory2_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_onchip_memory2_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave | ~cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave) & ((~cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave | ~cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave) & ((~cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~sd_card_0_avalon_sdcard_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~sd_card_0_avalon_sdcard_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_sdram_0_s1 | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1 & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_sdram_0_s1);

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = (cpu_0_data_master_granted_sdram_0_s1 | ~cpu_0_data_master_qualified_request_sdram_0_s1) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_read | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_write | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave | ~cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave) & ((~cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave | ~cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave) & ((~cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_sysid_control_slave | ~cpu_0_data_master_requests_sysid_control_slave) & ((~cpu_0_data_master_qualified_request_sysid_control_slave | ~cpu_0_data_master_read | (1 & ~d1_sysid_control_slave_end_xfer & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sysid_control_slave | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave) & ((~cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave | ~cpu_0_data_master_read | (1 & ~to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave | ~cpu_0_data_master_write | (1 & ~to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1;

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ((cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1 & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0])) | ~cpu_0_data_master_requests_cfi_flash_0_s1)) & (cpu_0_data_master_granted_cfi_flash_0_s1 | ~cpu_0_data_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_read | (1 & ((cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer)) & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_write | (1 & ((cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer)) & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave | ~cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave) & ((~cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write))));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_data_master_address_to_slave = cpu_0_data_master_address[24 : 0];

  //cpu_0_data_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_but_no_slave_selected <= 0;
      else 
        cpu_0_data_master_read_but_no_slave_selected <= cpu_0_data_master_read & cpu_0_data_master_run & ~cpu_0_data_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_0_data_master_is_granted_some_slave = cpu_0_data_master_granted_audio_0_avalon_audio_slave |
    cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave |
    cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave |
    cpu_0_data_master_granted_cpu_0_jtag_debug_module |
    cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave |
    cpu_0_data_master_granted_main_clock_0_in |
    cpu_0_data_master_granted_onchip_memory2_0_s1 |
    cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave |
    cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave |
    cpu_0_data_master_granted_sdram_0_s1 |
    cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave |
    cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave |
    cpu_0_data_master_granted_sysid_control_slave |
    cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave |
    cpu_0_data_master_granted_cfi_flash_0_s1 |
    cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_0_data_master_readdatavalid = cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave |
    cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave |
    cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 |
    cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave |
    (cpu_0_data_master_read_data_valid_sdram_0_s1 & dbs_rdv_counter_overflow) |
    cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave |
    cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave |
    (cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave & dbs_rdv_counter_overflow) |
    (cpu_0_data_master_read_data_valid_cfi_flash_0_s1 & dbs_rdv_counter_overflow) |
    cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_0_data_master_readdatavalid = cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    (cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave & dbs_counter_overflow) |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    (cpu_0_data_master_read_data_valid_main_clock_0_in & dbs_counter_overflow) |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_data_valid_sysid_control_slave |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid |
    cpu_0_data_master_read_but_no_slave_selected |
    pre_flush_cpu_0_data_master_readdatavalid;

  //cpu_0/data_master readdata mux, which is an e_mux
  assign cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave}} | audio_0_avalon_audio_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave}} | audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa) &
    ({32 {~(cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read)}} | {character_lcd_0_avalon_lcd_slave_readdata_from_sa[7 : 0],
    dbs_8_reg_segment_2,
    dbs_8_reg_segment_1,
    dbs_8_reg_segment_0}) &
    ({32 {~(cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module & cpu_0_data_master_read)}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~(cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read)}} | jtag_uart_0_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~(cpu_0_data_master_qualified_request_main_clock_0_in & cpu_0_data_master_read)}} | {main_clock_0_in_readdata_from_sa[7 : 0],
    dbs_8_reg_segment_2,
    dbs_8_reg_segment_1,
    dbs_8_reg_segment_0}) &
    ({32 {~cpu_0_data_master_read_data_valid_onchip_memory2_0_s1}} | onchip_memory2_0_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave}} | red_leds_avalon_parallel_port_slave_readdata_from_sa) &
    ({32 {~(cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_read)}} | sd_card_0_avalon_sdcard_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_read_data_valid_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave}} | seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave}} | seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa) &
    ({32 {~(cpu_0_data_master_qualified_request_sysid_control_slave & cpu_0_data_master_read)}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave}} | {to_external_bus_bridge_0_avalon_slave_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_0_data_master_read_data_valid_cfi_flash_0_s1}} | {incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0}) &
    ({32 {~cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave}} | video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign cpu_0_data_master_waitrequest = ~cpu_0_data_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_latency_counter <= 0;
      else 
        cpu_0_data_master_latency_counter <= p1_cpu_0_data_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_0_data_master_latency_counter = ((cpu_0_data_master_run & cpu_0_data_master_read))? latency_load_value :
    (cpu_0_data_master_latency_counter)? cpu_0_data_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = ({2 {cpu_0_data_master_requests_audio_0_avalon_audio_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_onchip_memory2_0_s1}} & 1) |
    ({2 {cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave}} & 1) |
    ({2 {cpu_0_data_master_requests_cfi_flash_0_s1}} & 2) |
    ({2 {cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave}} & 1);

  //irq assign, which is an e_assign
  assign cpu_0_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    audio_0_avalon_audio_slave_irq_from_sa,
    to_external_bus_bridge_0_avalon_slave_irq_from_sa,
    jtag_uart_0_avalon_jtag_slave_irq_from_sa};

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~0) & cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_write & !cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave)) |
    (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read & 1 & 1 & ~character_lcd_0_avalon_lcd_slave_waitrequest_from_sa) |
    (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_write & 1 & 1 & ~character_lcd_0_avalon_lcd_slave_waitrequest_from_sa) |
    (((~0) & cpu_0_data_master_requests_main_clock_0_in & cpu_0_data_master_write & !cpu_0_data_master_byteenable_main_clock_0_in)) |
    (cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_read & 1 & 1 & ~main_clock_0_in_waitrequest_from_sa) |
    (cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_write & 1 & 1 & ~main_clock_0_in_waitrequest_from_sa) |
    (((~0) & cpu_0_data_master_requests_sdram_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1)) |
    (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    (((~0) & cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_write & !cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave)) |
    (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_read & 1 & 1 & ~to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa) |
    (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_write & 1 & 1 & ~to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa) |
    (((~0) & cpu_0_data_master_requests_cfi_flash_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1)) |
    ((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer}))) |
    ((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to dbs-8 stored 0, which is an e_mux
  assign p1_dbs_8_reg_segment_0 = ((cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read))? character_lcd_0_avalon_lcd_slave_readdata_from_sa :
    main_clock_0_in_readdata_from_sa;

  //dbs register for dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 0))
          dbs_8_reg_segment_0 <= p1_dbs_8_reg_segment_0;
    end


  //input to dbs-8 stored 1, which is an e_mux
  assign p1_dbs_8_reg_segment_1 = ((cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read))? character_lcd_0_avalon_lcd_slave_readdata_from_sa :
    main_clock_0_in_readdata_from_sa;

  //dbs register for dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_1 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 1))
          dbs_8_reg_segment_1 <= p1_dbs_8_reg_segment_1;
    end


  //input to dbs-8 stored 2, which is an e_mux
  assign p1_dbs_8_reg_segment_2 = ((cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave & cpu_0_data_master_read))? character_lcd_0_avalon_lcd_slave_readdata_from_sa :
    main_clock_0_in_readdata_from_sa;

  //dbs register for dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_2 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 2))
          dbs_8_reg_segment_2 <= p1_dbs_8_reg_segment_2;
    end


  //mux write dbs 2, which is an e_mux
  assign cpu_0_data_master_dbs_write_8 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_writedata[7 : 0] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_writedata[15 : 8] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_writedata[23 : 16] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 3))? cpu_0_data_master_writedata[31 : 24] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_writedata[7 : 0] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_writedata[15 : 8] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_writedata[23 : 16] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 3))? cpu_0_data_master_writedata[31 : 24] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_writedata[7 : 0] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_writedata[15 : 8] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_writedata[23 : 16] :
    cpu_0_data_master_writedata[31 : 24];

  //dbs count increment, which is an e_mux
  assign cpu_0_data_master_dbs_increment = (cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave)? 1 :
    (cpu_0_data_master_requests_main_clock_0_in)? 1 :
    (cpu_0_data_master_requests_sdram_0_s1)? 2 :
    (cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave)? 2 :
    (cpu_0_data_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_data_master_dbs_address + cpu_0_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_data_master_dbs_address <= next_dbs_address;
    end


  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = (cpu_0_data_master_read_data_valid_sdram_0_s1)? sdram_0_s1_readdata_from_sa :
    to_external_bus_bridge_0_avalon_slave_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_data_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_0_data_master_dbs_write_16 = (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    (~(cpu_0_data_master_dbs_address[1]))? cpu_0_data_master_writedata[15 : 0] :
    (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    cpu_0_data_master_writedata[15 : 0];

  //p1 dbs rdv counter, which is an e_assign
  assign cpu_0_data_master_next_dbs_rdv_counter = cpu_0_data_master_dbs_rdv_counter + cpu_0_data_master_dbs_rdv_counter_inc;

  //cpu_0_data_master_rdv_inc_mux, which is an e_mux
  assign cpu_0_data_master_dbs_rdv_counter_inc = (cpu_0_data_master_read_data_valid_sdram_0_s1)? 2 :
    (cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave)? 2 :
    1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_0_data_master_read_data_valid_sdram_0_s1 |
    cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave |
    cpu_0_data_master_read_data_valid_cfi_flash_0_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_0_data_master_dbs_rdv_counter <= cpu_0_data_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_0_data_master_dbs_rdv_counter[1] & ~cpu_0_data_master_next_dbs_rdv_counter[1];

  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_data_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_data_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_data_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end



//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0_data_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_address_last_time <= 0;
      else 
        cpu_0_data_master_address_last_time <= cpu_0_data_master_address;
    end


  //cpu_0/data_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_0_data_master_waitrequest & (cpu_0_data_master_read | cpu_0_data_master_write);
    end


  //cpu_0_data_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_data_master_address != cpu_0_data_master_address_last_time))
        begin
          $write("%0d ns: cpu_0_data_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_data_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_byteenable_last_time <= 0;
      else 
        cpu_0_data_master_byteenable_last_time <= cpu_0_data_master_byteenable;
    end


  //cpu_0_data_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_data_master_byteenable != cpu_0_data_master_byteenable_last_time))
        begin
          $write("%0d ns: cpu_0_data_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_data_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_last_time <= 0;
      else 
        cpu_0_data_master_read_last_time <= cpu_0_data_master_read;
    end


  //cpu_0_data_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_data_master_read != cpu_0_data_master_read_last_time))
        begin
          $write("%0d ns: cpu_0_data_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_data_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_write_last_time <= 0;
      else 
        cpu_0_data_master_write_last_time <= cpu_0_data_master_write;
    end


  //cpu_0_data_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_data_master_write != cpu_0_data_master_write_last_time))
        begin
          $write("%0d ns: cpu_0_data_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_data_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_writedata_last_time <= 0;
      else 
        cpu_0_data_master_writedata_last_time <= cpu_0_data_master_writedata;
    end


  //cpu_0_data_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_data_master_writedata != cpu_0_data_master_writedata_last_time) & cpu_0_data_master_write)
        begin
          $write("%0d ns: cpu_0_data_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_instruction_master_arbitrator (
                                             // inputs:
                                              cfi_flash_0_s1_wait_counter_eq_0,
                                              clk,
                                              cpu_0_instruction_master_address,
                                              cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                              cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_granted_onchip_memory2_0_s1,
                                              cpu_0_instruction_master_granted_sdram_0_s1,
                                              cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                              cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1,
                                              cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                              cpu_0_instruction_master_read,
                                              cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                              cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                              cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                              cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_requests_onchip_memory2_0_s1,
                                              cpu_0_instruction_master_requests_sdram_0_s1,
                                              cpu_0_jtag_debug_module_readdata_from_sa,
                                              d1_cpu_0_jtag_debug_module_end_xfer,
                                              d1_onchip_memory2_0_s1_end_xfer,
                                              d1_sdram_0_s1_end_xfer,
                                              d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                              incoming_data_to_and_from_the_cfi_flash_0,
                                              onchip_memory2_0_s1_readdata_from_sa,
                                              reset_n,
                                              sdram_0_s1_readdata_from_sa,
                                              sdram_0_s1_waitrequest_from_sa,

                                             // outputs:
                                              cpu_0_instruction_master_address_to_slave,
                                              cpu_0_instruction_master_dbs_address,
                                              cpu_0_instruction_master_latency_counter,
                                              cpu_0_instruction_master_readdata,
                                              cpu_0_instruction_master_readdatavalid,
                                              cpu_0_instruction_master_waitrequest
                                           )
;

  output  [ 24: 0] cpu_0_instruction_master_address_to_slave;
  output  [  1: 0] cpu_0_instruction_master_dbs_address;
  output  [  1: 0] cpu_0_instruction_master_latency_counter;
  output  [ 31: 0] cpu_0_instruction_master_readdata;
  output           cpu_0_instruction_master_readdatavalid;
  output           cpu_0_instruction_master_waitrequest;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input            clk;
  input   [ 24: 0] cpu_0_instruction_master_address;
  input            cpu_0_instruction_master_granted_cfi_flash_0_s1;
  input            cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  input            cpu_0_instruction_master_granted_sdram_0_s1;
  input            cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  input            cpu_0_instruction_master_qualified_request_sdram_0_s1;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_instruction_master_requests_cfi_flash_0_s1;
  input            cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  input            cpu_0_instruction_master_requests_sdram_0_s1;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_onchip_memory2_0_s1_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input   [  7: 0] incoming_data_to_and_from_the_cfi_flash_0;
  input   [ 31: 0] onchip_memory2_0_s1_readdata_from_sa;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 24: 0] cpu_0_instruction_master_address_last_time;
  wire    [ 24: 0] cpu_0_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_0_instruction_master_dbs_address;
  wire    [  1: 0] cpu_0_instruction_master_dbs_increment;
  reg     [  1: 0] cpu_0_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_0_instruction_master_dbs_rdv_counter_inc;
  wire             cpu_0_instruction_master_is_granted_some_slave;
  reg     [  1: 0] cpu_0_instruction_master_latency_counter;
  wire    [  1: 0] cpu_0_instruction_master_next_dbs_rdv_counter;
  reg              cpu_0_instruction_master_read_but_no_slave_selected;
  reg              cpu_0_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_run;
  wire             cpu_0_instruction_master_waitrequest;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_0_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_0_instruction_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  wire             r_3;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) & (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_read | (1 & ~d1_cpu_0_jtag_debug_module_end_xfer & cpu_0_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_instruction_master_run = r_0 & r_1 & r_2 & r_3;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 | ~cpu_0_instruction_master_requests_onchip_memory2_0_s1) & (cpu_0_instruction_master_granted_onchip_memory2_0_s1 | ~cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1) & ((~cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 | ~(cpu_0_instruction_master_read) | (1 & (cpu_0_instruction_master_read))));

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_requests_sdram_0_s1) & (cpu_0_instruction_master_granted_sdram_0_s1 | ~cpu_0_instruction_master_qualified_request_sdram_0_s1) & ((~cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_read | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_instruction_master_dbs_address[1]) & cpu_0_instruction_master_read)));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) & (cpu_0_instruction_master_granted_cfi_flash_0_s1 | ~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_read | (1 & ((cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer)) & (cpu_0_instruction_master_dbs_address[1] & cpu_0_instruction_master_dbs_address[0]) & cpu_0_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_instruction_master_address_to_slave = cpu_0_instruction_master_address[24 : 0];

  //cpu_0_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_but_no_slave_selected <= 0;
      else 
        cpu_0_instruction_master_read_but_no_slave_selected <= cpu_0_instruction_master_read & cpu_0_instruction_master_run & ~cpu_0_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_0_instruction_master_is_granted_some_slave = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_granted_onchip_memory2_0_s1 |
    cpu_0_instruction_master_granted_sdram_0_s1 |
    cpu_0_instruction_master_granted_cfi_flash_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_0_instruction_master_readdatavalid = cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 |
    (cpu_0_instruction_master_read_data_valid_sdram_0_s1 & dbs_rdv_counter_overflow) |
    (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_0_instruction_master_readdatavalid = cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid;

  //cpu_0/instruction_master readdata mux, which is an e_mux
  assign cpu_0_instruction_master_readdata = ({32 {~(cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module & cpu_0_instruction_master_read)}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1}} | onchip_memory2_0_s1_readdata_from_sa) &
    ({32 {~cpu_0_instruction_master_read_data_valid_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1}} | {incoming_data_to_and_from_the_cfi_flash_0[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_0_instruction_master_waitrequest = ~cpu_0_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_latency_counter <= 0;
      else 
        cpu_0_instruction_master_latency_counter <= p1_cpu_0_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_0_instruction_master_latency_counter = ((cpu_0_instruction_master_run & cpu_0_instruction_master_read))? latency_load_value :
    (cpu_0_instruction_master_latency_counter)? cpu_0_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = ({2 {cpu_0_instruction_master_requests_onchip_memory2_0_s1}} & 1) |
    ({2 {cpu_0_instruction_master_requests_cfi_flash_0_s1}} & 2);

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = sdram_0_s1_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_0_instruction_master_dbs_increment = (cpu_0_instruction_master_requests_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_instruction_master_dbs_address + cpu_0_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_instruction_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_0_instruction_master_next_dbs_rdv_counter = cpu_0_instruction_master_dbs_rdv_counter + cpu_0_instruction_master_dbs_rdv_counter_inc;

  //cpu_0_instruction_master_rdv_inc_mux, which is an e_mux
  assign cpu_0_instruction_master_dbs_rdv_counter_inc = (cpu_0_instruction_master_read_data_valid_sdram_0_s1)? 2 :
    1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_0_instruction_master_read_data_valid_sdram_0_s1 |
    cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_0_instruction_master_dbs_rdv_counter <= cpu_0_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_0_instruction_master_dbs_rdv_counter[1] & ~cpu_0_instruction_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    ((cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_data_to_and_from_the_cfi_flash_0;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_data_to_and_from_the_cfi_flash_0;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_data_to_and_from_the_cfi_flash_0;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end



//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_address_last_time <= 0;
      else 
        cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
    end


  //cpu_0/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_0_instruction_master_waitrequest & (cpu_0_instruction_master_read);
    end


  //cpu_0_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_address != cpu_0_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_last_time <= 0;
      else 
        cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
    end


  //cpu_0_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_read != cpu_0_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_arbitrator (
                                                                                                          // inputs:
                                                                                                           clk,
                                                                                                           cpu_0_custom_instruction_master_multi_clk_en,
                                                                                                           cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select,
                                                                                                           reset_n,

                                                                                                          // outputs:
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa,
                                                                                                           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start
                                                                                                        )
;

  output           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en;
  output           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa;
  output           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset;
  output  [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa;
  output           cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start;
  input            clk;
  input            cpu_0_custom_instruction_master_multi_clk_en;
  input            cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0;
  input            cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done;
  input   [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result;
  input            cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select;
  input            reset_n;

  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset;
  wire    [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start;
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en = cpu_0_custom_instruction_master_multi_clk_en;
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start = cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0;
  //assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa = cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa = cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result;

  //assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa = cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa = cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done;

  //cpu_0_wait_for_interrupt_custom_instruction_0_91_inst/nios_custom_instruction_slave_0 local reset_n, which is an e_assign
  assign cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset = ~reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_0_avalon_jtag_slave_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cpu_0_data_master_address_to_slave,
                                                   cpu_0_data_master_latency_counter,
                                                   cpu_0_data_master_read,
                                                   cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                   cpu_0_data_master_write,
                                                   cpu_0_data_master_writedata,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable,
                                                   jtag_uart_0_avalon_jtag_slave_irq,
                                                   jtag_uart_0_avalon_jtag_slave_readdata,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest,
                                                   reset_n,

                                                  // outputs:
                                                   cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                                   d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                                   jtag_uart_0_avalon_jtag_slave_address,
                                                   jtag_uart_0_avalon_jtag_slave_chipselect,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_read_n,
                                                   jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_reset_n,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_write_n,
                                                   jtag_uart_0_avalon_jtag_slave_writedata
                                                )
;

  output           cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  output           d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  output           jtag_uart_0_avalon_jtag_slave_address;
  output           jtag_uart_0_avalon_jtag_slave_chipselect;
  output           jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_reset_n;
  output           jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            jtag_uart_0_avalon_jtag_slave_dataavailable;
  input            jtag_uart_0_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  input            jtag_uart_0_avalon_jtag_slave_readyfordata;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave;
  reg              d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_allgrants;
  wire             jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_0_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_0_avalon_jtag_slave_arb_counter_enable;
  reg     [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_0_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_0_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  reg              jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire    [ 24: 0] shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master;
  wire             wait_for_jtag_uart_0_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_0_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave));
  //assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata;

  assign cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave = ({cpu_0_data_master_address_to_slave[24 : 3] , 3'b0} == 25'h1111460) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_0_avalon_jtag_slave_firsttransfer ? (jtag_uart_0_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_0_avalon_jtag_slave_arb_share_counter ? (jtag_uart_0_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_allgrants = |jtag_uart_0_avalon_jtag_slave_grant_vector;

  //jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_end_xfer = ~(jtag_uart_0_avalon_jtag_slave_waits_for_read | jtag_uart_0_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave = jtag_uart_0_avalon_jtag_slave_end_xfer & (~jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & jtag_uart_0_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_0_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_0_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;

  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //local readdatavalid cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read & ~jtag_uart_0_avalon_jtag_slave_waits_for_read;

  //jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;

  //cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_0_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_0_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_0_avalon_jtag_slave_chipselect = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  //jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_firsttransfer = jtag_uart_0_avalon_jtag_slave_begins_xfer ? jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_0_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_0_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_0_avalon_jtag_slave_begins_xfer)
          jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_0_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_read_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read);

  //~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_write_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write);

  assign shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_address = shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master >> 2;

  //d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_read = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_read_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_write = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_write_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_0_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main_clock_0_in_arbitrator (
                                    // inputs:
                                     clk,
                                     cpu_0_data_master_address_to_slave,
                                     cpu_0_data_master_byteenable,
                                     cpu_0_data_master_dbs_address,
                                     cpu_0_data_master_dbs_write_8,
                                     cpu_0_data_master_latency_counter,
                                     cpu_0_data_master_read,
                                     cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                     cpu_0_data_master_write,
                                     main_clock_0_in_endofpacket,
                                     main_clock_0_in_readdata,
                                     main_clock_0_in_waitrequest,
                                     reset_n,

                                    // outputs:
                                     cpu_0_data_master_byteenable_main_clock_0_in,
                                     cpu_0_data_master_granted_main_clock_0_in,
                                     cpu_0_data_master_qualified_request_main_clock_0_in,
                                     cpu_0_data_master_read_data_valid_main_clock_0_in,
                                     cpu_0_data_master_requests_main_clock_0_in,
                                     d1_main_clock_0_in_end_xfer,
                                     main_clock_0_in_address,
                                     main_clock_0_in_endofpacket_from_sa,
                                     main_clock_0_in_nativeaddress,
                                     main_clock_0_in_read,
                                     main_clock_0_in_readdata_from_sa,
                                     main_clock_0_in_reset_n,
                                     main_clock_0_in_waitrequest_from_sa,
                                     main_clock_0_in_write,
                                     main_clock_0_in_writedata
                                  )
;

  output           cpu_0_data_master_byteenable_main_clock_0_in;
  output           cpu_0_data_master_granted_main_clock_0_in;
  output           cpu_0_data_master_qualified_request_main_clock_0_in;
  output           cpu_0_data_master_read_data_valid_main_clock_0_in;
  output           cpu_0_data_master_requests_main_clock_0_in;
  output           d1_main_clock_0_in_end_xfer;
  output           main_clock_0_in_address;
  output           main_clock_0_in_endofpacket_from_sa;
  output           main_clock_0_in_nativeaddress;
  output           main_clock_0_in_read;
  output  [  7: 0] main_clock_0_in_readdata_from_sa;
  output           main_clock_0_in_reset_n;
  output           main_clock_0_in_waitrequest_from_sa;
  output           main_clock_0_in_write;
  output  [  7: 0] main_clock_0_in_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [  7: 0] cpu_0_data_master_dbs_write_8;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input            main_clock_0_in_endofpacket;
  input   [  7: 0] main_clock_0_in_readdata;
  input            main_clock_0_in_waitrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_byteenable_main_clock_0_in;
  wire             cpu_0_data_master_byteenable_main_clock_0_in_segment_0;
  wire             cpu_0_data_master_byteenable_main_clock_0_in_segment_1;
  wire             cpu_0_data_master_byteenable_main_clock_0_in_segment_2;
  wire             cpu_0_data_master_byteenable_main_clock_0_in_segment_3;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_main_clock_0_in;
  wire             cpu_0_data_master_qualified_request_main_clock_0_in;
  wire             cpu_0_data_master_read_data_valid_main_clock_0_in;
  wire             cpu_0_data_master_requests_main_clock_0_in;
  wire             cpu_0_data_master_saved_grant_main_clock_0_in;
  reg              d1_main_clock_0_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_main_clock_0_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             main_clock_0_in_address;
  wire             main_clock_0_in_allgrants;
  wire             main_clock_0_in_allow_new_arb_cycle;
  wire             main_clock_0_in_any_bursting_master_saved_grant;
  wire             main_clock_0_in_any_continuerequest;
  wire             main_clock_0_in_arb_counter_enable;
  reg     [  2: 0] main_clock_0_in_arb_share_counter;
  wire    [  2: 0] main_clock_0_in_arb_share_counter_next_value;
  wire    [  2: 0] main_clock_0_in_arb_share_set_values;
  wire             main_clock_0_in_beginbursttransfer_internal;
  wire             main_clock_0_in_begins_xfer;
  wire             main_clock_0_in_end_xfer;
  wire             main_clock_0_in_endofpacket_from_sa;
  wire             main_clock_0_in_firsttransfer;
  wire             main_clock_0_in_grant_vector;
  wire             main_clock_0_in_in_a_read_cycle;
  wire             main_clock_0_in_in_a_write_cycle;
  wire             main_clock_0_in_master_qreq_vector;
  wire             main_clock_0_in_nativeaddress;
  wire             main_clock_0_in_non_bursting_master_requests;
  wire             main_clock_0_in_pretend_byte_enable;
  wire             main_clock_0_in_read;
  wire    [  7: 0] main_clock_0_in_readdata_from_sa;
  reg              main_clock_0_in_reg_firsttransfer;
  wire             main_clock_0_in_reset_n;
  reg              main_clock_0_in_slavearbiterlockenable;
  wire             main_clock_0_in_slavearbiterlockenable2;
  wire             main_clock_0_in_unreg_firsttransfer;
  wire             main_clock_0_in_waitrequest_from_sa;
  wire             main_clock_0_in_waits_for_read;
  wire             main_clock_0_in_waits_for_write;
  wire             main_clock_0_in_write;
  wire    [  7: 0] main_clock_0_in_writedata;
  wire             wait_for_main_clock_0_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~main_clock_0_in_end_xfer;
    end


  assign main_clock_0_in_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_main_clock_0_in));
  //assign main_clock_0_in_readdata_from_sa = main_clock_0_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign main_clock_0_in_readdata_from_sa = main_clock_0_in_readdata;

  assign cpu_0_data_master_requests_main_clock_0_in = ({cpu_0_data_master_address_to_slave[24 : 1] , 1'b0} == 25'h1111470) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign main_clock_0_in_waitrequest_from_sa = main_clock_0_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign main_clock_0_in_waitrequest_from_sa = main_clock_0_in_waitrequest;

  //main_clock_0_in_arb_share_counter set values, which is an e_mux
  assign main_clock_0_in_arb_share_set_values = (cpu_0_data_master_granted_main_clock_0_in)? 4 :
    1;

  //main_clock_0_in_non_bursting_master_requests mux, which is an e_mux
  assign main_clock_0_in_non_bursting_master_requests = cpu_0_data_master_requests_main_clock_0_in;

  //main_clock_0_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign main_clock_0_in_any_bursting_master_saved_grant = 0;

  //main_clock_0_in_arb_share_counter_next_value assignment, which is an e_assign
  assign main_clock_0_in_arb_share_counter_next_value = main_clock_0_in_firsttransfer ? (main_clock_0_in_arb_share_set_values - 1) : |main_clock_0_in_arb_share_counter ? (main_clock_0_in_arb_share_counter - 1) : 0;

  //main_clock_0_in_allgrants all slave grants, which is an e_mux
  assign main_clock_0_in_allgrants = |main_clock_0_in_grant_vector;

  //main_clock_0_in_end_xfer assignment, which is an e_assign
  assign main_clock_0_in_end_xfer = ~(main_clock_0_in_waits_for_read | main_clock_0_in_waits_for_write);

  //end_xfer_arb_share_counter_term_main_clock_0_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_main_clock_0_in = main_clock_0_in_end_xfer & (~main_clock_0_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //main_clock_0_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign main_clock_0_in_arb_counter_enable = (end_xfer_arb_share_counter_term_main_clock_0_in & main_clock_0_in_allgrants) | (end_xfer_arb_share_counter_term_main_clock_0_in & ~main_clock_0_in_non_bursting_master_requests);

  //main_clock_0_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_in_arb_share_counter <= 0;
      else if (main_clock_0_in_arb_counter_enable)
          main_clock_0_in_arb_share_counter <= main_clock_0_in_arb_share_counter_next_value;
    end


  //main_clock_0_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_in_slavearbiterlockenable <= 0;
      else if ((|main_clock_0_in_master_qreq_vector & end_xfer_arb_share_counter_term_main_clock_0_in) | (end_xfer_arb_share_counter_term_main_clock_0_in & ~main_clock_0_in_non_bursting_master_requests))
          main_clock_0_in_slavearbiterlockenable <= |main_clock_0_in_arb_share_counter_next_value;
    end


  //cpu_0/data_master main_clock_0/in arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = main_clock_0_in_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //main_clock_0_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign main_clock_0_in_slavearbiterlockenable2 = |main_clock_0_in_arb_share_counter_next_value;

  //cpu_0/data_master main_clock_0/in arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = main_clock_0_in_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //main_clock_0_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign main_clock_0_in_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_main_clock_0_in = cpu_0_data_master_requests_main_clock_0_in & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((!cpu_0_data_master_byteenable_main_clock_0_in) & cpu_0_data_master_write));
  //local readdatavalid cpu_0_data_master_read_data_valid_main_clock_0_in, which is an e_mux
  assign cpu_0_data_master_read_data_valid_main_clock_0_in = cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_read & ~main_clock_0_in_waits_for_read;

  //main_clock_0_in_writedata mux, which is an e_mux
  assign main_clock_0_in_writedata = cpu_0_data_master_dbs_write_8;

  //assign main_clock_0_in_endofpacket_from_sa = main_clock_0_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign main_clock_0_in_endofpacket_from_sa = main_clock_0_in_endofpacket;

  //master is always granted when requested
  assign cpu_0_data_master_granted_main_clock_0_in = cpu_0_data_master_qualified_request_main_clock_0_in;

  //cpu_0/data_master saved-grant main_clock_0/in, which is an e_assign
  assign cpu_0_data_master_saved_grant_main_clock_0_in = cpu_0_data_master_requests_main_clock_0_in;

  //allow new arb cycle for main_clock_0/in, which is an e_assign
  assign main_clock_0_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign main_clock_0_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign main_clock_0_in_master_qreq_vector = 1;

  //main_clock_0_in_reset_n assignment, which is an e_assign
  assign main_clock_0_in_reset_n = reset_n;

  //main_clock_0_in_firsttransfer first transaction, which is an e_assign
  assign main_clock_0_in_firsttransfer = main_clock_0_in_begins_xfer ? main_clock_0_in_unreg_firsttransfer : main_clock_0_in_reg_firsttransfer;

  //main_clock_0_in_unreg_firsttransfer first transaction, which is an e_assign
  assign main_clock_0_in_unreg_firsttransfer = ~(main_clock_0_in_slavearbiterlockenable & main_clock_0_in_any_continuerequest);

  //main_clock_0_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_in_reg_firsttransfer <= 1'b1;
      else if (main_clock_0_in_begins_xfer)
          main_clock_0_in_reg_firsttransfer <= main_clock_0_in_unreg_firsttransfer;
    end


  //main_clock_0_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign main_clock_0_in_beginbursttransfer_internal = main_clock_0_in_begins_xfer;

  //main_clock_0_in_read assignment, which is an e_mux
  assign main_clock_0_in_read = cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_read;

  //main_clock_0_in_write assignment, which is an e_mux
  assign main_clock_0_in_write = ((cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_write)) & main_clock_0_in_pretend_byte_enable;

  //main_clock_0_in_address mux, which is an e_mux
  assign main_clock_0_in_address = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1 : 0]};

  //slaveid main_clock_0_in_nativeaddress nativeaddress mux, which is an e_mux
  assign main_clock_0_in_nativeaddress = cpu_0_data_master_address_to_slave >> 2;

  //d1_main_clock_0_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_main_clock_0_in_end_xfer <= 1;
      else 
        d1_main_clock_0_in_end_xfer <= main_clock_0_in_end_xfer;
    end


  //main_clock_0_in_waits_for_read in a cycle, which is an e_mux
  assign main_clock_0_in_waits_for_read = main_clock_0_in_in_a_read_cycle & main_clock_0_in_waitrequest_from_sa;

  //main_clock_0_in_in_a_read_cycle assignment, which is an e_assign
  assign main_clock_0_in_in_a_read_cycle = cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = main_clock_0_in_in_a_read_cycle;

  //main_clock_0_in_waits_for_write in a cycle, which is an e_mux
  assign main_clock_0_in_waits_for_write = main_clock_0_in_in_a_write_cycle & main_clock_0_in_waitrequest_from_sa;

  //main_clock_0_in_in_a_write_cycle assignment, which is an e_assign
  assign main_clock_0_in_in_a_write_cycle = cpu_0_data_master_granted_main_clock_0_in & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = main_clock_0_in_in_a_write_cycle;

  assign wait_for_main_clock_0_in_counter = 0;
  //main_clock_0_in_pretend_byte_enable byte enable port mux, which is an e_mux
  assign main_clock_0_in_pretend_byte_enable = (cpu_0_data_master_granted_main_clock_0_in)? cpu_0_data_master_byteenable_main_clock_0_in :
    -1;

  assign {cpu_0_data_master_byteenable_main_clock_0_in_segment_3,
cpu_0_data_master_byteenable_main_clock_0_in_segment_2,
cpu_0_data_master_byteenable_main_clock_0_in_segment_1,
cpu_0_data_master_byteenable_main_clock_0_in_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_main_clock_0_in = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_byteenable_main_clock_0_in_segment_0 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_byteenable_main_clock_0_in_segment_1 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_byteenable_main_clock_0_in_segment_2 :
    cpu_0_data_master_byteenable_main_clock_0_in_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //main_clock_0/in enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main_clock_0_out_arbitrator (
                                     // inputs:
                                      clk,
                                      clocks_0_avalon_clocks_slave_readdata_from_sa,
                                      d1_clocks_0_avalon_clocks_slave_end_xfer,
                                      main_clock_0_out_address,
                                      main_clock_0_out_granted_clocks_0_avalon_clocks_slave,
                                      main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave,
                                      main_clock_0_out_read,
                                      main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave,
                                      main_clock_0_out_requests_clocks_0_avalon_clocks_slave,
                                      main_clock_0_out_write,
                                      main_clock_0_out_writedata,
                                      reset_n,

                                     // outputs:
                                      main_clock_0_out_address_to_slave,
                                      main_clock_0_out_readdata,
                                      main_clock_0_out_reset_n,
                                      main_clock_0_out_waitrequest
                                   )
;

  output           main_clock_0_out_address_to_slave;
  output  [  7: 0] main_clock_0_out_readdata;
  output           main_clock_0_out_reset_n;
  output           main_clock_0_out_waitrequest;
  input            clk;
  input   [  7: 0] clocks_0_avalon_clocks_slave_readdata_from_sa;
  input            d1_clocks_0_avalon_clocks_slave_end_xfer;
  input            main_clock_0_out_address;
  input            main_clock_0_out_granted_clocks_0_avalon_clocks_slave;
  input            main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave;
  input            main_clock_0_out_read;
  input            main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave;
  input            main_clock_0_out_requests_clocks_0_avalon_clocks_slave;
  input            main_clock_0_out_write;
  input   [  7: 0] main_clock_0_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg              main_clock_0_out_address_last_time;
  wire             main_clock_0_out_address_to_slave;
  reg              main_clock_0_out_read_last_time;
  wire    [  7: 0] main_clock_0_out_readdata;
  wire             main_clock_0_out_reset_n;
  wire             main_clock_0_out_run;
  wire             main_clock_0_out_waitrequest;
  reg              main_clock_0_out_write_last_time;
  reg     [  7: 0] main_clock_0_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave | main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave | ~main_clock_0_out_requests_clocks_0_avalon_clocks_slave) & ((~main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave | ~main_clock_0_out_read | (main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave & main_clock_0_out_read))) & ((~main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave | ~(main_clock_0_out_read | main_clock_0_out_write) | (1 & (main_clock_0_out_read | main_clock_0_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign main_clock_0_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign main_clock_0_out_address_to_slave = main_clock_0_out_address;

  //main_clock_0/out readdata mux, which is an e_mux
  assign main_clock_0_out_readdata = clocks_0_avalon_clocks_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign main_clock_0_out_waitrequest = ~main_clock_0_out_run;

  //main_clock_0_out_reset_n assignment, which is an e_assign
  assign main_clock_0_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //main_clock_0_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_out_address_last_time <= 0;
      else 
        main_clock_0_out_address_last_time <= main_clock_0_out_address;
    end


  //main_clock_0/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= main_clock_0_out_waitrequest & (main_clock_0_out_read | main_clock_0_out_write);
    end


  //main_clock_0_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (main_clock_0_out_address != main_clock_0_out_address_last_time))
        begin
          $write("%0d ns: main_clock_0_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //main_clock_0_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_out_read_last_time <= 0;
      else 
        main_clock_0_out_read_last_time <= main_clock_0_out_read;
    end


  //main_clock_0_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (main_clock_0_out_read != main_clock_0_out_read_last_time))
        begin
          $write("%0d ns: main_clock_0_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //main_clock_0_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_out_write_last_time <= 0;
      else 
        main_clock_0_out_write_last_time <= main_clock_0_out_write;
    end


  //main_clock_0_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (main_clock_0_out_write != main_clock_0_out_write_last_time))
        begin
          $write("%0d ns: main_clock_0_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //main_clock_0_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          main_clock_0_out_writedata_last_time <= 0;
      else 
        main_clock_0_out_writedata_last_time <= main_clock_0_out_writedata;
    end


  //main_clock_0_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (main_clock_0_out_writedata != main_clock_0_out_writedata_last_time) & main_clock_0_out_write)
        begin
          $write("%0d ns: main_clock_0_out_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module onchip_memory2_0_s1_arbitrator (
                                        // inputs:
                                         clk,
                                         cpu_0_data_master_address_to_slave,
                                         cpu_0_data_master_byteenable,
                                         cpu_0_data_master_latency_counter,
                                         cpu_0_data_master_read,
                                         cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                         cpu_0_data_master_write,
                                         cpu_0_data_master_writedata,
                                         cpu_0_instruction_master_address_to_slave,
                                         cpu_0_instruction_master_latency_counter,
                                         cpu_0_instruction_master_read,
                                         cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                         onchip_memory2_0_s1_readdata,
                                         reset_n,

                                        // outputs:
                                         cpu_0_data_master_granted_onchip_memory2_0_s1,
                                         cpu_0_data_master_qualified_request_onchip_memory2_0_s1,
                                         cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
                                         cpu_0_data_master_requests_onchip_memory2_0_s1,
                                         cpu_0_instruction_master_granted_onchip_memory2_0_s1,
                                         cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1,
                                         cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1,
                                         cpu_0_instruction_master_requests_onchip_memory2_0_s1,
                                         d1_onchip_memory2_0_s1_end_xfer,
                                         onchip_memory2_0_s1_address,
                                         onchip_memory2_0_s1_byteenable,
                                         onchip_memory2_0_s1_chipselect,
                                         onchip_memory2_0_s1_clken,
                                         onchip_memory2_0_s1_readdata_from_sa,
                                         onchip_memory2_0_s1_reset,
                                         onchip_memory2_0_s1_write,
                                         onchip_memory2_0_s1_writedata
                                      )
;

  output           cpu_0_data_master_granted_onchip_memory2_0_s1;
  output           cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  output           cpu_0_data_master_read_data_valid_onchip_memory2_0_s1;
  output           cpu_0_data_master_requests_onchip_memory2_0_s1;
  output           cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  output           cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  output           cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1;
  output           cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  output           d1_onchip_memory2_0_s1_end_xfer;
  output  [ 12: 0] onchip_memory2_0_s1_address;
  output  [  3: 0] onchip_memory2_0_s1_byteenable;
  output           onchip_memory2_0_s1_chipselect;
  output           onchip_memory2_0_s1_clken;
  output  [ 31: 0] onchip_memory2_0_s1_readdata_from_sa;
  output           onchip_memory2_0_s1_reset;
  output           onchip_memory2_0_s1_write;
  output  [ 31: 0] onchip_memory2_0_s1_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 24: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input   [ 31: 0] onchip_memory2_0_s1_readdata;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_onchip_memory2_0_s1;
  wire             cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  wire             cpu_0_data_master_read_data_valid_onchip_memory2_0_s1;
  reg              cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in;
  wire             cpu_0_data_master_requests_onchip_memory2_0_s1;
  wire             cpu_0_data_master_saved_grant_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1;
  reg              cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  wire             cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in;
  wire             cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1;
  reg              d1_onchip_memory2_0_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_onchip_memory2_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1;
  wire    [ 12: 0] onchip_memory2_0_s1_address;
  wire             onchip_memory2_0_s1_allgrants;
  wire             onchip_memory2_0_s1_allow_new_arb_cycle;
  wire             onchip_memory2_0_s1_any_bursting_master_saved_grant;
  wire             onchip_memory2_0_s1_any_continuerequest;
  reg     [  1: 0] onchip_memory2_0_s1_arb_addend;
  wire             onchip_memory2_0_s1_arb_counter_enable;
  reg     [  2: 0] onchip_memory2_0_s1_arb_share_counter;
  wire    [  2: 0] onchip_memory2_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] onchip_memory2_0_s1_arb_share_set_values;
  wire    [  1: 0] onchip_memory2_0_s1_arb_winner;
  wire             onchip_memory2_0_s1_arbitration_holdoff_internal;
  wire             onchip_memory2_0_s1_beginbursttransfer_internal;
  wire             onchip_memory2_0_s1_begins_xfer;
  wire    [  3: 0] onchip_memory2_0_s1_byteenable;
  wire             onchip_memory2_0_s1_chipselect;
  wire    [  3: 0] onchip_memory2_0_s1_chosen_master_double_vector;
  wire    [  1: 0] onchip_memory2_0_s1_chosen_master_rot_left;
  wire             onchip_memory2_0_s1_clken;
  wire             onchip_memory2_0_s1_end_xfer;
  wire             onchip_memory2_0_s1_firsttransfer;
  wire    [  1: 0] onchip_memory2_0_s1_grant_vector;
  wire             onchip_memory2_0_s1_in_a_read_cycle;
  wire             onchip_memory2_0_s1_in_a_write_cycle;
  wire    [  1: 0] onchip_memory2_0_s1_master_qreq_vector;
  wire             onchip_memory2_0_s1_non_bursting_master_requests;
  wire    [ 31: 0] onchip_memory2_0_s1_readdata_from_sa;
  reg              onchip_memory2_0_s1_reg_firsttransfer;
  wire             onchip_memory2_0_s1_reset;
  reg     [  1: 0] onchip_memory2_0_s1_saved_chosen_master_vector;
  reg              onchip_memory2_0_s1_slavearbiterlockenable;
  wire             onchip_memory2_0_s1_slavearbiterlockenable2;
  wire             onchip_memory2_0_s1_unreg_firsttransfer;
  wire             onchip_memory2_0_s1_waits_for_read;
  wire             onchip_memory2_0_s1_waits_for_write;
  wire             onchip_memory2_0_s1_write;
  wire    [ 31: 0] onchip_memory2_0_s1_writedata;
  wire             p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  wire             p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  wire    [ 24: 0] shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master;
  wire    [ 24: 0] shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master;
  wire             wait_for_onchip_memory2_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~onchip_memory2_0_s1_end_xfer;
    end


  assign onchip_memory2_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_onchip_memory2_0_s1 | cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1));
  //assign onchip_memory2_0_s1_readdata_from_sa = onchip_memory2_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign onchip_memory2_0_s1_readdata_from_sa = onchip_memory2_0_s1_readdata;

  assign cpu_0_data_master_requests_onchip_memory2_0_s1 = ({cpu_0_data_master_address_to_slave[24 : 15] , 15'b0} == 25'h1108000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //onchip_memory2_0_s1_arb_share_counter set values, which is an e_mux
  assign onchip_memory2_0_s1_arb_share_set_values = 1;

  //onchip_memory2_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign onchip_memory2_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_onchip_memory2_0_s1 |
    cpu_0_instruction_master_requests_onchip_memory2_0_s1 |
    cpu_0_data_master_requests_onchip_memory2_0_s1 |
    cpu_0_instruction_master_requests_onchip_memory2_0_s1;

  //onchip_memory2_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign onchip_memory2_0_s1_any_bursting_master_saved_grant = 0;

  //onchip_memory2_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign onchip_memory2_0_s1_arb_share_counter_next_value = onchip_memory2_0_s1_firsttransfer ? (onchip_memory2_0_s1_arb_share_set_values - 1) : |onchip_memory2_0_s1_arb_share_counter ? (onchip_memory2_0_s1_arb_share_counter - 1) : 0;

  //onchip_memory2_0_s1_allgrants all slave grants, which is an e_mux
  assign onchip_memory2_0_s1_allgrants = (|onchip_memory2_0_s1_grant_vector) |
    (|onchip_memory2_0_s1_grant_vector) |
    (|onchip_memory2_0_s1_grant_vector) |
    (|onchip_memory2_0_s1_grant_vector);

  //onchip_memory2_0_s1_end_xfer assignment, which is an e_assign
  assign onchip_memory2_0_s1_end_xfer = ~(onchip_memory2_0_s1_waits_for_read | onchip_memory2_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_onchip_memory2_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_onchip_memory2_0_s1 = onchip_memory2_0_s1_end_xfer & (~onchip_memory2_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //onchip_memory2_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign onchip_memory2_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_onchip_memory2_0_s1 & onchip_memory2_0_s1_allgrants) | (end_xfer_arb_share_counter_term_onchip_memory2_0_s1 & ~onchip_memory2_0_s1_non_bursting_master_requests);

  //onchip_memory2_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory2_0_s1_arb_share_counter <= 0;
      else if (onchip_memory2_0_s1_arb_counter_enable)
          onchip_memory2_0_s1_arb_share_counter <= onchip_memory2_0_s1_arb_share_counter_next_value;
    end


  //onchip_memory2_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory2_0_s1_slavearbiterlockenable <= 0;
      else if ((|onchip_memory2_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_onchip_memory2_0_s1) | (end_xfer_arb_share_counter_term_onchip_memory2_0_s1 & ~onchip_memory2_0_s1_non_bursting_master_requests))
          onchip_memory2_0_s1_slavearbiterlockenable <= |onchip_memory2_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master onchip_memory2_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = onchip_memory2_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //onchip_memory2_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign onchip_memory2_0_s1_slavearbiterlockenable2 = |onchip_memory2_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master onchip_memory2_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = onchip_memory2_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master onchip_memory2_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = onchip_memory2_0_s1_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master onchip_memory2_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = onchip_memory2_0_s1_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted onchip_memory2_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 <= cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1 ? 1 : (onchip_memory2_0_s1_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_onchip_memory2_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 & cpu_0_instruction_master_requests_onchip_memory2_0_s1;

  //onchip_memory2_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign onchip_memory2_0_s1_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_onchip_memory2_0_s1 = cpu_0_data_master_requests_onchip_memory2_0_s1 & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_instruction_master_arbiterlock);
  //cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in = cpu_0_data_master_granted_onchip_memory2_0_s1 & cpu_0_data_master_read & ~onchip_memory2_0_s1_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register = {cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register, cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in};

  //cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register <= p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_onchip_memory2_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 = cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;

  //onchip_memory2_0_s1_writedata mux, which is an e_mux
  assign onchip_memory2_0_s1_writedata = cpu_0_data_master_writedata;

  //mux onchip_memory2_0_s1_clken, which is an e_mux
  assign onchip_memory2_0_s1_clken = 1'b1;

  assign cpu_0_instruction_master_requests_onchip_memory2_0_s1 = (({cpu_0_instruction_master_address_to_slave[24 : 15] , 15'b0} == 25'h1108000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted onchip_memory2_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 <= cpu_0_data_master_saved_grant_onchip_memory2_0_s1 ? 1 : (onchip_memory2_0_s1_arbitration_holdoff_internal | ~cpu_0_data_master_requests_onchip_memory2_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 & cpu_0_data_master_requests_onchip_memory2_0_s1;

  assign cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 = cpu_0_instruction_master_requests_onchip_memory2_0_s1 & ~((cpu_0_instruction_master_read & ((1 < cpu_0_instruction_master_latency_counter) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in = cpu_0_instruction_master_granted_onchip_memory2_0_s1 & cpu_0_instruction_master_read & ~onchip_memory2_0_s1_waits_for_read;

  //shift register p1 cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register = {cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register, cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in};

  //cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register <= 0;
      else 
        cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register <= p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 = cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;

  //allow new arb cycle for onchip_memory2_0/s1, which is an e_assign
  assign onchip_memory2_0_s1_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for onchip_memory2_0/s1, which is an e_assign
  assign onchip_memory2_0_s1_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;

  //cpu_0/instruction_master grant onchip_memory2_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_onchip_memory2_0_s1 = onchip_memory2_0_s1_grant_vector[0];

  //cpu_0/instruction_master saved-grant onchip_memory2_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1 = onchip_memory2_0_s1_arb_winner[0] && cpu_0_instruction_master_requests_onchip_memory2_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for onchip_memory2_0/s1, which is an e_assign
  assign onchip_memory2_0_s1_master_qreq_vector[1] = cpu_0_data_master_qualified_request_onchip_memory2_0_s1;

  //cpu_0/data_master grant onchip_memory2_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_onchip_memory2_0_s1 = onchip_memory2_0_s1_grant_vector[1];

  //cpu_0/data_master saved-grant onchip_memory2_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_onchip_memory2_0_s1 = onchip_memory2_0_s1_arb_winner[1] && cpu_0_data_master_requests_onchip_memory2_0_s1;

  //onchip_memory2_0/s1 chosen-master double-vector, which is an e_assign
  assign onchip_memory2_0_s1_chosen_master_double_vector = {onchip_memory2_0_s1_master_qreq_vector, onchip_memory2_0_s1_master_qreq_vector} & ({~onchip_memory2_0_s1_master_qreq_vector, ~onchip_memory2_0_s1_master_qreq_vector} + onchip_memory2_0_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign onchip_memory2_0_s1_arb_winner = (onchip_memory2_0_s1_allow_new_arb_cycle & | onchip_memory2_0_s1_grant_vector) ? onchip_memory2_0_s1_grant_vector : onchip_memory2_0_s1_saved_chosen_master_vector;

  //saved onchip_memory2_0_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory2_0_s1_saved_chosen_master_vector <= 0;
      else if (onchip_memory2_0_s1_allow_new_arb_cycle)
          onchip_memory2_0_s1_saved_chosen_master_vector <= |onchip_memory2_0_s1_grant_vector ? onchip_memory2_0_s1_grant_vector : onchip_memory2_0_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign onchip_memory2_0_s1_grant_vector = {(onchip_memory2_0_s1_chosen_master_double_vector[1] | onchip_memory2_0_s1_chosen_master_double_vector[3]),
    (onchip_memory2_0_s1_chosen_master_double_vector[0] | onchip_memory2_0_s1_chosen_master_double_vector[2])};

  //onchip_memory2_0/s1 chosen master rotated left, which is an e_assign
  assign onchip_memory2_0_s1_chosen_master_rot_left = (onchip_memory2_0_s1_arb_winner << 1) ? (onchip_memory2_0_s1_arb_winner << 1) : 1;

  //onchip_memory2_0/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory2_0_s1_arb_addend <= 1;
      else if (|onchip_memory2_0_s1_grant_vector)
          onchip_memory2_0_s1_arb_addend <= onchip_memory2_0_s1_end_xfer? onchip_memory2_0_s1_chosen_master_rot_left : onchip_memory2_0_s1_grant_vector;
    end


  //~onchip_memory2_0_s1_reset assignment, which is an e_assign
  assign onchip_memory2_0_s1_reset = ~reset_n;

  assign onchip_memory2_0_s1_chipselect = cpu_0_data_master_granted_onchip_memory2_0_s1 | cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  //onchip_memory2_0_s1_firsttransfer first transaction, which is an e_assign
  assign onchip_memory2_0_s1_firsttransfer = onchip_memory2_0_s1_begins_xfer ? onchip_memory2_0_s1_unreg_firsttransfer : onchip_memory2_0_s1_reg_firsttransfer;

  //onchip_memory2_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign onchip_memory2_0_s1_unreg_firsttransfer = ~(onchip_memory2_0_s1_slavearbiterlockenable & onchip_memory2_0_s1_any_continuerequest);

  //onchip_memory2_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory2_0_s1_reg_firsttransfer <= 1'b1;
      else if (onchip_memory2_0_s1_begins_xfer)
          onchip_memory2_0_s1_reg_firsttransfer <= onchip_memory2_0_s1_unreg_firsttransfer;
    end


  //onchip_memory2_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign onchip_memory2_0_s1_beginbursttransfer_internal = onchip_memory2_0_s1_begins_xfer;

  //onchip_memory2_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign onchip_memory2_0_s1_arbitration_holdoff_internal = onchip_memory2_0_s1_begins_xfer & onchip_memory2_0_s1_firsttransfer;

  //onchip_memory2_0_s1_write assignment, which is an e_mux
  assign onchip_memory2_0_s1_write = cpu_0_data_master_granted_onchip_memory2_0_s1 & cpu_0_data_master_write;

  assign shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //onchip_memory2_0_s1_address mux, which is an e_mux
  assign onchip_memory2_0_s1_address = (cpu_0_data_master_granted_onchip_memory2_0_s1)? (shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master >> 2) :
    (shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master >> 2);

  assign shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master = cpu_0_instruction_master_address_to_slave;
  //d1_onchip_memory2_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_onchip_memory2_0_s1_end_xfer <= 1;
      else 
        d1_onchip_memory2_0_s1_end_xfer <= onchip_memory2_0_s1_end_xfer;
    end


  //onchip_memory2_0_s1_waits_for_read in a cycle, which is an e_mux
  assign onchip_memory2_0_s1_waits_for_read = onchip_memory2_0_s1_in_a_read_cycle & 0;

  //onchip_memory2_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign onchip_memory2_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_onchip_memory2_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_onchip_memory2_0_s1 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = onchip_memory2_0_s1_in_a_read_cycle;

  //onchip_memory2_0_s1_waits_for_write in a cycle, which is an e_mux
  assign onchip_memory2_0_s1_waits_for_write = onchip_memory2_0_s1_in_a_write_cycle & 0;

  //onchip_memory2_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign onchip_memory2_0_s1_in_a_write_cycle = cpu_0_data_master_granted_onchip_memory2_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = onchip_memory2_0_s1_in_a_write_cycle;

  assign wait_for_onchip_memory2_0_s1_counter = 0;
  //onchip_memory2_0_s1_byteenable byte enable port mux, which is an e_mux
  assign onchip_memory2_0_s1_byteenable = (cpu_0_data_master_granted_onchip_memory2_0_s1)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //onchip_memory2_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_onchip_memory2_0_s1 + cpu_0_instruction_master_granted_onchip_memory2_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_onchip_memory2_0_s1 + cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module red_leds_avalon_parallel_port_slave_arbitrator (
                                                        // inputs:
                                                         clk,
                                                         cpu_0_data_master_address_to_slave,
                                                         cpu_0_data_master_byteenable,
                                                         cpu_0_data_master_latency_counter,
                                                         cpu_0_data_master_read,
                                                         cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                         cpu_0_data_master_write,
                                                         cpu_0_data_master_writedata,
                                                         red_leds_avalon_parallel_port_slave_readdata,
                                                         reset_n,

                                                        // outputs:
                                                         cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave,
                                                         cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave,
                                                         cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave,
                                                         cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave,
                                                         d1_red_leds_avalon_parallel_port_slave_end_xfer,
                                                         red_leds_avalon_parallel_port_slave_address,
                                                         red_leds_avalon_parallel_port_slave_byteenable,
                                                         red_leds_avalon_parallel_port_slave_chipselect,
                                                         red_leds_avalon_parallel_port_slave_read,
                                                         red_leds_avalon_parallel_port_slave_readdata_from_sa,
                                                         red_leds_avalon_parallel_port_slave_reset,
                                                         red_leds_avalon_parallel_port_slave_write,
                                                         red_leds_avalon_parallel_port_slave_writedata
                                                      )
;

  output           cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave;
  output           cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave;
  output           cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave;
  output           cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;
  output           d1_red_leds_avalon_parallel_port_slave_end_xfer;
  output  [  1: 0] red_leds_avalon_parallel_port_slave_address;
  output  [  3: 0] red_leds_avalon_parallel_port_slave_byteenable;
  output           red_leds_avalon_parallel_port_slave_chipselect;
  output           red_leds_avalon_parallel_port_slave_read;
  output  [ 31: 0] red_leds_avalon_parallel_port_slave_readdata_from_sa;
  output           red_leds_avalon_parallel_port_slave_reset;
  output           red_leds_avalon_parallel_port_slave_write;
  output  [ 31: 0] red_leds_avalon_parallel_port_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 31: 0] red_leds_avalon_parallel_port_slave_readdata;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave;
  reg              cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register_in;
  wire             cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_saved_grant_red_leds_avalon_parallel_port_slave;
  reg              d1_reasons_to_wait;
  reg              d1_red_leds_avalon_parallel_port_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register;
  wire    [  1: 0] red_leds_avalon_parallel_port_slave_address;
  wire             red_leds_avalon_parallel_port_slave_allgrants;
  wire             red_leds_avalon_parallel_port_slave_allow_new_arb_cycle;
  wire             red_leds_avalon_parallel_port_slave_any_bursting_master_saved_grant;
  wire             red_leds_avalon_parallel_port_slave_any_continuerequest;
  wire             red_leds_avalon_parallel_port_slave_arb_counter_enable;
  reg     [  2: 0] red_leds_avalon_parallel_port_slave_arb_share_counter;
  wire    [  2: 0] red_leds_avalon_parallel_port_slave_arb_share_counter_next_value;
  wire    [  2: 0] red_leds_avalon_parallel_port_slave_arb_share_set_values;
  wire             red_leds_avalon_parallel_port_slave_beginbursttransfer_internal;
  wire             red_leds_avalon_parallel_port_slave_begins_xfer;
  wire    [  3: 0] red_leds_avalon_parallel_port_slave_byteenable;
  wire             red_leds_avalon_parallel_port_slave_chipselect;
  wire             red_leds_avalon_parallel_port_slave_end_xfer;
  wire             red_leds_avalon_parallel_port_slave_firsttransfer;
  wire             red_leds_avalon_parallel_port_slave_grant_vector;
  wire             red_leds_avalon_parallel_port_slave_in_a_read_cycle;
  wire             red_leds_avalon_parallel_port_slave_in_a_write_cycle;
  wire             red_leds_avalon_parallel_port_slave_master_qreq_vector;
  wire             red_leds_avalon_parallel_port_slave_non_bursting_master_requests;
  wire             red_leds_avalon_parallel_port_slave_read;
  wire    [ 31: 0] red_leds_avalon_parallel_port_slave_readdata_from_sa;
  reg              red_leds_avalon_parallel_port_slave_reg_firsttransfer;
  wire             red_leds_avalon_parallel_port_slave_reset;
  reg              red_leds_avalon_parallel_port_slave_slavearbiterlockenable;
  wire             red_leds_avalon_parallel_port_slave_slavearbiterlockenable2;
  wire             red_leds_avalon_parallel_port_slave_unreg_firsttransfer;
  wire             red_leds_avalon_parallel_port_slave_waits_for_read;
  wire             red_leds_avalon_parallel_port_slave_waits_for_write;
  wire             red_leds_avalon_parallel_port_slave_write;
  wire    [ 31: 0] red_leds_avalon_parallel_port_slave_writedata;
  wire    [ 24: 0] shifted_address_to_red_leds_avalon_parallel_port_slave_from_cpu_0_data_master;
  wire             wait_for_red_leds_avalon_parallel_port_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~red_leds_avalon_parallel_port_slave_end_xfer;
    end


  assign red_leds_avalon_parallel_port_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave));
  //assign red_leds_avalon_parallel_port_slave_readdata_from_sa = red_leds_avalon_parallel_port_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_readdata_from_sa = red_leds_avalon_parallel_port_slave_readdata;

  assign cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111410) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //red_leds_avalon_parallel_port_slave_arb_share_counter set values, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_arb_share_set_values = 1;

  //red_leds_avalon_parallel_port_slave_non_bursting_master_requests mux, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_non_bursting_master_requests = cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;

  //red_leds_avalon_parallel_port_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_any_bursting_master_saved_grant = 0;

  //red_leds_avalon_parallel_port_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_arb_share_counter_next_value = red_leds_avalon_parallel_port_slave_firsttransfer ? (red_leds_avalon_parallel_port_slave_arb_share_set_values - 1) : |red_leds_avalon_parallel_port_slave_arb_share_counter ? (red_leds_avalon_parallel_port_slave_arb_share_counter - 1) : 0;

  //red_leds_avalon_parallel_port_slave_allgrants all slave grants, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_allgrants = |red_leds_avalon_parallel_port_slave_grant_vector;

  //red_leds_avalon_parallel_port_slave_end_xfer assignment, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_end_xfer = ~(red_leds_avalon_parallel_port_slave_waits_for_read | red_leds_avalon_parallel_port_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave = red_leds_avalon_parallel_port_slave_end_xfer & (~red_leds_avalon_parallel_port_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //red_leds_avalon_parallel_port_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave & red_leds_avalon_parallel_port_slave_allgrants) | (end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave & ~red_leds_avalon_parallel_port_slave_non_bursting_master_requests);

  //red_leds_avalon_parallel_port_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          red_leds_avalon_parallel_port_slave_arb_share_counter <= 0;
      else if (red_leds_avalon_parallel_port_slave_arb_counter_enable)
          red_leds_avalon_parallel_port_slave_arb_share_counter <= red_leds_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //red_leds_avalon_parallel_port_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          red_leds_avalon_parallel_port_slave_slavearbiterlockenable <= 0;
      else if ((|red_leds_avalon_parallel_port_slave_master_qreq_vector & end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave) | (end_xfer_arb_share_counter_term_red_leds_avalon_parallel_port_slave & ~red_leds_avalon_parallel_port_slave_non_bursting_master_requests))
          red_leds_avalon_parallel_port_slave_slavearbiterlockenable <= |red_leds_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master red_leds/avalon_parallel_port_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = red_leds_avalon_parallel_port_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //red_leds_avalon_parallel_port_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_slavearbiterlockenable2 = |red_leds_avalon_parallel_port_slave_arb_share_counter_next_value;

  //cpu_0/data_master red_leds/avalon_parallel_port_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = red_leds_avalon_parallel_port_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //red_leds_avalon_parallel_port_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave = cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register_in = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave & cpu_0_data_master_read & ~red_leds_avalon_parallel_port_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register = {cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register, cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave = cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave_shift_register;

  //red_leds_avalon_parallel_port_slave_writedata mux, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave = cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave;

  //cpu_0/data_master saved-grant red_leds/avalon_parallel_port_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_red_leds_avalon_parallel_port_slave = cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;

  //allow new arb cycle for red_leds/avalon_parallel_port_slave, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign red_leds_avalon_parallel_port_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign red_leds_avalon_parallel_port_slave_master_qreq_vector = 1;

  //~red_leds_avalon_parallel_port_slave_reset assignment, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_reset = ~reset_n;

  assign red_leds_avalon_parallel_port_slave_chipselect = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave;
  //red_leds_avalon_parallel_port_slave_firsttransfer first transaction, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_firsttransfer = red_leds_avalon_parallel_port_slave_begins_xfer ? red_leds_avalon_parallel_port_slave_unreg_firsttransfer : red_leds_avalon_parallel_port_slave_reg_firsttransfer;

  //red_leds_avalon_parallel_port_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_unreg_firsttransfer = ~(red_leds_avalon_parallel_port_slave_slavearbiterlockenable & red_leds_avalon_parallel_port_slave_any_continuerequest);

  //red_leds_avalon_parallel_port_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          red_leds_avalon_parallel_port_slave_reg_firsttransfer <= 1'b1;
      else if (red_leds_avalon_parallel_port_slave_begins_xfer)
          red_leds_avalon_parallel_port_slave_reg_firsttransfer <= red_leds_avalon_parallel_port_slave_unreg_firsttransfer;
    end


  //red_leds_avalon_parallel_port_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_beginbursttransfer_internal = red_leds_avalon_parallel_port_slave_begins_xfer;

  //red_leds_avalon_parallel_port_slave_read assignment, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_read = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave & cpu_0_data_master_read;

  //red_leds_avalon_parallel_port_slave_write assignment, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_write = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave & cpu_0_data_master_write;

  assign shifted_address_to_red_leds_avalon_parallel_port_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //red_leds_avalon_parallel_port_slave_address mux, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_address = shifted_address_to_red_leds_avalon_parallel_port_slave_from_cpu_0_data_master >> 2;

  //d1_red_leds_avalon_parallel_port_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_red_leds_avalon_parallel_port_slave_end_xfer <= 1;
      else 
        d1_red_leds_avalon_parallel_port_slave_end_xfer <= red_leds_avalon_parallel_port_slave_end_xfer;
    end


  //red_leds_avalon_parallel_port_slave_waits_for_read in a cycle, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_waits_for_read = red_leds_avalon_parallel_port_slave_in_a_read_cycle & 0;

  //red_leds_avalon_parallel_port_slave_in_a_read_cycle assignment, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_in_a_read_cycle = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = red_leds_avalon_parallel_port_slave_in_a_read_cycle;

  //red_leds_avalon_parallel_port_slave_waits_for_write in a cycle, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_waits_for_write = red_leds_avalon_parallel_port_slave_in_a_write_cycle & 0;

  //red_leds_avalon_parallel_port_slave_in_a_write_cycle assignment, which is an e_assign
  assign red_leds_avalon_parallel_port_slave_in_a_write_cycle = cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = red_leds_avalon_parallel_port_slave_in_a_write_cycle;

  assign wait_for_red_leds_avalon_parallel_port_slave_counter = 0;
  //red_leds_avalon_parallel_port_slave_byteenable byte enable port mux, which is an e_mux
  assign red_leds_avalon_parallel_port_slave_byteenable = (cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //red_leds/avalon_parallel_port_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sd_card_0_avalon_sdcard_slave_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cpu_0_data_master_address_to_slave,
                                                   cpu_0_data_master_byteenable,
                                                   cpu_0_data_master_latency_counter,
                                                   cpu_0_data_master_read,
                                                   cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                   cpu_0_data_master_write,
                                                   cpu_0_data_master_writedata,
                                                   reset_n,
                                                   sd_card_0_avalon_sdcard_slave_readdata,
                                                   sd_card_0_avalon_sdcard_slave_waitrequest,

                                                  // outputs:
                                                   cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave,
                                                   cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave,
                                                   cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave,
                                                   cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave,
                                                   d1_sd_card_0_avalon_sdcard_slave_end_xfer,
                                                   sd_card_0_avalon_sdcard_slave_address,
                                                   sd_card_0_avalon_sdcard_slave_byteenable,
                                                   sd_card_0_avalon_sdcard_slave_chipselect,
                                                   sd_card_0_avalon_sdcard_slave_read,
                                                   sd_card_0_avalon_sdcard_slave_readdata_from_sa,
                                                   sd_card_0_avalon_sdcard_slave_reset_n,
                                                   sd_card_0_avalon_sdcard_slave_waitrequest_from_sa,
                                                   sd_card_0_avalon_sdcard_slave_write,
                                                   sd_card_0_avalon_sdcard_slave_writedata
                                                )
;

  output           cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave;
  output           cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave;
  output           cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave;
  output           cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;
  output           d1_sd_card_0_avalon_sdcard_slave_end_xfer;
  output  [  7: 0] sd_card_0_avalon_sdcard_slave_address;
  output  [  3: 0] sd_card_0_avalon_sdcard_slave_byteenable;
  output           sd_card_0_avalon_sdcard_slave_chipselect;
  output           sd_card_0_avalon_sdcard_slave_read;
  output  [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata_from_sa;
  output           sd_card_0_avalon_sdcard_slave_reset_n;
  output           sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;
  output           sd_card_0_avalon_sdcard_slave_write;
  output  [ 31: 0] sd_card_0_avalon_sdcard_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata;
  input            sd_card_0_avalon_sdcard_slave_waitrequest;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_saved_grant_sd_card_0_avalon_sdcard_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sd_card_0_avalon_sdcard_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  7: 0] sd_card_0_avalon_sdcard_slave_address;
  wire             sd_card_0_avalon_sdcard_slave_allgrants;
  wire             sd_card_0_avalon_sdcard_slave_allow_new_arb_cycle;
  wire             sd_card_0_avalon_sdcard_slave_any_bursting_master_saved_grant;
  wire             sd_card_0_avalon_sdcard_slave_any_continuerequest;
  wire             sd_card_0_avalon_sdcard_slave_arb_counter_enable;
  reg     [  2: 0] sd_card_0_avalon_sdcard_slave_arb_share_counter;
  wire    [  2: 0] sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value;
  wire    [  2: 0] sd_card_0_avalon_sdcard_slave_arb_share_set_values;
  wire             sd_card_0_avalon_sdcard_slave_beginbursttransfer_internal;
  wire             sd_card_0_avalon_sdcard_slave_begins_xfer;
  wire    [  3: 0] sd_card_0_avalon_sdcard_slave_byteenable;
  wire             sd_card_0_avalon_sdcard_slave_chipselect;
  wire             sd_card_0_avalon_sdcard_slave_end_xfer;
  wire             sd_card_0_avalon_sdcard_slave_firsttransfer;
  wire             sd_card_0_avalon_sdcard_slave_grant_vector;
  wire             sd_card_0_avalon_sdcard_slave_in_a_read_cycle;
  wire             sd_card_0_avalon_sdcard_slave_in_a_write_cycle;
  wire             sd_card_0_avalon_sdcard_slave_master_qreq_vector;
  wire             sd_card_0_avalon_sdcard_slave_non_bursting_master_requests;
  wire             sd_card_0_avalon_sdcard_slave_read;
  wire    [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata_from_sa;
  reg              sd_card_0_avalon_sdcard_slave_reg_firsttransfer;
  wire             sd_card_0_avalon_sdcard_slave_reset_n;
  reg              sd_card_0_avalon_sdcard_slave_slavearbiterlockenable;
  wire             sd_card_0_avalon_sdcard_slave_slavearbiterlockenable2;
  wire             sd_card_0_avalon_sdcard_slave_unreg_firsttransfer;
  wire             sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;
  wire             sd_card_0_avalon_sdcard_slave_waits_for_read;
  wire             sd_card_0_avalon_sdcard_slave_waits_for_write;
  wire             sd_card_0_avalon_sdcard_slave_write;
  wire    [ 31: 0] sd_card_0_avalon_sdcard_slave_writedata;
  wire    [ 24: 0] shifted_address_to_sd_card_0_avalon_sdcard_slave_from_cpu_0_data_master;
  wire             wait_for_sd_card_0_avalon_sdcard_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sd_card_0_avalon_sdcard_slave_end_xfer;
    end


  assign sd_card_0_avalon_sdcard_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave));
  //assign sd_card_0_avalon_sdcard_slave_readdata_from_sa = sd_card_0_avalon_sdcard_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_readdata_from_sa = sd_card_0_avalon_sdcard_slave_readdata;

  assign cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave = ({cpu_0_data_master_address_to_slave[24 : 10] , 10'b0} == 25'h1111000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign sd_card_0_avalon_sdcard_slave_waitrequest_from_sa = sd_card_0_avalon_sdcard_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_waitrequest_from_sa = sd_card_0_avalon_sdcard_slave_waitrequest;

  //sd_card_0_avalon_sdcard_slave_arb_share_counter set values, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_arb_share_set_values = 1;

  //sd_card_0_avalon_sdcard_slave_non_bursting_master_requests mux, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_non_bursting_master_requests = cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;

  //sd_card_0_avalon_sdcard_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_any_bursting_master_saved_grant = 0;

  //sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value = sd_card_0_avalon_sdcard_slave_firsttransfer ? (sd_card_0_avalon_sdcard_slave_arb_share_set_values - 1) : |sd_card_0_avalon_sdcard_slave_arb_share_counter ? (sd_card_0_avalon_sdcard_slave_arb_share_counter - 1) : 0;

  //sd_card_0_avalon_sdcard_slave_allgrants all slave grants, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_allgrants = |sd_card_0_avalon_sdcard_slave_grant_vector;

  //sd_card_0_avalon_sdcard_slave_end_xfer assignment, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_end_xfer = ~(sd_card_0_avalon_sdcard_slave_waits_for_read | sd_card_0_avalon_sdcard_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave = sd_card_0_avalon_sdcard_slave_end_xfer & (~sd_card_0_avalon_sdcard_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sd_card_0_avalon_sdcard_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave & sd_card_0_avalon_sdcard_slave_allgrants) | (end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave & ~sd_card_0_avalon_sdcard_slave_non_bursting_master_requests);

  //sd_card_0_avalon_sdcard_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_card_0_avalon_sdcard_slave_arb_share_counter <= 0;
      else if (sd_card_0_avalon_sdcard_slave_arb_counter_enable)
          sd_card_0_avalon_sdcard_slave_arb_share_counter <= sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value;
    end


  //sd_card_0_avalon_sdcard_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_card_0_avalon_sdcard_slave_slavearbiterlockenable <= 0;
      else if ((|sd_card_0_avalon_sdcard_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave) | (end_xfer_arb_share_counter_term_sd_card_0_avalon_sdcard_slave & ~sd_card_0_avalon_sdcard_slave_non_bursting_master_requests))
          sd_card_0_avalon_sdcard_slave_slavearbiterlockenable <= |sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master sd_card_0/avalon_sdcard_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sd_card_0_avalon_sdcard_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sd_card_0_avalon_sdcard_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_slavearbiterlockenable2 = |sd_card_0_avalon_sdcard_slave_arb_share_counter_next_value;

  //cpu_0/data_master sd_card_0/avalon_sdcard_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sd_card_0_avalon_sdcard_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //sd_card_0_avalon_sdcard_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave = cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //local readdatavalid cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_read & ~sd_card_0_avalon_sdcard_slave_waits_for_read;

  //sd_card_0_avalon_sdcard_slave_writedata mux, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave = cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave;

  //cpu_0/data_master saved-grant sd_card_0/avalon_sdcard_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_sd_card_0_avalon_sdcard_slave = cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;

  //allow new arb cycle for sd_card_0/avalon_sdcard_slave, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sd_card_0_avalon_sdcard_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sd_card_0_avalon_sdcard_slave_master_qreq_vector = 1;

  //sd_card_0_avalon_sdcard_slave_reset_n assignment, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_reset_n = reset_n;

  assign sd_card_0_avalon_sdcard_slave_chipselect = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave;
  //sd_card_0_avalon_sdcard_slave_firsttransfer first transaction, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_firsttransfer = sd_card_0_avalon_sdcard_slave_begins_xfer ? sd_card_0_avalon_sdcard_slave_unreg_firsttransfer : sd_card_0_avalon_sdcard_slave_reg_firsttransfer;

  //sd_card_0_avalon_sdcard_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_unreg_firsttransfer = ~(sd_card_0_avalon_sdcard_slave_slavearbiterlockenable & sd_card_0_avalon_sdcard_slave_any_continuerequest);

  //sd_card_0_avalon_sdcard_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_card_0_avalon_sdcard_slave_reg_firsttransfer <= 1'b1;
      else if (sd_card_0_avalon_sdcard_slave_begins_xfer)
          sd_card_0_avalon_sdcard_slave_reg_firsttransfer <= sd_card_0_avalon_sdcard_slave_unreg_firsttransfer;
    end


  //sd_card_0_avalon_sdcard_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_beginbursttransfer_internal = sd_card_0_avalon_sdcard_slave_begins_xfer;

  //sd_card_0_avalon_sdcard_slave_read assignment, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_read = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_read;

  //sd_card_0_avalon_sdcard_slave_write assignment, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_write = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_write;

  assign shifted_address_to_sd_card_0_avalon_sdcard_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //sd_card_0_avalon_sdcard_slave_address mux, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_address = shifted_address_to_sd_card_0_avalon_sdcard_slave_from_cpu_0_data_master >> 2;

  //d1_sd_card_0_avalon_sdcard_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sd_card_0_avalon_sdcard_slave_end_xfer <= 1;
      else 
        d1_sd_card_0_avalon_sdcard_slave_end_xfer <= sd_card_0_avalon_sdcard_slave_end_xfer;
    end


  //sd_card_0_avalon_sdcard_slave_waits_for_read in a cycle, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_waits_for_read = sd_card_0_avalon_sdcard_slave_in_a_read_cycle & sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;

  //sd_card_0_avalon_sdcard_slave_in_a_read_cycle assignment, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_in_a_read_cycle = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sd_card_0_avalon_sdcard_slave_in_a_read_cycle;

  //sd_card_0_avalon_sdcard_slave_waits_for_write in a cycle, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_waits_for_write = sd_card_0_avalon_sdcard_slave_in_a_write_cycle & sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;

  //sd_card_0_avalon_sdcard_slave_in_a_write_cycle assignment, which is an e_assign
  assign sd_card_0_avalon_sdcard_slave_in_a_write_cycle = cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sd_card_0_avalon_sdcard_slave_in_a_write_cycle;

  assign wait_for_sd_card_0_avalon_sdcard_slave_counter = 0;
  //sd_card_0_avalon_sdcard_slave_byteenable byte enable port mux, which is an e_mux
  assign sd_card_0_avalon_sdcard_slave_byteenable = (cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sd_card_0/avalon_sdcard_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1_module (
                                                                  // inputs:
                                                                   clear_fifo,
                                                                   clk,
                                                                   data_in,
                                                                   read,
                                                                   reset_n,
                                                                   sync_reset,
                                                                   write,

                                                                  // outputs:
                                                                   data_out,
                                                                   empty,
                                                                   fifo_contains_ones_n,
                                                                   full
                                                                )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module (
                                                             // inputs:
                                                              clear_fifo,
                                                              clk,
                                                              data_in,
                                                              read,
                                                              reset_n,
                                                              sync_reset,
                                                              write,

                                                             // outputs:
                                                              data_out,
                                                              empty,
                                                              fifo_contains_ones_n,
                                                              full
                                                           )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module (
                                                                    // inputs:
                                                                     clear_fifo,
                                                                     clk,
                                                                     data_in,
                                                                     read,
                                                                     reset_n,
                                                                     sync_reset,
                                                                     write,

                                                                    // outputs:
                                                                     data_out,
                                                                     empty,
                                                                     fifo_contains_ones_n,
                                                                     full
                                                                  )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_video_pixel_buffer_dma_0_avalon_pixel_dma_master_to_sdram_0_s1_module (
                                                                                            // inputs:
                                                                                             clear_fifo,
                                                                                             clk,
                                                                                             data_in,
                                                                                             read,
                                                                                             reset_n,
                                                                                             sync_reset,
                                                                                             write,

                                                                                            // outputs:
                                                                                             data_out,
                                                                                             empty,
                                                                                             fifo_contains_ones_n,
                                                                                             full
                                                                                          )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_0_s1_arbitrator (
                               // inputs:
                                bridge_0_avalon_master_address_to_slave,
                                bridge_0_avalon_master_byteenable,
                                bridge_0_avalon_master_read,
                                bridge_0_avalon_master_write,
                                bridge_0_avalon_master_writedata,
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_byteenable,
                                cpu_0_data_master_dbs_address,
                                cpu_0_data_master_dbs_write_16,
                                cpu_0_data_master_latency_counter,
                                cpu_0_data_master_read,
                                cpu_0_data_master_write,
                                cpu_0_instruction_master_address_to_slave,
                                cpu_0_instruction_master_dbs_address,
                                cpu_0_instruction_master_latency_counter,
                                cpu_0_instruction_master_read,
                                reset_n,
                                sdram_0_s1_readdata,
                                sdram_0_s1_readdatavalid,
                                sdram_0_s1_waitrequest,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_read,

                               // outputs:
                                bridge_0_granted_sdram_0_s1,
                                bridge_0_qualified_request_sdram_0_s1,
                                bridge_0_read_data_valid_sdram_0_s1,
                                bridge_0_read_data_valid_sdram_0_s1_shift_register,
                                bridge_0_requests_sdram_0_s1,
                                cpu_0_data_master_byteenable_sdram_0_s1,
                                cpu_0_data_master_granted_sdram_0_s1,
                                cpu_0_data_master_qualified_request_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_data_master_requests_sdram_0_s1,
                                cpu_0_instruction_master_granted_sdram_0_s1,
                                cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_instruction_master_requests_sdram_0_s1,
                                d1_sdram_0_s1_end_xfer,
                                sdram_0_s1_address,
                                sdram_0_s1_byteenable_n,
                                sdram_0_s1_chipselect,
                                sdram_0_s1_read_n,
                                sdram_0_s1_readdata_from_sa,
                                sdram_0_s1_reset_n,
                                sdram_0_s1_waitrequest_from_sa,
                                sdram_0_s1_write_n,
                                sdram_0_s1_writedata,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register,
                                video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1
                             )
;

  output           bridge_0_granted_sdram_0_s1;
  output           bridge_0_qualified_request_sdram_0_s1;
  output           bridge_0_read_data_valid_sdram_0_s1;
  output           bridge_0_read_data_valid_sdram_0_s1_shift_register;
  output           bridge_0_requests_sdram_0_s1;
  output  [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  output           cpu_0_data_master_granted_sdram_0_s1;
  output           cpu_0_data_master_qualified_request_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_data_master_requests_sdram_0_s1;
  output           cpu_0_instruction_master_granted_sdram_0_s1;
  output           cpu_0_instruction_master_qualified_request_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_instruction_master_requests_sdram_0_s1;
  output           d1_sdram_0_s1_end_xfer;
  output  [ 21: 0] sdram_0_s1_address;
  output  [  1: 0] sdram_0_s1_byteenable_n;
  output           sdram_0_s1_chipselect;
  output           sdram_0_s1_read_n;
  output  [ 15: 0] sdram_0_s1_readdata_from_sa;
  output           sdram_0_s1_reset_n;
  output           sdram_0_s1_waitrequest_from_sa;
  output           sdram_0_s1_write_n;
  output  [ 15: 0] sdram_0_s1_writedata;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;
  input   [ 23: 0] bridge_0_avalon_master_address_to_slave;
  input   [  1: 0] bridge_0_avalon_master_byteenable;
  input            bridge_0_avalon_master_read;
  input            bridge_0_avalon_master_write;
  input   [ 15: 0] bridge_0_avalon_master_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 24: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata;
  input            sdram_0_s1_readdatavalid;
  input            sdram_0_s1_waitrequest;
  input   [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_read;

  wire             bridge_0_avalon_master_arbiterlock;
  wire             bridge_0_avalon_master_arbiterlock2;
  wire             bridge_0_avalon_master_continuerequest;
  wire             bridge_0_granted_sdram_0_s1;
  wire             bridge_0_qualified_request_sdram_0_s1;
  wire             bridge_0_rdv_fifo_empty_sdram_0_s1;
  wire             bridge_0_rdv_fifo_output_from_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1_shift_register;
  wire             bridge_0_requests_sdram_0_s1;
  wire             bridge_0_saved_grant_sdram_0_s1;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_saved_grant_sdram_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_saved_grant_sdram_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sdram_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sdram_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1;
  reg              last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
  reg              last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1;
  wire             saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1;
  wire    [ 21: 0] sdram_0_s1_address;
  wire             sdram_0_s1_allgrants;
  wire             sdram_0_s1_allow_new_arb_cycle;
  wire             sdram_0_s1_any_bursting_master_saved_grant;
  wire             sdram_0_s1_any_continuerequest;
  reg     [  3: 0] sdram_0_s1_arb_addend;
  wire             sdram_0_s1_arb_counter_enable;
  reg     [  2: 0] sdram_0_s1_arb_share_counter;
  wire    [  2: 0] sdram_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] sdram_0_s1_arb_share_set_values;
  wire    [  3: 0] sdram_0_s1_arb_winner;
  wire             sdram_0_s1_arbitration_holdoff_internal;
  wire             sdram_0_s1_beginbursttransfer_internal;
  wire             sdram_0_s1_begins_xfer;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire    [  7: 0] sdram_0_s1_chosen_master_double_vector;
  wire    [  3: 0] sdram_0_s1_chosen_master_rot_left;
  wire             sdram_0_s1_end_xfer;
  wire             sdram_0_s1_firsttransfer;
  wire    [  3: 0] sdram_0_s1_grant_vector;
  wire             sdram_0_s1_in_a_read_cycle;
  wire             sdram_0_s1_in_a_write_cycle;
  wire    [  3: 0] sdram_0_s1_master_qreq_vector;
  wire             sdram_0_s1_move_on_to_next_transaction;
  wire             sdram_0_s1_non_bursting_master_requests;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid_from_sa;
  reg              sdram_0_s1_reg_firsttransfer;
  wire             sdram_0_s1_reset_n;
  reg     [  3: 0] sdram_0_s1_saved_chosen_master_vector;
  reg              sdram_0_s1_slavearbiterlockenable;
  wire             sdram_0_s1_slavearbiterlockenable2;
  wire             sdram_0_s1_unreg_firsttransfer;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_waits_for_read;
  wire             sdram_0_s1_waits_for_write;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire    [ 23: 0] shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master;
  wire    [ 24: 0] shifted_address_to_sdram_0_s1_from_cpu_0_data_master;
  wire    [ 24: 0] shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master;
  wire    [ 31: 0] shifted_address_to_sdram_0_s1_from_video_pixel_buffer_dma_0_avalon_pixel_dma_master;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock2;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_empty_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_output_from_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_saved_grant_sdram_0_s1;
  wire             wait_for_sdram_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sdram_0_s1_end_xfer;
    end


  assign sdram_0_s1_begins_xfer = ~d1_reasons_to_wait & ((bridge_0_qualified_request_sdram_0_s1 | cpu_0_data_master_qualified_request_sdram_0_s1 | cpu_0_instruction_master_qualified_request_sdram_0_s1 | video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1));
  //assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid;

  //assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata;

  assign bridge_0_requests_sdram_0_s1 = ({bridge_0_avalon_master_address_to_slave[23] , 23'b0} == 24'h800000) & (bridge_0_avalon_master_read | bridge_0_avalon_master_write);
  //assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest;

  //sdram_0_s1_arb_share_counter set values, which is an e_mux
  assign sdram_0_s1_arb_share_set_values = (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    1;

  //sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_0_s1_non_bursting_master_requests = bridge_0_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1 |
    bridge_0_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1 |
    bridge_0_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1 |
    bridge_0_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;

  //sdram_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sdram_0_s1_any_bursting_master_saved_grant = 0;

  //sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_0_s1_arb_share_counter_next_value = sdram_0_s1_firsttransfer ? (sdram_0_s1_arb_share_set_values - 1) : |sdram_0_s1_arb_share_counter ? (sdram_0_s1_arb_share_counter - 1) : 0;

  //sdram_0_s1_allgrants all slave grants, which is an e_mux
  assign sdram_0_s1_allgrants = (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector);

  //sdram_0_s1_end_xfer assignment, which is an e_assign
  assign sdram_0_s1_end_xfer = ~(sdram_0_s1_waits_for_read | sdram_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sdram_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sdram_0_s1 = sdram_0_s1_end_xfer & (~sdram_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sdram_0_s1 & sdram_0_s1_allgrants) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests);

  //sdram_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_share_counter <= 0;
      else if (sdram_0_s1_arb_counter_enable)
          sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
    end


  //sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sdram_0_s1) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests))
          sdram_0_s1_slavearbiterlockenable <= |sdram_0_s1_arb_share_counter_next_value;
    end


  //bridge_0/avalon_master sdram_0/s1 arbiterlock, which is an e_assign
  assign bridge_0_avalon_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & bridge_0_avalon_master_continuerequest;

  //sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_0_s1_slavearbiterlockenable2 = |sdram_0_s1_arb_share_counter_next_value;

  //bridge_0/avalon_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign bridge_0_avalon_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & bridge_0_avalon_master_continuerequest;

  //cpu_0/data_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //cpu_0/data_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/data_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= cpu_0_data_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_data_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1);

  //sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sdram_0_s1_any_continuerequest = cpu_0_data_master_continuerequest |
    cpu_0_instruction_master_continuerequest |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest |
    bridge_0_avalon_master_continuerequest |
    cpu_0_instruction_master_continuerequest |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest |
    bridge_0_avalon_master_continuerequest |
    cpu_0_data_master_continuerequest |
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest |
    bridge_0_avalon_master_continuerequest |
    cpu_0_data_master_continuerequest |
    cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= cpu_0_instruction_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1);

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest;

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1 <= video_pixel_buffer_dma_0_avalon_pixel_dma_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1) ? 0 : last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1;
    end


  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest continued request, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_continuerequest = (last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1) |
    (last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1) |
    (last_cycle_video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_slave_sdram_0_s1 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1);

  assign bridge_0_qualified_request_sdram_0_s1 = bridge_0_requests_sdram_0_s1 & ~((bridge_0_avalon_master_read & ((|bridge_0_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock | cpu_0_instruction_master_arbiterlock | (video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock & (saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1)));
  //unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_0_s1_move_on_to_next_transaction = sdram_0_s1_readdatavalid_from_sa;

  //rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1_module rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (bridge_0_granted_sdram_0_s1),
      .data_out             (bridge_0_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (bridge_0_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign bridge_0_read_data_valid_sdram_0_s1_shift_register = ~bridge_0_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid bridge_0_read_data_valid_sdram_0_s1, which is an e_mux
  assign bridge_0_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & bridge_0_rdv_fifo_output_from_sdram_0_s1) & ~ bridge_0_rdv_fifo_empty_sdram_0_s1;

  //sdram_0_s1_writedata mux, which is an e_mux
  assign sdram_0_s1_writedata = (bridge_0_granted_sdram_0_s1)? bridge_0_avalon_master_writedata :
    cpu_0_data_master_dbs_write_16;

  assign cpu_0_data_master_requests_sdram_0_s1 = ({cpu_0_data_master_address_to_slave[24 : 23] , 23'b0} == 25'h800000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //bridge_0/avalon_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1 <= bridge_0_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~bridge_0_requests_sdram_0_s1) ? 0 : last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1;
    end


  //bridge_0_avalon_master_continuerequest continued request, which is an e_mux
  assign bridge_0_avalon_master_continuerequest = (last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1 & bridge_0_requests_sdram_0_s1) |
    (last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1 & bridge_0_requests_sdram_0_s1) |
    (last_cycle_bridge_0_avalon_master_granted_slave_sdram_0_s1 & bridge_0_requests_sdram_0_s1);

  assign cpu_0_data_master_qualified_request_sdram_0_s1 = cpu_0_data_master_requests_sdram_0_s1 & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (1 < cpu_0_data_master_latency_counter))) | ((!cpu_0_data_master_byteenable_sdram_0_s1) & cpu_0_data_master_write) | bridge_0_avalon_master_arbiterlock | cpu_0_instruction_master_arbiterlock | (video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock & (saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1)));
  //rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_data_master_granted_sdram_0_s1),
      .data_out             (cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_data_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_data_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;

  assign cpu_0_instruction_master_requests_sdram_0_s1 = (({cpu_0_instruction_master_address_to_slave[24 : 23] , 23'b0} == 25'h800000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  assign cpu_0_instruction_master_qualified_request_sdram_0_s1 = cpu_0_instruction_master_requests_sdram_0_s1 & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (1 < cpu_0_instruction_master_latency_counter))) | bridge_0_avalon_master_arbiterlock | cpu_0_data_master_arbiterlock | (video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock & (saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1)));
  //rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_instruction_master_granted_sdram_0_s1),
      .data_out             (cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_instruction_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;

  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1 = (({video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave[31 : 23] , 23'b0} == 32'h800000) & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read)) & video_pixel_buffer_dma_0_avalon_pixel_dma_master_read;
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1 = video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1 & ~((video_pixel_buffer_dma_0_avalon_pixel_dma_master_read & ((video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter != 0) | (1 < video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter))) | bridge_0_avalon_master_arbiterlock | cpu_0_data_master_arbiterlock | cpu_0_instruction_master_arbiterlock);
  //rdv_fifo_for_video_pixel_buffer_dma_0_avalon_pixel_dma_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_video_pixel_buffer_dma_0_avalon_pixel_dma_master_to_sdram_0_s1_module rdv_fifo_for_video_pixel_buffer_dma_0_avalon_pixel_dma_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1),
      .data_out             (video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register = ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_output_from_sdram_0_s1) & ~ video_pixel_buffer_dma_0_avalon_pixel_dma_master_rdv_fifo_empty_sdram_0_s1;

  //allow new arb cycle for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_allow_new_arb_cycle = ~bridge_0_avalon_master_arbiterlock & ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock & ~(video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock & (saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1));

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[0] = video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1;

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master grant sdram_0/s1, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[0];

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master saved-grant sdram_0/s1, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[0] && video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;

  //saved chosen master btw video_pixel_buffer_dma_0/avalon_pixel_dma_master and sdram_0/s1, which is an e_assign
  assign saved_chosen_master_btw_video_pixel_buffer_dma_0_avalon_pixel_dma_master_and_sdram_0_s1 = sdram_0_s1_saved_chosen_master_vector[0];

  //cpu_0/instruction_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[1] = cpu_0_instruction_master_qualified_request_sdram_0_s1;

  //cpu_0/instruction_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[1];

  //cpu_0/instruction_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[1] && cpu_0_instruction_master_requests_sdram_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[2] = cpu_0_data_master_qualified_request_sdram_0_s1;

  //cpu_0/data_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[2];

  //cpu_0/data_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[2] && cpu_0_data_master_requests_sdram_0_s1;

  //bridge_0/avalon_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[3] = bridge_0_qualified_request_sdram_0_s1;

  //bridge_0/avalon_master grant sdram_0/s1, which is an e_assign
  assign bridge_0_granted_sdram_0_s1 = sdram_0_s1_grant_vector[3];

  //bridge_0/avalon_master saved-grant sdram_0/s1, which is an e_assign
  assign bridge_0_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[3] && bridge_0_requests_sdram_0_s1;

  //sdram_0/s1 chosen-master double-vector, which is an e_assign
  assign sdram_0_s1_chosen_master_double_vector = {sdram_0_s1_master_qreq_vector, sdram_0_s1_master_qreq_vector} & ({~sdram_0_s1_master_qreq_vector, ~sdram_0_s1_master_qreq_vector} + sdram_0_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sdram_0_s1_arb_winner = (sdram_0_s1_allow_new_arb_cycle & | sdram_0_s1_grant_vector) ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;

  //saved sdram_0_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_saved_chosen_master_vector <= 0;
      else if (sdram_0_s1_allow_new_arb_cycle)
          sdram_0_s1_saved_chosen_master_vector <= |sdram_0_s1_grant_vector ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sdram_0_s1_grant_vector = {(sdram_0_s1_chosen_master_double_vector[3] | sdram_0_s1_chosen_master_double_vector[7]),
    (sdram_0_s1_chosen_master_double_vector[2] | sdram_0_s1_chosen_master_double_vector[6]),
    (sdram_0_s1_chosen_master_double_vector[1] | sdram_0_s1_chosen_master_double_vector[5]),
    (sdram_0_s1_chosen_master_double_vector[0] | sdram_0_s1_chosen_master_double_vector[4])};

  //sdram_0/s1 chosen master rotated left, which is an e_assign
  assign sdram_0_s1_chosen_master_rot_left = (sdram_0_s1_arb_winner << 1) ? (sdram_0_s1_arb_winner << 1) : 1;

  //sdram_0/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_addend <= 1;
      else if (|sdram_0_s1_grant_vector)
          sdram_0_s1_arb_addend <= sdram_0_s1_end_xfer? sdram_0_s1_chosen_master_rot_left : sdram_0_s1_grant_vector;
    end


  //sdram_0_s1_reset_n assignment, which is an e_assign
  assign sdram_0_s1_reset_n = reset_n;

  assign sdram_0_s1_chipselect = bridge_0_granted_sdram_0_s1 | cpu_0_data_master_granted_sdram_0_s1 | cpu_0_instruction_master_granted_sdram_0_s1 | video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;
  //sdram_0_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_firsttransfer = sdram_0_s1_begins_xfer ? sdram_0_s1_unreg_firsttransfer : sdram_0_s1_reg_firsttransfer;

  //sdram_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_unreg_firsttransfer = ~(sdram_0_s1_slavearbiterlockenable & sdram_0_s1_any_continuerequest);

  //sdram_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_reg_firsttransfer <= 1'b1;
      else if (sdram_0_s1_begins_xfer)
          sdram_0_s1_reg_firsttransfer <= sdram_0_s1_unreg_firsttransfer;
    end


  //sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_0_s1_beginbursttransfer_internal = sdram_0_s1_begins_xfer;

  //sdram_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sdram_0_s1_arbitration_holdoff_internal = sdram_0_s1_begins_xfer & sdram_0_s1_firsttransfer;

  //~sdram_0_s1_read_n assignment, which is an e_mux
  assign sdram_0_s1_read_n = ~((bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_read) | (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read) | (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_read));

  //~sdram_0_s1_write_n assignment, which is an e_mux
  assign sdram_0_s1_write_n = ~((bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_write) | (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write));

  assign shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master = bridge_0_avalon_master_address_to_slave;
  //sdram_0_s1_address mux, which is an e_mux
  assign sdram_0_s1_address = (bridge_0_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master >> 1) :
    (cpu_0_data_master_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_cpu_0_data_master >> 1) :
    (cpu_0_instruction_master_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master >> 1) :
    (shifted_address_to_sdram_0_s1_from_video_pixel_buffer_dma_0_avalon_pixel_dma_master >> 1);

  assign shifted_address_to_sdram_0_s1_from_cpu_0_data_master = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1],
    {1 {1'b0}}};

  assign shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master = {cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  assign shifted_address_to_sdram_0_s1_from_video_pixel_buffer_dma_0_avalon_pixel_dma_master = video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave;
  //d1_sdram_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_0_s1_end_xfer <= 1;
      else 
        d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end


  //sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_read = sdram_0_s1_in_a_read_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_read_cycle = (bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_read) | (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read) | (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1 & video_pixel_buffer_dma_0_avalon_pixel_dma_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_0_s1_in_a_read_cycle;

  //sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_write = sdram_0_s1_in_a_write_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_write_cycle = (bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_write) | (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_0_s1_in_a_write_cycle;

  assign wait_for_sdram_0_s1_counter = 0;
  //~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_0_s1_byteenable_n = ~((bridge_0_granted_sdram_0_s1)? bridge_0_avalon_master_byteenable :
    (cpu_0_data_master_granted_sdram_0_s1)? cpu_0_data_master_byteenable_sdram_0_s1 :
    -1);

  assign {cpu_0_data_master_byteenable_sdram_0_s1_segment_1,
cpu_0_data_master_byteenable_sdram_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_sdram_0_s1 = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_sdram_0_s1_segment_0 :
    cpu_0_data_master_byteenable_sdram_0_s1_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sdram_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (bridge_0_granted_sdram_0_s1 + cpu_0_data_master_granted_sdram_0_s1 + cpu_0_instruction_master_granted_sdram_0_s1 + video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (bridge_0_saved_grant_sdram_0_s1 + cpu_0_data_master_saved_grant_sdram_0_s1 + cpu_0_instruction_master_saved_grant_sdram_0_s1 + video_pixel_buffer_dma_0_avalon_pixel_dma_master_saved_grant_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module seven_seg_3_0_avalon_parallel_port_slave_arbitrator (
                                                             // inputs:
                                                              clk,
                                                              cpu_0_data_master_address_to_slave,
                                                              cpu_0_data_master_byteenable,
                                                              cpu_0_data_master_latency_counter,
                                                              cpu_0_data_master_read,
                                                              cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                              cpu_0_data_master_write,
                                                              cpu_0_data_master_writedata,
                                                              reset_n,
                                                              seven_seg_3_0_avalon_parallel_port_slave_readdata,

                                                             // outputs:
                                                              cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave,
                                                              cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave,
                                                              cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave,
                                                              cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave,
                                                              d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer,
                                                              seven_seg_3_0_avalon_parallel_port_slave_address,
                                                              seven_seg_3_0_avalon_parallel_port_slave_byteenable,
                                                              seven_seg_3_0_avalon_parallel_port_slave_chipselect,
                                                              seven_seg_3_0_avalon_parallel_port_slave_read,
                                                              seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa,
                                                              seven_seg_3_0_avalon_parallel_port_slave_reset,
                                                              seven_seg_3_0_avalon_parallel_port_slave_write,
                                                              seven_seg_3_0_avalon_parallel_port_slave_writedata
                                                           )
;

  output           cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave;
  output           cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave;
  output           cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave;
  output           cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;
  output           d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
  output  [  1: 0] seven_seg_3_0_avalon_parallel_port_slave_address;
  output  [  3: 0] seven_seg_3_0_avalon_parallel_port_slave_byteenable;
  output           seven_seg_3_0_avalon_parallel_port_slave_chipselect;
  output           seven_seg_3_0_avalon_parallel_port_slave_read;
  output  [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa;
  output           seven_seg_3_0_avalon_parallel_port_slave_reset;
  output           seven_seg_3_0_avalon_parallel_port_slave_write;
  output  [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave;
  reg              cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register_in;
  wire             cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_saved_grant_seven_seg_3_0_avalon_parallel_port_slave;
  reg              d1_reasons_to_wait;
  reg              d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register;
  wire    [  1: 0] seven_seg_3_0_avalon_parallel_port_slave_address;
  wire             seven_seg_3_0_avalon_parallel_port_slave_allgrants;
  wire             seven_seg_3_0_avalon_parallel_port_slave_allow_new_arb_cycle;
  wire             seven_seg_3_0_avalon_parallel_port_slave_any_bursting_master_saved_grant;
  wire             seven_seg_3_0_avalon_parallel_port_slave_any_continuerequest;
  wire             seven_seg_3_0_avalon_parallel_port_slave_arb_counter_enable;
  reg     [  2: 0] seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter;
  wire    [  2: 0] seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value;
  wire    [  2: 0] seven_seg_3_0_avalon_parallel_port_slave_arb_share_set_values;
  wire             seven_seg_3_0_avalon_parallel_port_slave_beginbursttransfer_internal;
  wire             seven_seg_3_0_avalon_parallel_port_slave_begins_xfer;
  wire    [  3: 0] seven_seg_3_0_avalon_parallel_port_slave_byteenable;
  wire             seven_seg_3_0_avalon_parallel_port_slave_chipselect;
  wire             seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
  wire             seven_seg_3_0_avalon_parallel_port_slave_firsttransfer;
  wire             seven_seg_3_0_avalon_parallel_port_slave_grant_vector;
  wire             seven_seg_3_0_avalon_parallel_port_slave_in_a_read_cycle;
  wire             seven_seg_3_0_avalon_parallel_port_slave_in_a_write_cycle;
  wire             seven_seg_3_0_avalon_parallel_port_slave_master_qreq_vector;
  wire             seven_seg_3_0_avalon_parallel_port_slave_non_bursting_master_requests;
  wire             seven_seg_3_0_avalon_parallel_port_slave_read;
  wire    [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa;
  reg              seven_seg_3_0_avalon_parallel_port_slave_reg_firsttransfer;
  wire             seven_seg_3_0_avalon_parallel_port_slave_reset;
  reg              seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable;
  wire             seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable2;
  wire             seven_seg_3_0_avalon_parallel_port_slave_unreg_firsttransfer;
  wire             seven_seg_3_0_avalon_parallel_port_slave_waits_for_read;
  wire             seven_seg_3_0_avalon_parallel_port_slave_waits_for_write;
  wire             seven_seg_3_0_avalon_parallel_port_slave_write;
  wire    [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_writedata;
  wire    [ 24: 0] shifted_address_to_seven_seg_3_0_avalon_parallel_port_slave_from_cpu_0_data_master;
  wire             wait_for_seven_seg_3_0_avalon_parallel_port_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
    end


  assign seven_seg_3_0_avalon_parallel_port_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave));
  //assign seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa = seven_seg_3_0_avalon_parallel_port_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa = seven_seg_3_0_avalon_parallel_port_slave_readdata;

  assign cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111420) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter set values, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_arb_share_set_values = 1;

  //seven_seg_3_0_avalon_parallel_port_slave_non_bursting_master_requests mux, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_non_bursting_master_requests = cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;

  //seven_seg_3_0_avalon_parallel_port_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_any_bursting_master_saved_grant = 0;

  //seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value = seven_seg_3_0_avalon_parallel_port_slave_firsttransfer ? (seven_seg_3_0_avalon_parallel_port_slave_arb_share_set_values - 1) : |seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter ? (seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter - 1) : 0;

  //seven_seg_3_0_avalon_parallel_port_slave_allgrants all slave grants, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_allgrants = |seven_seg_3_0_avalon_parallel_port_slave_grant_vector;

  //seven_seg_3_0_avalon_parallel_port_slave_end_xfer assignment, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_end_xfer = ~(seven_seg_3_0_avalon_parallel_port_slave_waits_for_read | seven_seg_3_0_avalon_parallel_port_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave = seven_seg_3_0_avalon_parallel_port_slave_end_xfer & (~seven_seg_3_0_avalon_parallel_port_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave & seven_seg_3_0_avalon_parallel_port_slave_allgrants) | (end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave & ~seven_seg_3_0_avalon_parallel_port_slave_non_bursting_master_requests);

  //seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter <= 0;
      else if (seven_seg_3_0_avalon_parallel_port_slave_arb_counter_enable)
          seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter <= seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable <= 0;
      else if ((|seven_seg_3_0_avalon_parallel_port_slave_master_qreq_vector & end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave) | (end_xfer_arb_share_counter_term_seven_seg_3_0_avalon_parallel_port_slave & ~seven_seg_3_0_avalon_parallel_port_slave_non_bursting_master_requests))
          seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable <= |seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master seven_seg_3_0/avalon_parallel_port_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable2 = |seven_seg_3_0_avalon_parallel_port_slave_arb_share_counter_next_value;

  //cpu_0/data_master seven_seg_3_0/avalon_parallel_port_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //seven_seg_3_0_avalon_parallel_port_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave = cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register_in = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave & cpu_0_data_master_read & ~seven_seg_3_0_avalon_parallel_port_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register = {cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register, cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave = cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave_shift_register;

  //seven_seg_3_0_avalon_parallel_port_slave_writedata mux, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave = cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave;

  //cpu_0/data_master saved-grant seven_seg_3_0/avalon_parallel_port_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_seven_seg_3_0_avalon_parallel_port_slave = cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;

  //allow new arb cycle for seven_seg_3_0/avalon_parallel_port_slave, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign seven_seg_3_0_avalon_parallel_port_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign seven_seg_3_0_avalon_parallel_port_slave_master_qreq_vector = 1;

  //~seven_seg_3_0_avalon_parallel_port_slave_reset assignment, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_reset = ~reset_n;

  assign seven_seg_3_0_avalon_parallel_port_slave_chipselect = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave;
  //seven_seg_3_0_avalon_parallel_port_slave_firsttransfer first transaction, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_firsttransfer = seven_seg_3_0_avalon_parallel_port_slave_begins_xfer ? seven_seg_3_0_avalon_parallel_port_slave_unreg_firsttransfer : seven_seg_3_0_avalon_parallel_port_slave_reg_firsttransfer;

  //seven_seg_3_0_avalon_parallel_port_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_unreg_firsttransfer = ~(seven_seg_3_0_avalon_parallel_port_slave_slavearbiterlockenable & seven_seg_3_0_avalon_parallel_port_slave_any_continuerequest);

  //seven_seg_3_0_avalon_parallel_port_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_3_0_avalon_parallel_port_slave_reg_firsttransfer <= 1'b1;
      else if (seven_seg_3_0_avalon_parallel_port_slave_begins_xfer)
          seven_seg_3_0_avalon_parallel_port_slave_reg_firsttransfer <= seven_seg_3_0_avalon_parallel_port_slave_unreg_firsttransfer;
    end


  //seven_seg_3_0_avalon_parallel_port_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_beginbursttransfer_internal = seven_seg_3_0_avalon_parallel_port_slave_begins_xfer;

  //seven_seg_3_0_avalon_parallel_port_slave_read assignment, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_read = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave & cpu_0_data_master_read;

  //seven_seg_3_0_avalon_parallel_port_slave_write assignment, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_write = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave & cpu_0_data_master_write;

  assign shifted_address_to_seven_seg_3_0_avalon_parallel_port_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //seven_seg_3_0_avalon_parallel_port_slave_address mux, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_address = shifted_address_to_seven_seg_3_0_avalon_parallel_port_slave_from_cpu_0_data_master >> 2;

  //d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer <= 1;
      else 
        d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer <= seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
    end


  //seven_seg_3_0_avalon_parallel_port_slave_waits_for_read in a cycle, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_waits_for_read = seven_seg_3_0_avalon_parallel_port_slave_in_a_read_cycle & 0;

  //seven_seg_3_0_avalon_parallel_port_slave_in_a_read_cycle assignment, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_in_a_read_cycle = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = seven_seg_3_0_avalon_parallel_port_slave_in_a_read_cycle;

  //seven_seg_3_0_avalon_parallel_port_slave_waits_for_write in a cycle, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_waits_for_write = seven_seg_3_0_avalon_parallel_port_slave_in_a_write_cycle & 0;

  //seven_seg_3_0_avalon_parallel_port_slave_in_a_write_cycle assignment, which is an e_assign
  assign seven_seg_3_0_avalon_parallel_port_slave_in_a_write_cycle = cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = seven_seg_3_0_avalon_parallel_port_slave_in_a_write_cycle;

  assign wait_for_seven_seg_3_0_avalon_parallel_port_slave_counter = 0;
  //seven_seg_3_0_avalon_parallel_port_slave_byteenable byte enable port mux, which is an e_mux
  assign seven_seg_3_0_avalon_parallel_port_slave_byteenable = (cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //seven_seg_3_0/avalon_parallel_port_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module seven_seg_7_4_avalon_parallel_port_slave_arbitrator (
                                                             // inputs:
                                                              clk,
                                                              cpu_0_data_master_address_to_slave,
                                                              cpu_0_data_master_byteenable,
                                                              cpu_0_data_master_latency_counter,
                                                              cpu_0_data_master_read,
                                                              cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                              cpu_0_data_master_write,
                                                              cpu_0_data_master_writedata,
                                                              reset_n,
                                                              seven_seg_7_4_avalon_parallel_port_slave_readdata,

                                                             // outputs:
                                                              cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave,
                                                              cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave,
                                                              cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave,
                                                              cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave,
                                                              d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer,
                                                              seven_seg_7_4_avalon_parallel_port_slave_address,
                                                              seven_seg_7_4_avalon_parallel_port_slave_byteenable,
                                                              seven_seg_7_4_avalon_parallel_port_slave_chipselect,
                                                              seven_seg_7_4_avalon_parallel_port_slave_read,
                                                              seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa,
                                                              seven_seg_7_4_avalon_parallel_port_slave_reset,
                                                              seven_seg_7_4_avalon_parallel_port_slave_write,
                                                              seven_seg_7_4_avalon_parallel_port_slave_writedata
                                                           )
;

  output           cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave;
  output           cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave;
  output           cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave;
  output           cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;
  output           d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
  output  [  1: 0] seven_seg_7_4_avalon_parallel_port_slave_address;
  output  [  3: 0] seven_seg_7_4_avalon_parallel_port_slave_byteenable;
  output           seven_seg_7_4_avalon_parallel_port_slave_chipselect;
  output           seven_seg_7_4_avalon_parallel_port_slave_read;
  output  [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa;
  output           seven_seg_7_4_avalon_parallel_port_slave_reset;
  output           seven_seg_7_4_avalon_parallel_port_slave_write;
  output  [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave;
  reg              cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register_in;
  wire             cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_saved_grant_seven_seg_7_4_avalon_parallel_port_slave;
  reg              d1_reasons_to_wait;
  reg              d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register;
  wire    [  1: 0] seven_seg_7_4_avalon_parallel_port_slave_address;
  wire             seven_seg_7_4_avalon_parallel_port_slave_allgrants;
  wire             seven_seg_7_4_avalon_parallel_port_slave_allow_new_arb_cycle;
  wire             seven_seg_7_4_avalon_parallel_port_slave_any_bursting_master_saved_grant;
  wire             seven_seg_7_4_avalon_parallel_port_slave_any_continuerequest;
  wire             seven_seg_7_4_avalon_parallel_port_slave_arb_counter_enable;
  reg     [  2: 0] seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter;
  wire    [  2: 0] seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value;
  wire    [  2: 0] seven_seg_7_4_avalon_parallel_port_slave_arb_share_set_values;
  wire             seven_seg_7_4_avalon_parallel_port_slave_beginbursttransfer_internal;
  wire             seven_seg_7_4_avalon_parallel_port_slave_begins_xfer;
  wire    [  3: 0] seven_seg_7_4_avalon_parallel_port_slave_byteenable;
  wire             seven_seg_7_4_avalon_parallel_port_slave_chipselect;
  wire             seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
  wire             seven_seg_7_4_avalon_parallel_port_slave_firsttransfer;
  wire             seven_seg_7_4_avalon_parallel_port_slave_grant_vector;
  wire             seven_seg_7_4_avalon_parallel_port_slave_in_a_read_cycle;
  wire             seven_seg_7_4_avalon_parallel_port_slave_in_a_write_cycle;
  wire             seven_seg_7_4_avalon_parallel_port_slave_master_qreq_vector;
  wire             seven_seg_7_4_avalon_parallel_port_slave_non_bursting_master_requests;
  wire             seven_seg_7_4_avalon_parallel_port_slave_read;
  wire    [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa;
  reg              seven_seg_7_4_avalon_parallel_port_slave_reg_firsttransfer;
  wire             seven_seg_7_4_avalon_parallel_port_slave_reset;
  reg              seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable;
  wire             seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable2;
  wire             seven_seg_7_4_avalon_parallel_port_slave_unreg_firsttransfer;
  wire             seven_seg_7_4_avalon_parallel_port_slave_waits_for_read;
  wire             seven_seg_7_4_avalon_parallel_port_slave_waits_for_write;
  wire             seven_seg_7_4_avalon_parallel_port_slave_write;
  wire    [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_writedata;
  wire    [ 24: 0] shifted_address_to_seven_seg_7_4_avalon_parallel_port_slave_from_cpu_0_data_master;
  wire             wait_for_seven_seg_7_4_avalon_parallel_port_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
    end


  assign seven_seg_7_4_avalon_parallel_port_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave));
  //assign seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa = seven_seg_7_4_avalon_parallel_port_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa = seven_seg_7_4_avalon_parallel_port_slave_readdata;

  assign cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111430) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter set values, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_arb_share_set_values = 1;

  //seven_seg_7_4_avalon_parallel_port_slave_non_bursting_master_requests mux, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_non_bursting_master_requests = cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;

  //seven_seg_7_4_avalon_parallel_port_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_any_bursting_master_saved_grant = 0;

  //seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value = seven_seg_7_4_avalon_parallel_port_slave_firsttransfer ? (seven_seg_7_4_avalon_parallel_port_slave_arb_share_set_values - 1) : |seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter ? (seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter - 1) : 0;

  //seven_seg_7_4_avalon_parallel_port_slave_allgrants all slave grants, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_allgrants = |seven_seg_7_4_avalon_parallel_port_slave_grant_vector;

  //seven_seg_7_4_avalon_parallel_port_slave_end_xfer assignment, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_end_xfer = ~(seven_seg_7_4_avalon_parallel_port_slave_waits_for_read | seven_seg_7_4_avalon_parallel_port_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave = seven_seg_7_4_avalon_parallel_port_slave_end_xfer & (~seven_seg_7_4_avalon_parallel_port_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave & seven_seg_7_4_avalon_parallel_port_slave_allgrants) | (end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave & ~seven_seg_7_4_avalon_parallel_port_slave_non_bursting_master_requests);

  //seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter <= 0;
      else if (seven_seg_7_4_avalon_parallel_port_slave_arb_counter_enable)
          seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter <= seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable <= 0;
      else if ((|seven_seg_7_4_avalon_parallel_port_slave_master_qreq_vector & end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave) | (end_xfer_arb_share_counter_term_seven_seg_7_4_avalon_parallel_port_slave & ~seven_seg_7_4_avalon_parallel_port_slave_non_bursting_master_requests))
          seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable <= |seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master seven_seg_7_4/avalon_parallel_port_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable2 = |seven_seg_7_4_avalon_parallel_port_slave_arb_share_counter_next_value;

  //cpu_0/data_master seven_seg_7_4/avalon_parallel_port_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //seven_seg_7_4_avalon_parallel_port_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave = cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register_in = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave & cpu_0_data_master_read & ~seven_seg_7_4_avalon_parallel_port_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register = {cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register, cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave = cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave_shift_register;

  //seven_seg_7_4_avalon_parallel_port_slave_writedata mux, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave = cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave;

  //cpu_0/data_master saved-grant seven_seg_7_4/avalon_parallel_port_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_seven_seg_7_4_avalon_parallel_port_slave = cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;

  //allow new arb cycle for seven_seg_7_4/avalon_parallel_port_slave, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign seven_seg_7_4_avalon_parallel_port_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign seven_seg_7_4_avalon_parallel_port_slave_master_qreq_vector = 1;

  //~seven_seg_7_4_avalon_parallel_port_slave_reset assignment, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_reset = ~reset_n;

  assign seven_seg_7_4_avalon_parallel_port_slave_chipselect = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave;
  //seven_seg_7_4_avalon_parallel_port_slave_firsttransfer first transaction, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_firsttransfer = seven_seg_7_4_avalon_parallel_port_slave_begins_xfer ? seven_seg_7_4_avalon_parallel_port_slave_unreg_firsttransfer : seven_seg_7_4_avalon_parallel_port_slave_reg_firsttransfer;

  //seven_seg_7_4_avalon_parallel_port_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_unreg_firsttransfer = ~(seven_seg_7_4_avalon_parallel_port_slave_slavearbiterlockenable & seven_seg_7_4_avalon_parallel_port_slave_any_continuerequest);

  //seven_seg_7_4_avalon_parallel_port_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_7_4_avalon_parallel_port_slave_reg_firsttransfer <= 1'b1;
      else if (seven_seg_7_4_avalon_parallel_port_slave_begins_xfer)
          seven_seg_7_4_avalon_parallel_port_slave_reg_firsttransfer <= seven_seg_7_4_avalon_parallel_port_slave_unreg_firsttransfer;
    end


  //seven_seg_7_4_avalon_parallel_port_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_beginbursttransfer_internal = seven_seg_7_4_avalon_parallel_port_slave_begins_xfer;

  //seven_seg_7_4_avalon_parallel_port_slave_read assignment, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_read = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave & cpu_0_data_master_read;

  //seven_seg_7_4_avalon_parallel_port_slave_write assignment, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_write = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave & cpu_0_data_master_write;

  assign shifted_address_to_seven_seg_7_4_avalon_parallel_port_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //seven_seg_7_4_avalon_parallel_port_slave_address mux, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_address = shifted_address_to_seven_seg_7_4_avalon_parallel_port_slave_from_cpu_0_data_master >> 2;

  //d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer <= 1;
      else 
        d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer <= seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
    end


  //seven_seg_7_4_avalon_parallel_port_slave_waits_for_read in a cycle, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_waits_for_read = seven_seg_7_4_avalon_parallel_port_slave_in_a_read_cycle & 0;

  //seven_seg_7_4_avalon_parallel_port_slave_in_a_read_cycle assignment, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_in_a_read_cycle = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = seven_seg_7_4_avalon_parallel_port_slave_in_a_read_cycle;

  //seven_seg_7_4_avalon_parallel_port_slave_waits_for_write in a cycle, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_waits_for_write = seven_seg_7_4_avalon_parallel_port_slave_in_a_write_cycle & 0;

  //seven_seg_7_4_avalon_parallel_port_slave_in_a_write_cycle assignment, which is an e_assign
  assign seven_seg_7_4_avalon_parallel_port_slave_in_a_write_cycle = cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = seven_seg_7_4_avalon_parallel_port_slave_in_a_write_cycle;

  assign wait_for_seven_seg_7_4_avalon_parallel_port_slave_counter = 0;
  //seven_seg_7_4_avalon_parallel_port_slave_byteenable byte enable port mux, which is an e_mux
  assign seven_seg_7_4_avalon_parallel_port_slave_byteenable = (cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //seven_seg_7_4/avalon_parallel_port_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         cpu_0_data_master_address_to_slave,
                                         cpu_0_data_master_latency_counter,
                                         cpu_0_data_master_read,
                                         cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                         cpu_0_data_master_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         cpu_0_data_master_granted_sysid_control_slave,
                                         cpu_0_data_master_qualified_request_sysid_control_slave,
                                         cpu_0_data_master_read_data_valid_sysid_control_slave,
                                         cpu_0_data_master_requests_sysid_control_slave,
                                         d1_sysid_control_slave_end_xfer,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa,
                                         sysid_control_slave_reset_n
                                      )
;

  output           cpu_0_data_master_granted_sysid_control_slave;
  output           cpu_0_data_master_qualified_request_sysid_control_slave;
  output           cpu_0_data_master_read_data_valid_sysid_control_slave;
  output           cpu_0_data_master_requests_sysid_control_slave;
  output           d1_sysid_control_slave_end_xfer;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  output           sysid_control_slave_reset_n;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sysid_control_slave;
  wire             cpu_0_data_master_qualified_request_sysid_control_slave;
  wire             cpu_0_data_master_read_data_valid_sysid_control_slave;
  wire             cpu_0_data_master_requests_sysid_control_slave;
  wire             cpu_0_data_master_saved_grant_sysid_control_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 24: 0] shifted_address_to_sysid_control_slave_from_cpu_0_data_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg     [  2: 0] sysid_control_slave_arb_share_counter;
  wire    [  2: 0] sysid_control_slave_arb_share_counter_next_value;
  wire    [  2: 0] sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  wire             sysid_control_slave_reset_n;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign cpu_0_data_master_requests_sysid_control_slave = (({cpu_0_data_master_address_to_slave[24 : 3] , 3'b0} == 25'h1111468) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = cpu_0_data_master_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master sysid/control_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sysid_control_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //cpu_0/data_master sysid/control_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_sysid_control_slave = cpu_0_data_master_requests_sysid_control_slave & ~((cpu_0_data_master_read & ((cpu_0_data_master_latency_counter != 0) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //local readdatavalid cpu_0_data_master_read_data_valid_sysid_control_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_sysid_control_slave = cpu_0_data_master_granted_sysid_control_slave & cpu_0_data_master_read & ~sysid_control_slave_waits_for_read;

  //master is always granted when requested
  assign cpu_0_data_master_granted_sysid_control_slave = cpu_0_data_master_qualified_request_sysid_control_slave;

  //cpu_0/data_master saved-grant sysid/control_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_sysid_control_slave = cpu_0_data_master_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_reset_n assignment, which is an e_assign
  assign sysid_control_slave_reset_n = reset_n;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  assign shifted_address_to_sysid_control_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = shifted_address_to_sysid_control_slave_from_cpu_0_data_master >> 2;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else 
        d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = cpu_0_data_master_granted_sysid_control_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = cpu_0_data_master_granted_sysid_control_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module to_external_bus_bridge_0_avalon_slave_arbitrator (
                                                          // inputs:
                                                           clk,
                                                           cpu_0_data_master_address_to_slave,
                                                           cpu_0_data_master_byteenable,
                                                           cpu_0_data_master_dbs_address,
                                                           cpu_0_data_master_dbs_write_16,
                                                           cpu_0_data_master_latency_counter,
                                                           cpu_0_data_master_read,
                                                           cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                           cpu_0_data_master_write,
                                                           reset_n,
                                                           to_external_bus_bridge_0_avalon_slave_irq,
                                                           to_external_bus_bridge_0_avalon_slave_readdata,
                                                           to_external_bus_bridge_0_avalon_slave_waitrequest,

                                                          // outputs:
                                                           cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave,
                                                           cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave,
                                                           cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave,
                                                           cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave,
                                                           cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave,
                                                           d1_to_external_bus_bridge_0_avalon_slave_end_xfer,
                                                           to_external_bus_bridge_0_avalon_slave_address,
                                                           to_external_bus_bridge_0_avalon_slave_byteenable,
                                                           to_external_bus_bridge_0_avalon_slave_chipselect,
                                                           to_external_bus_bridge_0_avalon_slave_irq_from_sa,
                                                           to_external_bus_bridge_0_avalon_slave_read,
                                                           to_external_bus_bridge_0_avalon_slave_readdata_from_sa,
                                                           to_external_bus_bridge_0_avalon_slave_reset,
                                                           to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa,
                                                           to_external_bus_bridge_0_avalon_slave_write,
                                                           to_external_bus_bridge_0_avalon_slave_writedata
                                                        )
;

  output  [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave;
  output           cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave;
  output           cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave;
  output           cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave;
  output           cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;
  output           d1_to_external_bus_bridge_0_avalon_slave_end_xfer;
  output  [ 18: 0] to_external_bus_bridge_0_avalon_slave_address;
  output  [  1: 0] to_external_bus_bridge_0_avalon_slave_byteenable;
  output           to_external_bus_bridge_0_avalon_slave_chipselect;
  output           to_external_bus_bridge_0_avalon_slave_irq_from_sa;
  output           to_external_bus_bridge_0_avalon_slave_read;
  output  [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata_from_sa;
  output           to_external_bus_bridge_0_avalon_slave_reset;
  output           to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;
  output           to_external_bus_bridge_0_avalon_slave_write;
  output  [ 15: 0] to_external_bus_bridge_0_avalon_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input            reset_n;
  input            to_external_bus_bridge_0_avalon_slave_irq;
  input   [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata;
  input            to_external_bus_bridge_0_avalon_slave_waitrequest;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave;
  wire    [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave;
  reg              cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register_in;
  wire             cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_saved_grant_to_external_bus_bridge_0_avalon_slave;
  reg              d1_reasons_to_wait;
  reg              d1_to_external_bus_bridge_0_avalon_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register;
  wire    [ 24: 0] shifted_address_to_to_external_bus_bridge_0_avalon_slave_from_cpu_0_data_master;
  wire    [ 18: 0] to_external_bus_bridge_0_avalon_slave_address;
  wire             to_external_bus_bridge_0_avalon_slave_allgrants;
  wire             to_external_bus_bridge_0_avalon_slave_allow_new_arb_cycle;
  wire             to_external_bus_bridge_0_avalon_slave_any_bursting_master_saved_grant;
  wire             to_external_bus_bridge_0_avalon_slave_any_continuerequest;
  wire             to_external_bus_bridge_0_avalon_slave_arb_counter_enable;
  reg     [  2: 0] to_external_bus_bridge_0_avalon_slave_arb_share_counter;
  wire    [  2: 0] to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value;
  wire    [  2: 0] to_external_bus_bridge_0_avalon_slave_arb_share_set_values;
  wire             to_external_bus_bridge_0_avalon_slave_beginbursttransfer_internal;
  wire             to_external_bus_bridge_0_avalon_slave_begins_xfer;
  wire    [  1: 0] to_external_bus_bridge_0_avalon_slave_byteenable;
  wire             to_external_bus_bridge_0_avalon_slave_chipselect;
  wire             to_external_bus_bridge_0_avalon_slave_end_xfer;
  wire             to_external_bus_bridge_0_avalon_slave_firsttransfer;
  wire             to_external_bus_bridge_0_avalon_slave_grant_vector;
  wire             to_external_bus_bridge_0_avalon_slave_in_a_read_cycle;
  wire             to_external_bus_bridge_0_avalon_slave_in_a_write_cycle;
  wire             to_external_bus_bridge_0_avalon_slave_irq_from_sa;
  wire             to_external_bus_bridge_0_avalon_slave_master_qreq_vector;
  wire             to_external_bus_bridge_0_avalon_slave_non_bursting_master_requests;
  wire             to_external_bus_bridge_0_avalon_slave_read;
  wire    [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata_from_sa;
  reg              to_external_bus_bridge_0_avalon_slave_reg_firsttransfer;
  wire             to_external_bus_bridge_0_avalon_slave_reset;
  reg              to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable;
  wire             to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable2;
  wire             to_external_bus_bridge_0_avalon_slave_unreg_firsttransfer;
  wire             to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;
  wire             to_external_bus_bridge_0_avalon_slave_waits_for_read;
  wire             to_external_bus_bridge_0_avalon_slave_waits_for_write;
  wire             to_external_bus_bridge_0_avalon_slave_write;
  wire    [ 15: 0] to_external_bus_bridge_0_avalon_slave_writedata;
  wire             wait_for_to_external_bus_bridge_0_avalon_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~to_external_bus_bridge_0_avalon_slave_end_xfer;
    end


  assign to_external_bus_bridge_0_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave));
  //assign to_external_bus_bridge_0_avalon_slave_readdata_from_sa = to_external_bus_bridge_0_avalon_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_readdata_from_sa = to_external_bus_bridge_0_avalon_slave_readdata;

  assign cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave = ({cpu_0_data_master_address_to_slave[24 : 20] , 20'b0} == 25'h1000000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa = to_external_bus_bridge_0_avalon_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa = to_external_bus_bridge_0_avalon_slave_waitrequest;

  //to_external_bus_bridge_0_avalon_slave_arb_share_counter set values, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_arb_share_set_values = (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave)? 2 :
    1;

  //to_external_bus_bridge_0_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_non_bursting_master_requests = cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;

  //to_external_bus_bridge_0_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_any_bursting_master_saved_grant = 0;

  //to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value = to_external_bus_bridge_0_avalon_slave_firsttransfer ? (to_external_bus_bridge_0_avalon_slave_arb_share_set_values - 1) : |to_external_bus_bridge_0_avalon_slave_arb_share_counter ? (to_external_bus_bridge_0_avalon_slave_arb_share_counter - 1) : 0;

  //to_external_bus_bridge_0_avalon_slave_allgrants all slave grants, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_allgrants = |to_external_bus_bridge_0_avalon_slave_grant_vector;

  //to_external_bus_bridge_0_avalon_slave_end_xfer assignment, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_end_xfer = ~(to_external_bus_bridge_0_avalon_slave_waits_for_read | to_external_bus_bridge_0_avalon_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave = to_external_bus_bridge_0_avalon_slave_end_xfer & (~to_external_bus_bridge_0_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //to_external_bus_bridge_0_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave & to_external_bus_bridge_0_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave & ~to_external_bus_bridge_0_avalon_slave_non_bursting_master_requests);

  //to_external_bus_bridge_0_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          to_external_bus_bridge_0_avalon_slave_arb_share_counter <= 0;
      else if (to_external_bus_bridge_0_avalon_slave_arb_counter_enable)
          to_external_bus_bridge_0_avalon_slave_arb_share_counter <= to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|to_external_bus_bridge_0_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave) | (end_xfer_arb_share_counter_term_to_external_bus_bridge_0_avalon_slave & ~to_external_bus_bridge_0_avalon_slave_non_bursting_master_requests))
          to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable <= |to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master to_external_bus_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable2 = |to_external_bus_bridge_0_avalon_slave_arb_share_counter_next_value;

  //cpu_0/data_master to_external_bus_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //to_external_bus_bridge_0_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave = cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((!cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave) & cpu_0_data_master_write));
  //cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register_in = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_read & ~to_external_bus_bridge_0_avalon_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register = {cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register, cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave = cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave_shift_register;

  //to_external_bus_bridge_0_avalon_slave_writedata mux, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_writedata = cpu_0_data_master_dbs_write_16;

  //master is always granted when requested
  assign cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave = cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave;

  //cpu_0/data_master saved-grant to_external_bus_bridge_0/avalon_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_to_external_bus_bridge_0_avalon_slave = cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;

  //allow new arb cycle for to_external_bus_bridge_0/avalon_slave, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign to_external_bus_bridge_0_avalon_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign to_external_bus_bridge_0_avalon_slave_master_qreq_vector = 1;

  //~to_external_bus_bridge_0_avalon_slave_reset assignment, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_reset = ~reset_n;

  assign to_external_bus_bridge_0_avalon_slave_chipselect = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave;
  //to_external_bus_bridge_0_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_firsttransfer = to_external_bus_bridge_0_avalon_slave_begins_xfer ? to_external_bus_bridge_0_avalon_slave_unreg_firsttransfer : to_external_bus_bridge_0_avalon_slave_reg_firsttransfer;

  //to_external_bus_bridge_0_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_unreg_firsttransfer = ~(to_external_bus_bridge_0_avalon_slave_slavearbiterlockenable & to_external_bus_bridge_0_avalon_slave_any_continuerequest);

  //to_external_bus_bridge_0_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          to_external_bus_bridge_0_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (to_external_bus_bridge_0_avalon_slave_begins_xfer)
          to_external_bus_bridge_0_avalon_slave_reg_firsttransfer <= to_external_bus_bridge_0_avalon_slave_unreg_firsttransfer;
    end


  //to_external_bus_bridge_0_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_beginbursttransfer_internal = to_external_bus_bridge_0_avalon_slave_begins_xfer;

  //to_external_bus_bridge_0_avalon_slave_read assignment, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_read = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_read;

  //to_external_bus_bridge_0_avalon_slave_write assignment, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_write = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_write;

  assign shifted_address_to_to_external_bus_bridge_0_avalon_slave_from_cpu_0_data_master = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1],
    {1 {1'b0}}};

  //to_external_bus_bridge_0_avalon_slave_address mux, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_address = shifted_address_to_to_external_bus_bridge_0_avalon_slave_from_cpu_0_data_master >> 1;

  //d1_to_external_bus_bridge_0_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_to_external_bus_bridge_0_avalon_slave_end_xfer <= 1;
      else 
        d1_to_external_bus_bridge_0_avalon_slave_end_xfer <= to_external_bus_bridge_0_avalon_slave_end_xfer;
    end


  //to_external_bus_bridge_0_avalon_slave_waits_for_read in a cycle, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_waits_for_read = to_external_bus_bridge_0_avalon_slave_in_a_read_cycle & to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;

  //to_external_bus_bridge_0_avalon_slave_in_a_read_cycle assignment, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_in_a_read_cycle = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = to_external_bus_bridge_0_avalon_slave_in_a_read_cycle;

  //to_external_bus_bridge_0_avalon_slave_waits_for_write in a cycle, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_waits_for_write = to_external_bus_bridge_0_avalon_slave_in_a_write_cycle & to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;

  //to_external_bus_bridge_0_avalon_slave_in_a_write_cycle assignment, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_in_a_write_cycle = cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = to_external_bus_bridge_0_avalon_slave_in_a_write_cycle;

  assign wait_for_to_external_bus_bridge_0_avalon_slave_counter = 0;
  //to_external_bus_bridge_0_avalon_slave_byteenable byte enable port mux, which is an e_mux
  assign to_external_bus_bridge_0_avalon_slave_byteenable = (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave)? cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave :
    -1;

  assign {cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_1,
cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_0 :
    cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave_segment_1;

  //assign to_external_bus_bridge_0_avalon_slave_irq_from_sa = to_external_bus_bridge_0_avalon_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign to_external_bus_bridge_0_avalon_slave_irq_from_sa = to_external_bus_bridge_0_avalon_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //to_external_bus_bridge_0/avalon_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_avalon_slave_arbitrator (
                                                    // inputs:
                                                     clk,
                                                     cpu_0_data_master_address_to_slave,
                                                     cpu_0_data_master_byteenable,
                                                     cpu_0_data_master_dbs_address,
                                                     cpu_0_data_master_dbs_write_8,
                                                     cpu_0_data_master_latency_counter,
                                                     cpu_0_data_master_read,
                                                     cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                     cpu_0_data_master_write,
                                                     cpu_0_instruction_master_address_to_slave,
                                                     cpu_0_instruction_master_dbs_address,
                                                     cpu_0_instruction_master_latency_counter,
                                                     cpu_0_instruction_master_read,
                                                     cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                                     reset_n,

                                                    // outputs:
                                                     address_to_the_cfi_flash_0,
                                                     cfi_flash_0_s1_wait_counter_eq_0,
                                                     cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                                     cpu_0_data_master_granted_cfi_flash_0_s1,
                                                     cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_data_master_requests_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                                     d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                                     data_to_and_from_the_cfi_flash_0,
                                                     incoming_data_to_and_from_the_cfi_flash_0,
                                                     incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0,
                                                     read_n_to_the_cfi_flash_0,
                                                     select_n_to_the_cfi_flash_0,
                                                     write_n_to_the_cfi_flash_0
                                                  )
;

  output  [ 21: 0] address_to_the_cfi_flash_0;
  output           cfi_flash_0_s1_wait_counter_eq_0;
  output           cpu_0_data_master_byteenable_cfi_flash_0_s1;
  output           cpu_0_data_master_granted_cfi_flash_0_s1;
  output           cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_data_master_requests_cfi_flash_0_s1;
  output           cpu_0_instruction_master_granted_cfi_flash_0_s1;
  output           cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_instruction_master_requests_cfi_flash_0_s1;
  output           d1_tri_state_bridge_0_avalon_slave_end_xfer;
  inout   [  7: 0] data_to_and_from_the_cfi_flash_0;
  output  [  7: 0] incoming_data_to_and_from_the_cfi_flash_0;
  output  [  7: 0] incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;
  output           read_n_to_the_cfi_flash_0;
  output           select_n_to_the_cfi_flash_0;
  output           write_n_to_the_cfi_flash_0;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [  7: 0] cpu_0_data_master_dbs_write_8;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 24: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            reset_n;

  reg     [ 21: 0] address_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire    [  3: 0] cfi_flash_0_s1_counter_load_value;
  wire             cfi_flash_0_s1_in_a_read_cycle;
  wire             cfi_flash_0_s1_in_a_write_cycle;
  wire             cfi_flash_0_s1_pretend_byte_enable;
  reg     [  3: 0] cfi_flash_0_s1_wait_counter;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             cfi_flash_0_s1_waits_for_read;
  wire             cfi_flash_0_s1_waits_for_write;
  wire             cfi_flash_0_s1_with_write_latency;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_saved_grant_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_saved_grant_cfi_flash_0_s1;
  reg              d1_in_a_write_cycle /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
  reg     [  7: 0] d1_outgoing_data_to_and_from_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              d1_reasons_to_wait;
  reg              d1_tri_state_bridge_0_avalon_slave_end_xfer;
  wire    [  7: 0] data_to_and_from_the_cfi_flash_0;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg     [  7: 0] incoming_data_to_and_from_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_0_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_1_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_2_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_3_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_4_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_5_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_6_is_x;
  wire             incoming_data_to_and_from_the_cfi_flash_0_bit_7_is_x;
  wire    [  7: 0] incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;
  reg              last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
  wire    [  7: 0] outgoing_data_to_and_from_the_cfi_flash_0;
  wire    [ 21: 0] p1_address_to_the_cfi_flash_0;
  wire    [  1: 0] p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire    [  1: 0] p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             p1_read_n_to_the_cfi_flash_0;
  wire             p1_select_n_to_the_cfi_flash_0;
  wire             p1_write_n_to_the_cfi_flash_0;
  reg              read_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              select_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             time_to_write;
  wire             tri_state_bridge_0_avalon_slave_allgrants;
  wire             tri_state_bridge_0_avalon_slave_allow_new_arb_cycle;
  wire             tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant;
  wire             tri_state_bridge_0_avalon_slave_any_continuerequest;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_arb_addend;
  wire             tri_state_bridge_0_avalon_slave_arb_counter_enable;
  reg     [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_set_values;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_arb_winner;
  wire             tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal;
  wire             tri_state_bridge_0_avalon_slave_beginbursttransfer_internal;
  wire             tri_state_bridge_0_avalon_slave_begins_xfer;
  wire    [  3: 0] tri_state_bridge_0_avalon_slave_chosen_master_double_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_chosen_master_rot_left;
  wire             tri_state_bridge_0_avalon_slave_end_xfer;
  wire             tri_state_bridge_0_avalon_slave_firsttransfer;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_grant_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_master_qreq_vector;
  wire             tri_state_bridge_0_avalon_slave_non_bursting_master_requests;
  wire             tri_state_bridge_0_avalon_slave_read_pending;
  reg              tri_state_bridge_0_avalon_slave_reg_firsttransfer;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
  reg              tri_state_bridge_0_avalon_slave_slavearbiterlockenable;
  wire             tri_state_bridge_0_avalon_slave_slavearbiterlockenable2;
  wire             tri_state_bridge_0_avalon_slave_unreg_firsttransfer;
  wire             tri_state_bridge_0_avalon_slave_write_pending;
  wire             wait_for_cfi_flash_0_s1_counter;
  reg              write_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tri_state_bridge_0_avalon_slave_end_xfer;
    end


  assign tri_state_bridge_0_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1));
  assign cpu_0_data_master_requests_cfi_flash_0_s1 = ({cpu_0_data_master_address_to_slave[24 : 22] , 22'b0} == 25'h400000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //~select_n_to_the_cfi_flash_0 of type chipselect to ~p1_select_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          select_n_to_the_cfi_flash_0 <= ~0;
      else 
        select_n_to_the_cfi_flash_0 <= p1_select_n_to_the_cfi_flash_0;
    end


  assign tri_state_bridge_0_avalon_slave_write_pending = 0;
  //tri_state_bridge_0/avalon_slave read pending calc, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_read_pending = 0;

  //tri_state_bridge_0_avalon_slave_arb_share_counter set values, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_arb_share_set_values = (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    1;

  //tri_state_bridge_0_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_non_bursting_master_requests = cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1 |
    cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant = 0;

  //tri_state_bridge_0_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_share_counter_next_value = tri_state_bridge_0_avalon_slave_firsttransfer ? (tri_state_bridge_0_avalon_slave_arb_share_set_values - 1) : |tri_state_bridge_0_avalon_slave_arb_share_counter ? (tri_state_bridge_0_avalon_slave_arb_share_counter - 1) : 0;

  //tri_state_bridge_0_avalon_slave_allgrants all slave grants, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_allgrants = (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector);

  //tri_state_bridge_0_avalon_slave_end_xfer assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_end_xfer = ~(cfi_flash_0_s1_waits_for_read | cfi_flash_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave = tri_state_bridge_0_avalon_slave_end_xfer & (~tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tri_state_bridge_0_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & tri_state_bridge_0_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests);

  //tri_state_bridge_0_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= 0;
      else if (tri_state_bridge_0_avalon_slave_arb_counter_enable)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|tri_state_bridge_0_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave) | (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests))
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 = |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;

  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 & cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cfi_flash_0_s1 = cpu_0_data_master_requests_cfi_flash_0_s1 & ~((cpu_0_data_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (2 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((tri_state_bridge_0_avalon_slave_read_pending | !cpu_0_data_master_byteenable_cfi_flash_0_s1) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read & ~cfi_flash_0_s1_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1 = cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //data_to_and_from_the_cfi_flash_0 register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          incoming_data_to_and_from_the_cfi_flash_0 <= 0;
      else 
        incoming_data_to_and_from_the_cfi_flash_0 <= data_to_and_from_the_cfi_flash_0;
    end


  //cfi_flash_0_s1_with_write_latency assignment, which is an e_assign
  assign cfi_flash_0_s1_with_write_latency = in_a_write_cycle & (cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1);

  //time to write the data, which is an e_mux
  assign time_to_write = (cfi_flash_0_s1_with_write_latency)? 1 :
    0;

  //d1_outgoing_data_to_and_from_the_cfi_flash_0 register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_outgoing_data_to_and_from_the_cfi_flash_0 <= 0;
      else 
        d1_outgoing_data_to_and_from_the_cfi_flash_0 <= outgoing_data_to_and_from_the_cfi_flash_0;
    end


  //write cycle delayed by 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_in_a_write_cycle <= 0;
      else 
        d1_in_a_write_cycle <= time_to_write;
    end


  //d1_outgoing_data_to_and_from_the_cfi_flash_0 tristate driver, which is an e_assign
  assign data_to_and_from_the_cfi_flash_0 = (d1_in_a_write_cycle)? d1_outgoing_data_to_and_from_the_cfi_flash_0:{8{1'bz}};

  //outgoing_data_to_and_from_the_cfi_flash_0 mux, which is an e_mux
  assign outgoing_data_to_and_from_the_cfi_flash_0 = cpu_0_data_master_dbs_write_8;

  assign cpu_0_instruction_master_requests_cfi_flash_0_s1 = (({cpu_0_instruction_master_address_to_slave[24 : 22] , 22'b0} == 25'h400000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= cpu_0_data_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 & cpu_0_data_master_requests_cfi_flash_0_s1;

  assign cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 = cpu_0_instruction_master_requests_cfi_flash_0_s1 & ~((cpu_0_instruction_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (2 < cpu_0_instruction_master_latency_counter) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & ~cfi_flash_0_s1_waits_for_read;

  //shift register p1 cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else 
        cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 = cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //allow new arb cycle for tri_state_bridge_0/avalon_slave, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/instruction_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[0];

  //cpu_0/instruction_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[0] && cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/data_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[1];

  //cpu_0/data_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[1] && cpu_0_data_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0/avalon_slave chosen-master double-vector, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_double_vector = {tri_state_bridge_0_avalon_slave_master_qreq_vector, tri_state_bridge_0_avalon_slave_master_qreq_vector} & ({~tri_state_bridge_0_avalon_slave_master_qreq_vector, ~tri_state_bridge_0_avalon_slave_master_qreq_vector} + tri_state_bridge_0_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign tri_state_bridge_0_avalon_slave_arb_winner = (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle & | tri_state_bridge_0_avalon_slave_grant_vector) ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;

  //saved tri_state_bridge_0_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= 0;
      else if (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= |tri_state_bridge_0_avalon_slave_grant_vector ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign tri_state_bridge_0_avalon_slave_grant_vector = {(tri_state_bridge_0_avalon_slave_chosen_master_double_vector[1] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[3]),
    (tri_state_bridge_0_avalon_slave_chosen_master_double_vector[0] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[2])};

  //tri_state_bridge_0/avalon_slave chosen master rotated left, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_rot_left = (tri_state_bridge_0_avalon_slave_arb_winner << 1) ? (tri_state_bridge_0_avalon_slave_arb_winner << 1) : 1;

  //tri_state_bridge_0/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_addend <= 1;
      else if (|tri_state_bridge_0_avalon_slave_grant_vector)
          tri_state_bridge_0_avalon_slave_arb_addend <= tri_state_bridge_0_avalon_slave_end_xfer? tri_state_bridge_0_avalon_slave_chosen_master_rot_left : tri_state_bridge_0_avalon_slave_grant_vector;
    end


  assign p1_select_n_to_the_cfi_flash_0 = ~(cpu_0_data_master_granted_cfi_flash_0_s1 | cpu_0_instruction_master_granted_cfi_flash_0_s1);
  //tri_state_bridge_0_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_firsttransfer = tri_state_bridge_0_avalon_slave_begins_xfer ? tri_state_bridge_0_avalon_slave_unreg_firsttransfer : tri_state_bridge_0_avalon_slave_reg_firsttransfer;

  //tri_state_bridge_0_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_unreg_firsttransfer = ~(tri_state_bridge_0_avalon_slave_slavearbiterlockenable & tri_state_bridge_0_avalon_slave_any_continuerequest);

  //tri_state_bridge_0_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (tri_state_bridge_0_avalon_slave_begins_xfer)
          tri_state_bridge_0_avalon_slave_reg_firsttransfer <= tri_state_bridge_0_avalon_slave_unreg_firsttransfer;
    end


  //tri_state_bridge_0_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_beginbursttransfer_internal = tri_state_bridge_0_avalon_slave_begins_xfer;

  //tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal = tri_state_bridge_0_avalon_slave_begins_xfer & tri_state_bridge_0_avalon_slave_firsttransfer;

  //~read_n_to_the_cfi_flash_0 of type read to ~p1_read_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_n_to_the_cfi_flash_0 <= ~0;
      else 
        read_n_to_the_cfi_flash_0 <= p1_read_n_to_the_cfi_flash_0;
    end


  //~p1_read_n_to_the_cfi_flash_0 assignment, which is an e_mux
  assign p1_read_n_to_the_cfi_flash_0 = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read))& ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter < 8));

  //~write_n_to_the_cfi_flash_0 of type write to ~p1_write_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_n_to_the_cfi_flash_0 <= ~0;
      else 
        write_n_to_the_cfi_flash_0 <= p1_write_n_to_the_cfi_flash_0;
    end


  //~p1_write_n_to_the_cfi_flash_0 assignment, which is an e_mux
  assign p1_write_n_to_the_cfi_flash_0 = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write)) & ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter >= 2) & (cfi_flash_0_s1_wait_counter < 10) & cfi_flash_0_s1_pretend_byte_enable);

  //address_to_the_cfi_flash_0 of type address to p1_address_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          address_to_the_cfi_flash_0 <= 0;
      else 
        address_to_the_cfi_flash_0 <= p1_address_to_the_cfi_flash_0;
    end


  //p1_address_to_the_cfi_flash_0 mux, which is an e_mux
  assign p1_address_to_the_cfi_flash_0 = (cpu_0_data_master_granted_cfi_flash_0_s1)? ({cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1 : 0]}) :
    ({cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1 : 0]});

  //d1_tri_state_bridge_0_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tri_state_bridge_0_avalon_slave_end_xfer <= 1;
      else 
        d1_tri_state_bridge_0_avalon_slave_end_xfer <= tri_state_bridge_0_avalon_slave_end_xfer;
    end


  //cfi_flash_0_s1_waits_for_read in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_read = cfi_flash_0_s1_in_a_read_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cfi_flash_0_s1_in_a_read_cycle;

  //cfi_flash_0_s1_waits_for_write in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_write = cfi_flash_0_s1_in_a_write_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_write_cycle = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cfi_flash_0_s1_in_a_write_cycle;

  assign cfi_flash_0_s1_wait_counter_eq_0 = cfi_flash_0_s1_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cfi_flash_0_s1_wait_counter <= 0;
      else 
        cfi_flash_0_s1_wait_counter <= cfi_flash_0_s1_counter_load_value;
    end


  assign cfi_flash_0_s1_counter_load_value = ((cfi_flash_0_s1_in_a_write_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 10 :
    ((cfi_flash_0_s1_in_a_read_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 8 :
    (~cfi_flash_0_s1_wait_counter_eq_0)? cfi_flash_0_s1_wait_counter - 1 :
    0;

  assign wait_for_cfi_flash_0_s1_counter = tri_state_bridge_0_avalon_slave_begins_xfer | ~cfi_flash_0_s1_wait_counter_eq_0;
  //cfi_flash_0_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign cfi_flash_0_s1_pretend_byte_enable = (cpu_0_data_master_granted_cfi_flash_0_s1)? cpu_0_data_master_byteenable_cfi_flash_0_s1 :
    -1;

  assign {cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_cfi_flash_0_s1 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2 :
    cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //incoming_data_to_and_from_the_cfi_flash_0_bit_0_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_0_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[0]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[0] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[0] = incoming_data_to_and_from_the_cfi_flash_0_bit_0_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[0];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_1_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_1_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[1]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[1] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[1] = incoming_data_to_and_from_the_cfi_flash_0_bit_1_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[1];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_2_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_2_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[2]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[2] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[2] = incoming_data_to_and_from_the_cfi_flash_0_bit_2_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[2];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_3_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_3_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[3]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[3] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[3] = incoming_data_to_and_from_the_cfi_flash_0_bit_3_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[3];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_4_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_4_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[4]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[4] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[4] = incoming_data_to_and_from_the_cfi_flash_0_bit_4_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[4];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_5_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_5_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[5]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[5] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[5] = incoming_data_to_and_from_the_cfi_flash_0_bit_5_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[5];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_6_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_6_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[6]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[6] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[6] = incoming_data_to_and_from_the_cfi_flash_0_bit_6_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[6];

  //incoming_data_to_and_from_the_cfi_flash_0_bit_7_is_x x check, which is an e_assign_is_x
  assign incoming_data_to_and_from_the_cfi_flash_0_bit_7_is_x = ^(incoming_data_to_and_from_the_cfi_flash_0[7]) === 1'bx;

  //Crush incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[7] Xs to 0, which is an e_assign
  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0[7] = incoming_data_to_and_from_the_cfi_flash_0_bit_7_is_x ? 1'b0 : incoming_data_to_and_from_the_cfi_flash_0[7];

  //cfi_flash_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cfi_flash_0_s1 + cpu_0_instruction_master_granted_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cfi_flash_0_s1 + cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0 = incoming_data_to_and_from_the_cfi_flash_0;
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_bridge_arbitrator 
;



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_dual_clock_buffer_0_avalon_dc_buffer_sink_arbitrator (
                                                                    // inputs:
                                                                     clk,
                                                                     reset_n,
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready,
                                                                     video_rgb_resampler_0_avalon_rgb_source_data,
                                                                     video_rgb_resampler_0_avalon_rgb_source_endofpacket,
                                                                     video_rgb_resampler_0_avalon_rgb_source_startofpacket,
                                                                     video_rgb_resampler_0_avalon_rgb_source_valid,

                                                                    // outputs:
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_data,
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket,
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa,
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket,
                                                                     video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid
                                                                  )
;

  output  [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_sink_data;
  output           video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket;
  output           video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa;
  output           video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket;
  output           video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid;
  input            clk;
  input            reset_n;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready;
  input   [ 29: 0] video_rgb_resampler_0_avalon_rgb_source_data;
  input            video_rgb_resampler_0_avalon_rgb_source_endofpacket;
  input            video_rgb_resampler_0_avalon_rgb_source_startofpacket;
  input            video_rgb_resampler_0_avalon_rgb_source_valid;

  wire    [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_sink_data;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid;
  //mux video_dual_clock_buffer_0_avalon_dc_buffer_sink_data, which is an e_mux
  assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_data = video_rgb_resampler_0_avalon_rgb_source_data;

  //mux video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket, which is an e_mux
  assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket = video_rgb_resampler_0_avalon_rgb_source_endofpacket;

  //assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa = video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa = video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready;

  //mux video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket, which is an e_mux
  assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket = video_rgb_resampler_0_avalon_rgb_source_startofpacket;

  //mux video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid, which is an e_mux
  assign video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid = video_rgb_resampler_0_avalon_rgb_source_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_dual_clock_buffer_0_avalon_dc_buffer_source_arbitrator (
                                                                      // inputs:
                                                                       clk,
                                                                       reset_n,
                                                                       video_dual_clock_buffer_0_avalon_dc_buffer_source_data,
                                                                       video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket,
                                                                       video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket,
                                                                       video_dual_clock_buffer_0_avalon_dc_buffer_source_valid,
                                                                       video_vga_controller_0_avalon_vga_sink_ready_from_sa,

                                                                      // outputs:
                                                                       video_dual_clock_buffer_0_avalon_dc_buffer_source_ready
                                                                    )
;

  output           video_dual_clock_buffer_0_avalon_dc_buffer_source_ready;
  input            clk;
  input            reset_n;
  input   [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_source_data;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_valid;
  input            video_vga_controller_0_avalon_vga_sink_ready_from_sa;

  wire             video_dual_clock_buffer_0_avalon_dc_buffer_source_ready;
  //mux video_dual_clock_buffer_0_avalon_dc_buffer_source_ready, which is an e_mux
  assign video_dual_clock_buffer_0_avalon_dc_buffer_source_ready = video_vga_controller_0_avalon_vga_sink_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_pixel_buffer_dma_0_avalon_control_slave_arbitrator (
                                                                  // inputs:
                                                                   clk,
                                                                   cpu_0_data_master_address_to_slave,
                                                                   cpu_0_data_master_byteenable,
                                                                   cpu_0_data_master_latency_counter,
                                                                   cpu_0_data_master_read,
                                                                   cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                                                   cpu_0_data_master_write,
                                                                   cpu_0_data_master_writedata,
                                                                   reset_n,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_readdata,

                                                                  // outputs:
                                                                   cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave,
                                                                   cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave,
                                                                   cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave,
                                                                   cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave,
                                                                   d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_address,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_byteenable,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_read,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_write,
                                                                   video_pixel_buffer_dma_0_avalon_control_slave_writedata
                                                                )
;

  output           cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave;
  output           cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave;
  output           cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave;
  output           cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;
  output           d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
  output  [  1: 0] video_pixel_buffer_dma_0_avalon_control_slave_address;
  output  [  3: 0] video_pixel_buffer_dma_0_avalon_control_slave_byteenable;
  output           video_pixel_buffer_dma_0_avalon_control_slave_read;
  output  [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa;
  output           video_pixel_buffer_dma_0_avalon_control_slave_write;
  output  [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_writedata;
  input            clk;
  input   [ 24: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_latency_counter;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave;
  reg              cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register;
  wire             cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register_in;
  wire             cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             cpu_0_data_master_saved_grant_video_pixel_buffer_dma_0_avalon_control_slave;
  reg              d1_reasons_to_wait;
  reg              d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p1_cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register;
  wire    [ 24: 0] shifted_address_to_video_pixel_buffer_dma_0_avalon_control_slave_from_cpu_0_data_master;
  wire    [  1: 0] video_pixel_buffer_dma_0_avalon_control_slave_address;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_allgrants;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_allow_new_arb_cycle;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_any_bursting_master_saved_grant;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_any_continuerequest;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_arb_counter_enable;
  reg     [  2: 0] video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter;
  wire    [  2: 0] video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value;
  wire    [  2: 0] video_pixel_buffer_dma_0_avalon_control_slave_arb_share_set_values;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_beginbursttransfer_internal;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_begins_xfer;
  wire    [  3: 0] video_pixel_buffer_dma_0_avalon_control_slave_byteenable;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_firsttransfer;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_grant_vector;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_in_a_read_cycle;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_in_a_write_cycle;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_master_qreq_vector;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_non_bursting_master_requests;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_read;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa;
  reg              video_pixel_buffer_dma_0_avalon_control_slave_reg_firsttransfer;
  reg              video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable2;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_unreg_firsttransfer;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_waits_for_read;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_waits_for_write;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_write;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_writedata;
  wire             wait_for_video_pixel_buffer_dma_0_avalon_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
    end


  assign video_pixel_buffer_dma_0_avalon_control_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave));
  //assign video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa = video_pixel_buffer_dma_0_avalon_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa = video_pixel_buffer_dma_0_avalon_control_slave_readdata;

  assign cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave = ({cpu_0_data_master_address_to_slave[24 : 4] , 4'b0} == 25'h1111400) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter set values, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_arb_share_set_values = 1;

  //video_pixel_buffer_dma_0_avalon_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_non_bursting_master_requests = cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;

  //video_pixel_buffer_dma_0_avalon_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_any_bursting_master_saved_grant = 0;

  //video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value = video_pixel_buffer_dma_0_avalon_control_slave_firsttransfer ? (video_pixel_buffer_dma_0_avalon_control_slave_arb_share_set_values - 1) : |video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter ? (video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter - 1) : 0;

  //video_pixel_buffer_dma_0_avalon_control_slave_allgrants all slave grants, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_allgrants = |video_pixel_buffer_dma_0_avalon_control_slave_grant_vector;

  //video_pixel_buffer_dma_0_avalon_control_slave_end_xfer assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_end_xfer = ~(video_pixel_buffer_dma_0_avalon_control_slave_waits_for_read | video_pixel_buffer_dma_0_avalon_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave = video_pixel_buffer_dma_0_avalon_control_slave_end_xfer & (~video_pixel_buffer_dma_0_avalon_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave & video_pixel_buffer_dma_0_avalon_control_slave_allgrants) | (end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave & ~video_pixel_buffer_dma_0_avalon_control_slave_non_bursting_master_requests);

  //video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter <= 0;
      else if (video_pixel_buffer_dma_0_avalon_control_slave_arb_counter_enable)
          video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter <= video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value;
    end


  //video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable <= 0;
      else if ((|video_pixel_buffer_dma_0_avalon_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave) | (end_xfer_arb_share_counter_term_video_pixel_buffer_dma_0_avalon_control_slave & ~video_pixel_buffer_dma_0_avalon_control_slave_non_bursting_master_requests))
          video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable <= |video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master video_pixel_buffer_dma_0/avalon_control_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable2 = |video_pixel_buffer_dma_0_avalon_control_slave_arb_share_counter_next_value;

  //cpu_0/data_master video_pixel_buffer_dma_0/avalon_control_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //video_pixel_buffer_dma_0_avalon_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave = cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave & ~((cpu_0_data_master_read & ((1 < cpu_0_data_master_latency_counter) | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))));
  //cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register_in = cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave & cpu_0_data_master_read & ~video_pixel_buffer_dma_0_avalon_control_slave_waits_for_read;

  //shift register p1 cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register = {cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register, cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register_in};

  //cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register <= p1_cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave, which is an e_mux
  assign cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave = cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave_shift_register;

  //video_pixel_buffer_dma_0_avalon_control_slave_writedata mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave = cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave;

  //cpu_0/data_master saved-grant video_pixel_buffer_dma_0/avalon_control_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_video_pixel_buffer_dma_0_avalon_control_slave = cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;

  //allow new arb cycle for video_pixel_buffer_dma_0/avalon_control_slave, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign video_pixel_buffer_dma_0_avalon_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign video_pixel_buffer_dma_0_avalon_control_slave_master_qreq_vector = 1;

  //video_pixel_buffer_dma_0_avalon_control_slave_firsttransfer first transaction, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_firsttransfer = video_pixel_buffer_dma_0_avalon_control_slave_begins_xfer ? video_pixel_buffer_dma_0_avalon_control_slave_unreg_firsttransfer : video_pixel_buffer_dma_0_avalon_control_slave_reg_firsttransfer;

  //video_pixel_buffer_dma_0_avalon_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_unreg_firsttransfer = ~(video_pixel_buffer_dma_0_avalon_control_slave_slavearbiterlockenable & video_pixel_buffer_dma_0_avalon_control_slave_any_continuerequest);

  //video_pixel_buffer_dma_0_avalon_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_control_slave_reg_firsttransfer <= 1'b1;
      else if (video_pixel_buffer_dma_0_avalon_control_slave_begins_xfer)
          video_pixel_buffer_dma_0_avalon_control_slave_reg_firsttransfer <= video_pixel_buffer_dma_0_avalon_control_slave_unreg_firsttransfer;
    end


  //video_pixel_buffer_dma_0_avalon_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_beginbursttransfer_internal = video_pixel_buffer_dma_0_avalon_control_slave_begins_xfer;

  //video_pixel_buffer_dma_0_avalon_control_slave_read assignment, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_read = cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave & cpu_0_data_master_read;

  //video_pixel_buffer_dma_0_avalon_control_slave_write assignment, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_write = cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave & cpu_0_data_master_write;

  assign shifted_address_to_video_pixel_buffer_dma_0_avalon_control_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //video_pixel_buffer_dma_0_avalon_control_slave_address mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_address = shifted_address_to_video_pixel_buffer_dma_0_avalon_control_slave_from_cpu_0_data_master >> 2;

  //d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer <= 1;
      else 
        d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer <= video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
    end


  //video_pixel_buffer_dma_0_avalon_control_slave_waits_for_read in a cycle, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_waits_for_read = video_pixel_buffer_dma_0_avalon_control_slave_in_a_read_cycle & 0;

  //video_pixel_buffer_dma_0_avalon_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_in_a_read_cycle = cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = video_pixel_buffer_dma_0_avalon_control_slave_in_a_read_cycle;

  //video_pixel_buffer_dma_0_avalon_control_slave_waits_for_write in a cycle, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_waits_for_write = video_pixel_buffer_dma_0_avalon_control_slave_in_a_write_cycle & 0;

  //video_pixel_buffer_dma_0_avalon_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_control_slave_in_a_write_cycle = cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = video_pixel_buffer_dma_0_avalon_control_slave_in_a_write_cycle;

  assign wait_for_video_pixel_buffer_dma_0_avalon_control_slave_counter = 0;
  //video_pixel_buffer_dma_0_avalon_control_slave_byteenable byte enable port mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_control_slave_byteenable = (cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //video_pixel_buffer_dma_0/avalon_control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_module (
                                                                                                // inputs:
                                                                                                 clear_fifo,
                                                                                                 clk,
                                                                                                 data_in,
                                                                                                 read,
                                                                                                 reset_n,
                                                                                                 sync_reset,
                                                                                                 write,

                                                                                                // outputs:
                                                                                                 data_out,
                                                                                                 empty,
                                                                                                 fifo_contains_ones_n,
                                                                                                 full
                                                                                              )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbitrator (
                                                                     // inputs:
                                                                      clk,
                                                                      d1_sdram_0_s1_end_xfer,
                                                                      reset_n,
                                                                      sdram_0_s1_readdata_from_sa,
                                                                      sdram_0_s1_waitrequest_from_sa,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_address,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_read,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1,

                                                                     // outputs:
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset,
                                                                      video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest
                                                                   )
;

  output  [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
  output  [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset;
  output           video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest;
  input            clk;
  input            d1_sdram_0_s1_end_xfer;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;
  input   [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_read;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register;
  input            video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;

  reg              active_and_waiting_last_time;
  wire             empty_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo;
  wire             full_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo;
  wire             latency_load_value;
  wire             p1_video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
  wire             pre_flush_video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid;
  wire             r_2;
  wire             read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo;
  wire    [  7: 0] sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs;
  wire             selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output;
  wire             selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output_sdram_0_s1;
  reg     [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_last_time;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_is_granted_some_slave;
  reg              video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
  reg              video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_but_no_slave_selected;
  reg              video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_last_time;
  wire    [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_run;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest;
  wire             write_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo;
  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1 | ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1) & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1 | ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1) & ((~video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1 | ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_read | (1 & ~sdram_0_s1_waitrequest_from_sa & video_pixel_buffer_dma_0_avalon_pixel_dma_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_run = r_2;

  //optimize select-logic by passing only those address bits which matter.
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave = {9'b1,
    video_pixel_buffer_dma_0_avalon_pixel_dma_master_address[22 : 0]};

  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_but_no_slave_selected <= 0;
      else 
        video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_but_no_slave_selected <= video_pixel_buffer_dma_0_avalon_pixel_dma_master_read & video_pixel_buffer_dma_0_avalon_pixel_dma_master_run & ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_is_granted_some_slave = video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid = video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid = video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_but_no_slave_selected |
    pre_flush_video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid;

  //Negative Dynamic Bus-sizing mux.
  //this mux selects the correct half of the 
  //wide data coming from the slave sdram_0/s1 
  assign sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs = ((selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output_sdram_0_s1 == 0))? sdram_0_s1_readdata_from_sa[7 : 0] :
    sdram_0_s1_readdata_from_sa[15 : 8];

  //read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo fifo read, which is an e_mux
  assign read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo = video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;

  //write_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo fifo write, which is an e_mux
  assign write_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo = video_pixel_buffer_dma_0_avalon_pixel_dma_master_read & video_pixel_buffer_dma_0_avalon_pixel_dma_master_run & video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;

  assign selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output_sdram_0_s1 = selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output;
  //selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo, which is an e_fifo_with_registered_outputs
  selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_module selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave[0]),
      .data_out             (selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo_output),
      .empty                (empty_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo),
      .fifo_contains_ones_n (),
      .full                 (full_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo),
      .read                 (read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (write_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo)
    );

  //video_pixel_buffer_dma_0/avalon_pixel_dma_master readdata mux, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata = sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs;

  //actual waitrequest port, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest = ~video_pixel_buffer_dma_0_avalon_pixel_dma_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter <= 0;
      else 
        video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter <= p1_video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter = ((video_pixel_buffer_dma_0_avalon_pixel_dma_master_run & video_pixel_buffer_dma_0_avalon_pixel_dma_master_read))? latency_load_value :
    (video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter)? video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //~video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset assignment, which is an e_assign
  assign video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset = ~reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_last_time <= 0;
      else 
        video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_last_time <= video_pixel_buffer_dma_0_avalon_pixel_dma_master_address;
    end


  //video_pixel_buffer_dma_0/avalon_pixel_dma_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read);
    end


  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address != video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_last_time))
        begin
          $write("%0d ns: video_pixel_buffer_dma_0_avalon_pixel_dma_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_last_time <= 0;
      else 
        video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_last_time <= video_pixel_buffer_dma_0_avalon_pixel_dma_master_read;
    end


  //video_pixel_buffer_dma_0_avalon_pixel_dma_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read != video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_last_time))
        begin
          $write("%0d ns: video_pixel_buffer_dma_0_avalon_pixel_dma_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo read when empty, which is an e_process
  always @(posedge clk)
    begin
      if (empty_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo & read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo)
        begin
          $write("%0d ns: video_pixel_buffer_dma_0/avalon_pixel_dma_master negative rdv fifo selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo: read AND empty.\n", $time);
          $stop;
        end
    end


  //selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo write when full, which is an e_process
  always @(posedge clk)
    begin
      if (full_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo & write_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo & ~read_selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo)
        begin
          $write("%0d ns: video_pixel_buffer_dma_0/avalon_pixel_dma_master negative rdv fifo selecto_nrdv_video_pixel_buffer_dma_0_avalon_pixel_dma_master_1_sdram_0_s1_fifo: write AND full.\n", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_pixel_buffer_dma_0_avalon_pixel_source_arbitrator (
                                                                 // inputs:
                                                                  clk,
                                                                  reset_n,
                                                                  video_pixel_buffer_dma_0_avalon_pixel_source_data,
                                                                  video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket,
                                                                  video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket,
                                                                  video_pixel_buffer_dma_0_avalon_pixel_source_valid,
                                                                  video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa,

                                                                 // outputs:
                                                                  video_pixel_buffer_dma_0_avalon_pixel_source_ready
                                                               )
;

  output           video_pixel_buffer_dma_0_avalon_pixel_source_ready;
  input            clk;
  input            reset_n;
  input   [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_source_data;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_valid;
  input            video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa;

  wire             video_pixel_buffer_dma_0_avalon_pixel_source_ready;
  //mux video_pixel_buffer_dma_0_avalon_pixel_source_ready, which is an e_mux
  assign video_pixel_buffer_dma_0_avalon_pixel_source_ready = video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_rgb_resampler_0_avalon_rgb_sink_arbitrator (
                                                          // inputs:
                                                           clk,
                                                           reset_n,
                                                           video_pixel_buffer_dma_0_avalon_pixel_source_data,
                                                           video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket,
                                                           video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket,
                                                           video_pixel_buffer_dma_0_avalon_pixel_source_valid,
                                                           video_rgb_resampler_0_avalon_rgb_sink_ready,

                                                          // outputs:
                                                           video_rgb_resampler_0_avalon_rgb_sink_data,
                                                           video_rgb_resampler_0_avalon_rgb_sink_endofpacket,
                                                           video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa,
                                                           video_rgb_resampler_0_avalon_rgb_sink_reset,
                                                           video_rgb_resampler_0_avalon_rgb_sink_startofpacket,
                                                           video_rgb_resampler_0_avalon_rgb_sink_valid
                                                        )
;

  output  [  7: 0] video_rgb_resampler_0_avalon_rgb_sink_data;
  output           video_rgb_resampler_0_avalon_rgb_sink_endofpacket;
  output           video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa;
  output           video_rgb_resampler_0_avalon_rgb_sink_reset;
  output           video_rgb_resampler_0_avalon_rgb_sink_startofpacket;
  output           video_rgb_resampler_0_avalon_rgb_sink_valid;
  input            clk;
  input            reset_n;
  input   [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_source_data;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket;
  input            video_pixel_buffer_dma_0_avalon_pixel_source_valid;
  input            video_rgb_resampler_0_avalon_rgb_sink_ready;

  wire    [  7: 0] video_rgb_resampler_0_avalon_rgb_sink_data;
  wire             video_rgb_resampler_0_avalon_rgb_sink_endofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa;
  wire             video_rgb_resampler_0_avalon_rgb_sink_reset;
  wire             video_rgb_resampler_0_avalon_rgb_sink_startofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_sink_valid;
  //mux video_rgb_resampler_0_avalon_rgb_sink_data, which is an e_mux
  assign video_rgb_resampler_0_avalon_rgb_sink_data = video_pixel_buffer_dma_0_avalon_pixel_source_data;

  //mux video_rgb_resampler_0_avalon_rgb_sink_endofpacket, which is an e_mux
  assign video_rgb_resampler_0_avalon_rgb_sink_endofpacket = video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket;

  //assign video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa = video_rgb_resampler_0_avalon_rgb_sink_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa = video_rgb_resampler_0_avalon_rgb_sink_ready;

  //mux video_rgb_resampler_0_avalon_rgb_sink_startofpacket, which is an e_mux
  assign video_rgb_resampler_0_avalon_rgb_sink_startofpacket = video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket;

  //mux video_rgb_resampler_0_avalon_rgb_sink_valid, which is an e_mux
  assign video_rgb_resampler_0_avalon_rgb_sink_valid = video_pixel_buffer_dma_0_avalon_pixel_source_valid;

  //~video_rgb_resampler_0_avalon_rgb_sink_reset assignment, which is an e_assign
  assign video_rgb_resampler_0_avalon_rgb_sink_reset = ~reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_rgb_resampler_0_avalon_rgb_source_arbitrator (
                                                            // inputs:
                                                             clk,
                                                             reset_n,
                                                             video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa,
                                                             video_rgb_resampler_0_avalon_rgb_source_data,
                                                             video_rgb_resampler_0_avalon_rgb_source_endofpacket,
                                                             video_rgb_resampler_0_avalon_rgb_source_startofpacket,
                                                             video_rgb_resampler_0_avalon_rgb_source_valid,

                                                            // outputs:
                                                             video_rgb_resampler_0_avalon_rgb_source_ready
                                                          )
;

  output           video_rgb_resampler_0_avalon_rgb_source_ready;
  input            clk;
  input            reset_n;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa;
  input   [ 29: 0] video_rgb_resampler_0_avalon_rgb_source_data;
  input            video_rgb_resampler_0_avalon_rgb_source_endofpacket;
  input            video_rgb_resampler_0_avalon_rgb_source_startofpacket;
  input            video_rgb_resampler_0_avalon_rgb_source_valid;

  wire             video_rgb_resampler_0_avalon_rgb_source_ready;
  //mux video_rgb_resampler_0_avalon_rgb_source_ready, which is an e_mux
  assign video_rgb_resampler_0_avalon_rgb_source_ready = video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module video_vga_controller_0_avalon_vga_sink_arbitrator (
                                                           // inputs:
                                                            clk,
                                                            reset_n,
                                                            video_dual_clock_buffer_0_avalon_dc_buffer_source_data,
                                                            video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket,
                                                            video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket,
                                                            video_dual_clock_buffer_0_avalon_dc_buffer_source_valid,
                                                            video_vga_controller_0_avalon_vga_sink_ready,

                                                           // outputs:
                                                            video_vga_controller_0_avalon_vga_sink_data,
                                                            video_vga_controller_0_avalon_vga_sink_endofpacket,
                                                            video_vga_controller_0_avalon_vga_sink_ready_from_sa,
                                                            video_vga_controller_0_avalon_vga_sink_reset,
                                                            video_vga_controller_0_avalon_vga_sink_startofpacket,
                                                            video_vga_controller_0_avalon_vga_sink_valid
                                                         )
;

  output  [ 29: 0] video_vga_controller_0_avalon_vga_sink_data;
  output           video_vga_controller_0_avalon_vga_sink_endofpacket;
  output           video_vga_controller_0_avalon_vga_sink_ready_from_sa;
  output           video_vga_controller_0_avalon_vga_sink_reset;
  output           video_vga_controller_0_avalon_vga_sink_startofpacket;
  output           video_vga_controller_0_avalon_vga_sink_valid;
  input            clk;
  input            reset_n;
  input   [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_source_data;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket;
  input            video_dual_clock_buffer_0_avalon_dc_buffer_source_valid;
  input            video_vga_controller_0_avalon_vga_sink_ready;

  wire    [ 29: 0] video_vga_controller_0_avalon_vga_sink_data;
  wire             video_vga_controller_0_avalon_vga_sink_endofpacket;
  wire             video_vga_controller_0_avalon_vga_sink_ready_from_sa;
  wire             video_vga_controller_0_avalon_vga_sink_reset;
  wire             video_vga_controller_0_avalon_vga_sink_startofpacket;
  wire             video_vga_controller_0_avalon_vga_sink_valid;
  //mux video_vga_controller_0_avalon_vga_sink_data, which is an e_mux
  assign video_vga_controller_0_avalon_vga_sink_data = video_dual_clock_buffer_0_avalon_dc_buffer_source_data;

  //mux video_vga_controller_0_avalon_vga_sink_endofpacket, which is an e_mux
  assign video_vga_controller_0_avalon_vga_sink_endofpacket = video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket;

  //assign video_vga_controller_0_avalon_vga_sink_ready_from_sa = video_vga_controller_0_avalon_vga_sink_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign video_vga_controller_0_avalon_vga_sink_ready_from_sa = video_vga_controller_0_avalon_vga_sink_ready;

  //mux video_vga_controller_0_avalon_vga_sink_startofpacket, which is an e_mux
  assign video_vga_controller_0_avalon_vga_sink_startofpacket = video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket;

  //mux video_vga_controller_0_avalon_vga_sink_valid, which is an e_mux
  assign video_vga_controller_0_avalon_vga_sink_valid = video_dual_clock_buffer_0_avalon_dc_buffer_source_valid;

  //~video_vga_controller_0_avalon_vga_sink_reset assignment, which is an e_assign
  assign video_vga_controller_0_avalon_vga_sink_reset = ~reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main_reset_sys_clk_domain_synch_module (
                                                // inputs:
                                                 clk,
                                                 data_in,
                                                 reset_n,

                                                // outputs:
                                                 data_out
                                              )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main_reset_clk_50_domain_synch_module (
                                               // inputs:
                                                clk,
                                                data_in,
                                                reset_n,

                                               // outputs:
                                                data_out
                                             )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main_reset_vga_clk_domain_synch_module (
                                                // inputs:
                                                 clk,
                                                 data_in,
                                                 reset_n,

                                                // outputs:
                                                 data_out
                                              )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module main (
              // 1) global signals:
               audio_clk,
               clk_27,
               clk_50,
               reset_n,
               sdram_clk,
               sys_clk,
               vga_clk,

              // the_audio_0
               AUD_ADCDAT_to_the_audio_0,
               AUD_ADCLRCK_to_and_from_the_audio_0,
               AUD_BCLK_to_and_from_the_audio_0,
               AUD_DACDAT_from_the_audio_0,
               AUD_DACLRCK_to_and_from_the_audio_0,

              // the_audio_and_video_config_0
               I2C_SCLK_from_the_audio_and_video_config_0,
               I2C_SDAT_to_and_from_the_audio_and_video_config_0,

              // the_bridge_0
               acknowledge_from_the_bridge_0,
               address_to_the_bridge_0,
               byte_enable_to_the_bridge_0,
               read_data_from_the_bridge_0,
               read_to_the_bridge_0,
               write_data_to_the_bridge_0,
               write_to_the_bridge_0,

              // the_character_lcd_0
               LCD_BLON_from_the_character_lcd_0,
               LCD_DATA_to_and_from_the_character_lcd_0,
               LCD_EN_from_the_character_lcd_0,
               LCD_ON_from_the_character_lcd_0,
               LCD_RS_from_the_character_lcd_0,
               LCD_RW_from_the_character_lcd_0,

              // the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst
               interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst,

              // the_red_leds
               LEDR_from_the_red_leds,

              // the_sd_card_0
               b_SD_cmd_to_and_from_the_sd_card_0,
               b_SD_dat3_to_and_from_the_sd_card_0,
               b_SD_dat_to_and_from_the_sd_card_0,
               o_SD_clock_from_the_sd_card_0,

              // the_sdram_0
               zs_addr_from_the_sdram_0,
               zs_ba_from_the_sdram_0,
               zs_cas_n_from_the_sdram_0,
               zs_cke_from_the_sdram_0,
               zs_cs_n_from_the_sdram_0,
               zs_dq_to_and_from_the_sdram_0,
               zs_dqm_from_the_sdram_0,
               zs_ras_n_from_the_sdram_0,
               zs_we_n_from_the_sdram_0,

              // the_seven_seg_3_0
               HEX0_from_the_seven_seg_3_0,
               HEX1_from_the_seven_seg_3_0,
               HEX2_from_the_seven_seg_3_0,
               HEX3_from_the_seven_seg_3_0,

              // the_seven_seg_7_4
               HEX4_from_the_seven_seg_7_4,
               HEX5_from_the_seven_seg_7_4,
               HEX6_from_the_seven_seg_7_4,
               HEX7_from_the_seven_seg_7_4,

              // the_to_external_bus_bridge_0
               acknowledge_to_the_to_external_bus_bridge_0,
               address_from_the_to_external_bus_bridge_0,
               bus_enable_from_the_to_external_bus_bridge_0,
               byte_enable_from_the_to_external_bus_bridge_0,
               irq_to_the_to_external_bus_bridge_0,
               read_data_to_the_to_external_bus_bridge_0,
               rw_from_the_to_external_bus_bridge_0,
               write_data_from_the_to_external_bus_bridge_0,

              // the_tri_state_bridge_0_avalon_slave
               address_to_the_cfi_flash_0,
               data_to_and_from_the_cfi_flash_0,
               read_n_to_the_cfi_flash_0,
               select_n_to_the_cfi_flash_0,
               write_n_to_the_cfi_flash_0,

              // the_video_vga_controller_0
               VGA_BLANK_from_the_video_vga_controller_0,
               VGA_B_from_the_video_vga_controller_0,
               VGA_CLK_from_the_video_vga_controller_0,
               VGA_G_from_the_video_vga_controller_0,
               VGA_HS_from_the_video_vga_controller_0,
               VGA_R_from_the_video_vga_controller_0,
               VGA_SYNC_from_the_video_vga_controller_0,
               VGA_VS_from_the_video_vga_controller_0
            )
;

  inout            AUD_ADCLRCK_to_and_from_the_audio_0;
  inout            AUD_BCLK_to_and_from_the_audio_0;
  output           AUD_DACDAT_from_the_audio_0;
  inout            AUD_DACLRCK_to_and_from_the_audio_0;
  output  [  6: 0] HEX0_from_the_seven_seg_3_0;
  output  [  6: 0] HEX1_from_the_seven_seg_3_0;
  output  [  6: 0] HEX2_from_the_seven_seg_3_0;
  output  [  6: 0] HEX3_from_the_seven_seg_3_0;
  output  [  6: 0] HEX4_from_the_seven_seg_7_4;
  output  [  6: 0] HEX5_from_the_seven_seg_7_4;
  output  [  6: 0] HEX6_from_the_seven_seg_7_4;
  output  [  6: 0] HEX7_from_the_seven_seg_7_4;
  output           I2C_SCLK_from_the_audio_and_video_config_0;
  inout            I2C_SDAT_to_and_from_the_audio_and_video_config_0;
  output           LCD_BLON_from_the_character_lcd_0;
  inout   [  7: 0] LCD_DATA_to_and_from_the_character_lcd_0;
  output           LCD_EN_from_the_character_lcd_0;
  output           LCD_ON_from_the_character_lcd_0;
  output           LCD_RS_from_the_character_lcd_0;
  output           LCD_RW_from_the_character_lcd_0;
  output  [ 17: 0] LEDR_from_the_red_leds;
  output           VGA_BLANK_from_the_video_vga_controller_0;
  output  [  9: 0] VGA_B_from_the_video_vga_controller_0;
  output           VGA_CLK_from_the_video_vga_controller_0;
  output  [  9: 0] VGA_G_from_the_video_vga_controller_0;
  output           VGA_HS_from_the_video_vga_controller_0;
  output  [  9: 0] VGA_R_from_the_video_vga_controller_0;
  output           VGA_SYNC_from_the_video_vga_controller_0;
  output           VGA_VS_from_the_video_vga_controller_0;
  output           acknowledge_from_the_bridge_0;
  output  [ 19: 0] address_from_the_to_external_bus_bridge_0;
  output  [ 21: 0] address_to_the_cfi_flash_0;
  output           audio_clk;
  inout            b_SD_cmd_to_and_from_the_sd_card_0;
  inout            b_SD_dat3_to_and_from_the_sd_card_0;
  inout            b_SD_dat_to_and_from_the_sd_card_0;
  output           bus_enable_from_the_to_external_bus_bridge_0;
  output  [  1: 0] byte_enable_from_the_to_external_bus_bridge_0;
  inout   [  7: 0] data_to_and_from_the_cfi_flash_0;
  output           o_SD_clock_from_the_sd_card_0;
  output  [ 15: 0] read_data_from_the_bridge_0;
  output           read_n_to_the_cfi_flash_0;
  output           rw_from_the_to_external_bus_bridge_0;
  output           sdram_clk;
  output           select_n_to_the_cfi_flash_0;
  output           sys_clk;
  output           vga_clk;
  output  [ 15: 0] write_data_from_the_to_external_bus_bridge_0;
  output           write_n_to_the_cfi_flash_0;
  output  [ 11: 0] zs_addr_from_the_sdram_0;
  output  [  1: 0] zs_ba_from_the_sdram_0;
  output           zs_cas_n_from_the_sdram_0;
  output           zs_cke_from_the_sdram_0;
  output           zs_cs_n_from_the_sdram_0;
  inout   [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  output  [  1: 0] zs_dqm_from_the_sdram_0;
  output           zs_ras_n_from_the_sdram_0;
  output           zs_we_n_from_the_sdram_0;
  input            AUD_ADCDAT_to_the_audio_0;
  input            acknowledge_to_the_to_external_bus_bridge_0;
  input   [ 23: 0] address_to_the_bridge_0;
  input   [  1: 0] byte_enable_to_the_bridge_0;
  input            clk_27;
  input            clk_50;
  input            interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst;
  input            irq_to_the_to_external_bus_bridge_0;
  input   [ 15: 0] read_data_to_the_to_external_bus_bridge_0;
  input            read_to_the_bridge_0;
  input            reset_n;
  input   [ 15: 0] write_data_to_the_bridge_0;
  input            write_to_the_bridge_0;

  wire             AUD_ADCLRCK_to_and_from_the_audio_0;
  wire             AUD_BCLK_to_and_from_the_audio_0;
  wire             AUD_DACDAT_from_the_audio_0;
  wire             AUD_DACLRCK_to_and_from_the_audio_0;
  wire    [  6: 0] HEX0_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX1_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX2_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX3_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX4_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX5_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX6_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX7_from_the_seven_seg_7_4;
  wire             I2C_SCLK_from_the_audio_and_video_config_0;
  wire             I2C_SDAT_to_and_from_the_audio_and_video_config_0;
  wire             LCD_BLON_from_the_character_lcd_0;
  wire    [  7: 0] LCD_DATA_to_and_from_the_character_lcd_0;
  wire             LCD_EN_from_the_character_lcd_0;
  wire             LCD_ON_from_the_character_lcd_0;
  wire             LCD_RS_from_the_character_lcd_0;
  wire             LCD_RW_from_the_character_lcd_0;
  wire    [ 17: 0] LEDR_from_the_red_leds;
  wire             VGA_BLANK_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_B_from_the_video_vga_controller_0;
  wire             VGA_CLK_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_G_from_the_video_vga_controller_0;
  wire             VGA_HS_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_R_from_the_video_vga_controller_0;
  wire             VGA_SYNC_from_the_video_vga_controller_0;
  wire             VGA_VS_from_the_video_vga_controller_0;
  wire             acknowledge_from_the_bridge_0;
  wire    [ 19: 0] address_from_the_to_external_bus_bridge_0;
  wire    [ 21: 0] address_to_the_cfi_flash_0;
  wire    [  1: 0] audio_0_avalon_audio_slave_address;
  wire             audio_0_avalon_audio_slave_chipselect;
  wire             audio_0_avalon_audio_slave_irq;
  wire             audio_0_avalon_audio_slave_irq_from_sa;
  wire             audio_0_avalon_audio_slave_read;
  wire    [ 31: 0] audio_0_avalon_audio_slave_readdata;
  wire    [ 31: 0] audio_0_avalon_audio_slave_readdata_from_sa;
  wire             audio_0_avalon_audio_slave_reset;
  wire             audio_0_avalon_audio_slave_write;
  wire    [ 31: 0] audio_0_avalon_audio_slave_writedata;
  wire    [  1: 0] audio_and_video_config_0_avalon_av_config_slave_address;
  wire    [  3: 0] audio_and_video_config_0_avalon_av_config_slave_byteenable;
  wire             audio_and_video_config_0_avalon_av_config_slave_read;
  wire    [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata;
  wire    [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa;
  wire             audio_and_video_config_0_avalon_av_config_slave_reset;
  wire             audio_and_video_config_0_avalon_av_config_slave_waitrequest;
  wire             audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa;
  wire             audio_and_video_config_0_avalon_av_config_slave_write;
  wire    [ 31: 0] audio_and_video_config_0_avalon_av_config_slave_writedata;
  wire             audio_clk;
  wire             b_SD_cmd_to_and_from_the_sd_card_0;
  wire             b_SD_dat3_to_and_from_the_sd_card_0;
  wire             b_SD_dat_to_and_from_the_sd_card_0;
  wire    [ 23: 0] bridge_0_avalon_master_address;
  wire    [ 23: 0] bridge_0_avalon_master_address_to_slave;
  wire    [  1: 0] bridge_0_avalon_master_byteenable;
  wire             bridge_0_avalon_master_read;
  wire    [ 15: 0] bridge_0_avalon_master_readdata;
  wire             bridge_0_avalon_master_waitrequest;
  wire             bridge_0_avalon_master_write;
  wire    [ 15: 0] bridge_0_avalon_master_writedata;
  wire             bridge_0_granted_sdram_0_s1;
  wire             bridge_0_qualified_request_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1_shift_register;
  wire             bridge_0_requests_sdram_0_s1;
  wire             bus_enable_from_the_to_external_bus_bridge_0;
  wire    [  1: 0] byte_enable_from_the_to_external_bus_bridge_0;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             character_lcd_0_avalon_lcd_slave_address;
  wire             character_lcd_0_avalon_lcd_slave_chipselect;
  wire             character_lcd_0_avalon_lcd_slave_read;
  wire    [  7: 0] character_lcd_0_avalon_lcd_slave_readdata;
  wire    [  7: 0] character_lcd_0_avalon_lcd_slave_readdata_from_sa;
  wire             character_lcd_0_avalon_lcd_slave_reset;
  wire             character_lcd_0_avalon_lcd_slave_waitrequest;
  wire             character_lcd_0_avalon_lcd_slave_waitrequest_from_sa;
  wire             character_lcd_0_avalon_lcd_slave_write;
  wire    [  7: 0] character_lcd_0_avalon_lcd_slave_writedata;
  wire             clk_50_reset_n;
  wire             clocks_0_avalon_clocks_slave_address;
  wire    [  7: 0] clocks_0_avalon_clocks_slave_readdata;
  wire    [  7: 0] clocks_0_avalon_clocks_slave_readdata_from_sa;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_a;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_b;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_c;
  wire             cpu_0_custom_instruction_master_multi_clk;
  wire             cpu_0_custom_instruction_master_multi_clk_en;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_dataa;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_datab;
  wire             cpu_0_custom_instruction_master_multi_done;
  wire             cpu_0_custom_instruction_master_multi_estatus;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_ipending;
  wire    [  7: 0] cpu_0_custom_instruction_master_multi_n;
  wire             cpu_0_custom_instruction_master_multi_readra;
  wire             cpu_0_custom_instruction_master_multi_readrb;
  wire             cpu_0_custom_instruction_master_multi_reset;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_result;
  wire             cpu_0_custom_instruction_master_multi_start;
  wire             cpu_0_custom_instruction_master_multi_status;
  wire             cpu_0_custom_instruction_master_multi_writerc;
  wire             cpu_0_custom_instruction_master_reset_n;
  wire             cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0;
  wire    [ 24: 0] cpu_0_data_master_address;
  wire    [ 24: 0] cpu_0_data_master_address_to_slave;
  wire    [  3: 0] cpu_0_data_master_byteenable;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire             cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_byteenable_main_clock_0_in;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave;
  wire    [  1: 0] cpu_0_data_master_dbs_address;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire             cpu_0_data_master_debugaccess;
  wire             cpu_0_data_master_granted_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_granted_main_clock_0_in;
  wire             cpu_0_data_master_granted_onchip_memory2_0_s1;
  wire             cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_granted_sysid_control_slave;
  wire             cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave;
  wire    [ 31: 0] cpu_0_data_master_irq;
  wire    [  1: 0] cpu_0_data_master_latency_counter;
  wire             cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_main_clock_0_in;
  wire             cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  wire             cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_qualified_request_sysid_control_slave;
  wire             cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             cpu_0_data_master_read;
  wire             cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_main_clock_0_in;
  wire             cpu_0_data_master_read_data_valid_onchip_memory2_0_s1;
  wire             cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_read_data_valid_sysid_control_slave;
  wire             cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_readdatavalid;
  wire             cpu_0_data_master_requests_audio_0_avalon_audio_slave;
  wire             cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_main_clock_0_in;
  wire             cpu_0_data_master_requests_onchip_memory2_0_s1;
  wire             cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave;
  wire             cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave;
  wire             cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave;
  wire             cpu_0_data_master_requests_sysid_control_slave;
  wire             cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave;
  wire             cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave;
  wire             cpu_0_data_master_waitrequest;
  wire             cpu_0_data_master_write;
  wire    [ 31: 0] cpu_0_data_master_writedata;
  wire    [ 24: 0] cpu_0_instruction_master_address;
  wire    [ 24: 0] cpu_0_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_0_instruction_master_dbs_address;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire    [  1: 0] cpu_0_instruction_master_latency_counter;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_read;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_waitrequest;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_resetrequest;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset;
  wire    [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result;
  wire    [ 31: 0] cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select;
  wire             cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start;
  wire             d1_audio_0_avalon_audio_slave_end_xfer;
  wire             d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer;
  wire             d1_character_lcd_0_avalon_lcd_slave_end_xfer;
  wire             d1_clocks_0_avalon_clocks_slave_end_xfer;
  wire             d1_cpu_0_jtag_debug_module_end_xfer;
  wire             d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             d1_main_clock_0_in_end_xfer;
  wire             d1_onchip_memory2_0_s1_end_xfer;
  wire             d1_red_leds_avalon_parallel_port_slave_end_xfer;
  wire             d1_sd_card_0_avalon_sdcard_slave_end_xfer;
  wire             d1_sdram_0_s1_end_xfer;
  wire             d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer;
  wire             d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_to_external_bus_bridge_0_avalon_slave_end_xfer;
  wire             d1_tri_state_bridge_0_avalon_slave_end_xfer;
  wire             d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer;
  wire    [  7: 0] data_to_and_from_the_cfi_flash_0;
  wire    [  7: 0] incoming_data_to_and_from_the_cfi_flash_0;
  wire    [  7: 0] incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_irq;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire             main_clock_0_in_address;
  wire             main_clock_0_in_endofpacket;
  wire             main_clock_0_in_endofpacket_from_sa;
  wire             main_clock_0_in_nativeaddress;
  wire             main_clock_0_in_read;
  wire    [  7: 0] main_clock_0_in_readdata;
  wire    [  7: 0] main_clock_0_in_readdata_from_sa;
  wire             main_clock_0_in_reset_n;
  wire             main_clock_0_in_waitrequest;
  wire             main_clock_0_in_waitrequest_from_sa;
  wire             main_clock_0_in_write;
  wire    [  7: 0] main_clock_0_in_writedata;
  wire             main_clock_0_out_address;
  wire             main_clock_0_out_address_to_slave;
  wire             main_clock_0_out_endofpacket;
  wire             main_clock_0_out_granted_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_nativeaddress;
  wire             main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_read;
  wire             main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave;
  wire    [  7: 0] main_clock_0_out_readdata;
  wire             main_clock_0_out_requests_clocks_0_avalon_clocks_slave;
  wire             main_clock_0_out_reset_n;
  wire             main_clock_0_out_waitrequest;
  wire             main_clock_0_out_write;
  wire    [  7: 0] main_clock_0_out_writedata;
  wire             o_SD_clock_from_the_sd_card_0;
  wire    [ 12: 0] onchip_memory2_0_s1_address;
  wire    [  3: 0] onchip_memory2_0_s1_byteenable;
  wire             onchip_memory2_0_s1_chipselect;
  wire             onchip_memory2_0_s1_clken;
  wire    [ 31: 0] onchip_memory2_0_s1_readdata;
  wire    [ 31: 0] onchip_memory2_0_s1_readdata_from_sa;
  wire             onchip_memory2_0_s1_reset;
  wire             onchip_memory2_0_s1_write;
  wire    [ 31: 0] onchip_memory2_0_s1_writedata;
  wire             out_clk_clocks_0_AUD_CLK;
  wire             out_clk_clocks_0_SDRAM_CLK;
  wire             out_clk_clocks_0_VGA_CLK;
  wire             out_clk_clocks_0_sys_clk;
  wire    [ 15: 0] read_data_from_the_bridge_0;
  wire             read_n_to_the_cfi_flash_0;
  wire    [  1: 0] red_leds_avalon_parallel_port_slave_address;
  wire    [  3: 0] red_leds_avalon_parallel_port_slave_byteenable;
  wire             red_leds_avalon_parallel_port_slave_chipselect;
  wire             red_leds_avalon_parallel_port_slave_read;
  wire    [ 31: 0] red_leds_avalon_parallel_port_slave_readdata;
  wire    [ 31: 0] red_leds_avalon_parallel_port_slave_readdata_from_sa;
  wire             red_leds_avalon_parallel_port_slave_reset;
  wire             red_leds_avalon_parallel_port_slave_write;
  wire    [ 31: 0] red_leds_avalon_parallel_port_slave_writedata;
  wire             reset_n_sources;
  wire             rw_from_the_to_external_bus_bridge_0;
  wire    [  7: 0] sd_card_0_avalon_sdcard_slave_address;
  wire    [  3: 0] sd_card_0_avalon_sdcard_slave_byteenable;
  wire             sd_card_0_avalon_sdcard_slave_chipselect;
  wire             sd_card_0_avalon_sdcard_slave_read;
  wire    [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata;
  wire    [ 31: 0] sd_card_0_avalon_sdcard_slave_readdata_from_sa;
  wire             sd_card_0_avalon_sdcard_slave_reset_n;
  wire             sd_card_0_avalon_sdcard_slave_waitrequest;
  wire             sd_card_0_avalon_sdcard_slave_waitrequest_from_sa;
  wire             sd_card_0_avalon_sdcard_slave_write;
  wire    [ 31: 0] sd_card_0_avalon_sdcard_slave_writedata;
  wire    [ 21: 0] sdram_0_s1_address;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid;
  wire             sdram_0_s1_reset_n;
  wire             sdram_0_s1_waitrequest;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire             sdram_clk;
  wire             select_n_to_the_cfi_flash_0;
  wire    [  1: 0] seven_seg_3_0_avalon_parallel_port_slave_address;
  wire    [  3: 0] seven_seg_3_0_avalon_parallel_port_slave_byteenable;
  wire             seven_seg_3_0_avalon_parallel_port_slave_chipselect;
  wire             seven_seg_3_0_avalon_parallel_port_slave_read;
  wire    [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata;
  wire    [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa;
  wire             seven_seg_3_0_avalon_parallel_port_slave_reset;
  wire             seven_seg_3_0_avalon_parallel_port_slave_write;
  wire    [ 31: 0] seven_seg_3_0_avalon_parallel_port_slave_writedata;
  wire    [  1: 0] seven_seg_7_4_avalon_parallel_port_slave_address;
  wire    [  3: 0] seven_seg_7_4_avalon_parallel_port_slave_byteenable;
  wire             seven_seg_7_4_avalon_parallel_port_slave_chipselect;
  wire             seven_seg_7_4_avalon_parallel_port_slave_read;
  wire    [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata;
  wire    [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa;
  wire             seven_seg_7_4_avalon_parallel_port_slave_reset;
  wire             seven_seg_7_4_avalon_parallel_port_slave_write;
  wire    [ 31: 0] seven_seg_7_4_avalon_parallel_port_slave_writedata;
  wire             sys_clk;
  wire             sys_clk_reset_n;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_clock;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire             sysid_control_slave_reset_n;
  wire    [ 18: 0] to_external_bus_bridge_0_avalon_slave_address;
  wire    [  1: 0] to_external_bus_bridge_0_avalon_slave_byteenable;
  wire             to_external_bus_bridge_0_avalon_slave_chipselect;
  wire             to_external_bus_bridge_0_avalon_slave_irq;
  wire             to_external_bus_bridge_0_avalon_slave_irq_from_sa;
  wire             to_external_bus_bridge_0_avalon_slave_read;
  wire    [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata;
  wire    [ 15: 0] to_external_bus_bridge_0_avalon_slave_readdata_from_sa;
  wire             to_external_bus_bridge_0_avalon_slave_reset;
  wire             to_external_bus_bridge_0_avalon_slave_waitrequest;
  wire             to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa;
  wire             to_external_bus_bridge_0_avalon_slave_write;
  wire    [ 15: 0] to_external_bus_bridge_0_avalon_slave_writedata;
  wire             vga_clk;
  wire             vga_clk_reset_n;
  wire    [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_sink_data;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid;
  wire    [ 29: 0] video_dual_clock_buffer_0_avalon_dc_buffer_source_data;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_source_ready;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket;
  wire             video_dual_clock_buffer_0_avalon_dc_buffer_source_valid;
  wire    [  1: 0] video_pixel_buffer_dma_0_avalon_control_slave_address;
  wire    [  3: 0] video_pixel_buffer_dma_0_avalon_control_slave_byteenable;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_read;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa;
  wire             video_pixel_buffer_dma_0_avalon_control_slave_write;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_control_slave_writedata;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address;
  wire    [ 31: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_read;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register;
  wire    [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset;
  wire             video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest;
  wire    [  7: 0] video_pixel_buffer_dma_0_avalon_pixel_source_data;
  wire             video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket;
  wire             video_pixel_buffer_dma_0_avalon_pixel_source_ready;
  wire             video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket;
  wire             video_pixel_buffer_dma_0_avalon_pixel_source_valid;
  wire    [  7: 0] video_rgb_resampler_0_avalon_rgb_sink_data;
  wire             video_rgb_resampler_0_avalon_rgb_sink_endofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_sink_ready;
  wire             video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa;
  wire             video_rgb_resampler_0_avalon_rgb_sink_reset;
  wire             video_rgb_resampler_0_avalon_rgb_sink_startofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_sink_valid;
  wire    [ 29: 0] video_rgb_resampler_0_avalon_rgb_source_data;
  wire             video_rgb_resampler_0_avalon_rgb_source_endofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_source_ready;
  wire             video_rgb_resampler_0_avalon_rgb_source_startofpacket;
  wire             video_rgb_resampler_0_avalon_rgb_source_valid;
  wire    [ 29: 0] video_vga_controller_0_avalon_vga_sink_data;
  wire             video_vga_controller_0_avalon_vga_sink_endofpacket;
  wire             video_vga_controller_0_avalon_vga_sink_ready;
  wire             video_vga_controller_0_avalon_vga_sink_ready_from_sa;
  wire             video_vga_controller_0_avalon_vga_sink_reset;
  wire             video_vga_controller_0_avalon_vga_sink_startofpacket;
  wire             video_vga_controller_0_avalon_vga_sink_valid;
  wire    [ 15: 0] write_data_from_the_to_external_bus_bridge_0;
  wire             write_n_to_the_cfi_flash_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;
  audio_0_avalon_audio_slave_arbitrator the_audio_0_avalon_audio_slave
    (
      .audio_0_avalon_audio_slave_address                             (audio_0_avalon_audio_slave_address),
      .audio_0_avalon_audio_slave_chipselect                          (audio_0_avalon_audio_slave_chipselect),
      .audio_0_avalon_audio_slave_irq                                 (audio_0_avalon_audio_slave_irq),
      .audio_0_avalon_audio_slave_irq_from_sa                         (audio_0_avalon_audio_slave_irq_from_sa),
      .audio_0_avalon_audio_slave_read                                (audio_0_avalon_audio_slave_read),
      .audio_0_avalon_audio_slave_readdata                            (audio_0_avalon_audio_slave_readdata),
      .audio_0_avalon_audio_slave_readdata_from_sa                    (audio_0_avalon_audio_slave_readdata_from_sa),
      .audio_0_avalon_audio_slave_reset                               (audio_0_avalon_audio_slave_reset),
      .audio_0_avalon_audio_slave_write                               (audio_0_avalon_audio_slave_write),
      .audio_0_avalon_audio_slave_writedata                           (audio_0_avalon_audio_slave_writedata),
      .clk                                                            (sys_clk),
      .cpu_0_data_master_address_to_slave                             (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_audio_0_avalon_audio_slave           (cpu_0_data_master_granted_audio_0_avalon_audio_slave),
      .cpu_0_data_master_latency_counter                              (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave (cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave),
      .cpu_0_data_master_read                                         (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave   (cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register    (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_audio_0_avalon_audio_slave          (cpu_0_data_master_requests_audio_0_avalon_audio_slave),
      .cpu_0_data_master_write                                        (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                    (cpu_0_data_master_writedata),
      .d1_audio_0_avalon_audio_slave_end_xfer                         (d1_audio_0_avalon_audio_slave_end_xfer),
      .reset_n                                                        (sys_clk_reset_n)
    );

  audio_0 the_audio_0
    (
      .AUD_ADCDAT  (AUD_ADCDAT_to_the_audio_0),
      .AUD_ADCLRCK (AUD_ADCLRCK_to_and_from_the_audio_0),
      .AUD_BCLK    (AUD_BCLK_to_and_from_the_audio_0),
      .AUD_DACDAT  (AUD_DACDAT_from_the_audio_0),
      .AUD_DACLRCK (AUD_DACLRCK_to_and_from_the_audio_0),
      .address     (audio_0_avalon_audio_slave_address),
      .chipselect  (audio_0_avalon_audio_slave_chipselect),
      .clk         (sys_clk),
      .irq         (audio_0_avalon_audio_slave_irq),
      .read        (audio_0_avalon_audio_slave_read),
      .readdata    (audio_0_avalon_audio_slave_readdata),
      .reset       (audio_0_avalon_audio_slave_reset),
      .write       (audio_0_avalon_audio_slave_write),
      .writedata   (audio_0_avalon_audio_slave_writedata)
    );

  audio_and_video_config_0_avalon_av_config_slave_arbitrator the_audio_and_video_config_0_avalon_av_config_slave
    (
      .audio_and_video_config_0_avalon_av_config_slave_address                             (audio_and_video_config_0_avalon_av_config_slave_address),
      .audio_and_video_config_0_avalon_av_config_slave_byteenable                          (audio_and_video_config_0_avalon_av_config_slave_byteenable),
      .audio_and_video_config_0_avalon_av_config_slave_read                                (audio_and_video_config_0_avalon_av_config_slave_read),
      .audio_and_video_config_0_avalon_av_config_slave_readdata                            (audio_and_video_config_0_avalon_av_config_slave_readdata),
      .audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa                    (audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa),
      .audio_and_video_config_0_avalon_av_config_slave_reset                               (audio_and_video_config_0_avalon_av_config_slave_reset),
      .audio_and_video_config_0_avalon_av_config_slave_waitrequest                         (audio_and_video_config_0_avalon_av_config_slave_waitrequest),
      .audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa                 (audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa),
      .audio_and_video_config_0_avalon_av_config_slave_write                               (audio_and_video_config_0_avalon_av_config_slave_write),
      .audio_and_video_config_0_avalon_av_config_slave_writedata                           (audio_and_video_config_0_avalon_av_config_slave_writedata),
      .clk                                                                                 (sys_clk),
      .cpu_0_data_master_address_to_slave                                                  (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                        (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave           (cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_latency_counter                                                   (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave (cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_read                                                              (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave   (cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                         (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave          (cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_write                                                             (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                         (cpu_0_data_master_writedata),
      .d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer                         (d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer),
      .reset_n                                                                             (sys_clk_reset_n)
    );

  audio_and_video_config_0 the_audio_and_video_config_0
    (
      .I2C_SCLK    (I2C_SCLK_from_the_audio_and_video_config_0),
      .I2C_SDAT    (I2C_SDAT_to_and_from_the_audio_and_video_config_0),
      .address     (audio_and_video_config_0_avalon_av_config_slave_address),
      .byteenable  (audio_and_video_config_0_avalon_av_config_slave_byteenable),
      .clk         (sys_clk),
      .read        (audio_and_video_config_0_avalon_av_config_slave_read),
      .readdata    (audio_and_video_config_0_avalon_av_config_slave_readdata),
      .reset       (audio_and_video_config_0_avalon_av_config_slave_reset),
      .waitrequest (audio_and_video_config_0_avalon_av_config_slave_waitrequest),
      .write       (audio_and_video_config_0_avalon_av_config_slave_write),
      .writedata   (audio_and_video_config_0_avalon_av_config_slave_writedata)
    );

  bridge_0_avalon_master_arbitrator the_bridge_0_avalon_master
    (
      .bridge_0_avalon_master_address                     (bridge_0_avalon_master_address),
      .bridge_0_avalon_master_address_to_slave            (bridge_0_avalon_master_address_to_slave),
      .bridge_0_avalon_master_byteenable                  (bridge_0_avalon_master_byteenable),
      .bridge_0_avalon_master_read                        (bridge_0_avalon_master_read),
      .bridge_0_avalon_master_readdata                    (bridge_0_avalon_master_readdata),
      .bridge_0_avalon_master_waitrequest                 (bridge_0_avalon_master_waitrequest),
      .bridge_0_avalon_master_write                       (bridge_0_avalon_master_write),
      .bridge_0_avalon_master_writedata                   (bridge_0_avalon_master_writedata),
      .bridge_0_granted_sdram_0_s1                        (bridge_0_granted_sdram_0_s1),
      .bridge_0_qualified_request_sdram_0_s1              (bridge_0_qualified_request_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1                (bridge_0_read_data_valid_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1_shift_register (bridge_0_read_data_valid_sdram_0_s1_shift_register),
      .bridge_0_requests_sdram_0_s1                       (bridge_0_requests_sdram_0_s1),
      .clk                                                (sys_clk),
      .d1_sdram_0_s1_end_xfer                             (d1_sdram_0_s1_end_xfer),
      .reset_n                                            (sys_clk_reset_n),
      .sdram_0_s1_readdata_from_sa                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                     (sdram_0_s1_waitrequest_from_sa)
    );

  bridge_0 the_bridge_0
    (
      .acknowledge        (acknowledge_from_the_bridge_0),
      .address            (address_to_the_bridge_0),
      .avalon_address     (bridge_0_avalon_master_address),
      .avalon_byteenable  (bridge_0_avalon_master_byteenable),
      .avalon_read        (bridge_0_avalon_master_read),
      .avalon_readdata    (bridge_0_avalon_master_readdata),
      .avalon_waitrequest (bridge_0_avalon_master_waitrequest),
      .avalon_write       (bridge_0_avalon_master_write),
      .avalon_writedata   (bridge_0_avalon_master_writedata),
      .byte_enable        (byte_enable_to_the_bridge_0),
      .clk                (sys_clk),
      .read               (read_to_the_bridge_0),
      .read_data          (read_data_from_the_bridge_0),
      .write              (write_to_the_bridge_0),
      .write_data         (write_data_to_the_bridge_0)
    );

  character_lcd_0_avalon_lcd_slave_arbitrator the_character_lcd_0_avalon_lcd_slave
    (
      .character_lcd_0_avalon_lcd_slave_address                             (character_lcd_0_avalon_lcd_slave_address),
      .character_lcd_0_avalon_lcd_slave_chipselect                          (character_lcd_0_avalon_lcd_slave_chipselect),
      .character_lcd_0_avalon_lcd_slave_read                                (character_lcd_0_avalon_lcd_slave_read),
      .character_lcd_0_avalon_lcd_slave_readdata                            (character_lcd_0_avalon_lcd_slave_readdata),
      .character_lcd_0_avalon_lcd_slave_readdata_from_sa                    (character_lcd_0_avalon_lcd_slave_readdata_from_sa),
      .character_lcd_0_avalon_lcd_slave_reset                               (character_lcd_0_avalon_lcd_slave_reset),
      .character_lcd_0_avalon_lcd_slave_waitrequest                         (character_lcd_0_avalon_lcd_slave_waitrequest),
      .character_lcd_0_avalon_lcd_slave_waitrequest_from_sa                 (character_lcd_0_avalon_lcd_slave_waitrequest_from_sa),
      .character_lcd_0_avalon_lcd_slave_write                               (character_lcd_0_avalon_lcd_slave_write),
      .character_lcd_0_avalon_lcd_slave_writedata                           (character_lcd_0_avalon_lcd_slave_writedata),
      .clk                                                                  (sys_clk),
      .cpu_0_data_master_address_to_slave                                   (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                         (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave        (cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_dbs_address                                        (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_8                                        (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave           (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_latency_counter                                    (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave (cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_read                                               (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave   (cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register          (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave          (cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_write                                              (cpu_0_data_master_write),
      .d1_character_lcd_0_avalon_lcd_slave_end_xfer                         (d1_character_lcd_0_avalon_lcd_slave_end_xfer),
      .reset_n                                                              (sys_clk_reset_n)
    );

  character_lcd_0 the_character_lcd_0
    (
      .LCD_BLON    (LCD_BLON_from_the_character_lcd_0),
      .LCD_DATA    (LCD_DATA_to_and_from_the_character_lcd_0),
      .LCD_EN      (LCD_EN_from_the_character_lcd_0),
      .LCD_ON      (LCD_ON_from_the_character_lcd_0),
      .LCD_RS      (LCD_RS_from_the_character_lcd_0),
      .LCD_RW      (LCD_RW_from_the_character_lcd_0),
      .address     (character_lcd_0_avalon_lcd_slave_address),
      .chipselect  (character_lcd_0_avalon_lcd_slave_chipselect),
      .clk         (sys_clk),
      .read        (character_lcd_0_avalon_lcd_slave_read),
      .readdata    (character_lcd_0_avalon_lcd_slave_readdata),
      .reset       (character_lcd_0_avalon_lcd_slave_reset),
      .waitrequest (character_lcd_0_avalon_lcd_slave_waitrequest),
      .write       (character_lcd_0_avalon_lcd_slave_write),
      .writedata   (character_lcd_0_avalon_lcd_slave_writedata)
    );

  clocks_0_avalon_clocks_slave_arbitrator the_clocks_0_avalon_clocks_slave
    (
      .clk                                                             (clk_50),
      .clocks_0_avalon_clocks_slave_address                            (clocks_0_avalon_clocks_slave_address),
      .clocks_0_avalon_clocks_slave_readdata                           (clocks_0_avalon_clocks_slave_readdata),
      .clocks_0_avalon_clocks_slave_readdata_from_sa                   (clocks_0_avalon_clocks_slave_readdata_from_sa),
      .d1_clocks_0_avalon_clocks_slave_end_xfer                        (d1_clocks_0_avalon_clocks_slave_end_xfer),
      .main_clock_0_out_address_to_slave                               (main_clock_0_out_address_to_slave),
      .main_clock_0_out_granted_clocks_0_avalon_clocks_slave           (main_clock_0_out_granted_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave (main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_read                                           (main_clock_0_out_read),
      .main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave   (main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_requests_clocks_0_avalon_clocks_slave          (main_clock_0_out_requests_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_write                                          (main_clock_0_out_write),
      .reset_n                                                         (clk_50_reset_n)
    );

  //audio_clk out_clk assignment, which is an e_assign
  assign audio_clk = out_clk_clocks_0_AUD_CLK;

  //sdram_clk out_clk assignment, which is an e_assign
  assign sdram_clk = out_clk_clocks_0_SDRAM_CLK;

  //vga_clk out_clk assignment, which is an e_assign
  assign vga_clk = out_clk_clocks_0_VGA_CLK;

  //sys_clk out_clk assignment, which is an e_assign
  assign sys_clk = out_clk_clocks_0_sys_clk;

  clocks_0 the_clocks_0
    (
      .AUD_CLK   (out_clk_clocks_0_AUD_CLK),
      .CLOCK_27  (clk_27),
      .CLOCK_50  (clk_50),
      .SDRAM_CLK (out_clk_clocks_0_SDRAM_CLK),
      .VGA_CLK   (out_clk_clocks_0_VGA_CLK),
      .address   (clocks_0_avalon_clocks_slave_address),
      .readdata  (clocks_0_avalon_clocks_slave_readdata),
      .sys_clk   (out_clk_clocks_0_sys_clk)
    );

  cpu_0_jtag_debug_module_arbitrator the_cpu_0_jtag_debug_module
    (
      .clk                                                                (sys_clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_debugaccess                                      (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                  (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_latency_counter                                  (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module        (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module          (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register        (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                 (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                        (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_jtag_debug_module_address                                    (cpu_0_jtag_debug_module_address),
      .cpu_0_jtag_debug_module_begintransfer                              (cpu_0_jtag_debug_module_begintransfer),
      .cpu_0_jtag_debug_module_byteenable                                 (cpu_0_jtag_debug_module_byteenable),
      .cpu_0_jtag_debug_module_chipselect                                 (cpu_0_jtag_debug_module_chipselect),
      .cpu_0_jtag_debug_module_debugaccess                                (cpu_0_jtag_debug_module_debugaccess),
      .cpu_0_jtag_debug_module_readdata                                   (cpu_0_jtag_debug_module_readdata),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .cpu_0_jtag_debug_module_resetrequest                               (cpu_0_jtag_debug_module_resetrequest),
      .cpu_0_jtag_debug_module_resetrequest_from_sa                       (cpu_0_jtag_debug_module_resetrequest_from_sa),
      .cpu_0_jtag_debug_module_write                                      (cpu_0_jtag_debug_module_write),
      .cpu_0_jtag_debug_module_writedata                                  (cpu_0_jtag_debug_module_writedata),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .reset_n                                                            (sys_clk_reset_n)
    );

  cpu_0_custom_instruction_master_arbitrator the_cpu_0_custom_instruction_master
    (
      .clk                                                                                                                         (sys_clk),
      .cpu_0_custom_instruction_master_multi_done                                                                                  (cpu_0_custom_instruction_master_multi_done),
      .cpu_0_custom_instruction_master_multi_result                                                                                (cpu_0_custom_instruction_master_multi_result),
      .cpu_0_custom_instruction_master_multi_start                                                                                 (cpu_0_custom_instruction_master_multi_start),
      .cpu_0_custom_instruction_master_reset_n                                                                                     (cpu_0_custom_instruction_master_reset_n),
      .cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0 (cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa                          (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa                        (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select                                (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select),
      .reset_n                                                                                                                     (sys_clk_reset_n)
    );

  cpu_0_data_master_arbitrator the_cpu_0_data_master
    (
      .audio_0_avalon_audio_slave_irq_from_sa                                              (audio_0_avalon_audio_slave_irq_from_sa),
      .audio_0_avalon_audio_slave_readdata_from_sa                                         (audio_0_avalon_audio_slave_readdata_from_sa),
      .audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa                    (audio_and_video_config_0_avalon_av_config_slave_readdata_from_sa),
      .audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa                 (audio_and_video_config_0_avalon_av_config_slave_waitrequest_from_sa),
      .cfi_flash_0_s1_wait_counter_eq_0                                                    (cfi_flash_0_s1_wait_counter_eq_0),
      .character_lcd_0_avalon_lcd_slave_readdata_from_sa                                   (character_lcd_0_avalon_lcd_slave_readdata_from_sa),
      .character_lcd_0_avalon_lcd_slave_waitrequest_from_sa                                (character_lcd_0_avalon_lcd_slave_waitrequest_from_sa),
      .clk                                                                                 (sys_clk),
      .cpu_0_data_master_address                                                           (cpu_0_data_master_address),
      .cpu_0_data_master_address_to_slave                                                  (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                        (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                                         (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave                       (cpu_0_data_master_byteenable_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_byteenable_main_clock_0_in                                        (cpu_0_data_master_byteenable_main_clock_0_in),
      .cpu_0_data_master_byteenable_sdram_0_s1                                             (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave                  (cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_dbs_address                                                       (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                                      (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_dbs_write_8                                                       (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_audio_0_avalon_audio_slave                                (cpu_0_data_master_granted_audio_0_avalon_audio_slave),
      .cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave           (cpu_0_data_master_granted_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_granted_cfi_flash_0_s1                                            (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave                          (cpu_0_data_master_granted_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                                   (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave                             (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_granted_main_clock_0_in                                           (cpu_0_data_master_granted_main_clock_0_in),
      .cpu_0_data_master_granted_onchip_memory2_0_s1                                       (cpu_0_data_master_granted_onchip_memory2_0_s1),
      .cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave                       (cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave                             (cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_granted_sdram_0_s1                                                (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave                  (cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave                  (cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_granted_sysid_control_slave                                       (cpu_0_data_master_granted_sysid_control_slave),
      .cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave                     (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave             (cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_irq                                                               (cpu_0_data_master_irq),
      .cpu_0_data_master_latency_counter                                                   (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave                      (cpu_0_data_master_qualified_request_audio_0_avalon_audio_slave),
      .cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave (cpu_0_data_master_qualified_request_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                                  (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave                (cpu_0_data_master_qualified_request_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module                         (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave                   (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_main_clock_0_in                                 (cpu_0_data_master_qualified_request_main_clock_0_in),
      .cpu_0_data_master_qualified_request_onchip_memory2_0_s1                             (cpu_0_data_master_qualified_request_onchip_memory2_0_s1),
      .cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave             (cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave                   (cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_qualified_request_sdram_0_s1                                      (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave        (cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave        (cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_qualified_request_sysid_control_slave                             (cpu_0_data_master_qualified_request_sysid_control_slave),
      .cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave           (cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave   (cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_read                                                              (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave                        (cpu_0_data_master_read_data_valid_audio_0_avalon_audio_slave),
      .cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave   (cpu_0_data_master_read_data_valid_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                                    (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave                  (cpu_0_data_master_read_data_valid_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module                           (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave                     (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read_data_valid_main_clock_0_in                                   (cpu_0_data_master_read_data_valid_main_clock_0_in),
      .cpu_0_data_master_read_data_valid_onchip_memory2_0_s1                               (cpu_0_data_master_read_data_valid_onchip_memory2_0_s1),
      .cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave               (cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave                     (cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                                        (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                         (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave          (cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave          (cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_read_data_valid_sysid_control_slave                               (cpu_0_data_master_read_data_valid_sysid_control_slave),
      .cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave             (cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave     (cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_readdata                                                          (cpu_0_data_master_readdata),
      .cpu_0_data_master_readdatavalid                                                     (cpu_0_data_master_readdatavalid),
      .cpu_0_data_master_requests_audio_0_avalon_audio_slave                               (cpu_0_data_master_requests_audio_0_avalon_audio_slave),
      .cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave          (cpu_0_data_master_requests_audio_and_video_config_0_avalon_av_config_slave),
      .cpu_0_data_master_requests_cfi_flash_0_s1                                           (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave                         (cpu_0_data_master_requests_character_lcd_0_avalon_lcd_slave),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                                  (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave                            (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_requests_main_clock_0_in                                          (cpu_0_data_master_requests_main_clock_0_in),
      .cpu_0_data_master_requests_onchip_memory2_0_s1                                      (cpu_0_data_master_requests_onchip_memory2_0_s1),
      .cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave                      (cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave                            (cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_requests_sdram_0_s1                                               (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave                 (cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave                 (cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_requests_sysid_control_slave                                      (cpu_0_data_master_requests_sysid_control_slave),
      .cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave                    (cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave            (cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_waitrequest                                                       (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                                             (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                         (cpu_0_data_master_writedata),
      .cpu_0_jtag_debug_module_readdata_from_sa                                            (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_audio_0_avalon_audio_slave_end_xfer                                              (d1_audio_0_avalon_audio_slave_end_xfer),
      .d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer                         (d1_audio_and_video_config_0_avalon_av_config_slave_end_xfer),
      .d1_character_lcd_0_avalon_lcd_slave_end_xfer                                        (d1_character_lcd_0_avalon_lcd_slave_end_xfer),
      .d1_cpu_0_jtag_debug_module_end_xfer                                                 (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                                           (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .d1_main_clock_0_in_end_xfer                                                         (d1_main_clock_0_in_end_xfer),
      .d1_onchip_memory2_0_s1_end_xfer                                                     (d1_onchip_memory2_0_s1_end_xfer),
      .d1_red_leds_avalon_parallel_port_slave_end_xfer                                     (d1_red_leds_avalon_parallel_port_slave_end_xfer),
      .d1_sd_card_0_avalon_sdcard_slave_end_xfer                                           (d1_sd_card_0_avalon_sdcard_slave_end_xfer),
      .d1_sdram_0_s1_end_xfer                                                              (d1_sdram_0_s1_end_xfer),
      .d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer                                (d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer),
      .d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer                                (d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer),
      .d1_sysid_control_slave_end_xfer                                                     (d1_sysid_control_slave_end_xfer),
      .d1_to_external_bus_bridge_0_avalon_slave_end_xfer                                   (d1_to_external_bus_bridge_0_avalon_slave_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                                         (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer                           (d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer),
      .incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0                    (incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                                           (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                                      (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                                   (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .main_clock_0_in_readdata_from_sa                                                    (main_clock_0_in_readdata_from_sa),
      .main_clock_0_in_waitrequest_from_sa                                                 (main_clock_0_in_waitrequest_from_sa),
      .onchip_memory2_0_s1_readdata_from_sa                                                (onchip_memory2_0_s1_readdata_from_sa),
      .red_leds_avalon_parallel_port_slave_readdata_from_sa                                (red_leds_avalon_parallel_port_slave_readdata_from_sa),
      .reset_n                                                                             (sys_clk_reset_n),
      .sd_card_0_avalon_sdcard_slave_readdata_from_sa                                      (sd_card_0_avalon_sdcard_slave_readdata_from_sa),
      .sd_card_0_avalon_sdcard_slave_waitrequest_from_sa                                   (sd_card_0_avalon_sdcard_slave_waitrequest_from_sa),
      .sdram_0_s1_readdata_from_sa                                                         (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                                      (sdram_0_s1_waitrequest_from_sa),
      .seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa                           (seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa),
      .seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa                           (seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa),
      .sysid_control_slave_readdata_from_sa                                                (sysid_control_slave_readdata_from_sa),
      .to_external_bus_bridge_0_avalon_slave_irq_from_sa                                   (to_external_bus_bridge_0_avalon_slave_irq_from_sa),
      .to_external_bus_bridge_0_avalon_slave_readdata_from_sa                              (to_external_bus_bridge_0_avalon_slave_readdata_from_sa),
      .to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa                           (to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa),
      .video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa                      (video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa)
    );

  cpu_0_instruction_master_arbitrator the_cpu_0_instruction_master
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                   (cfi_flash_0_s1_wait_counter_eq_0),
      .clk                                                                (sys_clk),
      .cpu_0_instruction_master_address                                   (cpu_0_instruction_master_address),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                    (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_granted_onchip_memory2_0_s1               (cpu_0_instruction_master_granted_onchip_memory2_0_s1),
      .cpu_0_instruction_master_granted_sdram_0_s1                        (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1          (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1     (cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1              (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1            (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1       (cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_readdata                                  (cpu_0_instruction_master_readdata),
      .cpu_0_instruction_master_readdatavalid                             (cpu_0_instruction_master_readdatavalid),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                   (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_requests_onchip_memory2_0_s1              (cpu_0_instruction_master_requests_onchip_memory2_0_s1),
      .cpu_0_instruction_master_requests_sdram_0_s1                       (cpu_0_instruction_master_requests_sdram_0_s1),
      .cpu_0_instruction_master_waitrequest                               (cpu_0_instruction_master_waitrequest),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_onchip_memory2_0_s1_end_xfer                                    (d1_onchip_memory2_0_s1_end_xfer),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                        (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .incoming_data_to_and_from_the_cfi_flash_0                          (incoming_data_to_and_from_the_cfi_flash_0),
      .onchip_memory2_0_s1_readdata_from_sa                               (onchip_memory2_0_s1_readdata_from_sa),
      .reset_n                                                            (sys_clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa)
    );

  cpu_0 the_cpu_0
    (
      .A_ci_multi_a                          (cpu_0_custom_instruction_master_multi_a),
      .A_ci_multi_b                          (cpu_0_custom_instruction_master_multi_b),
      .A_ci_multi_c                          (cpu_0_custom_instruction_master_multi_c),
      .A_ci_multi_clk_en                     (cpu_0_custom_instruction_master_multi_clk_en),
      .A_ci_multi_clock                      (cpu_0_custom_instruction_master_multi_clk),
      .A_ci_multi_dataa                      (cpu_0_custom_instruction_master_multi_dataa),
      .A_ci_multi_datab                      (cpu_0_custom_instruction_master_multi_datab),
      .A_ci_multi_done                       (cpu_0_custom_instruction_master_multi_done),
      .A_ci_multi_estatus                    (cpu_0_custom_instruction_master_multi_estatus),
      .A_ci_multi_ipending                   (cpu_0_custom_instruction_master_multi_ipending),
      .A_ci_multi_n                          (cpu_0_custom_instruction_master_multi_n),
      .A_ci_multi_readra                     (cpu_0_custom_instruction_master_multi_readra),
      .A_ci_multi_readrb                     (cpu_0_custom_instruction_master_multi_readrb),
      .A_ci_multi_reset                      (cpu_0_custom_instruction_master_multi_reset),
      .A_ci_multi_result                     (cpu_0_custom_instruction_master_multi_result),
      .A_ci_multi_start                      (cpu_0_custom_instruction_master_multi_start),
      .A_ci_multi_status                     (cpu_0_custom_instruction_master_multi_status),
      .A_ci_multi_writerc                    (cpu_0_custom_instruction_master_multi_writerc),
      .clk                                   (sys_clk),
      .d_address                             (cpu_0_data_master_address),
      .d_byteenable                          (cpu_0_data_master_byteenable),
      .d_irq                                 (cpu_0_data_master_irq),
      .d_read                                (cpu_0_data_master_read),
      .d_readdata                            (cpu_0_data_master_readdata),
      .d_readdatavalid                       (cpu_0_data_master_readdatavalid),
      .d_waitrequest                         (cpu_0_data_master_waitrequest),
      .d_write                               (cpu_0_data_master_write),
      .d_writedata                           (cpu_0_data_master_writedata),
      .i_address                             (cpu_0_instruction_master_address),
      .i_read                                (cpu_0_instruction_master_read),
      .i_readdata                            (cpu_0_instruction_master_readdata),
      .i_readdatavalid                       (cpu_0_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_0_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_0_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_0_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_0_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (cpu_0_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_0_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_0_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (cpu_0_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_0_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_0_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_0_jtag_debug_module_writedata),
      .reset_n                               (cpu_0_custom_instruction_master_reset_n)
    );

  cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_arbitrator the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0
    (
      .clk                                                                                                                         (sys_clk),
      .cpu_0_custom_instruction_master_multi_clk_en                                                                                (cpu_0_custom_instruction_master_multi_clk_en),
      .cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0 (cpu_0_custom_instruction_master_start_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en                                (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done                                  (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa                          (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done_from_sa),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset                                 (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result                                (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa                        (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result_from_sa),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select                                (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_select),
      .cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start                                 (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start),
      .reset_n                                                                                                                     (sys_clk_reset_n)
    );

  cpu_0_wait_for_interrupt_custom_instruction_0_91_inst the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst
    (
      .clk       (sys_clk),
      .clk_en    (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_clk_en),
      .done      (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_done),
      .interrupt (interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst),
      .reset     (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_reset),
      .result    (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_result),
      .start     (cpu_0_wait_for_interrupt_custom_instruction_0_91_inst_nios_custom_instruction_slave_0_start)
    );

  jtag_uart_0_avalon_jtag_slave_arbitrator the_jtag_uart_0_avalon_jtag_slave
    (
      .clk                                                               (sys_clk),
      .cpu_0_data_master_address_to_slave                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave           (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_latency_counter                                 (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave   (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register       (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave          (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_write                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                       (cpu_0_data_master_writedata),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .jtag_uart_0_avalon_jtag_slave_address                             (jtag_uart_0_avalon_jtag_slave_address),
      .jtag_uart_0_avalon_jtag_slave_chipselect                          (jtag_uart_0_avalon_jtag_slave_chipselect),
      .jtag_uart_0_avalon_jtag_slave_dataavailable                       (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa               (jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_0_avalon_jtag_slave_irq                                 (jtag_uart_0_avalon_jtag_slave_irq),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                         (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_read_n                              (jtag_uart_0_avalon_jtag_slave_read_n),
      .jtag_uart_0_avalon_jtag_slave_readdata                            (jtag_uart_0_avalon_jtag_slave_readdata),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readyfordata                        (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa                (jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_reset_n                             (jtag_uart_0_avalon_jtag_slave_reset_n),
      .jtag_uart_0_avalon_jtag_slave_waitrequest                         (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_0_avalon_jtag_slave_write_n                             (jtag_uart_0_avalon_jtag_slave_write_n),
      .jtag_uart_0_avalon_jtag_slave_writedata                           (jtag_uart_0_avalon_jtag_slave_writedata),
      .reset_n                                                           (sys_clk_reset_n)
    );

  jtag_uart_0 the_jtag_uart_0
    (
      .av_address     (jtag_uart_0_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_0_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_0_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_0_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_0_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_0_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_0_avalon_jtag_slave_writedata),
      .clk            (sys_clk),
      .dataavailable  (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_0_avalon_jtag_slave_reset_n)
    );

  main_clock_0_in_arbitrator the_main_clock_0_in
    (
      .clk                                                         (sys_clk),
      .cpu_0_data_master_address_to_slave                          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_main_clock_0_in                (cpu_0_data_master_byteenable_main_clock_0_in),
      .cpu_0_data_master_dbs_address                               (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_8                               (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_main_clock_0_in                   (cpu_0_data_master_granted_main_clock_0_in),
      .cpu_0_data_master_latency_counter                           (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_main_clock_0_in         (cpu_0_data_master_qualified_request_main_clock_0_in),
      .cpu_0_data_master_read                                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_main_clock_0_in           (cpu_0_data_master_read_data_valid_main_clock_0_in),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_main_clock_0_in                  (cpu_0_data_master_requests_main_clock_0_in),
      .cpu_0_data_master_write                                     (cpu_0_data_master_write),
      .d1_main_clock_0_in_end_xfer                                 (d1_main_clock_0_in_end_xfer),
      .main_clock_0_in_address                                     (main_clock_0_in_address),
      .main_clock_0_in_endofpacket                                 (main_clock_0_in_endofpacket),
      .main_clock_0_in_endofpacket_from_sa                         (main_clock_0_in_endofpacket_from_sa),
      .main_clock_0_in_nativeaddress                               (main_clock_0_in_nativeaddress),
      .main_clock_0_in_read                                        (main_clock_0_in_read),
      .main_clock_0_in_readdata                                    (main_clock_0_in_readdata),
      .main_clock_0_in_readdata_from_sa                            (main_clock_0_in_readdata_from_sa),
      .main_clock_0_in_reset_n                                     (main_clock_0_in_reset_n),
      .main_clock_0_in_waitrequest                                 (main_clock_0_in_waitrequest),
      .main_clock_0_in_waitrequest_from_sa                         (main_clock_0_in_waitrequest_from_sa),
      .main_clock_0_in_write                                       (main_clock_0_in_write),
      .main_clock_0_in_writedata                                   (main_clock_0_in_writedata),
      .reset_n                                                     (sys_clk_reset_n)
    );

  main_clock_0_out_arbitrator the_main_clock_0_out
    (
      .clk                                                             (clk_50),
      .clocks_0_avalon_clocks_slave_readdata_from_sa                   (clocks_0_avalon_clocks_slave_readdata_from_sa),
      .d1_clocks_0_avalon_clocks_slave_end_xfer                        (d1_clocks_0_avalon_clocks_slave_end_xfer),
      .main_clock_0_out_address                                        (main_clock_0_out_address),
      .main_clock_0_out_address_to_slave                               (main_clock_0_out_address_to_slave),
      .main_clock_0_out_granted_clocks_0_avalon_clocks_slave           (main_clock_0_out_granted_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave (main_clock_0_out_qualified_request_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_read                                           (main_clock_0_out_read),
      .main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave   (main_clock_0_out_read_data_valid_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_readdata                                       (main_clock_0_out_readdata),
      .main_clock_0_out_requests_clocks_0_avalon_clocks_slave          (main_clock_0_out_requests_clocks_0_avalon_clocks_slave),
      .main_clock_0_out_reset_n                                        (main_clock_0_out_reset_n),
      .main_clock_0_out_waitrequest                                    (main_clock_0_out_waitrequest),
      .main_clock_0_out_write                                          (main_clock_0_out_write),
      .main_clock_0_out_writedata                                      (main_clock_0_out_writedata),
      .reset_n                                                         (clk_50_reset_n)
    );

  main_clock_0 the_main_clock_0
    (
      .master_address       (main_clock_0_out_address),
      .master_clk           (clk_50),
      .master_endofpacket   (main_clock_0_out_endofpacket),
      .master_nativeaddress (main_clock_0_out_nativeaddress),
      .master_read          (main_clock_0_out_read),
      .master_readdata      (main_clock_0_out_readdata),
      .master_reset_n       (main_clock_0_out_reset_n),
      .master_waitrequest   (main_clock_0_out_waitrequest),
      .master_write         (main_clock_0_out_write),
      .master_writedata     (main_clock_0_out_writedata),
      .slave_address        (main_clock_0_in_address),
      .slave_clk            (sys_clk),
      .slave_endofpacket    (main_clock_0_in_endofpacket),
      .slave_nativeaddress  (main_clock_0_in_nativeaddress),
      .slave_read           (main_clock_0_in_read),
      .slave_readdata       (main_clock_0_in_readdata),
      .slave_reset_n        (main_clock_0_in_reset_n),
      .slave_waitrequest    (main_clock_0_in_waitrequest),
      .slave_write          (main_clock_0_in_write),
      .slave_writedata      (main_clock_0_in_writedata)
    );

  onchip_memory2_0_s1_arbitrator the_onchip_memory2_0_s1
    (
      .clk                                                                (sys_clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_onchip_memory2_0_s1                      (cpu_0_data_master_granted_onchip_memory2_0_s1),
      .cpu_0_data_master_latency_counter                                  (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_onchip_memory2_0_s1            (cpu_0_data_master_qualified_request_onchip_memory2_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_onchip_memory2_0_s1              (cpu_0_data_master_read_data_valid_onchip_memory2_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register        (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_onchip_memory2_0_s1                     (cpu_0_data_master_requests_onchip_memory2_0_s1),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                        (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_onchip_memory2_0_s1               (cpu_0_instruction_master_granted_onchip_memory2_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1     (cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1       (cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_onchip_memory2_0_s1              (cpu_0_instruction_master_requests_onchip_memory2_0_s1),
      .d1_onchip_memory2_0_s1_end_xfer                                    (d1_onchip_memory2_0_s1_end_xfer),
      .onchip_memory2_0_s1_address                                        (onchip_memory2_0_s1_address),
      .onchip_memory2_0_s1_byteenable                                     (onchip_memory2_0_s1_byteenable),
      .onchip_memory2_0_s1_chipselect                                     (onchip_memory2_0_s1_chipselect),
      .onchip_memory2_0_s1_clken                                          (onchip_memory2_0_s1_clken),
      .onchip_memory2_0_s1_readdata                                       (onchip_memory2_0_s1_readdata),
      .onchip_memory2_0_s1_readdata_from_sa                               (onchip_memory2_0_s1_readdata_from_sa),
      .onchip_memory2_0_s1_reset                                          (onchip_memory2_0_s1_reset),
      .onchip_memory2_0_s1_write                                          (onchip_memory2_0_s1_write),
      .onchip_memory2_0_s1_writedata                                      (onchip_memory2_0_s1_writedata),
      .reset_n                                                            (sys_clk_reset_n)
    );

  onchip_memory2_0 the_onchip_memory2_0
    (
      .address    (onchip_memory2_0_s1_address),
      .byteenable (onchip_memory2_0_s1_byteenable),
      .chipselect (onchip_memory2_0_s1_chipselect),
      .clk        (sys_clk),
      .clken      (onchip_memory2_0_s1_clken),
      .readdata   (onchip_memory2_0_s1_readdata),
      .reset      (onchip_memory2_0_s1_reset),
      .write      (onchip_memory2_0_s1_write),
      .writedata  (onchip_memory2_0_s1_writedata)
    );

  red_leds_avalon_parallel_port_slave_arbitrator the_red_leds_avalon_parallel_port_slave
    (
      .clk                                                                     (sys_clk),
      .cpu_0_data_master_address_to_slave                                      (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                            (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave           (cpu_0_data_master_granted_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_latency_counter                                       (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave (cpu_0_data_master_qualified_request_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_read                                                  (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave   (cpu_0_data_master_read_data_valid_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register             (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave          (cpu_0_data_master_requests_red_leds_avalon_parallel_port_slave),
      .cpu_0_data_master_write                                                 (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                             (cpu_0_data_master_writedata),
      .d1_red_leds_avalon_parallel_port_slave_end_xfer                         (d1_red_leds_avalon_parallel_port_slave_end_xfer),
      .red_leds_avalon_parallel_port_slave_address                             (red_leds_avalon_parallel_port_slave_address),
      .red_leds_avalon_parallel_port_slave_byteenable                          (red_leds_avalon_parallel_port_slave_byteenable),
      .red_leds_avalon_parallel_port_slave_chipselect                          (red_leds_avalon_parallel_port_slave_chipselect),
      .red_leds_avalon_parallel_port_slave_read                                (red_leds_avalon_parallel_port_slave_read),
      .red_leds_avalon_parallel_port_slave_readdata                            (red_leds_avalon_parallel_port_slave_readdata),
      .red_leds_avalon_parallel_port_slave_readdata_from_sa                    (red_leds_avalon_parallel_port_slave_readdata_from_sa),
      .red_leds_avalon_parallel_port_slave_reset                               (red_leds_avalon_parallel_port_slave_reset),
      .red_leds_avalon_parallel_port_slave_write                               (red_leds_avalon_parallel_port_slave_write),
      .red_leds_avalon_parallel_port_slave_writedata                           (red_leds_avalon_parallel_port_slave_writedata),
      .reset_n                                                                 (sys_clk_reset_n)
    );

  red_leds the_red_leds
    (
      .LEDR       (LEDR_from_the_red_leds),
      .address    (red_leds_avalon_parallel_port_slave_address),
      .byteenable (red_leds_avalon_parallel_port_slave_byteenable),
      .chipselect (red_leds_avalon_parallel_port_slave_chipselect),
      .clk        (sys_clk),
      .read       (red_leds_avalon_parallel_port_slave_read),
      .readdata   (red_leds_avalon_parallel_port_slave_readdata),
      .reset      (red_leds_avalon_parallel_port_slave_reset),
      .write      (red_leds_avalon_parallel_port_slave_write),
      .writedata  (red_leds_avalon_parallel_port_slave_writedata)
    );

  sd_card_0_avalon_sdcard_slave_arbitrator the_sd_card_0_avalon_sdcard_slave
    (
      .clk                                                               (sys_clk),
      .cpu_0_data_master_address_to_slave                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                      (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave           (cpu_0_data_master_granted_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_latency_counter                                 (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave (cpu_0_data_master_qualified_request_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_read                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave   (cpu_0_data_master_read_data_valid_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register       (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave          (cpu_0_data_master_requests_sd_card_0_avalon_sdcard_slave),
      .cpu_0_data_master_write                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                       (cpu_0_data_master_writedata),
      .d1_sd_card_0_avalon_sdcard_slave_end_xfer                         (d1_sd_card_0_avalon_sdcard_slave_end_xfer),
      .reset_n                                                           (sys_clk_reset_n),
      .sd_card_0_avalon_sdcard_slave_address                             (sd_card_0_avalon_sdcard_slave_address),
      .sd_card_0_avalon_sdcard_slave_byteenable                          (sd_card_0_avalon_sdcard_slave_byteenable),
      .sd_card_0_avalon_sdcard_slave_chipselect                          (sd_card_0_avalon_sdcard_slave_chipselect),
      .sd_card_0_avalon_sdcard_slave_read                                (sd_card_0_avalon_sdcard_slave_read),
      .sd_card_0_avalon_sdcard_slave_readdata                            (sd_card_0_avalon_sdcard_slave_readdata),
      .sd_card_0_avalon_sdcard_slave_readdata_from_sa                    (sd_card_0_avalon_sdcard_slave_readdata_from_sa),
      .sd_card_0_avalon_sdcard_slave_reset_n                             (sd_card_0_avalon_sdcard_slave_reset_n),
      .sd_card_0_avalon_sdcard_slave_waitrequest                         (sd_card_0_avalon_sdcard_slave_waitrequest),
      .sd_card_0_avalon_sdcard_slave_waitrequest_from_sa                 (sd_card_0_avalon_sdcard_slave_waitrequest_from_sa),
      .sd_card_0_avalon_sdcard_slave_write                               (sd_card_0_avalon_sdcard_slave_write),
      .sd_card_0_avalon_sdcard_slave_writedata                           (sd_card_0_avalon_sdcard_slave_writedata)
    );

  sd_card_0 the_sd_card_0
    (
      .b_SD_cmd             (b_SD_cmd_to_and_from_the_sd_card_0),
      .b_SD_dat             (b_SD_dat_to_and_from_the_sd_card_0),
      .b_SD_dat3            (b_SD_dat3_to_and_from_the_sd_card_0),
      .i_avalon_address     (sd_card_0_avalon_sdcard_slave_address),
      .i_avalon_byteenable  (sd_card_0_avalon_sdcard_slave_byteenable),
      .i_avalon_chip_select (sd_card_0_avalon_sdcard_slave_chipselect),
      .i_avalon_read        (sd_card_0_avalon_sdcard_slave_read),
      .i_avalon_write       (sd_card_0_avalon_sdcard_slave_write),
      .i_avalon_writedata   (sd_card_0_avalon_sdcard_slave_writedata),
      .i_clock              (sys_clk),
      .i_reset_n            (sd_card_0_avalon_sdcard_slave_reset_n),
      .o_SD_clock           (o_SD_clock_from_the_sd_card_0),
      .o_avalon_readdata    (sd_card_0_avalon_sdcard_slave_readdata),
      .o_avalon_waitrequest (sd_card_0_avalon_sdcard_slave_waitrequest)
    );

  sdram_0_s1_arbitrator the_sdram_0_s1
    (
      .bridge_0_avalon_master_address_to_slave                                                    (bridge_0_avalon_master_address_to_slave),
      .bridge_0_avalon_master_byteenable                                                          (bridge_0_avalon_master_byteenable),
      .bridge_0_avalon_master_read                                                                (bridge_0_avalon_master_read),
      .bridge_0_avalon_master_write                                                               (bridge_0_avalon_master_write),
      .bridge_0_avalon_master_writedata                                                           (bridge_0_avalon_master_writedata),
      .bridge_0_granted_sdram_0_s1                                                                (bridge_0_granted_sdram_0_s1),
      .bridge_0_qualified_request_sdram_0_s1                                                      (bridge_0_qualified_request_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1                                                        (bridge_0_read_data_valid_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1_shift_register                                         (bridge_0_read_data_valid_sdram_0_s1_shift_register),
      .bridge_0_requests_sdram_0_s1                                                               (bridge_0_requests_sdram_0_s1),
      .clk                                                                                        (sys_clk),
      .cpu_0_data_master_address_to_slave                                                         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                               (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_sdram_0_s1                                                    (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_dbs_address                                                              (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                                             (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_sdram_0_s1                                                       (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_latency_counter                                                          (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_sdram_0_s1                                             (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_read                                                                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                                               (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                                (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_sdram_0_s1                                                      (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_write                                                                    (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                                                  (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                                                       (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_sdram_0_s1                                                (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_latency_counter                                                   (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1                                      (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_read                                                              (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                                        (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register                         (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_sdram_0_s1                                               (cpu_0_instruction_master_requests_sdram_0_s1),
      .d1_sdram_0_s1_end_xfer                                                                     (d1_sdram_0_s1_end_xfer),
      .reset_n                                                                                    (sys_clk_reset_n),
      .sdram_0_s1_address                                                                         (sdram_0_s1_address),
      .sdram_0_s1_byteenable_n                                                                    (sdram_0_s1_byteenable_n),
      .sdram_0_s1_chipselect                                                                      (sdram_0_s1_chipselect),
      .sdram_0_s1_read_n                                                                          (sdram_0_s1_read_n),
      .sdram_0_s1_readdata                                                                        (sdram_0_s1_readdata),
      .sdram_0_s1_readdata_from_sa                                                                (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_readdatavalid                                                                   (sdram_0_s1_readdatavalid),
      .sdram_0_s1_reset_n                                                                         (sdram_0_s1_reset_n),
      .sdram_0_s1_waitrequest                                                                     (sdram_0_s1_waitrequest),
      .sdram_0_s1_waitrequest_from_sa                                                             (sdram_0_s1_waitrequest_from_sa),
      .sdram_0_s1_write_n                                                                         (sdram_0_s1_write_n),
      .sdram_0_s1_writedata                                                                       (sdram_0_s1_writedata),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave                          (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock                               (video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1                        (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter                           (video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1              (video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read                                      (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1                (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1                       (video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1)
    );

  sdram_0 the_sdram_0
    (
      .az_addr        (sdram_0_s1_address),
      .az_be_n        (sdram_0_s1_byteenable_n),
      .az_cs          (sdram_0_s1_chipselect),
      .az_data        (sdram_0_s1_writedata),
      .az_rd_n        (sdram_0_s1_read_n),
      .az_wr_n        (sdram_0_s1_write_n),
      .clk            (sys_clk),
      .reset_n        (sdram_0_s1_reset_n),
      .za_data        (sdram_0_s1_readdata),
      .za_valid       (sdram_0_s1_readdatavalid),
      .za_waitrequest (sdram_0_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram_0),
      .zs_ba          (zs_ba_from_the_sdram_0),
      .zs_cas_n       (zs_cas_n_from_the_sdram_0),
      .zs_cke         (zs_cke_from_the_sdram_0),
      .zs_cs_n        (zs_cs_n_from_the_sdram_0),
      .zs_dq          (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm         (zs_dqm_from_the_sdram_0),
      .zs_ras_n       (zs_ras_n_from_the_sdram_0),
      .zs_we_n        (zs_we_n_from_the_sdram_0)
    );

  seven_seg_3_0_avalon_parallel_port_slave_arbitrator the_seven_seg_3_0_avalon_parallel_port_slave
    (
      .clk                                                                          (sys_clk),
      .cpu_0_data_master_address_to_slave                                           (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                 (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave           (cpu_0_data_master_granted_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_latency_counter                                            (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave (cpu_0_data_master_qualified_request_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_read                                                       (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                  (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave   (cpu_0_data_master_read_data_valid_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave          (cpu_0_data_master_requests_seven_seg_3_0_avalon_parallel_port_slave),
      .cpu_0_data_master_write                                                      (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                  (cpu_0_data_master_writedata),
      .d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer                         (d1_seven_seg_3_0_avalon_parallel_port_slave_end_xfer),
      .reset_n                                                                      (sys_clk_reset_n),
      .seven_seg_3_0_avalon_parallel_port_slave_address                             (seven_seg_3_0_avalon_parallel_port_slave_address),
      .seven_seg_3_0_avalon_parallel_port_slave_byteenable                          (seven_seg_3_0_avalon_parallel_port_slave_byteenable),
      .seven_seg_3_0_avalon_parallel_port_slave_chipselect                          (seven_seg_3_0_avalon_parallel_port_slave_chipselect),
      .seven_seg_3_0_avalon_parallel_port_slave_read                                (seven_seg_3_0_avalon_parallel_port_slave_read),
      .seven_seg_3_0_avalon_parallel_port_slave_readdata                            (seven_seg_3_0_avalon_parallel_port_slave_readdata),
      .seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa                    (seven_seg_3_0_avalon_parallel_port_slave_readdata_from_sa),
      .seven_seg_3_0_avalon_parallel_port_slave_reset                               (seven_seg_3_0_avalon_parallel_port_slave_reset),
      .seven_seg_3_0_avalon_parallel_port_slave_write                               (seven_seg_3_0_avalon_parallel_port_slave_write),
      .seven_seg_3_0_avalon_parallel_port_slave_writedata                           (seven_seg_3_0_avalon_parallel_port_slave_writedata)
    );

  seven_seg_3_0 the_seven_seg_3_0
    (
      .HEX0       (HEX0_from_the_seven_seg_3_0),
      .HEX1       (HEX1_from_the_seven_seg_3_0),
      .HEX2       (HEX2_from_the_seven_seg_3_0),
      .HEX3       (HEX3_from_the_seven_seg_3_0),
      .address    (seven_seg_3_0_avalon_parallel_port_slave_address),
      .byteenable (seven_seg_3_0_avalon_parallel_port_slave_byteenable),
      .chipselect (seven_seg_3_0_avalon_parallel_port_slave_chipselect),
      .clk        (sys_clk),
      .read       (seven_seg_3_0_avalon_parallel_port_slave_read),
      .readdata   (seven_seg_3_0_avalon_parallel_port_slave_readdata),
      .reset      (seven_seg_3_0_avalon_parallel_port_slave_reset),
      .write      (seven_seg_3_0_avalon_parallel_port_slave_write),
      .writedata  (seven_seg_3_0_avalon_parallel_port_slave_writedata)
    );

  seven_seg_7_4_avalon_parallel_port_slave_arbitrator the_seven_seg_7_4_avalon_parallel_port_slave
    (
      .clk                                                                          (sys_clk),
      .cpu_0_data_master_address_to_slave                                           (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                 (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave           (cpu_0_data_master_granted_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_latency_counter                                            (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave (cpu_0_data_master_qualified_request_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_read                                                       (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                  (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave   (cpu_0_data_master_read_data_valid_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave          (cpu_0_data_master_requests_seven_seg_7_4_avalon_parallel_port_slave),
      .cpu_0_data_master_write                                                      (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                  (cpu_0_data_master_writedata),
      .d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer                         (d1_seven_seg_7_4_avalon_parallel_port_slave_end_xfer),
      .reset_n                                                                      (sys_clk_reset_n),
      .seven_seg_7_4_avalon_parallel_port_slave_address                             (seven_seg_7_4_avalon_parallel_port_slave_address),
      .seven_seg_7_4_avalon_parallel_port_slave_byteenable                          (seven_seg_7_4_avalon_parallel_port_slave_byteenable),
      .seven_seg_7_4_avalon_parallel_port_slave_chipselect                          (seven_seg_7_4_avalon_parallel_port_slave_chipselect),
      .seven_seg_7_4_avalon_parallel_port_slave_read                                (seven_seg_7_4_avalon_parallel_port_slave_read),
      .seven_seg_7_4_avalon_parallel_port_slave_readdata                            (seven_seg_7_4_avalon_parallel_port_slave_readdata),
      .seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa                    (seven_seg_7_4_avalon_parallel_port_slave_readdata_from_sa),
      .seven_seg_7_4_avalon_parallel_port_slave_reset                               (seven_seg_7_4_avalon_parallel_port_slave_reset),
      .seven_seg_7_4_avalon_parallel_port_slave_write                               (seven_seg_7_4_avalon_parallel_port_slave_write),
      .seven_seg_7_4_avalon_parallel_port_slave_writedata                           (seven_seg_7_4_avalon_parallel_port_slave_writedata)
    );

  seven_seg_7_4 the_seven_seg_7_4
    (
      .HEX4       (HEX4_from_the_seven_seg_7_4),
      .HEX5       (HEX5_from_the_seven_seg_7_4),
      .HEX6       (HEX6_from_the_seven_seg_7_4),
      .HEX7       (HEX7_from_the_seven_seg_7_4),
      .address    (seven_seg_7_4_avalon_parallel_port_slave_address),
      .byteenable (seven_seg_7_4_avalon_parallel_port_slave_byteenable),
      .chipselect (seven_seg_7_4_avalon_parallel_port_slave_chipselect),
      .clk        (sys_clk),
      .read       (seven_seg_7_4_avalon_parallel_port_slave_read),
      .readdata   (seven_seg_7_4_avalon_parallel_port_slave_readdata),
      .reset      (seven_seg_7_4_avalon_parallel_port_slave_reset),
      .write      (seven_seg_7_4_avalon_parallel_port_slave_write),
      .writedata  (seven_seg_7_4_avalon_parallel_port_slave_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                         (sys_clk),
      .cpu_0_data_master_address_to_slave                          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_sysid_control_slave               (cpu_0_data_master_granted_sysid_control_slave),
      .cpu_0_data_master_latency_counter                           (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_sysid_control_slave     (cpu_0_data_master_qualified_request_sysid_control_slave),
      .cpu_0_data_master_read                                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_sysid_control_slave       (cpu_0_data_master_read_data_valid_sysid_control_slave),
      .cpu_0_data_master_requests_sysid_control_slave              (cpu_0_data_master_requests_sysid_control_slave),
      .cpu_0_data_master_write                                     (cpu_0_data_master_write),
      .d1_sysid_control_slave_end_xfer                             (d1_sysid_control_slave_end_xfer),
      .reset_n                                                     (sys_clk_reset_n),
      .sysid_control_slave_address                                 (sysid_control_slave_address),
      .sysid_control_slave_readdata                                (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                        (sysid_control_slave_readdata_from_sa),
      .sysid_control_slave_reset_n                                 (sysid_control_slave_reset_n)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .clock    (sysid_control_slave_clock),
      .readdata (sysid_control_slave_readdata),
      .reset_n  (sysid_control_slave_reset_n)
    );

  to_external_bus_bridge_0_avalon_slave_arbitrator the_to_external_bus_bridge_0_avalon_slave
    (
      .clk                                                                       (sys_clk),
      .cpu_0_data_master_address_to_slave                                        (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                              (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave        (cpu_0_data_master_byteenable_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_dbs_address                                             (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                            (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave           (cpu_0_data_master_granted_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_latency_counter                                         (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave (cpu_0_data_master_qualified_request_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_read                                                    (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register               (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave   (cpu_0_data_master_read_data_valid_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave          (cpu_0_data_master_requests_to_external_bus_bridge_0_avalon_slave),
      .cpu_0_data_master_write                                                   (cpu_0_data_master_write),
      .d1_to_external_bus_bridge_0_avalon_slave_end_xfer                         (d1_to_external_bus_bridge_0_avalon_slave_end_xfer),
      .reset_n                                                                   (sys_clk_reset_n),
      .to_external_bus_bridge_0_avalon_slave_address                             (to_external_bus_bridge_0_avalon_slave_address),
      .to_external_bus_bridge_0_avalon_slave_byteenable                          (to_external_bus_bridge_0_avalon_slave_byteenable),
      .to_external_bus_bridge_0_avalon_slave_chipselect                          (to_external_bus_bridge_0_avalon_slave_chipselect),
      .to_external_bus_bridge_0_avalon_slave_irq                                 (to_external_bus_bridge_0_avalon_slave_irq),
      .to_external_bus_bridge_0_avalon_slave_irq_from_sa                         (to_external_bus_bridge_0_avalon_slave_irq_from_sa),
      .to_external_bus_bridge_0_avalon_slave_read                                (to_external_bus_bridge_0_avalon_slave_read),
      .to_external_bus_bridge_0_avalon_slave_readdata                            (to_external_bus_bridge_0_avalon_slave_readdata),
      .to_external_bus_bridge_0_avalon_slave_readdata_from_sa                    (to_external_bus_bridge_0_avalon_slave_readdata_from_sa),
      .to_external_bus_bridge_0_avalon_slave_reset                               (to_external_bus_bridge_0_avalon_slave_reset),
      .to_external_bus_bridge_0_avalon_slave_waitrequest                         (to_external_bus_bridge_0_avalon_slave_waitrequest),
      .to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa                 (to_external_bus_bridge_0_avalon_slave_waitrequest_from_sa),
      .to_external_bus_bridge_0_avalon_slave_write                               (to_external_bus_bridge_0_avalon_slave_write),
      .to_external_bus_bridge_0_avalon_slave_writedata                           (to_external_bus_bridge_0_avalon_slave_writedata)
    );

  to_external_bus_bridge_0 the_to_external_bus_bridge_0
    (
      .acknowledge        (acknowledge_to_the_to_external_bus_bridge_0),
      .address            (address_from_the_to_external_bus_bridge_0),
      .avalon_address     (to_external_bus_bridge_0_avalon_slave_address),
      .avalon_byteenable  (to_external_bus_bridge_0_avalon_slave_byteenable),
      .avalon_chipselect  (to_external_bus_bridge_0_avalon_slave_chipselect),
      .avalon_irq         (to_external_bus_bridge_0_avalon_slave_irq),
      .avalon_read        (to_external_bus_bridge_0_avalon_slave_read),
      .avalon_readdata    (to_external_bus_bridge_0_avalon_slave_readdata),
      .avalon_waitrequest (to_external_bus_bridge_0_avalon_slave_waitrequest),
      .avalon_write       (to_external_bus_bridge_0_avalon_slave_write),
      .avalon_writedata   (to_external_bus_bridge_0_avalon_slave_writedata),
      .bus_enable         (bus_enable_from_the_to_external_bus_bridge_0),
      .byte_enable        (byte_enable_from_the_to_external_bus_bridge_0),
      .clk                (sys_clk),
      .irq                (irq_to_the_to_external_bus_bridge_0),
      .read_data          (read_data_to_the_to_external_bus_bridge_0),
      .reset              (to_external_bus_bridge_0_avalon_slave_reset),
      .rw                 (rw_from_the_to_external_bus_bridge_0),
      .write_data         (write_data_from_the_to_external_bus_bridge_0)
    );

  tri_state_bridge_0_avalon_slave_arbitrator the_tri_state_bridge_0_avalon_slave
    (
      .address_to_the_cfi_flash_0                                         (address_to_the_cfi_flash_0),
      .cfi_flash_0_s1_wait_counter_eq_0                                   (cfi_flash_0_s1_wait_counter_eq_0),
      .clk                                                                (sys_clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                        (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_8                                      (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_cfi_flash_0_s1                           (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_latency_counter                                  (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                 (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                   (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register        (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_cfi_flash_0_s1                          (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                    (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1          (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1            (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                   (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                        (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .data_to_and_from_the_cfi_flash_0                                   (data_to_and_from_the_cfi_flash_0),
      .incoming_data_to_and_from_the_cfi_flash_0                          (incoming_data_to_and_from_the_cfi_flash_0),
      .incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0   (incoming_data_to_and_from_the_cfi_flash_0_with_Xs_converted_to_0),
      .read_n_to_the_cfi_flash_0                                          (read_n_to_the_cfi_flash_0),
      .reset_n                                                            (sys_clk_reset_n),
      .select_n_to_the_cfi_flash_0                                        (select_n_to_the_cfi_flash_0),
      .write_n_to_the_cfi_flash_0                                         (write_n_to_the_cfi_flash_0)
    );

  video_dual_clock_buffer_0_avalon_dc_buffer_sink_arbitrator the_video_dual_clock_buffer_0_avalon_dc_buffer_sink
    (
      .clk                                                           (sys_clk),
      .reset_n                                                       (sys_clk_reset_n),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_data          (video_dual_clock_buffer_0_avalon_dc_buffer_sink_data),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket   (video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready         (video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa (video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket (video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid         (video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid),
      .video_rgb_resampler_0_avalon_rgb_source_data                  (video_rgb_resampler_0_avalon_rgb_source_data),
      .video_rgb_resampler_0_avalon_rgb_source_endofpacket           (video_rgb_resampler_0_avalon_rgb_source_endofpacket),
      .video_rgb_resampler_0_avalon_rgb_source_startofpacket         (video_rgb_resampler_0_avalon_rgb_source_startofpacket),
      .video_rgb_resampler_0_avalon_rgb_source_valid                 (video_rgb_resampler_0_avalon_rgb_source_valid)
    );

  video_dual_clock_buffer_0_avalon_dc_buffer_source_arbitrator the_video_dual_clock_buffer_0_avalon_dc_buffer_source
    (
      .clk                                                             (vga_clk),
      .reset_n                                                         (vga_clk_reset_n),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_data          (video_dual_clock_buffer_0_avalon_dc_buffer_source_data),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket   (video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_ready         (video_dual_clock_buffer_0_avalon_dc_buffer_source_ready),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket (video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_valid         (video_dual_clock_buffer_0_avalon_dc_buffer_source_valid),
      .video_vga_controller_0_avalon_vga_sink_ready_from_sa            (video_vga_controller_0_avalon_vga_sink_ready_from_sa)
    );

  video_dual_clock_buffer_0 the_video_dual_clock_buffer_0
    (
      .clk_stream_in            (sys_clk),
      .clk_stream_out           (vga_clk),
      .stream_in_data           (video_dual_clock_buffer_0_avalon_dc_buffer_sink_data),
      .stream_in_endofpacket    (video_dual_clock_buffer_0_avalon_dc_buffer_sink_endofpacket),
      .stream_in_ready          (video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready),
      .stream_in_startofpacket  (video_dual_clock_buffer_0_avalon_dc_buffer_sink_startofpacket),
      .stream_in_valid          (video_dual_clock_buffer_0_avalon_dc_buffer_sink_valid),
      .stream_out_data          (video_dual_clock_buffer_0_avalon_dc_buffer_source_data),
      .stream_out_endofpacket   (video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket),
      .stream_out_ready         (video_dual_clock_buffer_0_avalon_dc_buffer_source_ready),
      .stream_out_startofpacket (video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket),
      .stream_out_valid         (video_dual_clock_buffer_0_avalon_dc_buffer_source_valid)
    );

  video_pixel_buffer_dma_0_avalon_control_slave_arbitrator the_video_pixel_buffer_dma_0_avalon_control_slave
    (
      .clk                                                                               (sys_clk),
      .cpu_0_data_master_address_to_slave                                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                      (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave           (cpu_0_data_master_granted_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_latency_counter                                                 (cpu_0_data_master_latency_counter),
      .cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave (cpu_0_data_master_qualified_request_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_read                                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register                       (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave   (cpu_0_data_master_read_data_valid_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave          (cpu_0_data_master_requests_video_pixel_buffer_dma_0_avalon_control_slave),
      .cpu_0_data_master_write                                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                       (cpu_0_data_master_writedata),
      .d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer                         (d1_video_pixel_buffer_dma_0_avalon_control_slave_end_xfer),
      .reset_n                                                                           (sys_clk_reset_n),
      .video_pixel_buffer_dma_0_avalon_control_slave_address                             (video_pixel_buffer_dma_0_avalon_control_slave_address),
      .video_pixel_buffer_dma_0_avalon_control_slave_byteenable                          (video_pixel_buffer_dma_0_avalon_control_slave_byteenable),
      .video_pixel_buffer_dma_0_avalon_control_slave_read                                (video_pixel_buffer_dma_0_avalon_control_slave_read),
      .video_pixel_buffer_dma_0_avalon_control_slave_readdata                            (video_pixel_buffer_dma_0_avalon_control_slave_readdata),
      .video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa                    (video_pixel_buffer_dma_0_avalon_control_slave_readdata_from_sa),
      .video_pixel_buffer_dma_0_avalon_control_slave_write                               (video_pixel_buffer_dma_0_avalon_control_slave_write),
      .video_pixel_buffer_dma_0_avalon_control_slave_writedata                           (video_pixel_buffer_dma_0_avalon_control_slave_writedata)
    );

  video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbitrator the_video_pixel_buffer_dma_0_avalon_pixel_dma_master
    (
      .clk                                                                                        (sys_clk),
      .d1_sdram_0_s1_end_xfer                                                                     (d1_sdram_0_s1_end_xfer),
      .reset_n                                                                                    (sys_clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                                                (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                                             (sdram_0_s1_waitrequest_from_sa),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_address                                   (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave                          (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address_to_slave),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1                        (video_pixel_buffer_dma_0_avalon_pixel_dma_master_granted_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter                           (video_pixel_buffer_dma_0_avalon_pixel_dma_master_latency_counter),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1              (video_pixel_buffer_dma_0_avalon_pixel_dma_master_qualified_request_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read                                      (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1                (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read_data_valid_sdram_0_s1_shift_register),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata                                  (video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid                             (video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1                       (video_pixel_buffer_dma_0_avalon_pixel_dma_master_requests_sdram_0_s1),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset                                     (video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset),
      .video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest                               (video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest)
    );

  video_pixel_buffer_dma_0_avalon_pixel_source_arbitrator the_video_pixel_buffer_dma_0_avalon_pixel_source
    (
      .clk                                                        (sys_clk),
      .reset_n                                                    (sys_clk_reset_n),
      .video_pixel_buffer_dma_0_avalon_pixel_source_data          (video_pixel_buffer_dma_0_avalon_pixel_source_data),
      .video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket   (video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket),
      .video_pixel_buffer_dma_0_avalon_pixel_source_ready         (video_pixel_buffer_dma_0_avalon_pixel_source_ready),
      .video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket (video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket),
      .video_pixel_buffer_dma_0_avalon_pixel_source_valid         (video_pixel_buffer_dma_0_avalon_pixel_source_valid),
      .video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa        (video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa)
    );

  video_pixel_buffer_dma_0 the_video_pixel_buffer_dma_0
    (
      .clk                  (sys_clk),
      .master_address       (video_pixel_buffer_dma_0_avalon_pixel_dma_master_address),
      .master_arbiterlock   (video_pixel_buffer_dma_0_avalon_pixel_dma_master_arbiterlock),
      .master_read          (video_pixel_buffer_dma_0_avalon_pixel_dma_master_read),
      .master_readdata      (video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdata),
      .master_readdatavalid (video_pixel_buffer_dma_0_avalon_pixel_dma_master_readdatavalid),
      .master_waitrequest   (video_pixel_buffer_dma_0_avalon_pixel_dma_master_waitrequest),
      .reset                (video_pixel_buffer_dma_0_avalon_pixel_dma_master_reset),
      .slave_address        (video_pixel_buffer_dma_0_avalon_control_slave_address),
      .slave_byteenable     (video_pixel_buffer_dma_0_avalon_control_slave_byteenable),
      .slave_read           (video_pixel_buffer_dma_0_avalon_control_slave_read),
      .slave_readdata       (video_pixel_buffer_dma_0_avalon_control_slave_readdata),
      .slave_write          (video_pixel_buffer_dma_0_avalon_control_slave_write),
      .slave_writedata      (video_pixel_buffer_dma_0_avalon_control_slave_writedata),
      .stream_data          (video_pixel_buffer_dma_0_avalon_pixel_source_data),
      .stream_endofpacket   (video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket),
      .stream_ready         (video_pixel_buffer_dma_0_avalon_pixel_source_ready),
      .stream_startofpacket (video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket),
      .stream_valid         (video_pixel_buffer_dma_0_avalon_pixel_source_valid)
    );

  video_rgb_resampler_0_avalon_rgb_sink_arbitrator the_video_rgb_resampler_0_avalon_rgb_sink
    (
      .clk                                                        (sys_clk),
      .reset_n                                                    (sys_clk_reset_n),
      .video_pixel_buffer_dma_0_avalon_pixel_source_data          (video_pixel_buffer_dma_0_avalon_pixel_source_data),
      .video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket   (video_pixel_buffer_dma_0_avalon_pixel_source_endofpacket),
      .video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket (video_pixel_buffer_dma_0_avalon_pixel_source_startofpacket),
      .video_pixel_buffer_dma_0_avalon_pixel_source_valid         (video_pixel_buffer_dma_0_avalon_pixel_source_valid),
      .video_rgb_resampler_0_avalon_rgb_sink_data                 (video_rgb_resampler_0_avalon_rgb_sink_data),
      .video_rgb_resampler_0_avalon_rgb_sink_endofpacket          (video_rgb_resampler_0_avalon_rgb_sink_endofpacket),
      .video_rgb_resampler_0_avalon_rgb_sink_ready                (video_rgb_resampler_0_avalon_rgb_sink_ready),
      .video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa        (video_rgb_resampler_0_avalon_rgb_sink_ready_from_sa),
      .video_rgb_resampler_0_avalon_rgb_sink_reset                (video_rgb_resampler_0_avalon_rgb_sink_reset),
      .video_rgb_resampler_0_avalon_rgb_sink_startofpacket        (video_rgb_resampler_0_avalon_rgb_sink_startofpacket),
      .video_rgb_resampler_0_avalon_rgb_sink_valid                (video_rgb_resampler_0_avalon_rgb_sink_valid)
    );

  video_rgb_resampler_0_avalon_rgb_source_arbitrator the_video_rgb_resampler_0_avalon_rgb_source
    (
      .clk                                                           (sys_clk),
      .reset_n                                                       (sys_clk_reset_n),
      .video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa (video_dual_clock_buffer_0_avalon_dc_buffer_sink_ready_from_sa),
      .video_rgb_resampler_0_avalon_rgb_source_data                  (video_rgb_resampler_0_avalon_rgb_source_data),
      .video_rgb_resampler_0_avalon_rgb_source_endofpacket           (video_rgb_resampler_0_avalon_rgb_source_endofpacket),
      .video_rgb_resampler_0_avalon_rgb_source_ready                 (video_rgb_resampler_0_avalon_rgb_source_ready),
      .video_rgb_resampler_0_avalon_rgb_source_startofpacket         (video_rgb_resampler_0_avalon_rgb_source_startofpacket),
      .video_rgb_resampler_0_avalon_rgb_source_valid                 (video_rgb_resampler_0_avalon_rgb_source_valid)
    );

  video_rgb_resampler_0 the_video_rgb_resampler_0
    (
      .clk                      (sys_clk),
      .reset                    (video_rgb_resampler_0_avalon_rgb_sink_reset),
      .stream_in_data           (video_rgb_resampler_0_avalon_rgb_sink_data),
      .stream_in_endofpacket    (video_rgb_resampler_0_avalon_rgb_sink_endofpacket),
      .stream_in_ready          (video_rgb_resampler_0_avalon_rgb_sink_ready),
      .stream_in_startofpacket  (video_rgb_resampler_0_avalon_rgb_sink_startofpacket),
      .stream_in_valid          (video_rgb_resampler_0_avalon_rgb_sink_valid),
      .stream_out_data          (video_rgb_resampler_0_avalon_rgb_source_data),
      .stream_out_endofpacket   (video_rgb_resampler_0_avalon_rgb_source_endofpacket),
      .stream_out_ready         (video_rgb_resampler_0_avalon_rgb_source_ready),
      .stream_out_startofpacket (video_rgb_resampler_0_avalon_rgb_source_startofpacket),
      .stream_out_valid         (video_rgb_resampler_0_avalon_rgb_source_valid)
    );

  video_vga_controller_0_avalon_vga_sink_arbitrator the_video_vga_controller_0_avalon_vga_sink
    (
      .clk                                                             (vga_clk),
      .reset_n                                                         (vga_clk_reset_n),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_data          (video_dual_clock_buffer_0_avalon_dc_buffer_source_data),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket   (video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket (video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket),
      .video_dual_clock_buffer_0_avalon_dc_buffer_source_valid         (video_dual_clock_buffer_0_avalon_dc_buffer_source_valid),
      .video_vga_controller_0_avalon_vga_sink_data                     (video_vga_controller_0_avalon_vga_sink_data),
      .video_vga_controller_0_avalon_vga_sink_endofpacket              (video_vga_controller_0_avalon_vga_sink_endofpacket),
      .video_vga_controller_0_avalon_vga_sink_ready                    (video_vga_controller_0_avalon_vga_sink_ready),
      .video_vga_controller_0_avalon_vga_sink_ready_from_sa            (video_vga_controller_0_avalon_vga_sink_ready_from_sa),
      .video_vga_controller_0_avalon_vga_sink_reset                    (video_vga_controller_0_avalon_vga_sink_reset),
      .video_vga_controller_0_avalon_vga_sink_startofpacket            (video_vga_controller_0_avalon_vga_sink_startofpacket),
      .video_vga_controller_0_avalon_vga_sink_valid                    (video_vga_controller_0_avalon_vga_sink_valid)
    );

  video_vga_controller_0 the_video_vga_controller_0
    (
      .VGA_B         (VGA_B_from_the_video_vga_controller_0),
      .VGA_BLANK     (VGA_BLANK_from_the_video_vga_controller_0),
      .VGA_CLK       (VGA_CLK_from_the_video_vga_controller_0),
      .VGA_G         (VGA_G_from_the_video_vga_controller_0),
      .VGA_HS        (VGA_HS_from_the_video_vga_controller_0),
      .VGA_R         (VGA_R_from_the_video_vga_controller_0),
      .VGA_SYNC      (VGA_SYNC_from_the_video_vga_controller_0),
      .VGA_VS        (VGA_VS_from_the_video_vga_controller_0),
      .clk           (vga_clk),
      .data          (video_vga_controller_0_avalon_vga_sink_data),
      .endofpacket   (video_vga_controller_0_avalon_vga_sink_endofpacket),
      .ready         (video_vga_controller_0_avalon_vga_sink_ready),
      .reset         (video_vga_controller_0_avalon_vga_sink_reset),
      .startofpacket (video_vga_controller_0_avalon_vga_sink_startofpacket),
      .valid         (video_vga_controller_0_avalon_vga_sink_valid)
    );

  //reset is asserted asynchronously and deasserted synchronously
  main_reset_sys_clk_domain_synch_module main_reset_sys_clk_domain_synch
    (
      .clk      (sys_clk),
      .data_in  (1'b1),
      .data_out (sys_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    0 |
    cpu_0_jtag_debug_module_resetrequest_from_sa |
    cpu_0_jtag_debug_module_resetrequest_from_sa |
    0);

  //reset is asserted asynchronously and deasserted synchronously
  main_reset_clk_50_domain_synch_module main_reset_clk_50_domain_synch
    (
      .clk      (clk_50),
      .data_in  (1'b1),
      .data_out (clk_50_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  main_reset_vga_clk_domain_synch_module main_reset_vga_clk_domain_synch
    (
      .clk      (vga_clk),
      .data_in  (1'b1),
      .data_out (vga_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //main_clock_0_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign main_clock_0_out_endofpacket = 0;

  //sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  assign sysid_control_slave_clock = 0;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0_lane0_module (
                                  // inputs:
                                   data,
                                   rdaddress,
                                   rdclken,
                                   wraddress,
                                   wrclock,
                                   wren,

                                  // outputs:
                                   q
                                )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 21: 0] rdaddress;
  input            rdclken;
  input   [ 21: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [4194303: 0];
  wire    [  7: 0] q;
  reg     [ 21: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("cfi_flash_0.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "cfi_flash_0.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 22,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0 (
                     // inputs:
                      address,
                      read_n,
                      select_n,
                      write_n,

                     // outputs:
                      data
                   )
;

  inout   [  7: 0] data;
  input   [ 21: 0] address;
  input            read_n;
  input            select_n;
  input            write_n;

  wire    [  7: 0] data;
  wire    [  7: 0] data_0;
  wire    [  7: 0] logic_vector_gasket;
  wire    [  7: 0] q_0;
  //s1, which is an e_ptf_slave

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign logic_vector_gasket = data;
  assign data_0 = logic_vector_gasket[7 : 0];
  //cfi_flash_0_lane0, which is an e_ram
  cfi_flash_0_lane0_module cfi_flash_0_lane0
    (
      .data      (data_0),
      .q         (q_0),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data = (~select_n & ~read_n)? q_0: {8{1'bz}};

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/quartus/quartus/eda/sim_lib/altera_mf.v"
`include "c:/quartus/quartus/eda/sim_lib/220model.v"
`include "c:/quartus/quartus/eda/sim_lib/sgate.v"
// sd_card_0.vhd
`include "video_rgb_resampler_0.v"
`include "seven_seg_3_0.v"
`include "audio_and_video_config_0.v"
`include "wait_for_interrupt_custom_instruction.v"
`include "cpu_0_wait_for_interrupt_custom_instruction_0_91_inst.v"
`include "character_lcd_0.v"
`include "seven_seg_7_4.v"
`include "to_external_bus_bridge_0.v"
`include "audio_0.v"
`include "red_leds.v"
`include "bridge_0.v"
`include "video_vga_controller_0.v"
`include "clocks_0.v"
`include "video_dual_clock_buffer_0.v"
`include "video_pixel_buffer_dma_0.v"
`include "sysid.v"
`include "cpu_0_test_bench.v"
`include "cpu_0_mult_cell.v"
`include "cpu_0_oci_test_bench.v"
`include "cpu_0_jtag_debug_module_tck.v"
`include "cpu_0_jtag_debug_module_sysclk.v"
`include "cpu_0_jtag_debug_module_wrapper.v"
`include "cpu_0.v"
`include "main_clock_0.v"
`include "jtag_uart_0.v"
`include "onchip_memory2_0.v"
`include "sdram_0.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             AUD_ADCDAT_to_the_audio_0;
  wire             AUD_ADCLRCK_to_and_from_the_audio_0;
  wire             AUD_BCLK_to_and_from_the_audio_0;
  wire             AUD_DACDAT_from_the_audio_0;
  wire             AUD_DACLRCK_to_and_from_the_audio_0;
  wire    [  6: 0] HEX0_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX1_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX2_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX3_from_the_seven_seg_3_0;
  wire    [  6: 0] HEX4_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX5_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX6_from_the_seven_seg_7_4;
  wire    [  6: 0] HEX7_from_the_seven_seg_7_4;
  wire             I2C_SCLK_from_the_audio_and_video_config_0;
  wire             I2C_SDAT_to_and_from_the_audio_and_video_config_0;
  wire             LCD_BLON_from_the_character_lcd_0;
  wire    [  7: 0] LCD_DATA_to_and_from_the_character_lcd_0;
  wire             LCD_EN_from_the_character_lcd_0;
  wire             LCD_ON_from_the_character_lcd_0;
  wire             LCD_RS_from_the_character_lcd_0;
  wire             LCD_RW_from_the_character_lcd_0;
  wire    [ 17: 0] LEDR_from_the_red_leds;
  wire             VGA_BLANK_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_B_from_the_video_vga_controller_0;
  wire             VGA_CLK_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_G_from_the_video_vga_controller_0;
  wire             VGA_HS_from_the_video_vga_controller_0;
  wire    [  9: 0] VGA_R_from_the_video_vga_controller_0;
  wire             VGA_SYNC_from_the_video_vga_controller_0;
  wire             VGA_VS_from_the_video_vga_controller_0;
  wire             acknowledge_from_the_bridge_0;
  wire             acknowledge_to_the_to_external_bus_bridge_0;
  wire    [ 19: 0] address_from_the_to_external_bus_bridge_0;
  wire    [ 23: 0] address_to_the_bridge_0;
  wire    [ 21: 0] address_to_the_cfi_flash_0;
  wire             audio_clk;
  wire             b_SD_cmd_to_and_from_the_sd_card_0;
  wire             b_SD_dat3_to_and_from_the_sd_card_0;
  wire             b_SD_dat_to_and_from_the_sd_card_0;
  wire             bus_enable_from_the_to_external_bus_bridge_0;
  wire    [  1: 0] byte_enable_from_the_to_external_bus_bridge_0;
  wire    [  1: 0] byte_enable_to_the_bridge_0;
  wire             clk;
  reg              clk_27;
  reg              clk_50;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_a;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_b;
  wire    [  4: 0] cpu_0_custom_instruction_master_multi_c;
  wire             cpu_0_custom_instruction_master_multi_clk;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_dataa;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_datab;
  wire             cpu_0_custom_instruction_master_multi_estatus;
  wire    [ 31: 0] cpu_0_custom_instruction_master_multi_ipending;
  wire    [  7: 0] cpu_0_custom_instruction_master_multi_n;
  wire             cpu_0_custom_instruction_master_multi_readra;
  wire             cpu_0_custom_instruction_master_multi_readrb;
  wire             cpu_0_custom_instruction_master_multi_reset;
  wire             cpu_0_custom_instruction_master_multi_status;
  wire             cpu_0_custom_instruction_master_multi_writerc;
  wire    [  7: 0] data_to_and_from_the_cfi_flash_0;
  wire             interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst;
  wire             irq_to_the_to_external_bus_bridge_0;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             main_clock_0_in_endofpacket_from_sa;
  wire             main_clock_0_out_endofpacket;
  wire             main_clock_0_out_nativeaddress;
  wire             o_SD_clock_from_the_sd_card_0;
  wire    [ 15: 0] read_data_from_the_bridge_0;
  wire    [ 15: 0] read_data_to_the_to_external_bus_bridge_0;
  wire             read_n_to_the_cfi_flash_0;
  wire             read_to_the_bridge_0;
  reg              reset_n;
  wire             rw_from_the_to_external_bus_bridge_0;
  wire             sdram_clk;
  wire             select_n_to_the_cfi_flash_0;
  wire             sys_clk;
  wire             sysid_control_slave_clock;
  wire             vga_clk;
  wire    [ 15: 0] write_data_from_the_to_external_bus_bridge_0;
  wire    [ 15: 0] write_data_to_the_bridge_0;
  wire             write_n_to_the_cfi_flash_0;
  wire             write_to_the_bridge_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  main DUT
    (
      .AUD_ADCDAT_to_the_audio_0                                              (AUD_ADCDAT_to_the_audio_0),
      .AUD_ADCLRCK_to_and_from_the_audio_0                                    (AUD_ADCLRCK_to_and_from_the_audio_0),
      .AUD_BCLK_to_and_from_the_audio_0                                       (AUD_BCLK_to_and_from_the_audio_0),
      .AUD_DACDAT_from_the_audio_0                                            (AUD_DACDAT_from_the_audio_0),
      .AUD_DACLRCK_to_and_from_the_audio_0                                    (AUD_DACLRCK_to_and_from_the_audio_0),
      .HEX0_from_the_seven_seg_3_0                                            (HEX0_from_the_seven_seg_3_0),
      .HEX1_from_the_seven_seg_3_0                                            (HEX1_from_the_seven_seg_3_0),
      .HEX2_from_the_seven_seg_3_0                                            (HEX2_from_the_seven_seg_3_0),
      .HEX3_from_the_seven_seg_3_0                                            (HEX3_from_the_seven_seg_3_0),
      .HEX4_from_the_seven_seg_7_4                                            (HEX4_from_the_seven_seg_7_4),
      .HEX5_from_the_seven_seg_7_4                                            (HEX5_from_the_seven_seg_7_4),
      .HEX6_from_the_seven_seg_7_4                                            (HEX6_from_the_seven_seg_7_4),
      .HEX7_from_the_seven_seg_7_4                                            (HEX7_from_the_seven_seg_7_4),
      .I2C_SCLK_from_the_audio_and_video_config_0                             (I2C_SCLK_from_the_audio_and_video_config_0),
      .I2C_SDAT_to_and_from_the_audio_and_video_config_0                      (I2C_SDAT_to_and_from_the_audio_and_video_config_0),
      .LCD_BLON_from_the_character_lcd_0                                      (LCD_BLON_from_the_character_lcd_0),
      .LCD_DATA_to_and_from_the_character_lcd_0                               (LCD_DATA_to_and_from_the_character_lcd_0),
      .LCD_EN_from_the_character_lcd_0                                        (LCD_EN_from_the_character_lcd_0),
      .LCD_ON_from_the_character_lcd_0                                        (LCD_ON_from_the_character_lcd_0),
      .LCD_RS_from_the_character_lcd_0                                        (LCD_RS_from_the_character_lcd_0),
      .LCD_RW_from_the_character_lcd_0                                        (LCD_RW_from_the_character_lcd_0),
      .LEDR_from_the_red_leds                                                 (LEDR_from_the_red_leds),
      .VGA_BLANK_from_the_video_vga_controller_0                              (VGA_BLANK_from_the_video_vga_controller_0),
      .VGA_B_from_the_video_vga_controller_0                                  (VGA_B_from_the_video_vga_controller_0),
      .VGA_CLK_from_the_video_vga_controller_0                                (VGA_CLK_from_the_video_vga_controller_0),
      .VGA_G_from_the_video_vga_controller_0                                  (VGA_G_from_the_video_vga_controller_0),
      .VGA_HS_from_the_video_vga_controller_0                                 (VGA_HS_from_the_video_vga_controller_0),
      .VGA_R_from_the_video_vga_controller_0                                  (VGA_R_from_the_video_vga_controller_0),
      .VGA_SYNC_from_the_video_vga_controller_0                               (VGA_SYNC_from_the_video_vga_controller_0),
      .VGA_VS_from_the_video_vga_controller_0                                 (VGA_VS_from_the_video_vga_controller_0),
      .acknowledge_from_the_bridge_0                                          (acknowledge_from_the_bridge_0),
      .acknowledge_to_the_to_external_bus_bridge_0                            (acknowledge_to_the_to_external_bus_bridge_0),
      .address_from_the_to_external_bus_bridge_0                              (address_from_the_to_external_bus_bridge_0),
      .address_to_the_bridge_0                                                (address_to_the_bridge_0),
      .address_to_the_cfi_flash_0                                             (address_to_the_cfi_flash_0),
      .audio_clk                                                              (audio_clk),
      .b_SD_cmd_to_and_from_the_sd_card_0                                     (b_SD_cmd_to_and_from_the_sd_card_0),
      .b_SD_dat3_to_and_from_the_sd_card_0                                    (b_SD_dat3_to_and_from_the_sd_card_0),
      .b_SD_dat_to_and_from_the_sd_card_0                                     (b_SD_dat_to_and_from_the_sd_card_0),
      .bus_enable_from_the_to_external_bus_bridge_0                           (bus_enable_from_the_to_external_bus_bridge_0),
      .byte_enable_from_the_to_external_bus_bridge_0                          (byte_enable_from_the_to_external_bus_bridge_0),
      .byte_enable_to_the_bridge_0                                            (byte_enable_to_the_bridge_0),
      .clk_27                                                                 (clk_27),
      .clk_50                                                                 (clk_50),
      .data_to_and_from_the_cfi_flash_0                                       (data_to_and_from_the_cfi_flash_0),
      .interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst (interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst),
      .irq_to_the_to_external_bus_bridge_0                                    (irq_to_the_to_external_bus_bridge_0),
      .o_SD_clock_from_the_sd_card_0                                          (o_SD_clock_from_the_sd_card_0),
      .read_data_from_the_bridge_0                                            (read_data_from_the_bridge_0),
      .read_data_to_the_to_external_bus_bridge_0                              (read_data_to_the_to_external_bus_bridge_0),
      .read_n_to_the_cfi_flash_0                                              (read_n_to_the_cfi_flash_0),
      .read_to_the_bridge_0                                                   (read_to_the_bridge_0),
      .reset_n                                                                (reset_n),
      .rw_from_the_to_external_bus_bridge_0                                   (rw_from_the_to_external_bus_bridge_0),
      .sdram_clk                                                              (sdram_clk),
      .select_n_to_the_cfi_flash_0                                            (select_n_to_the_cfi_flash_0),
      .sys_clk                                                                (sys_clk),
      .vga_clk                                                                (vga_clk),
      .write_data_from_the_to_external_bus_bridge_0                           (write_data_from_the_to_external_bus_bridge_0),
      .write_data_to_the_bridge_0                                             (write_data_to_the_bridge_0),
      .write_n_to_the_cfi_flash_0                                             (write_n_to_the_cfi_flash_0),
      .write_to_the_bridge_0                                                  (write_to_the_bridge_0),
      .zs_addr_from_the_sdram_0                                               (zs_addr_from_the_sdram_0),
      .zs_ba_from_the_sdram_0                                                 (zs_ba_from_the_sdram_0),
      .zs_cas_n_from_the_sdram_0                                              (zs_cas_n_from_the_sdram_0),
      .zs_cke_from_the_sdram_0                                                (zs_cke_from_the_sdram_0),
      .zs_cs_n_from_the_sdram_0                                               (zs_cs_n_from_the_sdram_0),
      .zs_dq_to_and_from_the_sdram_0                                          (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm_from_the_sdram_0                                                (zs_dqm_from_the_sdram_0),
      .zs_ras_n_from_the_sdram_0                                              (zs_ras_n_from_the_sdram_0),
      .zs_we_n_from_the_sdram_0                                               (zs_we_n_from_the_sdram_0)
    );

  cfi_flash_0 the_cfi_flash_0
    (
      .address  (address_to_the_cfi_flash_0),
      .data     (data_to_and_from_the_cfi_flash_0),
      .read_n   (read_n_to_the_cfi_flash_0),
      .select_n (select_n_to_the_cfi_flash_0),
      .write_n  (write_n_to_the_cfi_flash_0)
    );

  initial
    clk_27 = 1'b0;
  always
     if (clk_27 == 1'b1) 
    #18 clk_27 <= ~clk_27;
     else 
    #19 clk_27 <= ~clk_27;
  
  initial
    clk_50 = 1'b0;
  always
    #10 clk_50 <= ~clk_50;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on